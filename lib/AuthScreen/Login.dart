import 'dart:convert';
import 'dart:io';
import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_picker_dropdown.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/countdown.dart';
import 'package:flutter_countdown_timer/countdown_controller.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xplor/HomeScreen/RideMap.dart';
import 'package:xplor/Model/ApiResponce.dart';
import 'package:xplor/Model/LanguageResponce.dart';
import 'package:xplor/Model/UserData.dart';
import 'package:xplor/util/ApiControler.dart';
import 'package:xplor/util/AppButton.dart';
import 'package:xplor/util/Colorss.dart';
import 'package:xplor/util/Dimens.dart';
import 'package:xplor/util/SizeConfig.dart';
import 'package:xplor/util/Strings.dart';
import 'package:xplor/util/images.dart';
import 'package:xplor/util/utilities.dart';

import 'package:sms_autofill/sms_autofill.dart';

class Login extends StatefulWidget {
  Login({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<Login> {
  String booking;
  int pinLength = 6;
  bool hasError = false, validateEmail = false;
  String thisTextotp = "";
  TextEditingController controller = TextEditingController();
  TextEditingController _textControllerMobile = TextEditingController();
  String phonecontryCode = "971";
  final FocusNode _userFocus = FocusNode();
  bool remVal = false,
      isProgressShow = false,
      isVerificationmsgSent = false,
      validate = false,
      isTimmer = false;
  String mobileNumber = "", errorMsg = "";
  bool transactionStatus = true;
  bool bookingStatus = true;
  var profile;
  String image;
  CountdownController timercontroller;
  var terrifData, scoterdata, rideData;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  var prefs;
  var lanRes, Welcome, Signin;

  getDataLanguage() async {
    prefs = await SharedPreferences.getInstance();
    var data = prefs.getString('languageData');
    Map langMap = jsonDecode(data.toString());
    lanRes = LanguageResponce.parseLanguage(langMap);
    Welcome = lanRes.result.data.Welcome;
    Signin = lanRes.result.data.Signin;
    print(lanRes.result.data.Settings.lbl_firstname1);
  }

  startTimer() {
    timercontroller = CountdownController(duration: Duration(seconds: 60));

    timercontroller.addListener(() {
      setState(() {});
    });

    timercontroller.start();
    setState(() {
      isTimmer = true;
    });
    verifyPhoneNumber();
  }

  void verifyPhoneNumber() async {
    mobileNumber = _textControllerMobile.text;
    print("mobileNumber>> " + mobileNumber);
    if (mobileNumber == "") {
      new Utilities().showToast(
        context,
        "Please enter mobile number",
      );
      return;
    }
    controller.clear();
    try {
      mobileNumber = phonecontryCode + _textControllerMobile.text;
      setState(() {
        isProgressShow = true;
      });
      loginApi();
    } catch (e) {
      new Utilities().showAlertDialog(
          context, Strings.alert, "Failed to Verify Phone Number: ${e}", "OK");
    }
  }

  void signInWithPhoneNumber() async {
    try {
      VerifyApi();
    } catch (e) {
      print(e.toString());
      new Utilities().showAlertDialog(
          context, Strings.alert, "Failed to sign in: " + e.toString(), "OK");
    }
  }

  loginApi() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isProgressShow = true;
    });
    var dio = Dio();
    dio.interceptors.add(LogInterceptor(requestBody: true));

    new ApiControler().dioPost(context, Strings.authenticate, {
      "mobile": mobileNumber,
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
        setState(() {
          isVerificationmsgSent = true;
        });
      } else {
        new Utilities()
            .showAlertDialog(context, Strings.alert, user.result.message, "OK");
      }
    }
  }

  VerifyApi() async {
    print("thisTextotp>> " + thisTextotp);
    setState(() {
      isProgressShow = true;
    });
    var dio = Dio();
    dio.interceptors.add(LogInterceptor(requestBody: true));

    new ApiControler().dioPost(context, Strings.verificationOTP, {
      "otpToken": thisTextotp,
    }).then((onValue) {
      parseVerify(onValue);
    });
  }

