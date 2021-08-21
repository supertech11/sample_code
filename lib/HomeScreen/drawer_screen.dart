import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:xplor/Model/ApiResponce.dart';
import 'package:xplor/Model/LanguageResponce.dart';
import 'package:xplor/Screen/Offer.dart';
import 'package:xplor/Screen/Profile.dart';
import 'package:xplor/Screen/RideHistory.dart';
import 'package:xplor/Screen/Setting.dart';
import 'package:xplor/Screen/Statistics.dart';
import 'package:xplor/Screen/Support.dart';
import 'package:xplor/Screen/Wallet.dart';
import 'package:xplor/Screen/Welcome.dart';
import 'package:xplor/util/ApiControler.dart';
import 'package:xplor/util/Colorss.dart';
import 'package:xplor/util/Dimens.dart';
import 'package:xplor/util/SizeConfig.dart';
import 'package:xplor/util/Strings.dart';
import 'package:xplor/util/images.dart';
import 'package:xplor/util/utilities.dart';

class AppDrawer extends StatefulWidget {
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  bool showLanguages = false;
  bool isProgressShow = true;

  var profileUrl, imageurl;
  String _title = "One",
      profile_img = "",
      name = "",
      email = "",
      mobile = "",
      walletAmount = "0";
  var prefs;
  var selectedMenuItemId = "1";

  @override
  void initState() {
    getCheckbalances();
    super.initState();
    getUserInfo();
  }

  getCheckbalances() async {
    final prefs = await SharedPreferences.getInstance();
    var authToken = prefs.getString('authToken');
    var id = prefs.getString('id');
    setState(() {
      isProgressShow = true;
    });
    var dio = Dio();
    dio.interceptors.add(LogInterceptor(requestBody: true));

    new ApiControler()
        .dioAuthGet(context, authToken, Strings.checkbalance + "/" + id, {
      "authToken": authToken,
    }).then((onValue) {
      parse(onValue);
    });
  }

  var walletDatavalue;

