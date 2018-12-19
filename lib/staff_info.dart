import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Staff.dart';
import 'MyIcon.dart';
import 'package:url_launcher/url_launcher.dart';

class _ContactCategory extends StatelessWidget {
  const _ContactCategory({Key key, this.icon, this.children}) : super(key: key);

  final IconData icon;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: themeData.dividerColor))),
      child: DefaultTextStyle(
        style: Theme.of(context).textTheme.subhead,
        child: SafeArea(
          top: false,
          bottom: false,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  width: 72.0,
                  child: Icon(icon, color: themeData.primaryColor)),
              Expanded(child: Column(children: children))
            ],
          ),
        ),
      ),
    );
  }
}

class ContactsDemo extends StatefulWidget {
  final Staff staff;

  ContactsDemo(this.staff);

  @override
  ContactsDemoState createState() => ContactsDemoState(this.staff);
}

class ContactsDemoState extends State<ContactsDemo> {
  static final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>();
  final double _appBarHeight = 256.0;
  final Staff staff;

  ContactsDemoState(this.staff);

  String getText(String s) {
    return s == null ? '' : s;
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.indigo,
        platform: Theme.of(context).platform,
      ),
      child: Scaffold(
        key: _scaffoldKey,
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              expandedHeight: _appBarHeight,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(staff.name + '(${staff.gender})'),
                background: Stack(
                  fit: StackFit.expand,
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(<Widget>[
                _ContactCategory(
                  icon: Icons.contacts,
                  children: <Widget>[
                    ListTile(
                      title: Text(getText(staff.pname),
                          style: TextStyle(fontWeight: FontWeight.w300)),
                      onLongPress: () {
                        Clipboard.setData(new ClipboardData(text: getText(staff.pname)));
                      },
                    ),
                  ],
                ),
                _ContactCategory(
                  icon: Icons.domain,
                  children: <Widget>[
                    ListTile(
                      title: Text(getText(staff.workType),
                          style: TextStyle(fontWeight: FontWeight.w300)),
                      onLongPress: () {
                        Clipboard.setData(new ClipboardData(text: getText(staff.workType)));
                      },
                    ),
                  ],
                ),
                _ContactCategory(
                  icon: Icons.cake,
                  children: <Widget>[
                    ListTile(
                      title: Text(getText(staff.birthday),
                          style: TextStyle(fontWeight: FontWeight.w300)),
                      onLongPress: () {
                        Clipboard.setData(new ClipboardData(text: getText(staff.birthday)));
                      },
                    ),
                  ],
                ),
                _ContactCategory(
                  icon: Icons.email,
                  children: <Widget>[
                    ListTile(
                      title: Text(getText(staff.email),
                          style: TextStyle(fontWeight: FontWeight.w300)),
                      onLongPress: () {
                        Clipboard.setData(new ClipboardData(text: getText(staff.email)));
                      },
                    ),
                  ],
                ),
                _ContactCategory(
                  icon: MyIcon.qq,
                  children: <Widget>[
                    ListTile(
                      title: Text(getText(staff.qq),
                          style: TextStyle(fontWeight: FontWeight.w300)),
                      onLongPress: () {
                        Clipboard.setData(new ClipboardData(text: getText(staff.qq)));
                      },
                    ),
                  ],
                ),
                _ContactCategory(
                  icon: MyIcon.wx,
                  children: <Widget>[
                    ListTile(
                      title: Text(getText(staff.wx),
                          style: TextStyle(fontWeight: FontWeight.w300)),
                      onLongPress: () {
                        Clipboard.setData(new ClipboardData(text: getText(staff.wx)));
                      },
                    ),
                  ],
                ),
                _ContactCategory(
                  icon: MyIcon.gxt,
                  children: <Widget>[
                    ListTile(
                      title: Text(getText(staff.gxtAccount),
                          style: TextStyle(fontWeight: FontWeight.w300)),
                      onLongPress: () {
                        Clipboard.setData(new ClipboardData(text: getText(staff.gxtAccount)));
                      },
                    ),
                  ],
                ),
                _ContactCategory(
                  icon: Icons.call,
                  children: <Widget>[
                    ListTile(
                      title: Text(getText(staff.phone),
                          style: TextStyle(fontWeight: FontWeight.w300)),
                      onLongPress: () {
                        Clipboard.setData(new ClipboardData(text: getText(staff.phone)));
                      },
                      trailing: IconButton(
                        icon: const Icon(Icons.call),
                        onPressed: () async {
                          String url = 'tel:' + staff.phone;
                          if (await canLaunch(url)) {
                            await launch(url);
                          }
                        },
                      ),
                    ),
                  ],
                ),
                _ContactCategory(
                  icon: Icons.location_on,
                  children: <Widget>[
                    ListTile(
                      title: Text(getText(staff.workAddress),
                          style: TextStyle(fontWeight: FontWeight.w300)),
                      onLongPress: () {
                        Clipboard.setData(new ClipboardData(text: getText(staff.workAddress)));
                      },
                    ),
                  ],
                ),
                _ContactCategory(
                  icon: Icons.school,
                  children: <Widget>[
                    ListTile(
                      title: Text(getText(staff.school),
                          style: TextStyle(fontWeight: FontWeight.w300)),
                      onLongPress: () {
                        Clipboard.setData(new ClipboardData(text: getText(staff.school)));
                      },
                    ),
                    ListTile(
                      title: Text(getText(staff.major),
                          style: TextStyle(fontWeight: FontWeight.w300)),
                      onLongPress: () {
                        Clipboard.setData(new ClipboardData(text: getText(staff.major)));
                      },
                    ),
                  ],
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
