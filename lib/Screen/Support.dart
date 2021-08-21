import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xplor/Model/ApiResponce.dart';
import 'package:xplor/Model/LanguageResponce.dart';
import 'package:xplor/util/ApiControler.dart';
import 'package:xplor/util/AppHeader.dart';
import 'package:xplor/util/Colorss.dart';
import 'package:xplor/util/Dimens.dart';
import 'package:xplor/util/SizeConfig.dart';
import 'package:xplor/util/Strings.dart';
import 'package:xplor/util/utilities.dart';

import 'package:xplor/widgets/independent/support_line.dart';

class Support extends StatefulWidget {
  Support({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SupportPageState createState() => _SupportPageState();
}

class _SupportPageState extends State<Support> {
  var profile;
  bool isProgressShow = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDataLanguage();
    getSuportdetails();
  }

  var prefs;
  var lanRes;

  getDataLanguage() async {
    prefs = await SharedPreferences.getInstance();
    var data = prefs.getString('languageData');
    Map langMap = jsonDecode(data.toString());
    lanRes = LanguageResponce.parseLanguage(langMap);
    print(lanRes.result.data.Settings.lbl_firstname1);
  }

  getSuportdetails() async {
    final prefs = await SharedPreferences.getInstance();
    var authToken = prefs.getString('authToken');
    setState(() {
      isProgressShow = true;
    });
    var dio = Dio();
    dio.interceptors.add(LogInterceptor(requestBody: true));

    new ApiControler().dioAuthGet(context, authToken, Strings.suportdetails, {
      "authToken": authToken,
    }).then((onValue) {
      parse(onValue);
    });
  }

  var supportData;

  parse(reply) async {
    setState(() {
      isProgressShow = false;
    });

    if (reply != null) {
      Map userMap = jsonDecode(reply);
      var user = ApiResponce.fromJson(userMap);
      print('user' + user.toString());
      if (user.success) {
        supportData = ApiResponce.parseSupportResponce(userMap);
        setState(() {});
      } else {
        new Utilities()
            .showAlertDialog(context, Strings.alert, user.result.message, "OK");
        // print('Howdy, ${user.message} !');
      }
    }
  }

  setDate(date) {
    try {
      var now = new DateTime.now();
      var date4 = DateTime.parse("2019-10-10 " + date + ":00");
      //var date4 = DateTime.parse("2019-10-10 03:30:00");
      var formatter = new DateFormat('hh:mm aa');
      String formatted = formatter.format(date4);
      return formatted.toString();
    } catch (E) {
      return "!!";
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Material(
          color: Colorss.primary,
          child: new Stack(
            children: <Widget>[
              new Container(
                  decoration: BoxDecoration(
                    color: Colorss.gradient1,
                    gradient: LinearGradient(
                      // Where the linear gradient begins and ends
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      // Add one stop for each color. Stops should increase from 0 to 1
                      colors: [
                        Colorss.hgradient1,
                        Colorss.hgradient2,
                      ],
                    ),
                  ),
                  child: new ListView(
                    children: <Widget>[
                      new Container(
                          child: AppHeader(
                        title: lanRes != null
                            ? lanRes.result.data.navigation.lbl_Support
                            : Strings.support,
                        onBackClick: () {
                          Navigator.pop(context);
                        },
                      ))
                    ],
                  )),
              new Positioned(
                top: SizeConfig.safeBlockVertical * 20,
                child: new Container(
                  margin: EdgeInsets.only(top: 0),
                  padding: EdgeInsets.only(left: 25, right: 25),
                  height: SizeConfig.safeBlockVertical * 90,
                  width: SizeConfig.safeBlockHorizontal * 100,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(55.0),
                        bottomLeft: Radius.circular(25.0)),
                  ),
                  child: new Column(
                    children: <Widget>[
                      SizedBox(
                        height: 30.0,
                      ),
                      SupportLine(
                          label: lanRes != null
                              ? lanRes.result.data.Support.lbl_ContactPerson
                              : Strings.label_contact_person,
                          detail: supportData != null
                              ? supportData.result.support.name
                              : ""),

                      Divider(),
                      SupportLine(
                          label: lanRes != null&&lanRes.result.data.Support.lbl_Contact_No!=null
                              ? lanRes.result.data.Support.lbl_Contact_No.toString()
                              : Strings.label_contact_num,
                          detail: supportData != null
                              ? supportData.result.support.contactNo
                              : ""),
                      Divider(),
                      SupportLine(
                          label: lanRes != null
                              ? lanRes.result.data.Support.lbl_Email
                              : Strings.label_email,
                          detail: supportData != null
                              ? supportData.result.support.email
                              : ""),
                      Divider(),
                      SupportLine(
                          label: lanRes != null
                              ? lanRes.result.data.Support.Timings
                              : Strings.label_timing,
                          detail: supportData != null
                              ? setDate(supportData.result.support.openTime) +
                                  " - " +
                                  setDate(supportData.result.support.closedTime)
                              : ""),
                      Divider()
                    ],
                  ),
                ),
              ),
              if (isProgressShow)
                new Positioned(
                    child: new Center(child: CircularProgressIndicator()))
            ],
          )),
    ); // This trailing comma makes auto-formatting nicer for build methods.
  }
}