  parse(reply) async {
    setState(() {
      isProgressShow = false;
    });

    if (reply != null) {
      Map userMap = jsonDecode(reply);
      var user = ApiResponce.fromJson(userMap);
      if (user.success) {
        walletDatavalue = ApiResponce.parseWallet(userMap);
        // Fluttertoast.showToast(
        //     msg: ("Wallet updated"),
        //     toastLength: Toast.LENGTH_SHORT,
        //     gravity: ToastGravity.CENTER,
        //     timeInSecForIosWeb: 1,
        //     textColor: Colors.white,
        //     fontSize: 16.0);

        setState(() {
          walletAmount = walletDatavalue.result.walletBalace.toString();
        });
        prefs.setString(
            'walletAmount',
            walletDatavalue != null
                ? walletDatavalue.result.walletBalace.toString()
                : "0");
      } else {
        new Utilities()
            .showAlertDialog(context, Strings.alert, user.result.message, "OK");
        // print('Howdy, ${user.code} ${user.msg}!');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Drawer(
      child: Container(
        height: double.infinity,
        child: Center(
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: <Widget>[
              new Container(
                // height: MediaQuery.of(context).size.height,
                color: Colorss.white,
                child: new Column(
                  children: [
                    new Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Colorss.hgradient1,
                            Colorss.hgradient2,
                          ],
                        ),
                        border: Border(
                            left: BorderSide(width: 0, color: Colors.grey[200]),
                            right:
                                BorderSide(width: 0, color: Colors.grey[200])),
                      ),
                      height: SizeConfig.safeBlockVertical * 24,
                      child: new Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => Profile()),
//                     ).then((onValue) => {getUserInfo()});
                            },
                            child: Padding(
                              padding: EdgeInsets.only(top: 0),
                              child: new Stack(
                                children: [
                                  new Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      profileUrl != null && profileUrl != ""
                                          ? new Container(
                                              width: 90,
                                              margin: EdgeInsets.all(0),
                                              height: 90,
                                              decoration: BoxDecoration(
                                                  color: Colors.transparent,
                                                  borderRadius:
                                                      BorderRadius.circular(45),
                                                  border: Border.all(
                                                    color: Colors.white,
                                                    //                   <--- border color
                                                    width: 4.0,
                                                  ),
                                                  image: new DecorationImage(
                                                      fit: BoxFit.fill,
                                                      image: NetworkImage(
                                                          imageurl +
                                                              profileUrl))),
                                            )
                                          : Container(
                                              margin: EdgeInsets.all(0),
                                              width: 90,
                                              height: 90,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                  color: Colors.white,
                                                  //                   <--- border color
                                                  width: 4.0,
                                                ),
                                              ),
                                              child: Image.asset(
                                                Images.user,
                                                height: 90,
                                                width: 90,
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Center(
                            child: new Padding(
                              padding: EdgeInsets.only(top: 5),
                              child: Text(
                                name != null && name != "" ? name + "" : mobile,
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                style: TextStyle(
                                    fontSize: SizeConfig.safeBlockHorizontal *
                                        Dimens.menu_text,
                                    fontWeight: FontWeight.w500,
                                    color: Colorss.fontColor),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    new Container(
                        padding: EdgeInsets.only(left: 15, right: 15, top: 40),
                        height: SizeConfig.safeBlockVertical * 80,
                        width: SizeConfig.safeBlockHorizontal * 100,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(55.0),
                              bottomLeft: Radius.circular(0.0)),
                        ),
                        child: new Column(
                          children: [
                            new FlatButton(
                              height: 40,
                              onPressed: () {
                                //_innerDrawerKey.currentState.toggle();
                                Navigator.pop(context);
                                setState(() {
                                  selectedMenuItemId = "1";
                                });
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Profile()),
                                ).then((onValue) => {getUserInfo()});
                              },
                              child: new Container(
                                padding:
                                    EdgeInsets.only(left: 0, top: 8, bottom: 8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding:
                                          EdgeInsets.only(left: 10, right: 10),
                                      child: Text(
                                        lanRes != null &&
                                                lanRes.result.data.navigation
                                                        .lbl_ProfileImage !=
                                                    null
                                            ? lanRes.result.data.navigation
                                                .lbl_ProfileImage
                                            : "Profile",
                                        style: TextStyle(
                                            fontSize:
                                                SizeConfig.safeBlockHorizontal *
                                                    Dimens.menu_text,
                                            fontWeight: FontWeight.w500,
                                            color: Colorss.black),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            new Container(
                              margin: EdgeInsets.only(left: 15, right: 15),
                              child: Divider(
                                thickness: 1,
                                color: Colors.black26,
                              ),
                            ),
                            new FlatButton(
                              height: 40,
                              onPressed: () {
                                Navigator.pop(context);
                                //  _innerDrawerKey.currentState.toggle();
                                setState(() {
                                  selectedMenuItemId = "1";
                                });

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Wallet()),
                                );
                              },
                              child: new Container(
                                padding:
                                    EdgeInsets.only(left: 0, top: 8, bottom: 8),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    SizedBox(
                                        width:
                                            SizeConfig.safeBlockHorizontal * 28,
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              left: 10, right: 10),
                                          child: Text(
                                            lanRes != null
                                                ? lanRes.result.data.navigation
                                                        .lbl_Wallet +
                                                    ""
                                                : "My Wallet",
                                            style: TextStyle(
                                                fontSize: SizeConfig
                                                        .safeBlockHorizontal *
                                                    Dimens.menu_text,
                                                fontWeight: FontWeight.w500,
                                                color: Colorss.black),
                                          ),
                                        )),
                                    SizedBox(
                                      width:
                                          SizeConfig.safeBlockHorizontal * 28,
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            right: 10, left: 10),
                                        child: Text(
                                          walletAmount != null
                                              ? walletAmount +
                                                  Strings.app_currncy
                                              : '0' + Strings.app_currncy,
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                              fontSize: SizeConfig
                                                      .safeBlockHorizontal *
                                                  Dimens.menu_text,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black87),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            new Container(
                              margin: EdgeInsets.only(left: 15, right: 15),
                              child: Divider(
                                thickness: 1,
                                color: Colors.black26,
                              ),
                            ),
                            new FlatButton(
                              height: 40,
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => RideHistory()),
                                );
                              },
                              child: new Container(
                                height: 40,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding:
                                          EdgeInsets.only(left: 10, right: 10),
                                      child: Text(
                                        lanRes != null
                                            ? lanRes.result.data.navigation
                                                .lbl_Statistics
                                            : "My Statistics",
                                        style: TextStyle(
                                            fontSize:
                                                SizeConfig.safeBlockHorizontal *
                                                    Dimens.menu_text,
                                            fontWeight: FontWeight.w500,
                                            color: Colorss.black),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            new Container(
                              margin: EdgeInsets.only(left: 15, right: 15),
                              child: Divider(
                                thickness: 1,
                                color: Colors.black26,
                              ),
                            ),
                            new FlatButton(
                              height: 40,
                              onPressed: () {
                                Navigator.pop(context);
                                // _innerDrawerKey.currentState.toggle();
                                setState(() {});
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Support()),
                                );
                              },
                              child: new Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding:
                                          EdgeInsets.only(left: 10, right: 10),
                                      child: Text(
                                        lanRes != null
                                            ? lanRes.result.data.navigation
                                                .lbl_Support
                                            : "Support",
                                        style: TextStyle(
                                            fontSize:
                                                SizeConfig.safeBlockHorizontal *
                                                    Dimens.menu_text,
                                            fontWeight: FontWeight.w500,
                                            color: Colorss.black),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            new Container(
                              margin: EdgeInsets.only(left: 15, right: 15),
                              child: Divider(
                                thickness: 1,
                                color: Colors.black26,
                              ),
                            ),
                            new FlatButton(
                              height: 40,
                              onPressed: () {
                                Navigator.pop(context);
                                //  _innerDrawerKey.currentState.toggle();
                                setState(() {});
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Setting()),
                                );
                              },
                              child: new Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding:
                                          EdgeInsets.only(left: 10, right: 10),
                                      child: Text(
                                        lanRes != null
                                            ? lanRes.result.data.navigation
                                                .lbl_Setting
                                            : "Settings",
                                        style: TextStyle(
                                            fontSize:
                                                SizeConfig.safeBlockHorizontal *
                                                    Dimens.menu_text,
                                            fontWeight: FontWeight.w500,
                                            color: Colorss.black),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            new Container(
                              margin: EdgeInsets.only(
                                  left: 18, right: 15, bottom: 40),
                              child: Divider(
                                thickness: 1,
                                color: Colors.black26,
                              ),
                            ),
                            new GestureDetector(
                              onTap: () {
                                //  _innerDrawerKey.currentState.toggle();
                                logout();
                              },
                              child: new Container(
                                padding: EdgeInsets.only(
                                    left: 15, top: 5, bottom: 5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    new Container(
                                      margin: EdgeInsets.only(
                                          top:
                                              SizeConfig.safeBlockVertical * 0),
                                      child: new Image.asset(Images.log_out,
                                          width:
                                              SizeConfig.safeBlockHorizontal *
                                                  9,
                                          height:
                                              SizeConfig.safeBlockHorizontal *
                                                  9,
                                          color: Colorss.black),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 10),
                                      child: Text(
                                        lanRes != null
                                            ? lanRes.result.data.navigation
                                                .btn_LogOut
                                            : "Logout",
                                        style: TextStyle(
                                            fontSize:
                                                SizeConfig.safeBlockHorizontal *
                                                    Dimens.menu_text,
                                            fontWeight: FontWeight.w500,
                                            color: Colorss.black),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  getUserInfo() async {
    prefs = await SharedPreferences.getInstance();
    walletAmount = "" + prefs.getString('walletAmount');
    mobile = "" + prefs.getString('mobile');
    setState(() {});
    print('walletAmount >>>>>>>>' + walletAmount.toString());
    readProfile();
    getDataLanguage();
  }

  readProfile() async {
    final prefs = await SharedPreferences.getInstance();
    var profileRes = prefs.getString('profile');
    var url = prefs.getString('url');
    // print('profileRes' + profileRes);
    if (profileRes != null) {
      Map profileMap = jsonDecode(profileRes.toString());
      // print('profileMap' + profileMap.toString());
      var profile = ApiResponce.fromlogindataJson(profileMap);
      print('profile >>>>>>>>' + profile.id.toString());
      print('profile >>>>>>>>' + profile.profileImage.toString());
      profileUrl = profile.profileImage;
      imageurl = url + "/Xplor/images/";
      print(profile);
      name = profile.firstName + ' ' + profile.lastName;

      setState(() {});
    }
    // print('profile' + profile);
  }

  var lanRes;

  getDataLanguage() async {
    prefs = await SharedPreferences.getInstance();
    var data = prefs.getString('languageData');
    Map langMap = jsonDecode(data.toString());
    lanRes = LanguageResponce.parseLanguage(langMap);
    print(lanRes.result.data.navigation.btn_LogOut);
  }

  logout() async {
    SendNotificaton();
    prefs.setBool('islogin', false);
    prefs.setString('bookingId', "");
    prefs.setString('ride_status', "");

    LogoutApi();
    Navigator.pushNamedAndRemoveUntil(context, "/Welcome", (r) => false);
  }

  LogoutApi() async {
    final prefs = await SharedPreferences.getInstance();
    var authToken = prefs.getString('authToken');

    var dio = Dio();
    dio.interceptors.add(LogInterceptor(requestBody: true));

    new ApiControler().dioAuthPost(context, authToken, Strings.logout, {
      "authToken": authToken,
    }).then((onValue) {
      parses(onValue);
    });
  }

  SendNotificaton() async {
    final prefs = await SharedPreferences.getInstance();
    var profileRes = prefs.getString('profile');
    Map profileMap = jsonDecode(profileRes.toString());
    var profile = ApiResponce.fromlogindataJson(profileMap);
    print(profile);
    name = profile.firstName + ' ' + profile.lastName;
    setState(() {
      isProgressShow = true;
    });
    var dio = Dio();
    dio.interceptors.add(LogInterceptor(requestBody: true));

    new ApiControler().dioPost(context, Strings.authenticate, {
      "mobile": profile.mobile,
      "notificationId": prefs.getString("notificationid"),
    }).then((onValue) {
      parseLogin(onValue);
    });
  }

  parseLogin(reply) async {
    setState(() {
      isProgressShow = false;
    });

    if (reply != null) {
      Map userMap = jsonDecode(reply);
      var user = ApiResponce.fromJson(userMap);
      if (user.success) {
        // setState(() {
        //   isVerificationmsgSent = true;
        // });
      } else {
        new Utilities()
            .showAlertDialog(context, Strings.alert, user.result.message, "OK");
      }
    }
  }

  parses(reply) async {}
  getCheckbalance() async {
    final prefs = await SharedPreferences.getInstance();
    var authToken = prefs.getString('authToken');
    var id = prefs.getString('id');
    var dio = Dio();
    dio.interceptors.add(LogInterceptor(requestBody: true));

    new ApiControler()
        .dioAuthGet(context, authToken, Strings.checkbalance + "/" + id, {
      "authToken": authToken,
    }).then((onValue) {
      parseWallet(onValue);
    });
  }

  var walletData;

  parseWallet(reply) async {
    if (reply != null) {
      Map userMap = jsonDecode(reply);
      var user = ApiResponce.fromJson(userMap);
      if (user.success) {
        walletData = ApiResponce.parseWallet(userMap);
      } else {
        print('No wallet data found');
      }
    }
  }
}
