import 'package:flutter/material.dart';
import 'Company.dart';
import 'Staff.dart';
import 'staff_info.dart';
import 'package:dio/dio.dart';
import 'helper.dart';

class SecondCompanyPage extends StatefulWidget {
  final Company company;
  List<Company> companyList = new List();

  SecondCompanyPage({Key key, @required this.company}) : super(key: key);

  @override
  _SecondCompanyPageState createState() => _SecondCompanyPageState();
}

class _SecondCompanyPageState extends State<SecondCompanyPage> {
  ScrollController _scrollController = new ScrollController();
  static final int SOURCE = 0;
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
    Response response = await api.listCompany(widget.company.id);
    Response staffResponse = await api.listStaff(widget.company.id, _page, SOURCE);

    setState(() {
      if (response.data['success']) {
        widget.companyList = Company.buildList(response.data['data']);
      }
      if (staffResponse.data['success']) {
        this.staffList = Staff.buildList(staffResponse.data['data']);
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
    Response response = await api.listStaff(widget.company.id, _page, SOURCE);
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
        this.staffList.addAll(list);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.company.getName),
        ),
        body: _request ? Center(
          child: CircularProgressIndicator(),
        ) : ListView.builder(
          itemCount: this.staffList.length,
          itemBuilder: (context, index) {
            if (index == this.staffList.length) {
              return _buildProgressIndicator();
            } else {
              return ListTile(
                  leading: new CircleAvatar(child: new Text(String.fromCharCode(this.staffList[index].name.codeUnitAt(0)))),
                  title: new Text(this.staffList[index].name),
                  subtitle: new Text(this.staffList[index].workType),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => ContactsDemo(this.staffList[index])));
                  });
            }
          },
          controller: _scrollController,
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

}
