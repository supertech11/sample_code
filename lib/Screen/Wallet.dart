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
import 'package:xplor/Model/LanguageResponce.dart';
import 'package:xplor/Screen/PaymentURL.dart';

import 'package:xplor/util/ApiControler.dart';
import 'package:xplor/util/AppButton.dart';
import 'package:xplor/util/AppButtonPay.dart';
import 'package:xplor/util/AppHeader.dart';
import 'package:xplor/util/Colorss.dart';
import 'package:xplor/util/Dimens.dart';
import 'package:xplor/util/SizeConfig.dart';
import 'package:xplor/util/Strings.dart';
import 'package:xplor/util/utilities.dart';
import 'package:xplor/localization/language_constants.dart';
import 'package:xplor/util/images.dart';

import 'package:xplor/widgets/independent/menu_line.dart';

class Wallet extends StatefulWidget {
  Wallet({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _WalletPageState createState() => _WalletPageState();
}

class _WalletPageState extends State<Wallet> {
  var profile;
  bool isProgressShow = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDataLanguage();
    getCheckbalance();
  }

  var prefs;
  var lanRes, languageValue = "en";

  getDataLanguage() async {
    prefs = await SharedPreferences.getInstance();
    languageValue = prefs.getString(LAGUAGE_CODE) ?? "en";
    var data = prefs.getString('languageData');
    Map langMap = jsonDecode(data.toString());
    lanRes = LanguageResponce.parseLanguage(langMap);
    print(lanRes.result.data.Settings.lbl_firstname1);
  }

  getCheckbalance() async {
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

  var walletData;

  parse(reply) async {
    setState(() {
      isProgressShow = false;
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
      } else {
        new Utilities()
            .showAlertDialog(context, Strings.alert, user.result.message, "OK");
        // print('Howdy, ${user.code} ${user.msg}!');
      }
    }
  }

  addwalletbalance(amount) async {
    final prefs = await SharedPreferences.getInstance();
    var authToken = prefs.getString('authToken');
    var id = prefs.getString('id');
    setState(() {
      isProgressShow = true;
    });
    var dio = Dio();
    dio.interceptors.add(LogInterceptor(requestBody: true));

    new ApiControler().dioAuthGet(context, authToken,
        Strings.addwalletbalance + "/" + id + "/" + amount, {
      "authToken": authToken,
    }).then((onValue) {
      parseAddwalletbalance(onValue);
    });
  }

  var addWalletData;

  parseAddwalletbalance(reply) async {
    setState(() {
      isProgressShow = false;
    });

    if (reply != null) {
      Map userMap = jsonDecode(reply);
      var user = ApiResponce.fromJson(userMap);
      if (user.success) {
        addWalletData = ApiResponce.parseSavepayment(userMap);
        if (addWalletData.result != null &&
            addWalletData.result.paymentstatus == "1") {
          getCheckbalance();
          new Utilities().showAlertDialog(
              context, Strings.alert, user.result.message, "OK");
        } else {
          var PaymentPortal =
              addWalletData.result.data.Transaction.PaymentPortal;
          var TransactionIDs =
              addWalletData.result.data.Transaction.TransactionID;
          var CallBackUrl = addWalletData.result.data.Transaction.CallBackUrl;
          var walletid = addWalletData.result.walletid;

          print("PaymentPortal>>> " + PaymentPortal);
          print("TransactionIDs>>> " + TransactionIDs);
          print("CallBackUrl>>> " + CallBackUrl);

          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PaymentURL(
                    selectedUrl: PaymentPortal,
                    TransactionID: TransactionIDs,
                    CallBackUrl: CallBackUrl)),
          ).then((onValue) => {apiCompletePayment(TransactionIDs, walletid)});
        }
      } else {
        new Utilities()
            .showAlertDialog(context, Strings.alert, user.result.message, "OK");
        // print('Howdy, ${user.code} ${user.msg}!');
      }
    }
  }

