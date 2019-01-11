import 'package:flutter/material.dart';
import 'Project.dart';
import 'Staff.dart';
import 'staff_info.dart';
import 'package:dio/dio.dart';
import 'helper.dart';
import 'package:cached_network_image/cached_network_image.dart';

class SecondProjectPage extends StatefulWidget {
  final Project project;
  List<Project> projectList = new List();

  SecondProjectPage(
      {Key key,
      @required this.project})
      : super(key: key);

  @override
  _SecondProjectPageState createState() => _SecondProjectPageState();
}

class _SecondProjectPageState extends State<SecondProjectPage> {
  ScrollController _scrollController = new ScrollController();
  static final int SOURCE = 1;
  int _page = 1;
  bool _request = true;
  List<Staff> staffList = new List();

  @override
  void initState() {
    super.initState();

    this.initData();
    
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent
        && staffList.length >= 20 && _page > 1) {
        getMore();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void initData() async {
    _page = 1;
    Response staffResponse = await api.listStaff(widget.project.id, _page, SOURCE);

    setState(() {
      if (staffResponse.data['success']) {
        staffList = Staff.buildList(staffResponse.data['data']);
      }
      _request = false;
    });
    _page ++;
  }

  void getMore() async {
    setState(() {
      _request = true;
    });

    List<Staff> list;
    Response response = await api.listStaff(widget.project.id, _page, SOURCE);
    if (response.data['success']) {
      list = Staff.buildList(response.data['data']);
      if (list == null || list.length < 1) {
        _page = -1;
        setState(() {
          _request = false;
        });
        return;
      }
    }
    _page ++;

    if (list != null) {
      setState(() {
        _request = false;
        staffList.addAll(list);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.project.getName),
        ),
        body: _request ? Center(
          child: CircularProgressIndicator(),
        ) : RefreshIndicator(
          child: ListView.builder(
            itemCount: staffList.length,
            itemBuilder: (context, index) {
              if (index == staffList.length) {
                return _buildProgressIndicator();
              } else {
                return ListTile(
                    leading: new CircleAvatar(
                        child: this.staffList[index].avatar == null ?
                        new Text(String.fromCharCode(this.staffList[index].name.codeUnitAt(0))) :
                        new CachedNetworkImage(
                          imageUrl: this.staffList[index].avatar,
                        )
                    ),
                    title: new Text(staffList[index].name),
                    subtitle: new Text(staffList[index].workType),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => ContactsDemo(staffList[index])));
                    });
              }
            },
            controller: _scrollController,
          ),
          onRefresh: _handleRefresh,
        )
    );
  }

  Widget _buildProgressIndicator() {
    return new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Center(
        child: new Opacity(
          opacity: _request ? 1.0 : 0.0,
          child: new CircularProgressIndicator(),
        ),
      ),
    );
  }

  Future<Null> _handleRefresh() async {
    await new Future.delayed(new Duration(seconds: 1));
    initData();

    return null;
  }
}
