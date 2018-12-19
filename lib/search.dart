import 'package:flutter/material.dart';
import 'helper.dart';
import 'package:dio/dio.dart';
import 'SearchResult.dart';
import 'staff_info.dart';
import 'Staff.dart';
import 'Company.dart';
import 'Project.dart';
import 'second_company.dart';
import 'second_project.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => new _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController controller = new TextEditingController();
  List<SearchResult> _searchResult = new List();
  bool empty = false;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('搜索'),
        elevation: 0.0,
      ),
      body: new Column(
        children: <Widget>[
          new Container(
            color: Theme.of(context).primaryColor,
            child: new Padding(
              padding: const EdgeInsets.all(8.0),
              child: new Card(
                child: new ListTile(
                  leading: new Icon(Icons.search),
                  title: new TextField(
                    controller: controller,
                    decoration: new InputDecoration(
                        hintText: '搜索', border: InputBorder.none),
                    onSubmitted: onSearchTextChanged,
                  ),
                  trailing: new IconButton(icon: new Icon(Icons.cancel), onPressed: () {
                    controller.clear();
                    onSearchTextChanged('');
                  },),
                ),
              ),
            ),
          ),
          loading ? Container(
            margin: const EdgeInsets.all(50.0),
            child: CircularProgressIndicator(),
          ) :
          new Expanded(
            child: empty ? Center(child: Text('无结果'),) : buildList()
          ),
        ],
      ),
    );
  }

  Widget buildList() {
    return new ListView.builder(
      itemCount: _searchResult.length,
      itemBuilder: (context, i) {
        return new Card(
          child: new ListTile(
            leading: Icon(
              _searchResult[i].type == 1 ? Icons.contacts : Icons.domain,
              color: Colors.blue[500],
            ),
            title: new Text(_searchResult[i].title),
            onTap: () async {
              SearchResult sr = _searchResult[i];
              Map map = new Map();
              map['name'] = sr.title;
              map['id'] = sr.id;

              if (sr.type == 1) {
                Response response = await api.getStaff(sr.id);
                if (response.data['success']) {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ContactsDemo(Staff(response.data['data']))));
                }
              } else if (sr.type == 2) {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SecondCompanyPage(company: new Company(map))));
              } else if (sr.type == 3) {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SecondProjectPage(project: new Project(map))));
              }
            },
          ),
          margin: const EdgeInsets.all(0.0),
        );
      },
    );
  }

  onSearchTextChanged(String text) async {
    _searchResult.clear();
    if (text.isEmpty) {
      this.loading = false;
      this.empty = false;

      setState(() {});
      return;
    }

    setState(() {
      this.loading = true;
    });

    Response response = await api.search(text);
    // print(response.data);

    for(Map map in response.data['data']) {
      _searchResult.add(SearchResult(map['id'], map['type'], map['title']));
    }
    setState(() {
      this.empty = _searchResult.isEmpty;
      this.loading = false;
    });
  }
}
