import 'dart:convert';
import 'dart:ffi';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:xplor/Model/ApiResponce.dart';
import 'package:xplor/Model/LanguageResponce.dart';
import 'package:xplor/Screen/PaymentURL.dart';
import 'package:xplor/util/ApiControler.dart';
import 'package:xplor/util/AppButton.dart';
import 'package:xplor/util/AppHeader.dart';
import 'package:xplor/util/Colorss.dart';
import 'package:xplor/util/Dimens.dart';
import 'package:xplor/util/SizeConfig.dart';
import 'package:xplor/util/Strings.dart';
import 'package:xplor/util/images.dart';
import 'package:xplor/util/utilities.dart';

import 'package:xplor/widgets/independent/menu_line.dart';
import 'package:xplor/widgets/independent/card_item.dart';
import 'package:xplor/widgets/independent/pay_item.dart';

class PaymentSummary extends StatefulWidget {
  PaymentSummary({
    Key key,
  }) : super(key: key);

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentSummary> {
  String totalDiscount = "0",
      afterDiscountPrice = "0",
      baseFare = "0",
      totalMin = "0",
      totalCharge = "0",
      totalwallet = "0",
      total = "0",
      totalrideEstimate = "0";
  bool isProgressShow = false;
  var prefs;
  var languageTerrif,
      languageMyWallet,
      languagePayment,
      languageMessages,
      lanRes;
  var walletData;
  var rideData;

  @override
  void initState() {
    super.initState();
    getDataLanguage();
  }

  getDataLanguage() async {
    prefs = await SharedPreferences.getInstance();
    var data = prefs.getString('languageData');
    Map langMap = jsonDecode(data.toString());
    lanRes = LanguageResponce.parseLanguage(langMap);
    languageTerrif = lanRes.result.data.Tariff;
    languageMyWallet = lanRes.result.data.MyWallet;
    languagePayment = lanRes.result.data.Payments;
    languageMessages = lanRes.result.data.Messages;
    print(languageTerrif.toString());
    getbookingdetails();
    getCheckbalance();
  }

  getCheckbalance() async {
    final prefs = await SharedPreferences.getInstance();
    var authToken = prefs.getString('authToken');
    var id = prefs.getString('id');
    setState(() {
      //isProgressShow = true;
    });
    var dio = Dio();
    dio.interceptors.add(LogInterceptor(requestBody: true));

    new ApiControler()
        .dioAuthGet(context, authToken, Strings.checkbalance + "/" + id, {
      "authToken": authToken,
    }).then((onValue) {
      parsewallet(onValue);
    });
  }

  parsewallet(reply) async {
    setState(() {
      // isProgressShow = false;
    });

    if (reply != null) {
      Map userMap = jsonDecode(reply);
      var user = ApiResponce.fromJson(userMap);
      if (user.success) {
        walletData = ApiResponce.parseWallet(userMap);
        prefs.setString(
            'walletAmount',
            walletData != null
                ? walletData.result.walletBalace.toString()
                : "0");
      }
    }
  }

  getbookingdetails() async {
    final prefs = await SharedPreferences.getInstance();
    var authToken = prefs.getString('authToken');
    var bookingId = prefs.getString('bookingId');
    setState(() {
      //isProgressShow = true;
    });
    var dio = Dio();
    dio.interceptors.add(LogInterceptor(requestBody: true));

    new ApiControler().dioAuthGet(
        context, authToken, Strings.bookingdetails + "/" + bookingId, {
      "authToken": authToken,
    }).then((onValue) {
      parseBookingdetails(onValue);
    });
  }

  parseBookingdetails(reply) async {
    setState(() {
      // isProgressShow = false;
    });

    if (reply != null) {
      Map userMap = jsonDecode(reply);
      var user = ApiResponce.fromJson(userMap);
      if (user.success) {
        var res = ApiResponce.parseRideDetailsResponce(userMap);
        rideData = res.result.data;
        prefs.setString('ride_status', "0");
        prefs.setString('bookingId', "");
        setState(() {});
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
                  child: new ListView(
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
                        child: new Column(
                          children: <Widget>[
                            new Container(
                                height: SizeConfig.safeBlockVertical * 16,
                                child: AppHeader(
                                  title: languagePayment != null
                                      ? languagePayment.lbl_Payment_Summary
                                      : "Payment Summary",
                                  onBackClick: () {
                                    Navigator.pop(context);
                                  },
                                )),
                            new Container(
                              margin: EdgeInsets.only(
                                  top: SizeConfig.safeBlockVertical * 5),
                              padding: EdgeInsets.only(left: 25, right: 25),
                              height: SizeConfig.safeBlockVertical * 79,
                              width: SizeConfig.safeBlockHorizontal * 100,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(55.0),
                                    bottomLeft: Radius.circular(0.0)),
                              ),
                              child: SingleChildScrollView(
                                child: new Column(
                                  children: <Widget>[
                                    //TODO: DESIGN: Background to container.

                                    SizedBox(
                                      height: 30.0,
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      child: new Column(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(left: 30),
                                            child: new Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Text(
                                                    languageTerrif != null
                                                        ? languageTerrif
                                                            .lbl_Pay_as_you_go
                                                        : "Pay as you go",
                                                    style: TextStyle(
                                                        color: Colorss.black,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w500)),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(left: 30),
                                            child: Divider(
                                              color: Colors.brown.shade50,
                                              thickness: 1,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10.0,
                                          ),
                                        ],
                                      ),
                                    ),

                                    rideData != null
                                        ? new Container(
                                            margin: EdgeInsets.only(
                                                left: 35, right: 35, top: 10),
                                            child: new Column(
                                              children: [
                                                new Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        languagePayment !=
                                                                null
                                                            ? languagePayment
                                                                .lbl_Total_Minutes
                                                            : "Total Minutes",
                                                        style: TextStyle(
                                                            color:
                                                                Colorss.black,
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: new Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          Text(
                                                            rideData != null
                                                                ? '' +
                                                                    rideData
                                                                        .totalRideTime
                                                                : '0',
                                                            style: TextStyle(
                                                              color: Colorss
                                                                  .black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize: 16,
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 10.0,
                                                ),
                                                Divider(
                                                  color: Colors.brown.shade50,
                                                  thickness: 1,
                                                ),
                                                SizedBox(
                                                  height: 10.0,
                                                ),
                                                new Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        languageTerrif != null
                                                            ? languageTerrif
                                                                .lbl_Base_Fare
                                                            : "Base fare",
                                                        style: TextStyle(
                                                            color:
                                                                Colorss.black,
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: new Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          Text(
                                                            rideData != null
                                                                ? double.parse(rideData
                                                                            .advanceAmount)
                                                                        .toStringAsFixed(
                                                                            2) +
                                                                    Strings
                                                                        .app_currncy
                                                                : '0' +
                                                                    Strings
                                                                        .app_currncy,
                                                            style: TextStyle(
                                                              color: Colorss
                                                                  .black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize: 16,
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 10.0,
                                                ),
                                                Divider(
                                                  color: Colors.brown.shade50,
                                                  thickness: 1,
                                                ),
                                                SizedBox(
                                                  height: 10.0,
                                                ),
                                                new Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        languagePayment !=
                                                                null
                                                            ? languagePayment
                                                                .lbl_Total_Charge
                                                            : "Total Charge",
                                                        style: TextStyle(
                                                            color:
                                                                Colorss.black,
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: new Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          Text(
                                                            rideData != null
                                                                ? double.parse(rideData
                                                                            .fareAmount)
                                                                        .toStringAsFixed(
                                                                            2) +
                                                                    Strings
                                                                        .app_currncy
                                                                : '0' +
                                                                    Strings
                                                                        .app_currncy,
                                                            style: TextStyle(
                                                              color: Colorss
                                                                  .black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize: 16,
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 10.0,
                                                ),
                                                Divider(
                                                  color: Colors.brown.shade50,
                                                  thickness: 1,
                                                ),
                                                SizedBox(
                                                  height: 10.0,
                                                ),
                                                new Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        languagePayment !=
                                                                null
                                                            ? languagePayment
                                                                .lbl_Discount
                                                            : "Discount",
                                                        style: TextStyle(
                                                            color:
                                                                Colorss.black,
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: new Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          Text(
                                                            rideData != null
                                                                ? double.parse(rideData
                                                                            .discountPrice)
                                                                        .toStringAsFixed(
                                                                            2) +
                                                                    Strings
                                                                        .app_currncy
                                                                : '0' +
                                                                    Strings
                                                                        .app_currncy,
                                                            style: TextStyle(
                                                              color: Colorss
                                                                  .black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize: 16,
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 10.0,
                                                ),
                                                Divider(
                                                  color: Colors.brown.shade50,
                                                  thickness: 1,
                                                ),
                                                SizedBox(
                                                  height: 10.0,
                                                ),
                                                new Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        "VAT",
                                                        style: TextStyle(
                                                            color:
                                                                Colorss.black,
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: new Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          Text(
                                                            rideData != null
                                                                ? double.parse(rideData
                                                                            .tax)
                                                                        .toStringAsFixed(
                                                                            2) +
                                                                    Strings
                                                                        .app_currncy
                                                                : '0' +
                                                                    Strings
                                                                        .app_currncy,
                                                            style: TextStyle(
                                                              color: Colorss
                                                                  .black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize: 16,
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 10.0,
                                                ),
                                                Divider(
                                                  color: Colors.brown.shade50,
                                                  thickness: 1,
                                                ),
                                                SizedBox(
                                                  height: 10.0,
                                                ),
                                                new Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        languagePayment !=
                                                                null
                                                            ? languagePayment
                                                                .lbl_Wallet
                                                            : "Wallet",
                                                        style: TextStyle(
                                                            color:
                                                                Colorss.black,
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: new Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          Text(
                                                            rideData != null
                                                                ? double.parse(rideData
                                                                            .walletAmount)
                                                                        .toStringAsFixed(
                                                                            2) +
                                                                    Strings
                                                                        .app_currncy
                                                                : '0' +
                                                                    Strings
                                                                        .app_currncy,
                                                            style: TextStyle(
                                                              color: Colorss
                                                                  .black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize: 16,
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 10.0,
                                                ),
                                                Divider(
                                                  color: Colors.brown.shade50,
                                                  thickness: 1,
                                                ),
                                                SizedBox(
                                                  height: 10.0,
                                                ),
                                                new Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        languagePayment !=
                                                                null
                                                            ? languagePayment
                                                                .lbl_Total
                                                            : "Total",
                                                        style: TextStyle(
                                                            color:
                                                                Colorss.black,
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: new Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          Text(
                                                            rideData != null
                                                                ? double.parse(rideData
                                                                            .totalPaymentAmount)
                                                                        .toStringAsFixed(
                                                                            2) +
                                                                    Strings
                                                                        .app_currncy
                                                                : '0' +
                                                                    Strings
                                                                        .app_currncy,
                                                            style: TextStyle(
                                                              color: Colorss
                                                                  .black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize: 16,
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                new Container(
                                                  width: SizeConfig
                                                          .safeBlockHorizontal *
                                                      70,
                                                  margin: EdgeInsets.only(
                                                      top: SizeConfig
                                                              .safeBlockVertical *
                                                          7,
                                                      bottom: 5),
                                                  child: AppButton(
                                                      title: lanRes != null &&
                                                              lanRes
                                                                      .result
                                                                      .data
                                                                      .navigation
                                                                      .lbl_Home !=
                                                                  null
                                                          ? lanRes
                                                              .result
                                                              .data
                                                              .navigation
                                                              .lbl_Home
                                                          : "Home",
                                                      showIcon: false,
                                                      onButtonClick: () {
                                                        prefs.setString(
                                                            'ride_status',
                                                            "0");
                                                        prefs.setString(
                                                            'bookingId', "");
                                                        Navigator
                                                            .pushNamedAndRemoveUntil(
                                                                context,
                                                                "/MenuScreen",
                                                                (r) => false);
                                                      },
                                                      fontSize: SizeConfig
                                                              .safeBlockHorizontal *
                                                          Dimens.text_5),
                                                )
                                              ],
                                            ),
                                          )
                                        : new Container()
                                    // Divider(),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                if (isProgressShow)
                  new Positioned(
                      child: new Center(child: CircularProgressIndicator())),
              ],
            ),
          )),
    ); // This trailing comma makes auto-formatting nicer for build methods.
  }
}
