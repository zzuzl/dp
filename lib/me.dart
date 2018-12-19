import 'package:flutter/material.dart';
import 'Staff.dart';
import 'MyIcon.dart';
import 'package:flutter/services.dart';
import 'helper.dart';
import 'login.dart';

class MePage extends StatelessWidget {
  final Staff staff;

  MePage(this.staff);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text(staff.name,
                style: TextStyle(fontWeight: FontWeight.w500)),
            subtitle: Text(staff.workType),
            leading: Icon(
              Icons.contacts,
              color: Colors.blue[500],
            ),
            onLongPress: () {
              Clipboard.setData(new ClipboardData(text: staff.name));
            },
          ),
          Divider(),
          ListTile(
            title: Text(staff.pname),
            leading: Icon(
              Icons.domain,
              color: Colors.blue[500],
            ),
            onLongPress: () {
              Clipboard.setData(new ClipboardData(text: staff.pname));
            },
          ),
          ListTile(
            title: Text(staff.phone),
            leading: Icon(
              Icons.call,
              color: Colors.blue[500],
            ),
            onLongPress: () {
              Clipboard.setData(new ClipboardData(text: staff.phone));
            },
          ),
          ListTile(
            title: Text(staff.email),
            leading: Icon(
              Icons.email,
              color: Colors.blue[500],
            ),
            onLongPress: () {
              Clipboard.setData(new ClipboardData(text: staff.email));
            },
          ),
          ListTile(
            title: Text(staff.qq),
            leading: Icon(
              MyIcon.qq,
              color: Colors.blue[500],
            ),
            onLongPress: () {
              Clipboard.setData(new ClipboardData(text: staff.qq));
            },
          ),
          ListTile(
            title: Text(staff.wx),
            leading: Icon(
              MyIcon.wx,
              color: Colors.blue[500],
            ),
            onLongPress: () {
              Clipboard.setData(new ClipboardData(text: staff.wx));
            },
          ),
          ListTile(
            title: Text(staff.gxtAccount),
            leading: Icon(
              MyIcon.gxt,
              color: Colors.blue[500],
            ),
            onLongPress: () {
              Clipboard.setData(new ClipboardData(text: staff.gxtAccount));
            },
          ),
          ListTile(
            title: Text(staff.workAddress),
            leading: Icon(
              Icons.location_on,
              color: Colors.blue[500],
            ),
            onLongPress: () {
              Clipboard.setData(new ClipboardData(text: staff.workAddress));
            },
          ),
          ListTile(
            title: Text(staff.birthday),
            leading: Icon(
              Icons.cake,
              color: Colors.blue[500],
            ),
            onLongPress: () {
              Clipboard.setData(new ClipboardData(text: staff.birthday));
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
      ),
    );
  }
}