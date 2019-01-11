import 'dart:io';

import 'package:flutter/material.dart';
import 'Staff.dart';
import 'MyIcon.dart';
import 'package:flutter/services.dart';
import 'helper.dart';
import 'login.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:event_bus/event_bus.dart';
import 'package:package_info/package_info.dart';

class MePage extends StatefulWidget {
  final Staff _staff;
  final EventBus _eventBus;

  MePage(this._staff, this._eventBus);

  @override
  _MePageState createState() => _MePageState();
}

class _MePageState extends State<MePage> {
  bool _loading = false;
  Future<File> _imageFile;
  String _version;

  _MePageState();

  void _onImageButtonPressed(BuildContext context, ImageSource source) {
    _imageFile = ImagePicker.pickImage(source: source);

    _imageFile.then((File file) {
      if (file == null) {
        return;
      }
      if (file.lengthSync() >= 5120000) {
        Scaffold.of(context).showSnackBar(SnackBar(content: Text('图片超过5M')));
        return;
      }

      setState(() {
        _loading = true;
      });

      api.uploadAvatar(file, widget._staff.email).then((Response response) {
        if (response.data['success']) {
          String avatar = response.data['msg'];
          widget._staff.avatar = avatar;
          widget._eventBus.fire(new AvatarUpdateEvent(avatar));
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

  void _copyData(BuildContext context, String text) {
    if (text == null || text.length < 1) {
      return;
    }
    Clipboard.setData(new ClipboardData(text: text));
    Scaffold.of(context).showSnackBar(SnackBar(content: Text('已复制到剪切板')));
  }

  @override
  Widget build(BuildContext context) {
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      setState(() {
        _version = " [${packageInfo.version}]";
      });
    });

    Widget listView = ListView(
      children: <Widget>[
        Align(
          alignment: Alignment.center,
          child: Container(
            margin: EdgeInsets.all(20.0),
            width: 150.0,
            height: 150.0,
            decoration: new BoxDecoration(
              image: new DecorationImage(
                image: new CachedNetworkImageProvider(widget._staff.avatar),
                fit: BoxFit.cover,
              ),
              borderRadius: new BorderRadius.all(new Radius.circular(10.0)),
            ),
          ),
        ),
        ListTile(
          title:
              Text(widget._staff.name, style: TextStyle(fontWeight: FontWeight.w500)),
          subtitle: Text(widget._staff.workType),
          leading: Icon(
            Icons.contacts,
            color: Colors.blue[500],
          ),
          onLongPress: () {
            _copyData(context, widget._staff.name);
          },
        ),
        Divider(),
        ListTile(
          title: Text(widget._staff.pname),
          leading: Icon(
            Icons.domain,
            color: Colors.blue[500],
          ),
          onLongPress: () {
            _copyData(context, widget._staff.pname);
          },
        ),
        ListTile(
          title: Text(widget._staff.phone),
          leading: Icon(
            Icons.call,
            color: Colors.blue[500],
          ),
          onLongPress: () {
            _copyData(context, widget._staff.phone);
          },
        ),
        ListTile(
          title: Text(widget._staff.email),
          leading: Icon(
            Icons.email,
            color: Colors.blue[500],
          ),
          onLongPress: () {
            _copyData(context, widget._staff.email);
          },
        ),
        ListTile(
          title: Text(widget._staff.qq),
          leading: Icon(
            MyIcon.qq,
            color: Colors.blue[500],
          ),
          onLongPress: () {
            _copyData(context, widget._staff.qq);
          },
        ),
        ListTile(
          title: Text(widget._staff.wx),
          leading: Icon(
            MyIcon.wx,
            color: Colors.blue[500],
          ),
          onLongPress: () {
            _copyData(context, widget._staff.wx);
          },
        ),
        ListTile(
          title: Text(widget._staff.gxtAccount),
          leading: Icon(
            MyIcon.gxt,
            color: Colors.blue[500],
          ),
          onLongPress: () {
            _copyData(context, widget._staff.gxtAccount);
          },
        ),
        ListTile(
          title: Text(widget._staff.birthday),
          leading: Icon(
            Icons.cake,
            color: Colors.blue[500],
          ),
          onLongPress: () {
            _copyData(context, widget._staff.birthday);
          },
        ),
        RaisedButton(
          child: new Text("修改头像"),
          color: Colors.white70,
          onPressed: () {
            _onImageButtonPressed(context, ImageSource.gallery);
          },
        ),
        RaisedButton(
          child: new Text("退 出${_version}"),
          color: Colors.redAccent,
          onPressed: () {
            api.logout();
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
              (Route<dynamic> route) {
                return false;
              },
            );
          },
        ),
      ],
    );

    return Scaffold(
        body: Builder(builder: (context) => _loading
            ? Stack(
          alignment: FractionalOffset.center,
          children: [
            listView,
            Opacity(
                opacity: 0.8,
                child: ModalBarrier(
                  color: Color(0xFFEEEEEE),
                )),
            CircularProgressIndicator()
          ],
        ) : listView));
  }
}

class AvatarUpdateEvent {
  String _avatar;

  AvatarUpdateEvent(this._avatar);

  String get avatar => _avatar;
}
