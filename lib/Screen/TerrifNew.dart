import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xplor/HomeScreen/RideMap.dart';
import 'package:xplor/Model/ApiResponce.dart';
import 'package:xplor/Model/LanguageResponce.dart';
import 'package:xplor/util/ApiControler.dart';
import 'package:xplor/util/AppButton.dart';
import 'package:xplor/util/AppHeader.dart';

import 'package:xplor/util/Colorss.dart';
import 'package:xplor/util/Dimens.dart';
import 'package:xplor/util/SizeConfig.dart';
import 'package:xplor/util/Strings.dart';
import 'package:xplor/util/images.dart';
import 'package:xplor/util/utilities.dart';
import 'package:xplor/widgets/independent/card_item_terrif.dart';

class TerrifNew extends StatefulWidget {
  TerrifNew({Key key, this.qrText, this.adrress}) : super(key: key);

  final String qrText, adrress;

  @override
  _TerrifNewPageState createState() =>
      _TerrifNewPageState(this.qrText, this.adrress);
}

class _TerrifNewPageState extends State<TerrifNew> {
  var profile, qrText, adrress;
  bool isProgressShow = false;
  String bookingId;

  _TerrifNewPageState(this.qrText, this.adrress);

  @override
  void initState() {
    super.initState();

    getDataLanguage();
  }

  var prefs;
  var languageTerrif, languageMyWallet;

  getDataLanguage() async {
    prefs = await SharedPreferences.getInstance();
    var data = prefs.getString('languageData');
    Map langMap = jsonDecode(data.toString());
    var lanRes = LanguageResponce.parseLanguage(langMap);
    languageTerrif = lanRes.result.data.Tariff;
    languageMyWallet = lanRes.result.data.MyWallet;
    print(languageTerrif.toString());
    getCheckbalance();
    getAllTerrif();
  }

  getCheckbalance() async {
    var authToken = prefs.getString('authToken');
    var id = prefs.getString('id');
    setState(() {
      // isProgressShow = true;
    });
    var dio = Dio();
    dio.interceptors.add(LogInterceptor(requestBody: true));

    new ApiControler()
        .dioAuthGet(context, authToken, Strings.checkbalance + "/" + id, {
      "authToken": authToken,
    }).then((onValue) {
      parseCheckBalance(onValue);
    });
  }

  var balanceData;

  parseCheckBalance(reply) async {
    setState(() {
//      isProgressShow = false;
    });

    if (reply != null) {
      Map userMap = jsonDecode(reply);
      var user = ApiResponce.fromJson(userMap);
      if (user.success) {
        balanceData = ApiResponce.parseWallet(userMap);
      } else {
        new Utilities()
            .showAlertDialog(context, Strings.alert, user.result.message, "OK");
        // print('Howdy, ${user.code} ${user.msg}!');
      }
    }
  }

  getAllTerrif() async {
    var authToken = prefs.getString('authToken');

    setState(() {
      isProgressShow = true;
    });
    var dio = Dio();
    dio.interceptors.add(LogInterceptor(requestBody: true));

    new ApiControler().dioAuthGet(
        context, authToken, Strings.getScooterDetails + "/" + qrText, {
      "authToken": authToken,
    }).then((onValue) {
      parseterrif(onValue);
    });
  }

  var terrifData, scoterdata, rideData;

  parseterrif(reply) async {
    setState(() {
      isProgressShow = false;
    });

    if (reply != null) {
      Map userMap = jsonDecode(reply);
      // prefs.setInt('bareAmount', userMap['result']['data']['scooterId']['tarrifId']['baseAmount']);
      print(userMap);
      var user = ApiResponce.fromJson(userMap);
      if (user.success) {
        var data = ApiResponce.parseTerrifList(userMap);
        scoterdata = data.result.scoterDetails;
        prefs.setDouble('ridelatitude', scoterdata.latitude);
        prefs.setDouble('ridelongitude', scoterdata.longitude);
        print(prefs.getDouble('ridelatitude'));
        print("scoter = " + scoterdata.latitude.toString());
        print('Howdy >>, ${scoterdata.deviceId}!');
        terrifData = data.result.scoterDetails.tarrifId;
        prefs.setDouble('bareAmount', double.parse(terrifData.baseAmount));
        prefs.setDouble(
            'perMinuteCharge', double.parse(terrifData.perMinuteCharge));
      } else {
        new Utilities()
            .showAlertDialog(context, Strings.alert, user.result.message, "OK");
        // print('Howdy, ${user.code} ${user.msg}!');
      }
    }
  }

  startRide() async {
    var authToken = prefs.getString('authToken');

    var id = prefs.getString('id');
    setState(() {
      isProgressShow = true;
    });
    var dio = Dio();
    dio.interceptors.add(LogInterceptor(requestBody: true));

    new ApiControler().dioAuthPost(context, authToken, Strings.startRide, {
      // "authToken": authToken,
      "qrCode": qrText,
      // "pickUpPoint": adrress,
      // "dropOffPoint": "",
      // "description": "Bike condition is good",
      // "timezoneId": "Asia/India",
      "userId": {"id": id},
    }).then((onValue) {
      parseRide(onValue);
    });
  }

