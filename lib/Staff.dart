import 'dart:convert';

class Staff {
  int _id;
  String _name;
  int _pid;
  String _pname;
  String _workType;
  int _gender;
  String _birthday;
  String _school;
  String _major;
  String _phone;
  String _qq;
  String _gxtAccount;
  String _email;
  String _wx;
  String _workAddress;

  Staff(Map map) {
    this._id = map['id'];
    this._name = map['name'];
    this._pid = map['pid'];
    this._pname = map['pname'];
    this._workType = map['type'];
    this._gender = map['gender'];
    this._birthday = map['birthday'];
    this._school = map['school'];
    this._major = map['major'];
    this._phone = map['phone'];
    this._qq = map['qq'];
    this._gxtAccount = map['gxtAccount'];
    this._email = map['email'];
    this._wx = map['wx'];
    this._workAddress = map['workAddress'];
  }

  static List<Staff> buildList(List list) {
    List<Staff> staffs = new List();
    for (Map map in list) {
      staffs.add(new Staff(map));
    }
    return staffs;
  }

  @override
  String toString() {
    return 'Staff{_id: $_id, _name: $_name, _pid: $_pid, _pname: $_pname, _workType: $_workType, _gender: $_gender, _birthday: $_birthday, _school: $_school, _major: $_major, _phone: $_phone, _qq: $_qq, _gxtAccount: $_gxtAccount, _email: $_email, _wx: $_wx, _workAddress: $_workAddress}';
  }

  int get pid => _pid;
  
  String get workType => _workType;
  
  String get name => _name;
  
  int get id => _id;
  
  String get gender => _gender == 1 ? '男' : '女';

  String get birthday => _birthday;

  String get school => _school;

  String get major => _major;

  String get phone => _phone;

  String get qq => _qq;

  String get gxtAccount => _gxtAccount;

  String get email => _email;

  String get wx => _wx;

  String get workAddress => _workAddress;

  String get pname => _pname;

  void setPname(String value) {
    _pname = value;
  }

}