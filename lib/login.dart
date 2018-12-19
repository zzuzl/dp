import 'package:flutter/material.dart';
import 'helper.dart';
import 'package:dio/dio.dart';
import 'home.dart';
import 'Staff.dart';
import 'main.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool buttonEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          children: <Widget>[
            SizedBox(height: 80.0),
            Column(
              children: <Widget>[
                Image.asset('images/diamond.png'),
                SizedBox(height: 16.0),
                TextField(
                    decoration: InputDecoration(
                      labelText: '邮箱',
                    ),
                    controller: _usernameController),
                SizedBox(height: 12.0),
                TextField(
                    decoration: InputDecoration(
                      labelText: '密码',
                    ),
                    obscureText: true,
                    controller: _passwordController)
              ],
            ),
            SizedBox(height: 120.0),
            ButtonBar(
              children: <Widget>[
                buildButton(),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget buildButton() {
    return new RaisedButton(
      child: new Text(
          buttonEnabled ? "登录" : "登录中"
      ),
      onPressed: buttonEnabled ? login : null,
    );
  }

  void login() async {
    setState(() {
      buttonEnabled = false;
    });
    Response response =
        await api.login(_usernameController.text, _passwordController.text);
    if (response.data['success']) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyHomePage(staff: Staff(response.data['data']))));
    } else {
      showDialog<void>(
        context: context,
        barrierDismissible: true, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('提示'),
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

      setState(() {
        buttonEnabled = true;
      });
    }
  }
}
