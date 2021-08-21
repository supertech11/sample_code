import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart' as path;
import 'package:xplor/HomeScreen/HomeMap.dart';
import 'package:xplor/Model/ApiResponce.dart';
import 'package:xplor/Model/LanguageResponce.dart';
import 'package:xplor/Screen/Offer.dart';
import 'package:xplor/Screen/Payment.dart';
import 'package:xplor/Screen/Profile.dart';
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

class MenuScreen extends StatefulWidget {
  MenuScreen({Key key}) : super(key: key);

  @override
  _ExampleOneState createState() => _ExampleOneState();
}

class _ExampleOneState extends State<MenuScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<InnerDrawerState> _innerDrawerKey =
      GlobalKey<InnerDrawerState>();

  GlobalKey _keyRed = GlobalKey();
  double _width = 10;

  bool _position = true;
  bool _onTapToClose = false;
  bool _swipe = true;
  bool _tapScaffold = true;
  InnerDrawerAnimation _animationType = InnerDrawerAnimation.quadratic;
  double _offset = 0.4;

  double _dragUpdate = 0;

  InnerDrawerDirection _direction = InnerDrawerDirection.start;
  var profileUrl, imageurl;
  String _title = "One", profile_img = "", name = "", email = "", mobile = "";
  var prefs;
  var selectedMenuItemId = "1";

  AnimationController _animation;
  StreamSubscription iosSubscription;

  @override
  void initState() {
    super.initState();
    getUserInfo();
    getCheckbalance();
  }

  getUserInfo() async {
    prefs = await SharedPreferences.getInstance();

    mobile = "" + prefs.getString('mobile');
    readProfile();
    getDataLanguage();
  }

  readProfile() async {
    final prefs = await SharedPreferences.getInstance();
    var profileRes = prefs.getString('profile');
    var url = prefs.getString('url');
    imageurl = url + "/Xplor/images/";
    print("tosin" + imageurl);
    // print('profileRes' + profileRes);
    if (profileRes != null) {
      Map profileMap = jsonDecode(profileRes.toString());
      // print('profileMap' + profileMap.toString());
      var profile = ApiResponce.fromlogindataJson(profileMap);
      print('profile >>>>>>>>' + profile.id.toString());
      profileUrl = profile.profileImage;

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
    prefs.setBool('islogin', false);

    prefs.setString('bookingId', "");

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
      parse(onValue);
    });
  }

  var supportData;

  parse(reply) async {}

  @override
  void dispose() {
    super.dispose();
  }

  onSkip() {
    // logout();
  }

  Color pickerColor = Color(0xff443a49);
  Color currentColor = Colors.black54;
  ValueChanged<Color> onColorChanged;

  changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to exit an App'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: new Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

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

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return new InnerDrawer(
      key: _innerDrawerKey,
      onTapClose: _onTapToClose,
      tapScaffoldEnabled: _tapScaffold,
      offset: IDOffset.horizontal(0.8),
      // scale: IDOffset.horizontal(0),
      backgroundDecoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        boxShadow: <BoxShadow>[
          new BoxShadow(
            color: Colors.black26,
            blurRadius: 5.0,
            offset: new Offset(5.0, 5.0),
          ),
        ],
      ),
      // scale: IDOffset.horizontal(0.8),
      swipe: _swipe,
      boxShadow: [
        BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 5)
      ],
      //  colorTransition: currentColor,
      leftAnimationType: _animationType,
      rightAnimationType: InnerDrawerAnimation.quadratic,

      leftChild: Material(
          child: Container(
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
              right: BorderSide(width: 0, color: Colors.grey[200])),
        ),
        child: Stack(
          children: <Widget>[
            ListView(
              children: <Widget>[
                new Container(
                  height: SizeConfig.safeBlockVertical * 21,
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Profile()),
                          ).then((onValue) => {getUserInfo()});
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
                                                      imageurl + profileUrl))),
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
                              new Positioned(
                                  right: SizeConfig.safeBlockHorizontal * 30,
                                  top: SizeConfig.safeBlockVertical * 3,
                                  child: Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                    size: 24.0,
                                    semanticLabel:
                                        'Text to announce in accessibility modes',
                                  ))
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
                    margin: EdgeInsets.only(top: 13),
                    padding: EdgeInsets.only(left: 15, right: 15, top: 29),
                    height: SizeConfig.safeBlockVertical * 87,
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
                          onPressed: () {
                            _innerDrawerKey.currentState.toggle();
                            setState(() {
                              selectedMenuItemId = "1";
                            });
                          },
                          child: new Container(
                            padding: EdgeInsets.only(left: 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(left: 10, right: 10),
                                  child: Text(
                                    lanRes != null
                                        ? lanRes.result.data.navigation.lbl_Home
                                        : "Home",
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
                          onPressed: () {
                            _innerDrawerKey.currentState.toggle();
                            setState(() {
                              selectedMenuItemId = "1";
                            });

                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Wallet()),
                            );
                          },
                          child: new Container(
                            padding: EdgeInsets.only(left: 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                SizedBox(
                                    width: SizeConfig.safeBlockHorizontal * 35,
                                    child: Padding(
                                      padding:
                                          EdgeInsets.only(left: 10, right: 10),
                                      child: Text(
                                        lanRes != null
                                            ? lanRes.result.data.navigation
                                                    .lbl_Wallet +
                                                ""
                                            : "My Wallet",
                                        style: TextStyle(
                                            fontSize:
                                                SizeConfig.safeBlockHorizontal *
                                                    Dimens.menu_text,
                                            fontWeight: FontWeight.w500,
                                            color: Colorss.black),
                                      ),
                                    )),
                                SizedBox(
                                  width: SizeConfig.safeBlockHorizontal * 34,
                                  child: Padding(
                                    padding:
                                        EdgeInsets.only(right: 10, left: 10),
                                    child: Text(
                                      walletData != null
                                          ? "" +
                                              walletData.result.walletBalace +
                                              Strings.app_currncy
                                          : '0' + Strings.app_currncy,
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                          fontSize:
                                              SizeConfig.safeBlockHorizontal *
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
                          onPressed: () {
                            _innerDrawerKey.currentState.toggle();

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Statistics()),
                            );
                          },
                          child: new Container(
                            padding: EdgeInsets.only(left: 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(left: 10, right: 10),
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
                          onPressed: () {
                            _innerDrawerKey.currentState.toggle();

                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Offers()),
                            );
                          },
                          child: new Container(
                            padding: EdgeInsets.only(left: 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(left: 10, right: 10),
                                  child: Text(
                                    lanRes != null
                                        ? lanRes
                                            .result.data.navigation.lbl_Offer
                                        : "Offers",
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
                          onPressed: () {
                            _innerDrawerKey.currentState.toggle();
                            setState(() {});
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Support()),
                            );
                          },
                          child: new Container(
                            padding: EdgeInsets.only(left: 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(left: 10, right: 10),
                                  child: Text(
                                    lanRes != null
                                        ? lanRes
                                            .result.data.navigation.lbl_Support
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
                          onPressed: () {
                            _innerDrawerKey.currentState.toggle();
                            setState(() {});
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Setting()),
                            );
                          },
                          child: new Container(
                            padding: EdgeInsets.only(left: 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(left: 10, right: 10),
                                  child: Text(
                                    lanRes != null
                                        ? lanRes
                                            .result.data.navigation.lbl_Setting
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
                          margin: EdgeInsets.only(left: 15, right: 15),
                          child: Divider(
                            thickness: 1,
                            color: Colors.black26,
                          ),
                        ),
                      ],
                    ))
              ],
            ),
            new Positioned(
              bottom: 30,
              left: 25,
              child: new GestureDetector(
                onTap: () {
                  logout();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    new Container(
                      margin: EdgeInsets.only(
                          top: SizeConfig.safeBlockVertical * 0),
                      child: new Image.asset(Images.log_out,
                          width: SizeConfig.safeBlockHorizontal * 9,
                          height: SizeConfig.safeBlockHorizontal * 9,
                          color: Colorss.black),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        lanRes != null
                            ? lanRes.result.data.navigation.btn_LogOut
                            : "Logout",
                        style: TextStyle(
                            fontSize: SizeConfig.safeBlockHorizontal *
                                Dimens.menu_text,
                            fontWeight: FontWeight.w500,
                            color: Colorss.black),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      )),

      scaffold: new Container(),
      onDragUpdate: (double val, InnerDrawerDirection direction) {
        _direction = direction;
        setState(() => _dragUpdate = val);
        getUserInfo();
      },
      //innerDrawerCallback: (a) => print(a),
    );
  }
}
