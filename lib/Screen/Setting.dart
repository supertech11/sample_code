import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xplor/Model/ApiResponce.dart';
import 'package:xplor/Model/LanguageResponce.dart';
import 'package:xplor/Screen/PrivacyPolicy.dart';
import 'package:xplor/Screen/TermsCondition.dart';
import 'package:xplor/api/rest-api.dart';
import 'package:xplor/localization/language_constants.dart';
import 'package:xplor/util/ApiControler.dart';
import 'package:xplor/util/AppHeader.dart';
import 'package:xplor/util/Colorss.dart';
import 'package:xplor/util/Dimens.dart';
import 'package:xplor/util/SizeConfig.dart';
import 'package:xplor/util/Strings.dart';
import 'package:xplor/util/images.dart';
import 'package:xplor/util/utilities.dart';
import 'package:xplor/widgets/independent/menu_line.dart';

import '../main.dart';

class Setting extends StatefulWidget {
  Setting({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<Setting> {
  var profile;
  var prefs;
  var lanRes, languageValue;
  bool isProgressShow = false, notificationStatus = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDataLanguage();
    //stetMynotificationStatus(notificationStatus);
  }

  var lansetting;

  getDataLanguage() async {
    prefs = await SharedPreferences.getInstance();
    var data = prefs.getString('languageData');

    notificationStatus = prefs.getBool('notification') ?? false;

    Map langMap = jsonDecode(data.toString());
    lanRes = LanguageResponce.parseLanguage(langMap);
    lansetting = lanRes.result.data.Settings;
    print(lanRes.result.data.Settings.lbl_firstname1);
    setLanguage();
  }

  void _selectLanguage(value) {
    _select(value);
  }

  setLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    languageValue = prefs.getString(LAGUAGE_CODE) ?? "en";
    setState(() {});
  }

  void _changeLanguage(languageValue) async {
    Locale _locale = await setLocale(languageValue);
    MyApp.setLocale(context, _locale);
    setState(() {
      isProgressShow = false;
    });
    Navigator.pushNamedAndRemoveUntil(context, "/MenuScreen", (r) => false);
  }

  void _select(String language) async {
    print("dd log " + language);
    languageValue = language;
    setState(() {
      isProgressShow = true;
    });
    getLanguageLabels(languageValue);
  }

  Future<String> getLanguageLabels(languageValue) async {
    prefs = await SharedPreferences.getInstance();

    try {
      ApiService.getLanguageLabels(languageValue == "en" ? "1" : "2")
          .then((response) {
        print('response =======>' + response);
        if (response != null) {
          Map langMap = jsonDecode(response.toString());
          var user = ApiResponce.fromJson(langMap);
          if (user.success) {
            prefs.setString('languageData', response.toString());
            lanRes = LanguageResponce.parseLanguage(langMap);
            _changeLanguage(languageValue);
            prefs.setString('url', lanRes.result.data.IpaAddress.lbl_server.toString());
            print(lanRes.result.data.navigation.btn_LogOut);
            setState(() {});
          } else {
            // print('Howdy, ${user.code} ${user.msg}!');
          }
        }
      });
      return "Success";
    } catch (error) {
      print('error =======>' + error);
    }
  }

  stetMynotificationStatus(notificationStatus) async {
    final prefs = await SharedPreferences.getInstance();
    var authToken = prefs.getString('authToken');
    var id = prefs.getString('id');
    setState(() {
      isProgressShow = true;
    });
    var dio = Dio();
    dio.interceptors.add(LogInterceptor(requestBody: true));

    new ApiControler().dioAuthGet(
        context,
        authToken,
        Strings.triggernotification +
            "/" +
            id +
            "/" +
            notificationStatus.toString(),
        {
          "authToken": authToken,
        }).then((onValue) {
      parseMynotification(onValue);
    });
  }

  var mynotificationData;

  parseMynotification(reply) async {
    setState(() {
      isProgressShow = false;
    });

    if (reply != null) {
      Map userMap = jsonDecode(reply);
      var user = ApiResponce.fromJson(userMap);
      if (user.success) {
        prefs.setBool('notification', notificationStatus);
      } else {
        new Utilities()
            .showAlertDialog(context, Strings.alert, user.result.message, "OK");
        // print('Howdy, ${user.code} ${user.msg}!');
      }
    }
  }

  Widget _threeItemPopup() => PopupMenuButton(
        itemBuilder: (context) {
          var list = List<PopupMenuEntry<Object>>();
          list.add(
            PopupMenuItem(
              child: Text(
                  lanRes != null
                      ? lanRes.result.data.Settings.lbl_Language
                      : "Language",
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                      fontSize: 16)),
              value: "1",
            ),
          );
          list.add(
            PopupMenuDivider(
              height: 0,
            ),
          );
          list.add(
            CheckedPopupMenuItem(
              child: new Row(
                children: <Widget>[
                  new Image.asset(
                    Images.us_States,
                    width: SizeConfig.safeBlockHorizontal *
                            Dimens.menu_image_height +
                        8,
                    height: SizeConfig.safeBlockHorizontal *
                            Dimens.menu_image_height +
                        8,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: Text(
                      "English",
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                          fontSize: 14),
                    ),
                  )
                ],
              ),
              value: "en",
              checked: languageValue == "en" ? true : false,
            ),
          );
          list.add(
            CheckedPopupMenuItem(
              child: new Row(children: <Widget>[
                new Image.asset(
                  Images.ae_States,
                  width: SizeConfig.safeBlockHorizontal *
                          Dimens.menu_image_height +
                      8,
                  height: SizeConfig.safeBlockHorizontal *
                          Dimens.menu_image_height +
                      8,
                ),
                Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: Text(
                      "Arabic",
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                          fontSize: 14),
                    )),
              ]),
              value: "ar",
              checked: languageValue == "ar" ? true : false,
            ),
          );
          return list;
        },
        onCanceled: () {
          print("You have canceled the menu.");
        },
        onSelected: (value) {
          _selectLanguage(value);
          print("value:$value");
        },
        child: new OpenFlutterMenuLine(
          onTap: null,
          title: lanRes != null
              ? lanRes.result.data.Settings.lbl_Language
              : Strings.language,
          subtitle: languageValue == "ar" ? "Arabic" : "English",
          showBackIcon: true,
        ),
      );

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
                            ? lanRes.result.data.navigation.lbl_Setting
                            : Strings.settings,
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
                          bottomLeft: Radius.circular(0.0)),
                    ),
                    child: new Column(
                      children: <Widget>[
                        SizedBox(
                          height: 30.0,
                        ),

                        new Container(child: _threeItemPopup()),

                        // Divider(),
                        OpenFlutterMenuLine(
                            title: lanRes != null
                                ? lanRes.result.data.Settings.lbl_Notification
                                : Strings.notification,
                            //TODO: make short card info
                            subtitle: null,
                            showToggle: true,
                            enable: notificationStatus,
                            onTap: (() => {
                                  setState(() {
                                    notificationStatus = !notificationStatus;
                                  }),
                                  stetMynotificationStatus(notificationStatus)

                                  // widget.changeView(
                                  //   changeType: ViewChangeType.Exact, index: 3)
                                })),
                        // Divider(),
                        OpenFlutterMenuLine(
                            title: lanRes != null
                                ? lanRes.result.data.Settings.lbl_PrivacyPolicy
                                : Strings.privacy_policy,
                            //TODO: make short card info
                            subtitle: null,
                            onTap: (() => {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => PrivacyPolicy()),
                                  )
                                })),
                        // Divider(),
                        OpenFlutterMenuLine(
                            title: lanRes != null
                                ? lanRes
                                    .result.data.Settings.lbl_TermsConditions
                                : Strings.terms_conditions,
                            //TODO: make short card info
                            subtitle: null,
                            onTap: (() => {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => TermsCondition()),
                                  )
                                })),
                        // Divider(),
                      ],
                    ),
                  )),
              if (isProgressShow)
                new Positioned(
                    child: new Center(child: CircularProgressIndicator())),
            ],
          )),
    ); // This trailing comma makes auto-formatting nicer for build methods.
  }
}