  parseVerify(reply) async {
    setState(() {
      isProgressShow = false;
    });

    if (reply != null) {
      Map userMap = jsonDecode(reply);
      var user = ApiResponce.fromJson(userMap);
      if (user.success) {
        booking = userMap['result']['booking'].toString();
        print(userMap['result']['booking']);
        // booking = userMap['result']['booking'];
        final prefs = await SharedPreferences.getInstance();
        if (userMap['result']['booking'].toString() != "NULL") {
          var date = DateTime.fromMillisecondsSinceEpoch(
              userMap['result']['booking']['bookingDate']);
          String rideStartdate =
              new DateFormat("yyyy-MM-dd HH:mm:ss").format(date);
          print(rideStartdate);
          prefs.setString('rideStartdate', rideStartdate.toString());
          prefs.remove('bookingId');
          prefs.setString('bookingId',
              userMap['result']['booking']['bookingId'].toString());
          prefs.setDouble(
              'bareAmount',
              userMap['result']['booking']['scooterId']['tarrifId']
                  ['baseAmount']);
          prefs.setDouble(
              'perMinuteCharge',
              userMap['result']['booking']['scooterId']['tarrifId']
                  ['perMinuteCharge']);
          prefs.setString(
              'power', userMap['result']['booking']['scooterId']['power']);
          prefs.setString(
              'perMinuteCharge',
              userMap['result']['booking']['scooterId']['tarrifId']
                      ['perMinuteCharge']
                  .toString());
          setState(() {
            transactionStatus =
                userMap['result']['booking']['paymentId']['transactionStatus'];
            bookingStatus = userMap['result']['booking']['bookingStatus'];
            image = userMap['result']['booking']['images'].toString();
            if(image != null){
              prefs.setString("imageupload", image.toString());
            }
            
          });
          // if (userMap['result']['booking']['paymentId']['transactionStatus'] == true) {
          //   prefs.setString('ride_status', "2");

          // } else {
          //   prefs.setString('ride_status', "1");
          //   setState(() {
          //     transactionStatus = false;
          //   });
          // }
        } else {
          setState(() {
            transactionStatus = true;
          });
        }
        var user = ApiResponce.parseLoginResponce(userMap);
        if (timercontroller != null && timercontroller.isRunning) {
          timercontroller.dispose();
        }

        saveData(
          transactionStatus,
          userMap['result']['booking'].toString(),
          jsonEncode(user.result.data),
          user.result.data.firebaseId,
          user.result.data.authToken,
          user.result.data.mobile,
          user.result.data.id,
          user.result.data.notification,
          user.result.data.walletAmount,
          user.result.data.card_added,
          user.result.data.cardNo,
        );
        //new Utilities().showToast(context, user.message);

      } else {
        new Utilities()
            .showAlertDialog(context, Strings.alert, user.result.message, "OK");
        // print('Howdy, ${user.code} ${user.msg}!');
      }
    }
  }

  saveData(transactionStatus, bookingId, profile, firebaseId, authToken, mobile,
      id, notification, walletAmount, card_added, cardNo) async {
    final prefs = await SharedPreferences.getInstance();
    // print('profile' + profile);
    prefs.setString('profile', profile);
    prefs.setString('firebaseId', firebaseId);
    prefs.setString('authToken', authToken);
    prefs.setString('mobile', mobile);
    prefs.setString('id', id.toString());
    prefs.setBool('islogin', true);
    prefs.setBool('notification', notification);
    prefs.setBool('card_added', card_added);
    prefs.setString('walletAmount', walletAmount.toString());
    prefs.setString('card_no', cardNo);
    // Navigator.pushNamedAndRemoveUntil(context, "/MenuScreen", (r) => false);

    if (bookingId != "NULL") {
      if (bookingStatus == false) {
        prefs.setString('ride_status', "0");
        prefs.setString('bookingId', "");
        Navigator.pushNamedAndRemoveUntil(context, "/MenuScreen", (r) => false);
      } else if (transactionStatus == true && bookingStatus == true) {
        prefs.setBool('endrideDone', true);
        prefs.setString('ride_status', "2");
        prefs.setBool('forceendride', true);
        Navigator.pushNamedAndRemoveUntil(context, "/MenuScreen", (r) => false);
      } else if (transactionStatus == false && bookingStatus == true) {
        prefs.setString('ride_status', "1");
        Navigator.pushNamedAndRemoveUntil(context, "/RideScreen", (r) => false);
      }
    } else {
      Navigator.pushNamedAndRemoveUntil(context, "/MenuScreen", (r) => false);
    }

    if (Platform.isIOS) {
      await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
    }
  }

