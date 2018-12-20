import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'Company.dart';
import 'Project.dart';
import 'package:sentry/sentry.dart';
import 'dart:convert';

class Api {
  static String token = "";
  static const String TOKEN_KEY = "token";
  static const String COMPANY_KEY = "company_list";
  static const String PROJECT_KEY = "project_list";
  static const String BASE = "https://www.zlihj.cn/";
  static final Dio dio = new Dio();
  static SharedPreferences sp = null;
  static final int COMPANY_SOURCE = 0;
  static final int Project_SOURCE = 1;
  static final SentryClient _sentry = SentryClient(dsn: "https://b73bc3090e8e45f9bf27fa181a819f9a@sentry.io/1357328");

  Api() {
    dio.interceptor.request.onSend = (Options options) {
      options.contentType=ContentType.parse("application/x-www-form-urlencoded");
      options.headers = {TOKEN_KEY: token};

      return options;
    };
    dio.interceptor.response.onSuccess = (Response response) {
      String token = response.headers.value(TOKEN_KEY);
      if (token != null && token.length > 0) {
        storeToken(token);
      }

      return response; // continue
    };
  }

  Future<void> reportError(dynamic error, dynamic stackTrace) async {
    // Print the exception to the console
    print('Caught error: $error, stackTrace: $stackTrace');
      // Send the Exception and Stacktrace to Sentry in Production mode
    _sentry.captureException(
      exception: error,
      stackTrace: stackTrace,
    );
  }

  void initSp(SharedPreferences s) {
    /*const MethodChannel('plugins.flutter.io/shared_preferences')
        .setMockMethodCallHandler((MethodCall methodCall) async {
      if (methodCall.method == 'getAll') {
        return <String, dynamic>{}; // set initial values here if desired
      }
      return null;
    });*/
    sp = s;
    token = sp.getString(TOKEN_KEY);
  }

  Future<Response> login(String email, String password) {
    return dio.post(BASE + "rest/staff/login", data: {
      "user": email,
      "password": password
    });
  }

  void logout() {
    sp.remove(TOKEN_KEY);
  }

  Future<Response> search(String key) {
    return dio.get(BASE + "rest/search?key=${key}");
  }

  Future<Response> listCompany(int pid) {
    return dio.get(BASE + "rest/company/list?pid=${pid}");
  }

  Future<Response> listProject(int pid) {
    return dio.get(BASE + "rest/project/list?pid=${pid}");
  }

  Future<Response> listStaff(int pid, int page, int source) {
    return dio.get(BASE + "rest/staff/findByPid?pid=${pid}&page=${page}&source=${source}");
  }

  Future<Response> getStaff(int id) {
    return dio.get(BASE + "rest/staff/findById?id=${id}");
  }

  Future<Response> getCompany(int id) {
    return dio.get(BASE + "rest/company/findById?id=${id}");
  }

  Future<Response> getProject(int id) {
    return dio.get(BASE + "rest/project/findById?id=${id}");
  }

  Future<Response> checkToken() {
    return dio.get(BASE + "rest/checkLogin");
  }

  Future<Response> download(String uri, String savePath) {
    return dio.download(uri, savePath);
  }

  Future<Response> checkVersion() {
    return dio.get(BASE + "rest/checkVersion");
  }

  void storeToken(String _token) {
    token = _token;
    sp.setString(TOKEN_KEY, token);
  }

  void storeCompany(List<Company> companys) {
    sp.setString(COMPANY_KEY, jsonEncode(companys));
  }

  void storeProject(List<Project> projects) {
    sp.setString(PROJECT_KEY, jsonEncode(projects));
  }

  List<Company> loadLocalCompany() {
    List<Company> list = [];
    try {
      var company_s = sp.getString(COMPANY_KEY);
      if (company_s == null) {
        return list;
      }

      List maps = jsonDecode(company_s);
      if (maps != null) {
        for (Map map in maps) {
          list.add(new Company(map));
        }
      }
    } catch(e) {
      print(e);
    }

    return list;
  }

  List<Project> loadLocalProject() {
    List<Project> list = [];
    try {
      var project_s = sp.getString(PROJECT_KEY);
      if (project_s == null) {
        return list;
      }

      List maps = jsonDecode(project_s);
      if (maps != null) {
        for (dynamic map in maps) {
          list.add(new Project(map));
        }
      }
    } catch(e) {
      print(e);
    }

    return list;
  }
}