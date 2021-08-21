import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xplor/Model/ApiResponce.dart';
import 'package:xplor/Model/LanguageResponce.dart';
import 'package:xplor/Screen/PaymentSummary.dart';
import 'package:xplor/Screen/PaymentURL.dart';
import 'package:xplor/provider/get_ride_provider.dart';
import 'package:xplor/util/AddScooterHeader.dart';
import 'package:xplor/util/ApiControler.dart';
import 'package:xplor/util/AppButton.dart';

import 'package:xplor/util/Colorss.dart';
import 'package:xplor/util/Dimens.dart';
import 'package:xplor/util/SizeConfig.dart';
import 'package:xplor/util/Strings.dart';
import 'package:xplor/util/utilities.dart';

// import 'package:xplor/widgets/independent/Profile_item.dart';
import 'package:xplor/util/images.dart';

class AddScooterImage extends StatefulWidget {
  AddScooterImage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _AddScooterImagePageState createState() => _AddScooterImagePageState();
}

class _AddScooterImagePageState extends State<AddScooterImage> {
  bool _validateImage = false;
  var profile;
  File _image, croppedFile;
  PickedFile _imageFile;
  dynamic _pickImageError;
  bool isVideo = false, isProgressShow = false;
  final ImagePicker _picker = ImagePicker();
  TextEditingController _textControllercoupon = TextEditingController();
  bool _isCheckedCoupon = false;
  final FocusNode _couponFocus = FocusNode();
  String image, imageurl;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDataLanguage();
    readProfile();
  }

  @override
  void dispose() {
    super.dispose();
  }

  var prefs;
  var lanRes, ride_scooter_image_screen, profileLanData, languagePayment;

  getDataLanguage() async {
    prefs = await SharedPreferences.getInstance();
    var data = prefs.getString('languageData');
    Map langMap = jsonDecode(data.toString());
    lanRes = LanguageResponce.parseLanguage(langMap);
    ride_scooter_image_screen = lanRes.result.data.ride_scooter_image_screen;
    languagePayment = lanRes.result.data.Payments;
    profileLanData = lanRes.result.data.Profile;
    print(lanRes.result.data.Settings.lbl_firstname1);
    setState(() {
      image = prefs.getString('imageupload').toString();
      print("back end image" + image);
    });
    // stopRide();
    if (image != null.toString() && prefs.getBool('endrideDone') == true) {
      print(")))))" + image);
      Fluttertoast.showToast(
          msg: 'Your ride successfully Ended',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0);
      apiSavePayment(image);
    } else if (prefs.getBool('endrideDone') != true) {
      stopRide();
    }
  }

  void _onImageButtonPressed(ImageSource source, {BuildContext context}) async {
    try {
      final pickedFile = await _picker.getImage(
          source: source, maxWidth: 200, maxHeight: 200, imageQuality: 60);
      setState(() {
        _imageFile = pickedFile;
      });
    } catch (e) {
      setState(() {
        _pickImageError = e;
      });
    }
  }

  _pickImage() async {
    _onImageButtonPressed(ImageSource.camera, context: context);
  }

  readProfile() async {
    prefs = await SharedPreferences.getInstance();
    var profileRes = prefs.getString('profile');
    var url = prefs.getString('url');
    // print('profileRes' + profileRes);
    imageurl = url + "/Xplor/images/";
    if (profileRes != null) {
      Map profileMap = jsonDecode(profileRes.toString());
      // print('profileMap' + profileMap.toString());
      profile = ApiResponce.fromlogindataJson(profileMap);
    }
    // print('profile' + profile);
  }

  uploadscooterimages() async {
    String base64Image;
    if (_imageFile != null) {
      _validateImage = false;
      base64Image = base64Encode(File(_imageFile.path).readAsBytesSync());
    } else {
      setState(() {
        _validateImage = true;
      });
    }
    if (base64Image != null) {
      final prefs = await SharedPreferences.getInstance();
      var authToken = prefs.getString('authToken');
      var id = prefs.getString('bookingId');
      var forceendride = prefs.getBool('forceendride');
      setState(() {
        isProgressShow = true;
      });
      apiSavePayment(base64Image);
    } else {
      new Utilities().showToast(
          context,
          ride_scooter_image_screen != null
              ? ride_scooter_image_screen.lbl_Select_Image
              : 'Please select scooter image');
    }
  }

  parse(reply) async {
    setState(() {
      isProgressShow = false;
    });

    if (reply != null) {
      Map userMap = jsonDecode(reply);
      var user = ApiResponce.fromJson(userMap);
      if (user.success) {
        if (rideData != null) {
          // apiSavePayment();
        } else {
          prefs.setString('ride_status', "0");
          prefs.setString('bookingId', "");

          Navigator.pushNamedAndRemoveUntil(
              context, "/MenuScreen", (r) => false);
        }
        new Utilities().showToast(context, user.result.message);
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            // return object of type Dialog
            return AlertDialog(
              title: new Text(Strings.alert),
              content: new Text(user.result.message),
              actions: <Widget>[
                // usually buttons at the bottom of the dialog
                new FlatButton(
                  child: new Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
        // new Utilities()
        //     .showAlertDialog(context, Strings.alert, user.result.message, "OK");
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
                          child: AddScooterHeader(
                        title: "",
                        onBackClick: () {
                          Navigator.pop(context);
                        },
                      )),
                      new Container(
                        margin: EdgeInsets.only(top: 0),
                        padding: EdgeInsets.only(left: 35, right: 35),
                        width: SizeConfig.safeBlockHorizontal * 100,
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(top: 1),
                              child: new Padding(
                                padding: EdgeInsets.all(0),
                                child: Text(
                                  ride_scooter_image_screen != null
                                      ? ride_scooter_image_screen.lbl_Thank_You
                                      : "Thank You",
                                  style: TextStyle(
                                      color: Colorss.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: SizeConfig.safeBlockHorizontal *
                                          Dimens.text_6),
                                ),
                              ),
                            ),
                            profile != null && profile.firstName != null
                                ? Container(
                                    margin: EdgeInsets.only(top: 1),
                                    child: new Padding(
                                      padding: EdgeInsets.all(0),
                                      child: Text(
                                        profile != null
                                            ? profile.firstName
                                            : "",
                                        style: TextStyle(
                                            color: Colorss.white,
                                            fontWeight: FontWeight.w700,
                                            fontSize:
                                                SizeConfig.safeBlockHorizontal *
                                                    Dimens.text_6),
                                      ),
                                    ),
                                  )
                                : new Container(),
                            SizedBox(
                              height: 10.0,
                            ),

                            Container(
                              margin: EdgeInsets.only(top: 1),
                              child: new Padding(
                                padding: EdgeInsets.all(0),
                                child: Text(
                                  ride_scooter_image_screen != null
                                      ? ride_scooter_image_screen.lbl_Hope
                                      : "We hope you had a great ride!",
                                  style: TextStyle(
                                      color: Colorss.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: SizeConfig.safeBlockHorizontal *
                                          Dimens.text_5),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 50),
                              child: new Padding(
                                padding: EdgeInsets.all(0),
                                child: Text(
                                  ride_scooter_image_screen != null
                                      ? ride_scooter_image_screen
                                          .lbl_Add_Scooter_Image
                                      : "Add scooter image",
                                  style: TextStyle(
                                      color: Colorss.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: SizeConfig.safeBlockHorizontal *
                                          Dimens.text_4_5),
                                ),
                              ),
                            ),

                            GestureDetector(
                              onTap: () {
                                try {
                                  _pickImage();
                                } catch (e) {
                                  FirebaseCrashlytics.instance
                                      .log(e.toString());
                                }
                              },
                              child: new Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    margin: EdgeInsets.all(15),
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      border: Border.all(
                                        color: Colors.white,
                                        //                   <--- border color
                                        width: 4.0,
                                      ),
                                    ),
                                    child: image.toString() != null.toString()
                                        ? new Container(
                                            width: 100,
                                            height: 100,
                                            decoration: BoxDecoration(
                                                color: Colors.black87,
                                                image: new DecorationImage(
                                                    fit: BoxFit.fill,
                                                    image: NetworkImage(
                                                        "$imageurl$image"))))
                                        : _imageFile != null
                                            ? new Container(
                                                width: 100,
                                                height: 100,
                                                decoration: BoxDecoration(
                                                    color: Colors.black87,
                                                    image: new DecorationImage(
                                                        fit: BoxFit.fill,
                                                        image: FileImage(File(
                                                            _imageFile.path)))),
                                              )
                                            : Image.asset(
                                                Images.Square,
                                                height: 100,
                                                width: 100,
                                                fit: BoxFit.fill,
                                              ),
                                  ),
                                  if (_validateImage)
                                    Text(
                                      ride_scooter_image_screen != null
                                          ? ride_scooter_image_screen
                                              .lbl_Select_Image
                                          : 'Please select scooter image',
                                      style: TextStyle(
                                          color: Colors.redAccent,
                                          fontSize: 10),
                                    )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 0, right: 0),
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
                                                    color: Colorss.white),
                                                keyboardType:
                                                    TextInputType.text,
                                                // controller: _textControllerName,
                                                textInputAction:
                                                    TextInputAction.done,
                                                cursorColor: Colorss.app_color,
                                                onSubmitted: (couponCode) {
                                                  _couponFocus.unfocus();
                                                },
                                                decoration: InputDecoration(
                                                  disabledBorder:
                                                      UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                        width: 0.0,
                                                        color:
                                                            Colors.transparent),
                                                  ),
                                                  border: UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                        width: 0.0,
                                                        color:
                                                            Colors.transparent),
                                                  ),
                                                  hintText:
                                                      languagePayment != null
                                                          ? languagePayment
                                                              .lbl_Coupon_Code
                                                          : "Coupon Code",
                                                  fillColor: Colors.transparent,
                                                  // focusColor: Colors.black54,
                                                  focusedBorder:
                                                      UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                        width: 0.0,
                                                        color:
                                                            Colors.transparent),
                                                  ),
                                                  enabledBorder:
                                                      UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                        width: 0.0,
                                                        color:
                                                            Colors.transparent),
                                                  ),
                                                  labelStyle: TextStyle(
                                                      fontSize: SizeConfig
                                                              .safeBlockHorizontal *
                                                          Dimens.text_4,
                                                      color: Colorss.white),
                                                  hintStyle: TextStyle(
                                                      fontSize: SizeConfig
                                                              .safeBlockHorizontal *
                                                          Dimens.text_4,
                                                      color:
                                                          Colorss.grey_color),
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
                                              new Row(
                                                children: [
                                                  new Container(
                                                    child: IconButton(
                                                      icon: _isCheckedCoupon
                                                          ? Icon(
                                                              Icons.check_box,
                                                              color: Colorss
                                                                  .app_color,
                                                              size: 30,
                                                            )
                                                          : Icon(
                                                              Icons
                                                                  .check_box_outline_blank,
                                                              color:
                                                                  Colorss.white,
                                                              size: 30,
                                                            ),
                                                      onPressed: () {
                                                        setState(() {
                                                          _isCheckedCoupon =
                                                              !_isCheckedCoupon;
                                                        });
                                                        if (_isCheckedCoupon) {
                                                          couponCode =
                                                              _textControllercoupon
                                                                  .text;
                                                        } else {
                                                          _textControllercoupon
                                                              .text = "";
                                                          couponCode = "";
                                                        }
                                                      },
                                                    ),
                                                  )
                                                ],
                                              )
                                            ],
                                          ))
                                    ],
                                  )),
                            ),
                            Divider(
                              color: Colors.white54,
                              thickness: .5,
                            ),

                            SizedBox(
                              height: 15.0,
                            ),