  apiCompletePayment(TransactionIDs, walletid) async {
    var authToken = prefs.getString('authToken');
    var id = prefs.getString('id');
    setState(() {
      isProgressShow = true;
    });
    var dio = Dio();
    dio.interceptors.add(LogInterceptor(requestBody: true));

    new ApiControler()
        .dioAuthPost(context, authToken, Strings.checkwallettransaction, {
      "authToken": authToken,
      "transactionId": TransactionIDs,
      "walletId": walletid,
      "userId": id,
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
        getCheckbalance();
        new Utilities()
            .showAlertDialog(context, Strings.alert, user.result.message, "OK");

        // showSuccesPaymentDialog(context, Strings.alert, user.result.message);
      } else {
        new Utilities()
            .showAlertDialog(context, Strings.alert, user.result.message, "OK");
        // print('Howdy, ${user.code} ${user.msg}!');
      }
    }
  }

  _onAlertWithStylePressed2(context) {
    TextEditingController _textControllerAmount = TextEditingController();

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            contentPadding: EdgeInsets.only(top: 15, left: 15, right: 15),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)),
            content: StatefulBuilder(
              // You need this, notice the parameters below:
              builder: (BuildContext context, StateSetter setState) {
                return SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Container(
                    height: 180,
                    width: SizeConfig.safeBlockHorizontal * 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: new Stack(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              new Container(
                                padding: EdgeInsets.only(
                                    top: 0, bottom: 10, left: 1, right: 1),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      bottomRight: Radius.circular(20),
                                      bottomLeft: Radius.circular(20),
                                      topRight: Radius.circular(20)),
                                ),
                                width: SizeConfig.safeBlockHorizontal * 90,
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: 10,
                                          right: 10,
                                          bottom: 8,
                                          top: 5),
                                      child: Text("Enter Amount",
                                          style: TextStyle(
                                            color: Colors.black87,
                                            fontWeight: FontWeight.w500,
                                            fontSize:
                                                SizeConfig.blockSizeHorizontal *
                                                    Dimens.text_4,
                                          )),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Container(
                                      height: 40,
                                      padding: const EdgeInsets.all(0.0),
                                      child: TextField(
                                        onChanged: (value) {},
                                        controller: _textControllerAmount,
                                        keyboardType: TextInputType.number,
                                        textInputAction: TextInputAction.done,
                                        decoration: InputDecoration(
                                            labelText: "amount",
                                            hintText: "amount",
                                            labelStyle: TextStyle(
                                                fontStyle: FontStyle.normal,
                                                fontSize: SizeConfig
                                                        .blockSizeHorizontal *
                                                    Dimens.text_4,
                                                color: Colors.black),
                                            hintStyle: TextStyle(
                                                fontSize: SizeConfig
                                                        .blockSizeHorizontal *
                                                    Dimens.text_4,
                                                color: Colors.black),
                                            border: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(5.0)))),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    new Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            new Container(
                                              width: SizeConfig
                                                      .safeBlockHorizontal *
                                                  30,
                                              margin: EdgeInsets.only(
                                                  left: 0,
                                                  right: 10,
                                                  bottom: 0,
                                                  top: 0),
                                              child: new MaterialButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                colorBrightness:
                                                    Brightness.light,
                                                splashColor: Colors.white,
                                                color: Colors.black,
                                                textColor: Colors.white,
                                                elevation: 5,
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                shape:
                                                    new RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    20.0))),
                                                child: new Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    new Text("Cancel",
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 15,
                                                        ))
                                                  ],
                                                ),
                                              ),
                                            ),
                                            new Container(
                                              width: SizeConfig
                                                      .safeBlockHorizontal *
                                                  30,
                                              margin: EdgeInsets.only(
                                                  left: 0,
                                                  right: 10,
                                                  bottom: 0,
                                                  top: 0),
                                              child: AppButtonPay(
                                                  title: "Pay",
                                                  onButtonClick: () {
                                                    String amount =
                                                        _textControllerAmount
                                                            .text;
                                                    if (amount != null &&
                                                        amount != "") {
                                                      Navigator.of(context)
                                                          .pop();
                                                      addwalletbalance(amount);
                                                    }

                                                    // getBookCourt(jsonArrr, slotList.get(posSlot).toString(), slotList.get(posSlot + 1).toString(), "", "", "");
                                                  },
                                                  fontSize: SizeConfig
                                                          .safeBlockHorizontal *
                                                      Dimens.text_4),
                                            ),
                                          ],
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        });
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
                padding: EdgeInsets.only(
                    top: SizeConfig.safeBlockVertical * 4, right: 20),
                child: new Container(
                    child: AppHeader(
                  title: lanRes != null
                      ? lanRes.result.data.navigation.lbl_Wallet
                      : Strings.wallets,
                  onBackClick: () {
                    Navigator.pop(context);
                  },
                )),
              ),
              new Positioned(
                  child: new Container(
                margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 30),
                padding: EdgeInsets.only(left: 25, right: 25),
                height: SizeConfig.safeBlockVertical * 76,
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
                  top: SizeConfig.safeBlockVertical * 18,
                  left: 0,
                  right: 0,
                  child: new Container(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: new Column(
                      children: [
                        SizedBox(
                          height: 30.0,
                        ),
                        CreditCard(
                            cardTitle: lanRes != null
                                ? lanRes.result.data.MyWallet.lbl_Balance
                                : 'Balance',
                            amount: walletData != null
                                ? walletData.result.walletBalace +
                                    Strings.app_currncy
                                : '0' + Strings.app_currncy,
                            bg_pattern: languageValue == "en"
                                ? Images.walletPattern
                                : Images.walletPattern_ar,
                            bike: languageValue == "en"
                                ? Images.bike
                                : Images.bike_ar),
                        SizedBox(
                          height: 50.0,
                        ),
                        OpenFlutterMenuLine(
                            title: lanRes != null
                                ? lanRes.result.data.MyWallet.lbl_Topup
                                : Strings.topup,
                            showBackIcon: true,
                            onTap: (() =>
                                {_onAlertWithStylePressed2(context)})),
                        // Divider(
                        //   height: 5.0,
                        //   color: Colors.brown,
                        // ),
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

class CreditCard extends StatelessWidget {
  final String cardTitle;
  final String amount;
  String bg_pattern, bike;

  CreditCard(
      {Key key,
      @required this.cardTitle,
      @required this.amount,
      this.bg_pattern,
      this.bike})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _media = MediaQuery.of(context).size;
    return Container(
      width: _media.width - 40,
      // height: 200,
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: Colors.black26,
          blurRadius: 10,
        ),
      ], color: Colors.white, borderRadius: BorderRadius.circular(30)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                height: 210,
                width: _media.width / 2,
                decoration: new BoxDecoration(
                  image: new DecorationImage(
                    image: new ExactAssetImage(bg_pattern),
                    fit: BoxFit.fill,
                  ),
                ),
                child: new Container(
                    margin: EdgeInsets.all(25),
                    child: Image.asset(
                      bike,
                      // height: 100
                      // height: 100,
                      // color: Colors.white,
                    )),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 16.0, left: 10, right: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                SizedBox(
                    width: (_media.width / 2) - 65,
                    child: Text(
                      cardTitle,
                      textAlign: TextAlign.end,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize:
                              SizeConfig.safeBlockHorizontal * Dimens.text_4),
                    )),
                SizedBox(height: 10),
                SizedBox(
                  width: (_media.width / 2) - 65,
                  child: Text(
                    amount + "",
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize:
                          SizeConfig.safeBlockHorizontal * Dimens.text_4_5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(width: 5),
        ],
      ),
    );
  }
}
