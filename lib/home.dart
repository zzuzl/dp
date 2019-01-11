import 'package:flutter/material.dart';
import 'login.dart';
import 'helper.dart';
import 'package:dio/dio.dart';
import 'dart:io';
import 'Company.dart';
import 'Project.dart';
import 'Staff.dart';
import 'second_company.dart';
import 'second_project.dart';
import 'me.dart';
import 'search.dart';
import 'package:event_bus/event_bus.dart';

class MyHomePage extends StatefulWidget {
  final Staff staff;
  MyHomePage({Key key, @required this.staff}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState(staff);
}

class _MyHomePageState extends State<MyHomePage> {
  final Staff _staff;
  final EventBus _eventBus = new EventBus();
  int _selectedIndex = 0;
  List<Company> companyList;
  List<Project> projectList;
  int last = 0;

  _MyHomePageState(this._staff);

  @override
  void initState() {
    super.initState();

    this.companyList = api.loadLocalCompany();
    this.projectList = api.loadLocalProject();

    this.initData();

    _eventBus.on<AvatarUpdateEvent>().listen((event) {
      _staff.avatar = event.avatar;
    });
  }

  void initData() async {
    Response response = await api.listCompany(0);
    List<Company> companys = Company.buildList(response.data['data']);
    api.storeCompany(companys);

    setState(() {
      this.companyList = companys;
    });

    response = await api.listProject(0);
    List<Project> projects = Project.buildList(response.data['data']);
    api.storeProject(projects);

    setState(() {
      this.projectList = projects;
    });
  }

  Widget buildIndex() {
    if (_selectedIndex == 0) {
      return _buildIndex(companyList);
    } else if (_selectedIndex == 1) {
      return _buildIndex(projectList);
    } else {
      return MePage(_staff, _eventBus);
    }
  }

  Widget _buildIndex(List list) {
    return new ListView.builder(
        itemCount: list == null ? 0 : list.length,
        itemBuilder: (BuildContext context, int index) {
          return new Container(
            child: new Center(
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  ListTile(
                    title: Text(list[index].getName,
                        style: TextStyle(fontWeight: FontWeight.w300)),
                    // subtitle: Text('85 W Portal Ave'),
                    leading: Icon(
                      _selectedIndex == 0 ? Icons.bookmark_border: Icons.domain,
                      color: Colors.blue[500],
                    ),
                    onTap: () async {
                      if (_selectedIndex == 0) {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) => SecondCompanyPage(
                            company: list[index],
                          ),
                        ));
                      } else if (_selectedIndex == 1) {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) => SecondProjectPage(
                            project: list[index],
                          ),
                        ));
                      }
                    }
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        int now = DateTime.now().millisecond;
        if (now - last > 800) {
          last = DateTime.now().millisecond;
          return Future.value(false);
        } else {
          return Future.value(true);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('中原分公司数字人事'),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => SearchPage()));
              },
            ),
          ],
        ),
        body: buildIndex(),
        bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home), title: Text('总部')),
            BottomNavigationBarItem(
                icon: Icon(Icons.business), title: Text('项目簇')),
            BottomNavigationBarItem(
                icon: Icon(Icons.account_circle), title: Text('我的')),
          ],
          currentIndex: _selectedIndex,
          fixedColor: Colors.deepPurple,
          onTap: _onItemTapped,
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