//                            new Row(
//                              children: [
//                                Expanded(
//                                  child: Text(
//                                    languagePayment != null
//                                        ? languagePayment.lbl_Total
//                                        : "Total",
//                                    style: TextStyle(
//                                        color: Colorss.white,
//                                        fontSize: 16,
//                                        fontWeight: FontWeight.w500),
//                                  ),
//                                ),
//                                Expanded(
//                                  child: new Row(
//                                    mainAxisAlignment:
//                                    MainAxisAlignment.end,
//                                    children: [
//                                      Text(
//                                        total != null
//                                            ? double.parse(total)
//                                            .toStringAsFixed(
//                                            2) +
//                                            Strings.app_currncy
//                                            : '0' + Strings.app_currncy,
//                                        style: TextStyle(
//                                          color: Colorss.white,
//                                          fontWeight: FontWeight.w600,
//                                          fontSize: 16,
//                                        ),
//                                      )
//                                    ],
//                                  ),
//                                )
//                              ],
//                            ),
//                            SizedBox(
//                              height: 8.0,
//                            ),
//                            Divider(
//                              color: Colors.white54,
//                              thickness: .5,
//                            ),
                            SizedBox(
                              height: 40.0,
                            ),
                            new Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                new Container(
                                  width: SizeConfig.safeBlockHorizontal * 70,
                                  margin: EdgeInsets.only(
                                      top: SizeConfig.safeBlockVertical * 0,
                                      bottom: 5),
                                  child: AppButton(
                                      title: languagePayment != null
                                          ? languagePayment.lbl_Complete_Ride
                                          : "Complete Ride",
                                      onButtonClick: uploadscooterimages,
                                      showIcon: false,
                                      fontSize: SizeConfig.safeBlockHorizontal *
                                          Dimens.text_5),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  )),
              if (isProgressShow)
                new Positioned(
                    child: new Center(
                        child: CircularProgressIndicator(
                  backgroundColor: Colorss.app_color,
                ))),
            ],
          ),
        ),
      ),
    ); // This trailing comma makes auto-formatting nicer for build methods.
  }

  var rideData, paymentdata, terrifData;
  String totalDiscount = "0",
      totalCharge = "",
      baseFare = "",
      totalMin = "",
      afterDiscountPrice = "",
      totalwallet = "0",
      total = "0",
      couponCode = "",
      totalrideEstimate = "0";
  var walletData;

  stopRide() async {
    var authToken = prefs.getString('authToken');
    var bookingId = prefs.getString('bookingId');
    var forceendride = prefs.getBool('forceendride');
    var fareAmount = prefs.getDouble('fareAmount');
    var minutes = prefs.getInt('minutes');
    var tax = fareAmount * 0.05;
    var total = fareAmount + tax;
    print(bookingId);
    print(forceendride);
    print("fareAmount --- " + fareAmount.toString());
    print("tax ==" + tax.toString());
    print("total __==" + total.toString());
    print('minutes  === ' + minutes.toString());
    setState(() {
      isProgressShow = true;
    });
    var dio = Dio();
    dio.interceptors.add(LogInterceptor(requestBody: true));

    new ApiControler().dioAuthPost(context, authToken, Strings.stopRide, {
      "bookingId": bookingId,
      "totalRideTime": minutes,
      "forceendride": false,
      "paymentId": {"fareAmount": fareAmount, "tax": tax, "totalAmount": total}
      // "authToken": authToken,
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
        // prefs.setString('ride_status', "3");

        var data = ApiResponce.parseStopRide(userMap);
        rideData = data.result.rideDetails;
        paymentdata = data.result.rideDetails.paymentIdData;
        terrifData = data.result.rideDetails.scooterIddata.tarrifIdata;
        print("iotDeviceId>>  " +
            data.result.rideDetails.iotDeviceId.toUpperCase());
        print('ride ended');
        prefs.setBool('endrideDone', true);
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

  apiSavePayment(imagevalue) async {
    var authToken = prefs.getString('authToken');
    var bookingId = prefs.getString('bookingId');
    // var forceendride = prefs.getBool('forceendride');
    setState(() {
      isProgressShow = true;
    });
    var dio = Dio();
    dio.interceptors.add(LogInterceptor(requestBody: true));
    print(image);

    new ApiControler().dioAuthPost(context, authToken, Strings.savePayment, {
      "bookingId": bookingId,
      "couponCode": couponCode,
      "images": imagevalue,
    }).then((onValue) {
      parseSavePayment(onValue);
    });
  }

  parseSavePayment(reply) async {
    setState(() {
      isProgressShow = false;
      prefs.setBool('endrideDone', false);
    });

    if (reply != null) {
      Map userMap = jsonDecode(reply);
      var user = ApiResponce.fromJson(userMap);
      if (user.success) {
        var data = ApiResponce.parseWalletpayment(userMap);

        if (data.result != null && data.result.paymentstatus == "1") {
          new Utilities().showToast(
            context,
            user.result.message,
          );
          goToSummary();
          //showSuccesPaymentDialog(context, Strings.alert, user.result.message);
        } else {
          var data = ApiResponce.parseSavepayment(userMap);
          var PaymentPortal = data.result.data.Transaction.PaymentPortal;
          var TransactionIDs = data.result.data.Transaction.TransactionID;
          var CallBackUrl = data.result.data.Transaction.CallBackUrl;

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
          ).then((onValue) => {apiCompletePayment(TransactionIDs)});
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
        goToSummary();

        new Utilities().showToast(
          context,
          user.result.message,
        );

        // showSuccesPaymentDialog(context, Strings.alert, user.result.message);
      } else {
        new Utilities()
            .showAlertDialog(context, Strings.alert, user.result.message, "OK");
        // print('Howdy, ${user.code} ${user.msg}!');
      }
    }
  }

  goToSummary() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => PaymentSummary()),
    );
  }
}