  parseRide(reply) async {
    setState(() {
      isProgressShow = false;
    });

    if (reply != null) {
      Map userMap = jsonDecode(reply);
      var user = ApiResponce.fromJson(userMap);
      if (user.success) {
        bookingId = userMap['result']['data']['bookingId'];
        print(
            "This bookid" + userMap['result']['data']['bookingId'].toString());
        // booking = userMap['result']['booking'];
        final prefs = await SharedPreferences.getInstance();
        prefs.remove('bookingId');
        prefs.setString('bookingId', bookingId);
        var data = ApiResponce.parseStartRide(userMap);
        rideData = data.result.rideDetails;
        var now2 = new DateTime.now();
        String rideStartdate =
            new DateFormat("yyyy-MM-dd HH:mm:ss").format(now2);
        prefs.setString('rideStartdate', rideStartdate.toString());
        prefs.setString('power', rideData.scooterIddata.power.toString());
        prefs.setString(
            'perMinuteCharge', terrifData.perMinuteCharge.toString());

        await seveRideData(
            rideData.iotDeviceId, rideData.qrCode, rideData.bookingId);
        new Utilities().showToast(context, user.result.message);
        // Navigator.pop(context);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => RideMap()),
        );
      } else {
        new Utilities()
            .showAlertDialog(context, Strings.alert, user.result.message, "OK");
        // print('Howdy, ${user.code} ${user.msg}!');
      }
    }
  }

//  "iotDeviceId": "C3:4F:34:18:F1:D4",
//  "qrCode": "66655500397",
//  "bookingId": "RIDE7736912",

  seveRideData(iotDeviceId, qrCode, bookingId) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('ride_status', "1");
    prefs.setString('iotDeviceId', iotDeviceId);
    prefs.setString('qrCode', qrCode);
    prefs.setString('bookingId', bookingId);
  }

  void startRideApi() {
    if (scoterdata != null) {
      startRide();
    } else {
      getAllTerrif();
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
                      title: languageTerrif != null
                          ? languageTerrif.lbl_Tarrif
                          : Strings.tariff,
                      onBackClick: () {
                        Navigator.pop(context);
                      },
                    ))
                  ],
                )),
            new Positioned(
                top: SizeConfig.safeBlockVertical * 27,
                child: new Container(
                  margin: EdgeInsets.only(),
                  padding: EdgeInsets.only(left: 25, right: 25),
                  height: SizeConfig.safeBlockVertical * 78,
                  width: 600,
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
                top: SizeConfig.safeBlockVertical * 16,
                child: new Container(
                  width: SizeConfig.safeBlockHorizontal * 100,
                  margin: EdgeInsets.only(top: 0),
                  child: SingleChildScrollView(
                    child: new Column(
                      children: [
                        new Column(
                          children: <Widget>[
                            SizedBox(
                              height: 25.0,
                            ),
                            //TODO: DESIGN: Background to container.
                            new Container(
                                width: SizeConfig.safeBlockHorizontal * 100,
                                child: CreditCardTerrif(
                                    color: "2a1214",
                                    image: Images.card_new,
                                    value: balanceData != null
                                        ? balanceData.result.walletBalace +
                                            Strings.app_currncy
                                        : '0' + Strings.app_currncy,
                                    title: languageMyWallet != null
                                        ? languageMyWallet.lbl_Balance
                                        : "Balance")),
                            SizedBox(
                              height: 60.0,
                            ),
                            new Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 25, right: 25),
                                  child: Text(
                                      languageTerrif != null
                                          ? languageTerrif.lbl_Pay_as_you_go
                                          : "Pay as you go",
                                      style: TextStyle(
                                          color: Colorss.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500)),
                                ),
                              ],
                            ),
                            SingleChildScrollView(
                              child: new Container(
                                margin: EdgeInsets.only(
                                    left: 35, right: 35, top: 20),
                                child: new Column(
                                  children: [
                                    new Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            languageTerrif != null
                                                ? languageTerrif.lbl_Base_Fare
                                                : "Base fare",
                                            style: TextStyle(
                                                color: Colorss.black,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                        Expanded(
                                          child: new Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Text(
                                                terrifData != null
                                                    ? terrifData.baseAmount +
                                                        Strings.app_currncy
                                                    : '0' + Strings.app_currncy,
                                                style: TextStyle(
                                                  color: Colorss.black,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 16,
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 12.0,
                                    ),
                                    Divider(
                                      color: Colors.brown.shade50,
                                      thickness: 1,
                                    ),
                                    SizedBox(
                                      height: 12.0,
                                    ),
                                    new Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            languageTerrif != null
                                                ? languageTerrif
                                                    .lbl_Per_Minute_Charge
                                                : "Per Minute Charge",
                                            style: TextStyle(
                                                color: Colorss.black,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                        Expanded(
                                          child: new Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Text(
                                                terrifData != null
                                                    ? terrifData
                                                            .perMinuteCharge +
                                                        Strings.app_currncy
                                                    : '0' + Strings.app_currncy,
                                                style: TextStyle(
                                                  color: Colorss.black,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 16,
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    new Container(
                                      width:
                                          SizeConfig.safeBlockHorizontal * 70,
                                      margin: EdgeInsets.only(
                                          top: SizeConfig.safeBlockVertical * 8,
                                          bottom: 5),
                                      child: AppButton(
                                          title: languageTerrif != null
                                              ? languageTerrif.lbl_Ride
                                              : "Ride",
                                          onButtonClick: startRideApi,
                                          showIcon: false,
                                          fontSize:
                                              SizeConfig.safeBlockHorizontal *
                                                  Dimens.text_5),
                                    )
                                  ],
                                ),
                              ),
                            )
                            // Divider(),
                          ],
                        )
                      ],
                    ),
                  ),
                )),
            if (isProgressShow)
              new Positioned(
                  child: new Center(child: CircularProgressIndicator())),
          ],
        ),
      ),
    ); // This trailing comma makes auto-formatting nicer for build methods.
  }
}
