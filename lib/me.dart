import 'dart:io';

import 'package:flutter/material.dart';
import 'Staff.dart';
import 'MyIcon.dart';
import 'package:flutter/services.dart';
import 'helper.dart';
import 'login.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';

class MePage extends StatefulWidget {
  final Staff _staff;

  MePage(this._staff);

  @override
  _MePageState createState() => _MePageState(_staff);
}

class _MePageState extends State<MePage> {
  final Staff _staff;
  bool _loading = false;
  Future<File> _imageFile;

  _MePageState(this._staff);

  void _onImageButtonPressed(ImageSource source) {
    _imageFile = ImagePicker.pickImage(source: source);

    _imageFile.then((File file) {
      print("文件：${file}");

      setState(() {
        _loading = true;
      });

      api.uploadAvatar(file, _staff.email).then((Response response) {
        if (response.data['success']) {
          String avatar = response.data['msg'];
          _staff.avatar = avatar;
        } else {
          showDialog<void>(
            context: context,
            barrierDismissible: true, // user must tap button!
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('上传失败'),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      Text(response.data['msg']),
                    ],
                  ),
                ),
              );
            },
          );
        }

        setState(() {
          _loading = false;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> list = [ListView(
      children: <Widget>[
        ListTile(
          title: Text(_staff.name,
              style: TextStyle(fontWeight: FontWeight.w500)),
          subtitle: Text(_staff.workType),
          leading: Icon(
            Icons.contacts,
            color: Colors.blue[500],
          ),
          onLongPress: () {
            Clipboard.setData(new ClipboardData(text: _staff.name));
          },
        ),
        Divider(),
        ListTile(
          title: Text(_staff.pname),
          leading: Icon(
            Icons.domain,
            color: Colors.blue[500],
          ),
          onLongPress: () {
            Clipboard.setData(new ClipboardData(text: _staff.pname));
          },
        ),
        ListTile(
          title: Text(_staff.phone),
          leading: Icon(
            Icons.call,
            color: Colors.blue[500],
          ),
          onLongPress: () {
            Clipboard.setData(new ClipboardData(text: _staff.phone));
          },
        ),
        ListTile(
          title: Text(_staff.email),
          leading: Icon(
            Icons.email,
            color: Colors.blue[500],
          ),
          onLongPress: () {
            Clipboard.setData(new ClipboardData(text: _staff.email));
          },
        ),
        ListTile(
          title: Text(_staff.qq),
          leading: Icon(
            MyIcon.qq,
            color: Colors.blue[500],
          ),
          onLongPress: () {
            Clipboard.setData(new ClipboardData(text: _staff.qq));
          },
        ),
        ListTile(
          title: Text(_staff.wx),
          leading: Icon(
            MyIcon.wx,
            color: Colors.blue[500],
          ),
          onLongPress: () {
            Clipboard.setData(new ClipboardData(text: _staff.wx));
          },
        ),
        ListTile(
          title: Text(_staff.gxtAccount),
          leading: Icon(
            MyIcon.gxt,
            color: Colors.blue[500],
          ),
          onLongPress: () {
            Clipboard.setData(new ClipboardData(text: _staff.gxtAccount));
          },
        ),
        ListTile(
          title: Text(_staff.birthday),
          leading: Icon(
            Icons.cake,
            color: Colors.blue[500],
          ),
          onLongPress: () {
            Clipboard.setData(new ClipboardData(text: _staff.birthday));
          },
        ),
        RaisedButton(
          child: new Text("修改头像"),
          color: Colors.white70,
          onPressed: () {
            _onImageButtonPressed(ImageSource.gallery);
          },
        ),
        RaisedButton(
          child: new Text("退 出"),
          color: Colors.redAccent,
          onPressed: () {
            api.logout();
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
                  (Route<dynamic> route) { return false; },
            );
          },
        ),
      ],
    )];

    if (_loading) {
      list.add(Opacity(
          opacity: 0.8,
          child: ModalBarrier(
            color: Colors.grey,
          )));
      list.add(Center(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: CircularProgressIndicator(),
        ),
      ));
    }

    return Scaffold(
      body: Stack(
        children: list,
      )
    );
  }
}