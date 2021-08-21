import 'dart:convert';
import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_picker_dropdown.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xplor/Model/ApiResponce.dart';
import 'package:xplor/Model/Data.dart';
import 'package:xplor/Model/LanguageResponce.dart';
import 'package:xplor/Model/Notification.dart';

import 'package:xplor/util/ApiControler.dart';
import 'package:xplor/util/AppHeader.dart';
import 'package:xplor/util/Colorss.dart';
import 'package:xplor/util/Dimens.dart';
import 'package:xplor/util/SizeConfig.dart';
import 'package:xplor/util/Strings.dart';
import 'package:xplor/util/utilities.dart';
import 'package:xplor/localization/language_constants.dart';
import 'package:xplor/util/images.dart';

import 'package:xplor/widgets/independent/menu_line.dart';

class MainNotification extends StatefulWidget {
  MainNotification({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MainNotificationPageState createState() => _MainNotificationPageState();
}

class _MainNotificationPageState extends State<MainNotification> {
  bool isProgressShow = false;
  String msg;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDataLanguage();
    getMynotification();
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

  getMynotification() async {
    final prefs = await SharedPreferences.getInstance();
    var authToken = prefs.getString('authToken');
    var id = prefs.getString('id');
    setState(() {
      isProgressShow = true;
    });
    var dio = Dio();
    dio.interceptors.add(LogInterceptor(requestBody: true));

    new ApiControler()
        .dioAuthGet(context, authToken, Strings.mynotification + "/" + id, {
      "authToken": authToken,
    }).then((onValue) {
      parseMynotification(onValue);
    });
  }

  List<Data> mynotificationData;

  parseMynotification(reply) async {
    setState(() {
      isProgressShow = false;
    });

    if (reply != null) {
      Map userMap = jsonDecode(reply);
      var user = ApiResponce.fromJson(userMap);
      if (user.success) {
        var data = ApiResponce.parseMyNotification(userMap);
        mynotificationData = new List();
        mynotificationData.addAll(data.result.datalist);
      } else {
        msg = user.result.message;
        setState(() {});
//        new Utilities()
//            .showAlertDialog(context, Strings.alert, user.result.message, "OK");
        // print('Howdy, ${user.code} ${user.msg}!');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Material(
          color: Colorss.primary,
          child: Container(
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
                              ? lanRes.result.data.Settings.lbl_Notification
                              : Strings.notification,
                          onBackClick: () {
                            Navigator.pop(context);
                          },
                        )),
                      ],
                    )),
                new Positioned(
                    top: SizeConfig.safeBlockVertical * 27,
                    child: new Container(
                      margin: EdgeInsets.only(top: 0),
                      padding: EdgeInsets.only(left: 25, right: 25),
                      height: SizeConfig.safeBlockVertical * 90,
                      width: SizeConfig.safeBlockHorizontal * 100,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(55.0),
                            bottomLeft: Radius.circular(0.0)),
                      ),
                      child: new Column(
                        children: <Widget>[],
                      ),
                    )),
                new Positioned(
                    top: SizeConfig.safeBlockVertical * 17,
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: new Container(
                      padding: EdgeInsets.only(bottom: 10.0),
                      height: SizeConfig.safeBlockVertical * 90,
                      child: new Column(
                        children: [
                          mynotificationData != null
                              ? new Container(
                                  child: Expanded(
                                    child: new Container(
                                      child: ListView.builder(
                                        itemCount: mynotificationData.length,
                                        itemBuilder: (context, position) {
                                          final item =
                                              mynotificationData[position];
                                          return ListTile(
                                            contentPadding:
                                                EdgeInsets.all(10.0),
                                            title: Container(
                                              margin: EdgeInsets.symmetric(
                                                  vertical: 0, horizontal: 20),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: Colors.grey[200],
                                                      blurRadius: 10,
                                                      spreadRadius: 3,
                                                      offset: Offset(3, 4))
                                                ],
                                              ),
                                              child: ListTile(
                                                title: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      Text(
                                                        item.createdDate !=
                                                                    null &&
                                                                item.createdDate !=
                                                                    "null"
                                                            ? new Utilities()
                                                                .setDate(item
                                                                    .createdDate)
                                                                .toString()
                                                            : "",
                                                        style: TextStyle(
                                                            fontSize: SizeConfig
                                                                    .safeBlockHorizontal *
                                                                Dimens.text_2_5,
                                                            color: Colors.grey),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                subtitle: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(item.description,
                                                      style: TextStyle(
                                                          fontSize: SizeConfig
                                                                  .safeBlockHorizontal *
                                                              Dimens.text_3_5,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: Colors.black)),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                )
                              : new Container()
                        ],
                      ),
                    )),
                if (isProgressShow)
                  new Positioned(
                      child: new Center(child: CircularProgressIndicator())),
                if (msg != null)
                  new Positioned(
                      left: 0,
                      right: 0,
                      top: 0,
                      bottom: 0,
                      child: new Center(
                          child: Text(msg,
                              style: TextStyle(
                                  fontSize: SizeConfig.safeBlockHorizontal *
                                      Dimens.text_4,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.redAccent))))
              ],
            ),
          )),
    ); // This trailing comma makes auto-formatting nicer for build methods.
  }
}
