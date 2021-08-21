import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xplor/Model/ApiResponce.dart';
import 'package:xplor/Model/Data.dart';
import 'package:xplor/Model/LanguageResponce.dart';
import 'package:xplor/Model/RideHistory.dart';

import 'package:xplor/util/ApiControler.dart';
import 'package:xplor/util/AppHeader.dart';
import 'package:xplor/util/Colorss.dart';
import 'package:xplor/util/Dimens.dart';
import 'package:xplor/util/SizeConfig.dart';
import 'package:xplor/util/Strings.dart';
import 'package:xplor/util/utilities.dart';

class RideHistory extends StatefulWidget {
  RideHistory({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _RideHistoryPageState createState() => _RideHistoryPageState();
}

class _RideHistoryPageState extends State<RideHistory> {
  bool isProgressShow = false;
  List ride_histories = [
    RideH('2021-01-21', '3000 m', '30 min', '\$ 10.00'),
    RideH('2021-01-21', '3000 m', '30 min', '\$ 10.00'),
  ];
  String msg;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDataLanguage();
    getallbookingbyuserid();
  }

  var prefs;
  var lanRes, languageHome, lansetting;

  getDataLanguage() async {
    prefs = await SharedPreferences.getInstance();
    var data = prefs.getString('languageData');
    Map langMap = jsonDecode(data.toString());
    lanRes = LanguageResponce.parseLanguage(langMap);
    languageHome = lanRes.result.data.Home_Map;
    lansetting = lanRes.result.data.Settings;
    print(lanRes.result.data.Settings.lbl_firstname1);
  }

  getallbookingbyuserid() async {
    final prefs = await SharedPreferences.getInstance();
    var authToken = prefs.getString('authToken');
    var id = prefs.getString('id');
    setState(() {
      isProgressShow = true;
    });
    var dio = Dio();
    dio.interceptors.add(LogInterceptor(requestBody: true));

    new ApiControler().dioAuthGet(
        context, authToken, Strings.getallbookingbyuserid + "/" + id, {
      "authToken": authToken,
    }).then((onValue) {
      parse(onValue);
    });
  }

  List<Data> rideData;

  parse(reply) async {
    setState(() {
      isProgressShow = false;
    });

    if (reply != null) {
      Map userMap = jsonDecode(reply);
      var user = ApiResponce.fromJson(userMap);
      if (user.success) {
        var data = ApiResponce.parseRideHistory(userMap);
        //rideData=data.result.datalist;
        rideData = new List();
        rideData.addAll(data.result.datalist);
      } else {
        msg = user.result.message;
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(0.0, 0.0),
        child: Container(),
      ),
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
                              ? lanRes.result.data.MyStatistics.lbl_My_Rides
                              : Strings.my_rides,
                          onBackClick: () {
                            Navigator.pop(context);
                          },
                        ))
                      ],
                    )),
                new Positioned(
                  top: SizeConfig.safeBlockVertical * 17,
                  child: new Container(
                    margin: EdgeInsets.only(top: 0),
                    padding: EdgeInsets.only(left: 20, right: 20),
                    height: SizeConfig.safeBlockVertical * 85,
                    width: SizeConfig.screenWidth,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(55.0),
                          bottomLeft: Radius.circular(0.0)),
                    ),
                    child: new Column(
                      children: [
                        Expanded(
                          child: rideData != null
                              ? new Container(
                                  child: ListView.builder(
                                    itemCount: rideData.length,
                                    itemBuilder: (context, position) {
                                      final item = rideData[position];
                                      print(item.paymentIdData.totalAmount);
                                      return ListTile(
                                          contentPadding: EdgeInsets.all(5.0),
                                          title: Container(
                                            margin: EdgeInsets.symmetric(
                                                vertical: 0, horizontal: 5),
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
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                // mainAxisAlignment:
                                                //     MainAxisAlignment.spaceEvenly,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 10.0,
                                                                  right: 10,
                                                                  top: 30),
                                                          child: Center(
                                                            child: new Icon(
                                                              Icons.alt_route,
                                                              size: 35,
                                                              color:
                                                                  Colors.orange,
                                                            ),
                                                          ),
                                                        ),
                                                      ]),
                                                  Expanded(
                                                      child: new Container(
                                                    child: new Column(
                                                      children: [
                                                        Row(children: [
                                                          Expanded(
                                                              child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  languageHome !=
                                                                          null
                                                                      ? languageHome
                                                                              .lbl_Time +
                                                                          ""
                                                                      : 'Time',
                                                                  textAlign:
                                                                      TextAlign
                                                                          .start,
                                                                  style: TextStyle(
                                                                      fontSize: SizeConfig
                                                                              .safeBlockHorizontal *
                                                                          Dimens
                                                                              .text_4_5,
                                                                      color: Colors
                                                                          .grey),
                                                                ),
                                                                Text(
                                                                    item.totalRideTime +
                                                                        " " +
                                                                        lansetting
                                                                            .time_unit +
                                                                        "",
                                                                    style: TextStyle(
                                                                        fontSize: SizeConfig.safeBlockHorizontal *
                                                                            Dimens
                                                                                .text_5,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w600,
                                                                        color: Colors
                                                                            .black)),
                                                              ],
                                                            ),
                                                          )),
                                                          Expanded(
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: Text(
                                                                item.paymentIdData.totalAmount !=
                                                                            null &&
                                                                        item.paymentIdData.totalAmount !=
                                                                            "null"
                                                                    ? item.paymentIdData.totalAmount +
                                                                        Strings
                                                                            .app_currncy
                                                                    : '0' +
                                                                        Strings
                                                                            .app_currncy +
                                                                        "",
                                                                textAlign:
                                                                    TextAlign
                                                                        .right,
                                                                style: TextStyle(
                                                                    fontSize: SizeConfig
                                                                            .safeBlockHorizontal *
                                                                        Dimens
                                                                            .text_5,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    color: Colors
                                                                        .black),
                                                              ),
                                                            ),
                                                          ),
                                                        ]),
                                                        Row(
                                                          children: [
//                                                        Expanded(
//                                                            child: Padding(
//                                                              padding:
//                                                              const EdgeInsets
//                                                                  .all(0.0),
//                                                              child: Column(
//                                                                crossAxisAlignment:
//                                                                CrossAxisAlignment
//                                                                    .start,
//                                                                children: [
//                                                                  Text(
//                                                                    lanRes != null
//                                                                        ? lanRes
//                                                                        .result
//                                                                        .data
//                                                                        .MyStatistics
//                                                                        .lbl_Distance
//                                                                        : Strings
//                                                                        .distance,
//                                                                    style: TextStyle(
//                                                                        fontSize: SizeConfig
//                                                                            .safeBlockHorizontal *
//                                                                            Dimens
//                                                                                .text_4_5,
//                                                                        color: Colors
//                                                                            .grey),
//                                                                  ),
//                                                                  Text(
//                                                                      new Utilities()
//                                                                          .meterToKm(item
//                                                                          .totalDistance) +
//                                                                          " " +
//                                                                          lansetting
//                                                                              .dis_unit +
//                                                                          "",
//                                                                      style: TextStyle(
//                                                                          fontSize: SizeConfig
//                                                                              .safeBlockHorizontal *
//                                                                              Dimens
//                                                                                  .text_5,
//                                                                          fontWeight:
//                                                                          FontWeight
//                                                                              .w600,
//                                                                          color: Colors
//                                                                              .black)),
//                                                                ],
//                                                              ),
//                                                            )),
                                                            Expanded(
                                                                child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: Text(
                                                                item.bookingDate !=
                                                                            null &&
                                                                        item.bookingDate !=
                                                                            "null"
                                                                    ? new Utilities()
                                                                        .setDate(
                                                                            item.bookingDate)
                                                                        .toString()
                                                                    : "",
                                                                textAlign:
                                                                    TextAlign
                                                                        .right,
                                                                style: TextStyle(
                                                                    fontSize: SizeConfig
                                                                            .safeBlockHorizontal *
                                                                        Dimens
                                                                            .text_3,
                                                                    color: Colors
                                                                        .grey),
                                                              ),
                                                            )),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ))
                                                ],
                                              ),
                                            ),
                                          ));
                                    },
                                  ),
                                )
                              : new Container(),
                        )
                      ],
                    ),
                  ),
                ),
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
