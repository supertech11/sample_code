import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xplor/Model/LanguageResponce.dart';
import 'package:xplor/util/Colorss.dart';
import 'package:xplor/util/SizeConfig.dart';
import 'package:xplor/util/Strings.dart';
import 'package:xplor/util/utilities.dart';

class ApiControler {
  // headers: {HttpHeaders.authorizationHeader: "Basic your_api_token_here"}

//  static const String base_url =
//      'http://apps.bindboxes.com:8085/Xplor/api/user/';
  static const String base_url = 'http://172.104.34.79:8080/Xplor/api/user/';
  // 'http://172.104.34.79:8080/Xplor/api/user/';
//  New URl :-
//  Old :-   http://172.104.34.79:8080/Xplor/
//  New :- dashboard.xplormicromobility.com
  var prefs, lanRes;

  // getUrl() async {
  //   prefs = await SharedPreferences.getInstance();
  //   var data = prefs.getString('languageData');
  //   Map langMap = jsonDecode(data.toString());
  //   lanRes = LanguageResponce.parseLanguage(langMap).IpaAddress.lbl_server;
  //   var url = lanRes.result.data.IpaAddress.lbl_server + "/Xplor/api/user/";
  //   print("llllll" + lanRes.result.data.navigation.btn_LogOut.toString());

  //   return lanRes;
  // }

  Future<String> dioPost(context, api_name, data) async {
    prefs = await SharedPreferences.getInstance();
    var datavalue = prefs.getString('url');
    print(data);
    try {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi) {
        // I am connected to a mobile network.
        print("I am connected to network");
        print(base_url + api_name);
        print("body>> " + data.toString());

        var dio = Dio();

        dio.interceptors.add(LogInterceptor(requestBody: true));
        var response = await dio.post(datavalue + "/Xplor/api/user/" + api_name,
            data: data);
        print("response  login ddd>> " + response.toString());
        if (response.statusCode == 200) {
          return response.toString();
        } else if (response.statusCode == 500) {
          return "";
          new Utilities().showAlertDialog(
              context, Strings.alert, Strings.network_error, "OK");
        } else {
          return "";
        }
      } else {
        print("I am  not connected to a mobile network");
        new Utilities().showAlertDialog(
            context, Strings.alert, Strings.network_error, "OK");
        return "";
        // I am connected to a wifi network.
      }
    } catch (e, s) {
      print("$e");
      print("$s");
      return null;
    }
  }

  Future<String> dioAuthPost(context, authtoken, api_name, data) async {
    prefs = await SharedPreferences.getInstance();
    var datavalue = prefs.getString('url');
    print("@@@@@@@@" + datavalue);
    try {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi) {
        // I am connected to a mobile network.
        print("I am connected to network");
        print(base_url + api_name);
        print("body>> " + data.toString());

        var dio = Dio();
        dio.options.headers['content-Type'] = 'application/json';
        dio.options.headers["AUTHTOKEN"] = authtoken;
        dio.interceptors.add(LogInterceptor(requestBody: true));
        var response = await dio.post(datavalue + "/Xplor/api/user/" + api_name,
            data: data);
        print("response  ddd>> " + response.toString());
        if (response.statusCode == 200) {
          return response.toString();
        } else if (response.statusCode == 500) {
          return "";
          new Utilities().showAlertDialog(
              context, Strings.alert, Strings.network_error, "OK");
        } else {
          return "";
        }
      } else {
        print("I am  not connected to a mobile network");
        new Utilities().showAlertDialog(
            context, Strings.alert, Strings.network_error, "OK");
        return "";
        // I am connected to a wifi network.
      }
    } catch (e, s) {
      print("$e");
      print("$s");
      return null;
    }
  }

  Future<String> dioGet(context, api_name, data) async {
    prefs = await SharedPreferences.getInstance();
    var datavalue = prefs.getString('url');
    print(data);
    try {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi) {
        // I am connected to a mobile network.
        print("I am connected to network");
        print(base_url + api_name);
        print("body>> " + data.toString());

        var dio = Dio();
        dio.interceptors.add(LogInterceptor(requestBody: true));
        var response = await dio.get(
          datavalue + "/Xplor/api/user/" + api_name,
        );
        print("response  ddd>> " + response.toString());
        if (response.statusCode == 200) {
          return response.toString();
        } else if (response.statusCode == 500) {
          return "";
          new Utilities().showAlertDialog(
              context, Strings.alert, Strings.network_error, "OK");
        } else {
          return "";
        }
      } else {
        print("I am  not connected to a mobile network");
        new Utilities().showAlertDialog(
            context, Strings.alert, Strings.network_error, "OK");
        return "";
        // I am connected to a wifi network.
      }
    } catch (e, s) {
      print("$e");
      print("$s");
      return null;
    }
  }

  Future<String> dioAuthGet(context, authtoken, api_name, data) async {
    prefs = await SharedPreferences.getInstance();
    var datavalue = prefs.getString('url');
    print(data);
    try {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi) {
        // I am connected to a mobile network.
        print("I am connected to network");
        print(base_url + api_name);
        print("body>> " + data.toString());
        var dio = Dio();
        dio.interceptors.add(LogInterceptor(requestBody: true));
        // dio.options.headers["AUTHTOKEN"] = authtoken;
        dio.options.headers.addAll({"AUTHTOKEN": authtoken});
        dio.options.headers['content-Type'] = 'application/json';
        var response = await dio.get(datavalue + "/Xplor/api/user/" + api_name);
        print("response  ddd>> " + response.toString());
        if (response.statusCode == 200) {
          return response.toString();
        } else if (response.statusCode == 500) {
          return "";
          new Utilities().showAlertDialog(
              context, Strings.alert, Strings.network_error, "OK");
        } else {
          return "";
        }
      } else {
        print("I am  not connected to a mobile network");
        new Utilities().showAlertDialog(
            context, Strings.alert, Strings.network_error, "OK");
        return "";
        // I am connected to a wifi network.
      }
    } catch (e, s) {
      print("$e");
      print("$s");
      return null;
    }
  }

  Future<String> register(context, api_name, {Map body}) async {
    prefs = await SharedPreferences.getInstance();
    var datavalue = prefs.getString('url');
    try {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi) {
        // I am connected to a mobile network.
        print("I am connected to network");
        print(base_url + api_name);
        print("body>> " + body.toString());

        HttpClient httpClient = new HttpClient();

        httpClient.badCertificateCallback =
            ((X509Certificate cert, String host, int port) => true);

        HttpClientRequest request = await httpClient
            .postUrl(Uri.parse(datavalue + "/Xplor/api/user/" + api_name));
        request.headers.set('content-type', 'application/json');
        request.add(utf8.encode(json.encode(body)));

        HttpClientResponse response = await request.close();
        // todo - you should check the response.statusCode

        if (response.statusCode == 200) {
          String reply = await response.transform(utf8.decoder).join();
          httpClient.close();
          print(api_name + "" + reply);
          return reply;
        } else if (response.statusCode == 401) {
          String reply = await response.transform(utf8.decoder).join();
          httpClient.close();
          print(api_name + "" + reply);
          return reply;
        } else {
          return "";
        }
      } else {
        print("I am  not connected to a mobile network");
        new Utilities().showAlertDialog(
            context, Strings.alert, Strings.network_error, "OK");
        return null;
        // I am connected to a wifi network.
      }
    } catch (e, s) {
      print("$e");
      print("$s");
      return null;
    }
  }
}
