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

class Payment extends StatefulWidget {
  Payment({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<Payment> {
  var profile;
  bool _isCheckedCoupon = false;
  String totalDiscount = "0",
      afterDiscountPrice = "",
      totalwallet = "0",
      total = "0",
      couponCode = "",
      totalrideEstimate = "0";
  TextEditingController _textControllercoupon = TextEditingController();
  bool isProgressShow = false;
  final FocusNode _couponFocus = FocusNode();

  //_passFocus.unfocus();
  @override
  void initState() {
    super.initState();
    getDataLanguage();
  }

  stopRide() async {
    var authToken = prefs.getString('authToken');
    var bookingId = prefs.getString('bookingId');
    setState(() {
      isProgressShow = true;
    });
    var dio = Dio();
    dio.interceptors.add(LogInterceptor(requestBody: true));

    new ApiControler()
        .dioAuthGet(context, authToken, Strings.stopRide + "/" + bookingId, {
      "authToken": authToken,
    }).then((onValue) {
      parseRide(onValue);
    });
  }

  var rideData, paymentdata, terrifData;

  parseRide(reply) async {
    setState(() {
      isProgressShow = false;
    });

    if (reply != null) {
      Map userMap = jsonDecode(reply);
      var user = ApiResponce.fromJson(userMap);
      if (user.success) {
        prefs.setString('ride_status', "3");

        var data = ApiResponce.parseStopRide(userMap);
        rideData = data.result.rideDetails;

        paymentdata = data.result.rideDetails.paymentIdData;
        terrifData = data.result.rideDetails.scooterIddata.tarrifIdata;

        print("iotDeviceId>>  " +
            data.result.rideDetails.iotDeviceId.toUpperCase());
        getCheckbalance();
        new Utilities().showToast(
          context,
          user.result.message,
        );
      } else {
        new Utilities()
            .showAlertDialog(context, Strings.alert, user.result.message, "OK");
        // print('Howdy, ${user.code} ${user.msg}!');
      }
    }
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

  var walletData;

  parsewallet(reply) async {
    setState(() {
      // isProgressShow = false;
    });

    if (reply != null) {
      Map userMap = jsonDecode(reply);
      var user = ApiResponce.fromJson(userMap);
      if (user.success) {
        walletData = ApiResponce.parseWallet(userMap);
        setTotalCalculation("0");
      }
    }
  }

  setTotalCalculation(discount) {
    var totalRideamt,
        totalDiscountamt = double.parse(discount),
        totalWalletAmt =
            double.parse(walletData.result.walletBalace.toString());
    if (rideData.totalRideTime == "0") {
      totalRideamt = double.parse(terrifData.baseAmount);
    } else {
      totalRideamt = double.parse(terrifData.perMinuteCharge) *
              double.parse(rideData.totalRideTime) +
          double.parse(terrifData.baseAmount);
    }
    totalrideEstimate = totalRideamt.toString();

    if (discount == "0") {
      couponCode = "";
    }
    if (totalDiscountamt >= totalRideamt) {
      totalwallet = "0";
      total = "0";
      totalDiscount = totalRideamt.toString();
      afterDiscountPrice = "0";
    } else {
      totalRideamt = totalRideamt - totalDiscountamt;
      afterDiscountPrice = totalRideamt.toString();
      if (totalRideamt >= totalWalletAmt) {
        totalRideamt = totalRideamt - totalWalletAmt;
        totalwallet = totalWalletAmt.toString();
        total = totalRideamt.toString();
        totalDiscount = totalDiscountamt.toString();
      } else {
        totalwallet = totalRideamt.toString();
        total = "0";
        totalDiscount = totalDiscountamt.toString();
      }
    }

    setState(() {});
  }

  applyoffer(couponCode) async {
    var authToken = prefs.getString('authToken');
    var bookingId = prefs.getString('bookingId');
    setState(() {
      isProgressShow = true;
    });
    var dio = Dio();
    dio.interceptors.add(LogInterceptor(requestBody: true));

    new ApiControler().dioAuthGet(context, authToken,
        Strings.applyoffer + "/" + couponCode + "/" + bookingId, {
      "authToken": authToken,
    }).then((onValue) {
      parseApplyoffer(onValue, couponCode);
    });
  }

  parseApplyoffer(reply, strcouponCodes) async {
    setState(() {
      isProgressShow = false;
    });

    if (reply != null) {
      Map userMap = jsonDecode(reply);
      var user = ApiResponce.fromJson(userMap);
      if (user.success) {
        couponCode = strcouponCodes;
        var data = ApiResponce.parseApplyoffer(userMap);
        setTotalCalculation(data.appoffer.discountPrice);
      } else {
        couponCode = "";
        new Utilities()
            .showAlertDialog(context, Strings.alert, user.result.message, "OK");
        // print('Howdy, ${user.code} ${user.msg}!');
      }
    }
  }

  apiSavePayment() async {
    var authToken = prefs.getString('authToken');
    var bookingId = prefs.getString('bookingId');
    setState(() {
      isProgressShow = true;
    });
    var dio = Dio();
    dio.interceptors.add(LogInterceptor(requestBody: true));

    new ApiControler().dioAuthPost(context, authToken, Strings.savePayment, {
      "authToken": authToken,
      "bookingId": bookingId,
      "totalMinute": rideData.totalRideTime,
      "basefare": terrifData.baseAmount,
      "totalCharge": totalrideEstimate,
      "discountPrice": totalDiscount,
      "afterDiscountPrice": afterDiscountPrice,
      "walletAmount": totalwallet,
      "totalPaymentCharge": total,
      "damagedPenalty": 0,
      "taxAmount": 0,
      "couponCode": couponCode,
    }).then((onValue) {
      parseSavePayment(onValue);
    });
  }

  parseSavePayment(reply) async {
    setState(() {
      isProgressShow = false;
    });

    if (reply != null) {
      Map userMap = jsonDecode(reply);
      var user = ApiResponce.fromJson(userMap);
      if (user.success) {
        if (double.parse(total) == 0) {
          prefs.setString('ride_status', "0");
          prefs.setString('bookingId', "");
          showSuccesPaymentDialog(context, Strings.alert, user.result.message);
        } else {
          var data = ApiResponce.parseSavepayment(userMap);

          if (data.result != null && data.result.paymentstatus == "1") {
            prefs.setString('ride_status', "0");
            prefs.setString('bookingId', "");
            showSuccesPaymentDialog(
                context, Strings.alert, user.result.message);
          } else {
            var PaymentPortal = data.result.data.Transaction.PaymentPortal;
            var TransactionIDs = data.result.data.Transaction.TransactionID;
            var CallBackUrl = data.result.data.Transaction.CallBackUrl;

            print("PaymentPortal>>> " + PaymentPortal);
            print("TransactionIDs>>> " + TransactionIDs);
            print("CallBackUrl>>> " + CallBackUrl);
            new Utilities().showToast(
              context,
              user.result.message,
            );
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PaymentURL(
                      selectedUrl: PaymentPortal,
                      TransactionID: TransactionIDs,
                      CallBackUrl: CallBackUrl)),
            ).then((onValue) => {apiCompletePayment(TransactionIDs)});
          }
        }
      } else {
        new Utilities()
            .showAlertDialog(context, Strings.alert, user.result.message, "OK");
        // print('Howdy, ${user.code} ${user.msg}!');
      }
    }
  }

  apiCompletePayment(TransactionIDs) async {
    var authToken = prefs.getString('authToken');
    var bookingId = prefs.getString('bookingId');
    setState(() {
      isProgressShow = true;
    });
    var dio = Dio();
    dio.interceptors.add(LogInterceptor(requestBody: true));

    new ApiControler()
        .dioAuthPost(context, authToken, Strings.completePayment, {
      "authToken": authToken,
      "bookingId": bookingId,
      "transactionId": TransactionIDs,
      "totalMinute": rideData.totalRideTime,
      "basefare": terrifData.baseAmount,
      "totalCharge": totalrideEstimate,
      "discountPrice": totalDiscount,
      "walletAmount": totalwallet,
      "totalPaymentCharge": total,
      "damagedPenalty": 0,
      "taxAmount": 0
    }).then((onValue) {
      parseCompletePayment(onValue);
    });
  }

  parseCompletePayment(reply) async {
    setState(() {
      isProgressShow = false;
    });

    if (reply != null) {
      Map userMap = jsonDecode(reply);
      var user = ApiResponce.fromJson(userMap);
      if (user.success) {
        prefs.setString('bookingId', "");

//        new Utilities().showToast(
//          context,
//          user.result.message,
//        );

        showSuccesPaymentDialog(context, Strings.alert, user.result.message);
      } else {
        new Utilities()
            .showAlertDialog(context, Strings.alert, user.result.message, "OK");
        // print('Howdy, ${user.code} ${user.msg}!');
      }
    }
  }

  void showSuccesPaymentDialog(context, title, msg) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)), //this right here
            child: Container(
              height: 200,
              width: SizeConfig.safeBlockHorizontal * 75,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    new Container(
                      padding: EdgeInsets.only(
                          top: 10, bottom: 10, left: 20, right: 20),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20)),
                      ),
                      width: SizeConfig.safeBlockHorizontal * 75,
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          new Padding(
                            padding:
                                EdgeInsets.only(top: 5, left: 15, right: 15),
                            child: Text(
                              languageMessages != null
                                  ? languageMessages.Msg_Successful
                                  : "Successful",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: SizeConfig.safeBlockHorizontal *
                                      Dimens.text_5,
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                    new Container(
                        padding: EdgeInsets.only(top: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                        ),
                        width: 1000,
                        height: 95,
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            new Padding(
                              padding: EdgeInsets.only(left: 8, right: 8),
                              child: Text(
                                msg,
                                maxLines: 4,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: SizeConfig.safeBlockHorizontal *
                                      Dimens.text_4,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        )),
                    new Container(
                      height: 49,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(20),
                          bottomLeft: Radius.circular(20),
                        ),
                      ),
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            height: 35,
                            width: 100.0,
                            child: RaisedButton(
                              shape: StadiumBorder(),
                              onPressed: () {
                                Navigator.pop(context);
                                prefs.setString('ride_status', "");
                                prefs.setString('bookingId', "");
                                Navigator.pushNamedAndRemoveUntil(
                                    context, "/MenuScreen", (r) => false);
                              },
                              child: Text(
                                languageMessages != null
                                    ? languageMessages.Msg_Close
                                    : "Close",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: SizeConfig.safeBlockHorizontal *
                                        Dimens.text_4,
                                    fontWeight: FontWeight.w400),
                              ),
                              color: Colors.red,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  var prefs;
  var languageTerrif, languageMyWallet, languagePayment, languageMessages;

  getDataLanguage() async {
    prefs = await SharedPreferences.getInstance();
    var data = prefs.getString('languageData');
    Map langMap = jsonDecode(data.toString());
    var lanRes = LanguageResponce.parseLanguage(langMap);
    languageTerrif = lanRes.result.data.Tariff;
    languageMyWallet = lanRes.result.data.MyWallet;
    languagePayment = lanRes.result.data.Payments;
    languageMessages = lanRes.result.data.Messages;
    print(languageTerrif.toString());
    stopRide();
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
                            child: AppHeader(
                          title: languagePayment != null
                              ? languagePayment.lbl_Payment
                              : Strings.payment,
                          onBackClick: () {
                            Navigator.pop(context);
                          },
                        )),
                        new Container(
                          margin: EdgeInsets.only(
                              top: SizeConfig.safeBlockVertical * 5),
                          padding: EdgeInsets.only(left: 25, right: 25),
                          height: SizeConfig.safeBlockVertical * 95,
                          width: SizeConfig.safeBlockHorizontal * 100,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(55.0),
                                bottomLeft: Radius.circular(0.0)),
                          ),
                          child: new Column(
                            children: <Widget>[
                              //TODO: DESIGN: Background to container.

                              SizedBox(
                                height: 30.0,
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: new Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(left: 25),
                                      child: Container(
                                          decoration: BoxDecoration(
                                              border: Border(
                                            bottom: BorderSide(
                                              color: Colors.black12,
                                              // width: 1.0,
                                            ),
                                          )),
                                          child: new Row(
                                            children: [
                                              new Expanded(
                                                  flex: 2,
                                                  child: new Container(
                                                    child: Container(
                                                      child: TextField(
                                                        enabled: true,

                                                        focusNode: _couponFocus,
                                                        // enableInteractiveSelection:
                                                        //     _isCheckedCoupon,
                                                        controller:
                                                            _textControllercoupon,
                                                        style: TextStyle(
                                                            fontSize: SizeConfig
                                                                    .safeBlockHorizontal *
                                                                Dimens.text_4,
                                                            color:
                                                                Colorss.black),
                                                        keyboardType:
                                                            TextInputType.text,
                                                        // controller: _textControllerName,
                                                        textInputAction:
                                                            TextInputAction
                                                                .done,
                                                        cursorColor:
                                                            Colorss.app_color,
                                                        onSubmitted:
                                                            (couponCode) {
                                                          _couponFocus
                                                              .unfocus();
                                                        },
                                                        decoration:
                                                            InputDecoration(
                                                          disabledBorder:
                                                              UnderlineInputBorder(
                                                            borderSide: BorderSide(
                                                                width: 0.0,
                                                                color: Colors
                                                                    .transparent),
                                                          ),
                                                          border:
                                                              UnderlineInputBorder(
                                                            borderSide: BorderSide(
                                                                width: 0.0,
                                                                color: Colors
                                                                    .transparent),
                                                          ),
                                                          hintText: languagePayment !=
                                                                  null
                                                              ? languagePayment
                                                                  .lbl_Coupon_Code
                                                              : "Coupon Code",
                                                          fillColor: Colors
                                                              .transparent,
                                                          // focusColor: Colors.black54,
                                                          focusedBorder:
                                                              UnderlineInputBorder(
                                                            borderSide: BorderSide(
                                                                width: 0.0,
                                                                color: Colors
                                                                    .transparent),
                                                          ),
                                                          enabledBorder:
                                                              UnderlineInputBorder(
                                                            borderSide: BorderSide(
                                                                width: 0.0,
                                                                color: Colors
                                                                    .transparent),
                                                          ),
                                                          labelStyle: TextStyle(
                                                              fontSize: SizeConfig
                                                                      .safeBlockHorizontal *
                                                                  Dimens.text_4,
                                                              color: Colorss
                                                                  .black),
                                                          hintStyle: TextStyle(
                                                              fontSize: SizeConfig
                                                                      .safeBlockHorizontal *
                                                                  Dimens.text_4,
                                                              color: Colorss
                                                                  .grey_color),
                                                        ),
                                                      ),
                                                    ),
                                                  )),
                                              Expanded(
                                                  flex: 1,
                                                  child: new Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      Checkbox(
                                                        value: _isCheckedCoupon,
                                                        onChanged: (newValue) {
                                                          setState(() {
                                                            _isCheckedCoupon =
                                                                newValue;
                                                          });
                                                          if (newValue) {
                                                            var couponcode =
                                                                _textControllercoupon
                                                                    .text;

                                                            if (couponcode !=
                                                                    null &&
                                                                couponcode !=
                                                                    "") {
                                                              applyoffer(
                                                                  couponcode);
                                                            } else {
                                                              setTotalCalculation(
                                                                  "0");
                                                            }
                                                          } else {
                                                            _textControllercoupon
                                                                .text = "";
                                                            setTotalCalculation(
                                                                "0");
                                                          }
                                                        },
                                                        //  <-- leading Checkbox
                                                      ),
                                                    ],
                                                  ))
                                            ],
                                          )),
                                    ),
                                    SizedBox(
                                      height: 30.0,
                                    ),
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
                                                  fontWeight: FontWeight.w500)),
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

                              new Container(
                                margin: EdgeInsets.only(
                                    left: 35, right: 35, top: 10),
                                child: new Column(
                                  children: [
                                    new Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            languagePayment != null
                                                ? languagePayment
                                                    .lbl_Total_Minutes
                                                : "Total Minutes",
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
                                                rideData != null
                                                    ? '' +
                                                        rideData.totalRideTime
                                                    : '0',
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
                                            languagePayment != null
                                                ? languagePayment
                                                    .lbl_Total_Charge
                                                : "Total Charge",
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
                                                    ? (double.parse(terrifData
                                                                        .perMinuteCharge) *
                                                                    double.parse(
                                                                        rideData
                                                                            .totalRideTime) +
                                                                double.parse(
                                                                    terrifData
                                                                        .baseAmount))
                                                            .toStringAsFixed(
                                                                2) +
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
                                            languagePayment != null
                                                ? languagePayment.lbl_Discount
                                                : "Discount",
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
                                                totalDiscount != null
                                                    ? double.parse(
                                                                totalDiscount)
                                                            .toStringAsFixed(
                                                                2) +
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
                                            languagePayment != null
                                                ? languagePayment.lbl_Wallet
                                                : "Wallet",
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
                                                totalwallet != null
                                                    ? double.parse(totalwallet)
                                                            .toStringAsFixed(
                                                                2) +
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
                                            languagePayment != null
                                                ? languagePayment.lbl_Total
                                                : "Total",
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
                                                total != null
                                                    ? double.parse(total)
                                                            .toStringAsFixed(
                                                                2) +
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
                                          top: SizeConfig.safeBlockVertical * 7,
                                          bottom: 5),
                                      child: AppButton(
                                          title: languagePayment != null
                                              ? languagePayment.lbl_Pay
                                                  .toString()
                                              : "Pay",
                                          showIcon: false,
                                          onButtonClick: () {
                                            if (rideData != null) {
                                              apiSavePayment();
                                            } else {
                                              prefs.setString(
                                                  'ride_status', "0");
                                              prefs.setString('bookingId', "");

                                              Navigator.pushNamedAndRemoveUntil(
                                                  context,
                                                  "/MenuScreen",
                                                  (r) => false);
                                            }
                                          },
                                          fontSize:
                                              SizeConfig.safeBlockHorizontal *
                                                  Dimens.text_5),
                                    )
                                  ],
                                ),
                              )
                              // Divider(),
                            ],
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
      ),
    ); // This trailing comma makes auto-formatting nicer for build methods.
  }


}