  void onFb() {}

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  Country _selectedDialogCountry =
      CountryPickerUtils.getCountryByPhoneCode('971');

  void _openCountryPickerDialog() => showDialog(
        context: context,
        builder: (context) => Theme(
          data: Theme.of(context).copyWith(primaryColor: Colorss.app_color),
          child: CountryPickerDialog(
            titlePadding: EdgeInsets.all(8.0),
            searchCursorColor: Colors.pinkAccent,
            searchInputDecoration: InputDecoration(
                hintText: Signin != null ? Signin.lbl_Search : 'Search...',
                labelStyle: TextStyle(
                    fontSize: SizeConfig.safeBlockHorizontal * Dimens.text_4,
                    fontWeight: FontWeight.w500,
                    color: Colors.black),
                hintStyle: TextStyle(
                    fontSize: SizeConfig.safeBlockHorizontal * Dimens.text_4,
                    fontWeight: FontWeight.w500,
                    color: Colors.black)),
            isSearchable: true,
            title: Text(
                Signin != null ? Signin.ph_mobile : 'Select your phone code',
                style: TextStyle(
                    fontSize: SizeConfig.safeBlockHorizontal * Dimens.text_4,
                    fontWeight: FontWeight.w500,
                    color: Colors.black)),
            onValuePicked: (Country country) => setState(() => {
                  _selectedDialogCountry = country,
                  phonecontryCode = country.phoneCode
                }),
            itemBuilder: _buildDialogItemPicker,
            priorityList: [
              CountryPickerUtils.getCountryByIsoCode('TR'),
              CountryPickerUtils.getCountryByIsoCode('US'),
            ],
          ),
        ),
      );

