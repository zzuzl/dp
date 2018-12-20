import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'Company.dart';
import 'Project.dart';
import 'package:sentry/sentry.dart';

class Api {
  static String token = "";
  static const String TOKEN_KEY = "token";
  static const String BASE = "http://www.zlihj.cn/";
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
    print('init token:${token}');
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
}