  Widget _buildDialogItem(Country country) => new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          new Container(
            margin: EdgeInsets.only(top: 12),
            padding: EdgeInsets.only(bottom: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(bottom: BorderSide(color: Colors.grey)),
            ),
            child: Row(
              children: <Widget>[
                CountryPickerUtils.getDefaultFlagImage(country),
                SizedBox(width: 8.0),
                Text("+${country.phoneCode}",
                    style: TextStyle(
                        fontSize:
                            SizeConfig.safeBlockHorizontal * Dimens.text_4,
                        fontWeight: FontWeight.w500,
                        color: Colors.black)),
              ],
            ),
          )
        ],
      );

  Widget _buildDialogItemPicker(Country country) => Row(
        children: <Widget>[
          CountryPickerUtils.getDefaultFlagImage(country),
          SizedBox(width: 8.0),
          Text("+${country.phoneCode}",
              style: TextStyle(
                  fontSize: SizeConfig.safeBlockHorizontal * Dimens.text_4,
                  fontWeight: FontWeight.w500,
                  color: Colors.black)),
          SizedBox(width: 8.0),
          Flexible(
              child: Text(country.name,
                  style: TextStyle(
                      fontSize: SizeConfig.safeBlockHorizontal * Dimens.text_4,
                      fontWeight: FontWeight.w500,
                      color: Colors.black)))
        ],
      );

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

    return Scaffold(
      body: Material(
          color: Colorss.colorll1,
          child: new Stack(
            children: <Widget>[
              !isVerificationmsgSent
                  ? new Container(
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
                              height: SizeConfig.safeBlockVertical * 13,
                              child: new Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: 25, right: 25),
                                        child: Text(
                                          lanRes != null
                                              ? lanRes
                                                  .result.data.Signin.btn_Login
                                              : "Log in",
                                          style: TextStyle(
                                              fontSize: SizeConfig
                                                      .safeBlockHorizontal *
                                                  Dimens.text_7,
                                              fontWeight: FontWeight.w700,
                                              color: Colorss.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                  new Row(
                                    children: <Widget>[
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(25.0)),
                                        ),
                                        margin: EdgeInsets.only(
                                            top: 4, left: 25, right: 25),
                                        height: 6,
                                        width:
                                            SizeConfig.safeBlockHorizontal * 12,
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                          new Container(
                            margin: EdgeInsets.only(
                                top: SizeConfig.safeBlockVertical * 5),
                            height: SizeConfig.safeBlockVertical * 82,
                            width: 600,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(55.0),
                                  bottomLeft: Radius.circular(0.0)),
                            ),
                            child: new Column(
                              children: <Widget>[
                                new Container(
                                  margin: EdgeInsets.only(
                                      top: SizeConfig.safeBlockVertical * 6),
                                  child: Padding(
                                    //Add padding around textfield
                                    padding:
                                        EdgeInsets.only(left: 25, right: 25),
                                    child: new Stack(
                                      children: <Widget>[
                                        new Row(
                                          children: <Widget>[
                                            Expanded(
                                              flex: 2,
                                              child: GestureDetector(
                                                onTap: _openCountryPickerDialog,
                                                child: new Container(
                                                  margin: EdgeInsets.only(
                                                      right: 10),
                                                  child: _buildDialogItem(
                                                      _selectedDialogCountry),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 4,
                                              child: new Container(
                                                margin:
                                                    EdgeInsets.only(left: 10),
                                                child: TextField(
                                                  style: TextStyle(
                                                      fontSize: SizeConfig
                                                              .safeBlockHorizontal *
                                                          Dimens.text_4,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colorss.black),
                                                  keyboardType:
                                                      TextInputType.phone,
                                                  controller:
                                                      _textControllerMobile,
                                                  textInputAction:
                                                      TextInputAction.next,
                                                  cursorColor:
                                                      Colorss.app_color,
                                                  focusNode: _userFocus,
                                                  onSubmitted: (term) {
                                                    _userFocus.unfocus();
                                                  },
                                                  decoration: InputDecoration(
                                                    border:
                                                        UnderlineInputBorder(),

                                                    hintText: lanRes != null
                                                        ? lanRes.result.data
                                                            .Signin.lbl_Mobile
                                                        : Strings.mobile_num,
                                                    fillColor:
                                                        Colors.transparent,
                                                    focusColor: Colors.black54,
                                                    focusedBorder:
                                                        UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          width: 1,
                                                          color: Colorss
                                                              .app_color),
                                                    ),
                                                    enabledBorder:
                                                        UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          width: .5,
                                                          color:
                                                              Colors.black54),
                                                    ),
                                                    labelStyle: TextStyle(
                                                        fontSize: SizeConfig
                                                                .safeBlockHorizontal *
                                                            Dimens.text_4,
                                                        color: Colorss.black),
                                                    hintStyle: TextStyle(
                                                        fontSize: SizeConfig
                                                                .safeBlockHorizontal *
                                                            Dimens.text_4,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colorss.black),

                                                    //add icon outside input field

                                                    //add icon to the beginning of text field
                                                    //prefixIcon: Icon(Icons.person),
                                                    //can also add icon to the end of the textfiled
                                                    //suffixIcon: Icon(Icons.remove_red_eye),
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    validate
                                        ? Padding(
                                            padding: EdgeInsets.only(
                                                top: 4.0, left: 25, right: 25),
                                            child: Text(
                                              errorMsg,
                                              style: TextStyle(
                                                  fontSize: SizeConfig
                                                          .safeBlockHorizontal *
                                                      Dimens.text_3,
                                                  color: Colors.red),
                                            ),
                                          )
                                        : new Container(),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.only(
                                          top: SizeConfig.safeBlockHorizontal *
                                              12,
                                          left: SizeConfig.safeBlockHorizontal *
                                              3),
                                      child: Text(
                                        lanRes != null
                                            ? lanRes
                                                .result.data.Signin.lbl_Message
                                            : "Log in with your phone number",
                                        style: TextStyle(
                                            fontSize:
                                                SizeConfig.safeBlockHorizontal *
                                                    Dimens.text_4,
                                            color: Colorss.black),
                                      ),
                                    ),
                                  ],
                                ),
                                new Container(
                                  width: SizeConfig.safeBlockHorizontal * 70,
                                  margin: EdgeInsets.only(
                                      top: SizeConfig.safeBlockVertical * 16,
                                      bottom: 5),
                                  child: AppButton(
                                      title: lanRes != null
                                          ? lanRes.result.data.Signin.btn_Login
                                          : Strings.sign_in,
                                      onButtonClick: verifyPhoneNumber,
                                      showIcon: false,
                                      fontSize: SizeConfig.safeBlockHorizontal *
                                          Dimens.text_4),
                                ),
                              ],
                            ),
                          )
                        ],
                      ))
                  : new Container(
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
                              height: SizeConfig.safeBlockVertical * 13,
                              child: new Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  new Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        new Padding(
                                          padding: EdgeInsets.only(left: 18),
                                          child: IconButton(
                                            onPressed: () {
                                              setState(() {
                                                isVerificationmsgSent = false;
                                                isTimmer = false;
                                              });
                                            },
                                            icon: Icon(
                                              Icons.arrow_back,
                                              color: Colorss.white,
                                              size: SizeConfig
                                                      .safeBlockHorizontal *
                                                  8.0,
                                              semanticLabel:
                                                  'Text to announce in accessibility modes',
                                            ),
                                          ),
                                        )
                                      ]),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: 1, left: 25, right: 25),
                                        child: Text(
                                          lanRes != null
                                              ? lanRes.result.data.Verification
                                                  .lbl_Verification
                                              : "Verification",
                                          style: TextStyle(
                                              fontSize: SizeConfig
                                                      .safeBlockHorizontal *
                                                  Dimens.text_7,
                                              fontWeight: FontWeight.w700,
                                              color: Colorss.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                          new Container(
                            margin: EdgeInsets.only(
                                top: SizeConfig.safeBlockVertical * 5),
                            height: SizeConfig.safeBlockVertical * 82,
                            width: 600,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(55.0),
                                  bottomLeft: Radius.circular(0.0)),
                            ),
                            child: new Column(
                              children: <Widget>[
                                new Container(
                                  margin: EdgeInsets.only(
                                      top: SizeConfig.safeBlockVertical * 6),
                                  child: Padding(
                                    //Add padding around textfield
                                    padding:
                                        EdgeInsets.only(left: 25, right: 25),
                                    child: new Stack(
                                      children: <Widget>[
                                        new Container(
                                          margin: EdgeInsets.only(
                                              top: 10, right: 15, left: 15),
                                          child: PinCodeTextField(
                                            autofocus: true,
                                            controller: controller,
                                            hideCharacter: false,
                                            highlight: true,
                                            pinBoxWidth: 30.0,
                                            highlightColor: Colors.blueGrey,
                                            defaultBorderColor: Colors.blueGrey,
                                            hasTextBorderColor: Colors.blueGrey,
                                            maxLength: pinLength,
                                            hasError: hasError,
                                            maskCharacter: "*",
                                            onTextChanged: (text) {
                                              setState(() {
                                                hasError = false;
                                                thisTextotp = text;
                                              });
                                            },
                                            onDone: (text) {
                                              print("DONE $text");
                                              setState(() {
                                                thisTextotp = text;
                                              });
                                            },
                                            wrapAlignment: WrapAlignment.start,
                                            pinBoxDecoration:
                                                ProvidedPinBoxDecoration
                                                    .underlinedPinBoxDecoration,
                                            pinTextStyle: TextStyle(
                                              fontSize: 20.0,
                                              color: Colors.blueGrey,
                                            ),
                                            pinTextAnimatedSwitcherTransition:
                                                ProvidedPinBoxTextAnimation
                                                    .scalingTransition,
                                            pinTextAnimatedSwitcherDuration:
                                                Duration(milliseconds: 200),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(top: 5.0),
                                          child: validateEmail
                                              ? Text(
                                                  errorMsg,
                                                  style: TextStyle(
                                                      fontSize: 11,
                                                      color: Colors.red),
                                                )
                                              : null,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    validate
                                        ? Padding(
                                            padding: EdgeInsets.only(
                                                top: 4.0, left: 30, right: 30),
                                            child: Text(
                                              errorMsg,
                                              style: TextStyle(
                                                  fontSize: SizeConfig
                                                          .safeBlockHorizontal *
                                                      Dimens.text_3,
                                                  color: Colors.red),
                                            ),
                                          )
                                        : new Container(),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.only(
                                          top: SizeConfig.safeBlockHorizontal *
                                              4,
                                          left: SizeConfig.safeBlockHorizontal *
                                              3),
                                      child: Text(
                                        "+" + mobileNumber,
                                        style: TextStyle(
                                            letterSpacing: 1,
                                            fontSize:
                                                SizeConfig.safeBlockHorizontal *
                                                    Dimens.text_5,
                                            fontWeight: FontWeight.w500,
                                            color: Colorss.black),
                                      ),
                                    ),
                                  ],
                                ),
                                isTimmer
                                    ? new Container(
                                        padding: EdgeInsets.only(
                                          top: SizeConfig.safeBlockHorizontal *
                                              4,
                                        ),
                                        child: Countdown(
                                          countdownController: timercontroller,
                                          builder: (_, Duration time) {
                                            print("23333>>> " +
                                                time.inSeconds.toString());

                                            return time.inSeconds == 0
                                                ? Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: <Widget>[
                                                      GestureDetector(
                                                        onTap: startTimer,
                                                        child: Padding(
                                                          padding: EdgeInsets.only(
                                                              left: SizeConfig
                                                                      .safeBlockHorizontal *
                                                                  3),
                                                          child: Text(
                                                            lanRes != null
                                                                ? lanRes
                                                                    .result
                                                                    .data
                                                                    .Verification
                                                                    .lbl_NotReceiveSMS
                                                                : "Didn't receive SMS?",
                                                            style: TextStyle(
                                                                fontSize: SizeConfig
                                                                        .safeBlockHorizontal *
                                                                    Dimens
                                                                        .text_4,
                                                                color: Colorss
                                                                    .app_color),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                : Text(
                                                    '${time?.inSeconds ?? 0} seconds',
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color:
                                                            Colorss.app_color),
                                                  );
                                          },
                                        ),
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          GestureDetector(
                                            onTap: startTimer,
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  top: SizeConfig
                                                          .safeBlockHorizontal *
                                                      4,
                                                  left: SizeConfig
                                                          .safeBlockHorizontal *
                                                      3),
                                              child: Text(
                                                lanRes != null
                                                    ? lanRes
                                                        .result
                                                        .data
                                                        .Verification
                                                        .lbl_NotReceiveSMS
                                                    : "Didn't receive SMS?",
                                                style: TextStyle(
                                                    fontSize: SizeConfig
                                                            .safeBlockHorizontal *
                                                        Dimens.text_4,
                                                    color: Colorss.app_color),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                new Container(
                                  width: SizeConfig.safeBlockHorizontal * 70,
                                  margin: EdgeInsets.only(
                                      top: SizeConfig.safeBlockVertical * 14,
                                      bottom: 5),
                                  child: AppButton(
                                      title: lanRes != null
                                          ? lanRes.result.data.Verification
                                              .btn_Continue
                                          : "Continue",
                                      onButtonClick: thisTextotp.length == 6
                                          ? signInWithPhoneNumber
                                          : () {},
                                      showIcon: false,
                                      fontSize: SizeConfig.safeBlockHorizontal *
                                          Dimens.text_4),
                                ),
                              ],
                            ),
                          )
                        ],
                      )),
              new Positioned(
                  child: new Center(
                child: isProgressShow
                    ? CircularProgressIndicator()
                    : new Container(),
              ))
            ],
          )),
    ); // This trailing comma makes auto-formatting nicer for build methods.
  }
}
