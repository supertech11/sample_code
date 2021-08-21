import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xplor/Model/ApiResponce.dart';
import 'package:xplor/Model/LanguageResponce.dart';
import 'package:xplor/Screen/AddScooterImage.dart';
import 'package:xplor/Screen/PaymentURL.dart';
import 'package:xplor/Screen/RideHistory.dart';
import 'package:xplor/util/ApiControler.dart';
import 'package:xplor/util/AppButton.dart';
import 'package:xplor/util/AppHeader.dart';

import 'package:xplor/util/Colorss.dart';
import 'package:xplor/util/Dimens.dart';
import 'package:xplor/util/SizeConfig.dart';
import 'package:xplor/util/Strings.dart';
import 'package:xplor/util/utilities.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:image_picker_gallery_camera/image_picker_gallery_camera.dart';

// import 'package:xplor/widgets/independent/Profile_item.dart';
import 'package:xplor/util/images.dart';

class Profile extends StatefulWidget {
  Profile({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<Profile> {
  final _textName = TextEditingController();
  final _textEmail = TextEditingController();
  final _textMobile = TextEditingController();
  final _textAddress = TextEditingController();
  bool _validateName = false;
  bool _validateEmail = false;
  bool _validateMobile = false;
  bool _validateAddress = false;
  bool _validateImage = false;
  bool isProgressShow = false, cardStatus = false;
  var profile;
  String card_no = "";
  File _image, croppedFile;
  // PickedFile _imageFile;
  dynamic _pickImageError;
  bool isVideo = false;
  var profileUrl, imageurl;
  String _retrieveDataError;
  File file;
  String status = '';
  String base64Image;
  File _imagemg;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    // TODO: implement initState
    // FirebaseCrashlytics.instance.crash();
    super.initState();
    getDataLanguage();
    readProfile();
  }

  @override
  void dispose() {
    _textName.dispose();
    _textMobile.dispose();
    _textEmail.dispose();
    _textAddress.dispose();
    super.dispose();
  }

  var prefs;
  var lanRes, profileLanData;

  getDataLanguage() async {
    prefs = await SharedPreferences.getInstance();
    var data = prefs.getString('languageData');
    Map langMap = jsonDecode(data.toString());
    lanRes = LanguageResponce.parseLanguage(langMap);

    profileLanData = lanRes.result.data.Profile;
    print(lanRes.result.data.Settings.lbl_firstname1);
    setState(() {});
  }

  // void showRideHistory() {
  //   updateProfile();
  //   //validate();
  // }
  Future getImage(ImgSource source, {BuildContext context}) async {
    var image = await ImagePickerGC.pickImage(
      context: context,
      source: source,
      maxHeight: 400,
      maxWidth: 300,
      cameraIcon: Icon(
        Icons.add,
        color: Colors.red,
      ), //cameraIcon and galleryIcon can change. If no icon provided default icon will be present
    );
    try {
      setState(() {
        _imagemg = image;
        List<int> imageBytes = _image.readAsBytesSync();
        base64Image = base64Encode(imageBytes);
        image = base64Image;
        print(base64Image);
      });
    } catch (e) {}
  }

  void _onImageButtonPressed(ImageSource source, {BuildContext context}) async {
    Navigator.pop(context);

    try {
      final pickedFile = await _picker.getImage(
          source: source, maxWidth: 300, maxHeight: 400, imageQuality: 80);
      setState(() {
        // _imageFile = pickedFile;
      });
    } catch (e) {
      setState(() {
        _pickImageError = e;
      });
    }
  }

  _pickImage() async {
    _settingModalBottomSheet(context);
  }

  void _settingModalBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            height: 150,
            color: Color(0xff737373),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(
                        Icons.camera,
                        color: Colorss.app_color,
                      ),
                      title: new Text(
                        profileLanData != null
                            ? profileLanData.lbl_Camera
                            : 'Camera',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize:
                                SizeConfig.blockSizeHorizontal * Dimens.text_4,
                            fontWeight: FontWeight.w500),
                      ),
                      onTap: () => {
                            getImage(ImgSource.Camera),
                            Navigator.of(context).pop()
                            // _onImageButtonPressed(ImageSource.camera,
                            //     context: context)
                          }),
                  new ListTile(
                    leading: new Icon(
                      Icons.photo,
                      color: Colorss.app_color,
                    ),
                    title: new Text(
                      profileLanData != null
                          ? profileLanData.lbl_Gallery
                          : 'Gallery',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize:
                              SizeConfig.blockSizeHorizontal * Dimens.text_4,
                          fontWeight: FontWeight.w500),
                    ),
                    onTap: () => {
                      getImage(ImgSource.Gallery, context: context),
                      Navigator.of(context).pop(),
                      // _onImageButtonPressed(ImageSource.gallery,
                      //     context: context)
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  readProfile() async {
    final prefs = await SharedPreferences.getInstance();
    var profileRes = prefs.getString('profile');
    var url = prefs.getString('url');
    // print('profileRes' + profileRes);
    if (profileRes != null) {
      Map profileMap = jsonDecode(profileRes.toString());
      // print('profileMap' + profileMap.toString());
      profile = ApiResponce.fromlogindataJson(profileMap);
      print('profile >>>>>>>>' + profile.id.toString());
      card_no = prefs.getString('card_no');
      cardStatus = prefs.getBool('card_added') ?? false;
      _textMobile.text = profile.mobile;
      profileUrl = profile.profileImage;
      imageurl = url + "/Xplor/images/";
      print("tosin" + imageurl);
      if (profile.firstName != null && profile.lastName != null) {
        _textName.text = profile.firstName + ' ' + profile.lastName;
      } else {
        _textName.text = profile.firstName;
      }

      _textEmail.text = profile.email;
      _textAddress.text = profile.address;
    }
    // print('profile' + profile);
  }

  updateProfile() async {
    setState(() {
      _textName.text.isEmpty ? _validateName = true : _validateName = false;
      _textEmail.text.isEmpty ? _validateEmail = true : _validateEmail = false;
      _textMobile.text.isEmpty
          ? _validateMobile = true
          : _validateMobile = false;
    });
    if (!_validateName &&
        !_validateMobile &&
        !_validateImage &&
        !_validateEmail) {
      final prefs = await SharedPreferences.getInstance();
      var authToken = prefs.getString('authToken');
      var id = prefs.getString('id');
      setState(() {
        // isProgressShow = true;
      });
      var dio = Dio();
      dio.interceptors.add(LogInterceptor(requestBody: true));

      String base64Image;
      if (_imagemg != null) {
        base64Image = base64Encode(File(_imagemg.path).readAsBytesSync());
      }
      var fName = "", lName = "";
      if (_textName.text.split(' ').length > 1) {
        fName = _textName.text.split(' ')[0];
        lName = _textName.text.split(' ')[1];
      } else {
        fName = _textName.text;
        lName = "";
      }

      new ApiControler()
          .dioAuthPost(context, authToken, Strings.profile_update, {
        "authToken": authToken,
        "id": id,
        "firstName": fName,
        "lastName": lName,
        "email": _textEmail.text,
        "address": _textAddress.text,
        "city": profile.city,
        "state": profile.state,
        "country": profile.country,
        "zip": profile.zip,
        "latitude": 0.0,
        "longitude": profile.longitude,
        "timezoneId": "Asia/India",
        "profileImage": base64Image
      }).then((onValue) {
        parse(onValue);
      });
    }
  }

  var profileData;

  parse(reply) async {
    setState(() {
      //isProgressShow = false;
    });

    if (reply != null) {
      Map userMap = jsonDecode(reply);
      var user = ApiResponce.fromJson(userMap);
      if (user.success) {
        var userdata = ApiResponce.parseProfileResponce(userMap);
        saveData(
            jsonEncode(userdata.result.data),
            userdata.result.data.firebaseId,
            userdata.result.data.authToken,
            userdata.result.data.mobile,
            userdata.result.data.id);
        Navigator.pushNamedAndRemoveUntil(context, "/MenuScreen", (r) => false);
        new Utilities().showToast(context, user.result.message);
      } else {
        new Utilities()
            .showAlertDialog(context, Strings.alert, user.result.message, "OK");
        // print('Howdy, ${user.code} ${user.msg}!');
      }
    }
  }

  saveData(profile, firebaseId, authToken, mobile, id) async {
    final prefs = await SharedPreferences.getInstance();
    // print('profile' + profile);
    prefs.setString('profile', profile);
    prefs.setString('firebaseId', firebaseId);
    prefs.setString('authToken', authToken);
    prefs.setString('mobile', mobile);
    prefs.setString('id', id.toString());
    prefs.setBool('islogin', true);
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

    new ApiControler().dioAuthGet(
        context, authToken, Strings.addcard + "/" + id + "/" + amount, {
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
          prefs.setBool('card_added', true);
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
        .dioAuthPost(context, authToken, Strings.checkcardtransaction, {
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
        var data = ApiResponce.parseSavepayment(userMap);
        prefs.setString('card_no', data.result.data.Transaction.CardNumber);
        prefs.setBool('card_added', true);
        setState(() {
          cardStatus = true;
          card_no = data.result.data.Transaction.CardNumber;
        });
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
      parsewallet(onValue);
    });
  }

  var supportData;

  parsewallet(reply) async {
    setState(() {
      isProgressShow = false;
    });

    if (reply != null) {
      Map userMap = jsonDecode(reply);
      var user = ApiResponce.fromJson(userMap);
      if (user.success) {
        supportData = ApiResponce.parseWallet(userMap);

        prefs.setString(
            'walletAmount',
            supportData != null
                ? supportData.result.walletBalace.toString()
                : "0");
      } else {
        new Utilities()
            .showAlertDialog(context, Strings.alert, user.result.message, "OK");
        // print('Howdy, ${user.code} ${user.msg}!');
      }
    }
  }

  removeCard() async {
    final prefs = await SharedPreferences.getInstance();
    var authToken = prefs.getString('authToken');
    var id = prefs.getString('id');
    setState(() {
      isProgressShow = true;
    });
    var dio = Dio();
    dio.interceptors.add(LogInterceptor(requestBody: true));

    new ApiControler()
        .dioAuthGet(context, authToken, Strings.removecard + "/" + id, {
      "authToken": authToken,
    }).then((onValue) {
      parseDeleteCard(onValue);
    });
  }

  parseDeleteCard(reply) async {
    setState(() {
      isProgressShow = false;
    });

    if (reply != null) {
      Map userMap = jsonDecode(reply);
      var user = ApiResponce.fromJson(userMap);
      if (user.success) {
        prefs.setBool('card_added', false);
        cardStatus = false;
        setState(() {});
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
                      new Stack(
                        children: [
                          new Column(
                            children: [
                              new Container(
                                  child: AppHeader(
                                title: lanRes != null
                                    ? lanRes
                                        .result.data.navigation.lbl_ProfileImage
                                    : 'Profile',
                                onBackClick: () {
                                  Navigator.pop(context);
                                },
                              )),
                              new Container(
                                margin: EdgeInsets.only(
                                    top: SizeConfig.safeBlockVertical * 3),
                                padding: EdgeInsets.only(left: 25, right: 25),
                                width: SizeConfig.safeBlockHorizontal * 100,
                                height: SizeConfig.safeBlockVertical * 100,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(55.0),
                                      bottomLeft: Radius.circular(0.0)),
                                ),
                                child: new Column(
                                  children: <Widget>[
                                    SizedBox(
                                      height: 50.0,
                                    ),
                                    TextField(
                                      controller: _textName,
                                      style: TextStyle(
                                          fontSize:
                                              SizeConfig.safeBlockHorizontal *
                                                  Dimens.text_4,
                                          color: Colorss.black),
                                      keyboardType: TextInputType.name,
                                      // controller: _textControllerName,
                                      textInputAction: TextInputAction.next,
                                      cursorColor: Colorss.app_color,
                                      // focusNode: _userFocus,
                                      // onSubmitted: (term) {
                                      //   _fieldFocusChange(
                                      //       context, _userFocus, _passFocus);
                                      // },
                                      decoration: InputDecoration(
                                        border: UnderlineInputBorder(),
                                        hintText: profileLanData != null
                                            ? profileLanData.lbl_Name
                                            : "Name",
                                        fillColor: Colors.transparent,
                                        focusColor: Colors.black54,
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 1,
                                              color: Colorss.app_color),
                                        ),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              width: .5, color: Colors.black54),
                                        ),
                                        labelStyle: TextStyle(
                                            fontSize:
                                                SizeConfig.safeBlockHorizontal *
                                                    Dimens.text_4,
                                            color: Colorss.black),
                                        hintStyle: TextStyle(
                                            fontSize:
                                                SizeConfig.safeBlockHorizontal *
                                                    Dimens.text_4,
                                            color: Colorss.black),
                                        errorText: _validateName
                                            ? profileLanData != null
                                                ? profileLanData.ph_Enter_Name
                                                : 'Please enter name'
                                            : null,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20.0,
                                    ),
                                    TextField(
                                      controller: _textEmail,
                                      style: TextStyle(
                                          fontSize:
                                              SizeConfig.safeBlockHorizontal *
                                                  Dimens.text_4,
                                          color: Colorss.black),
                                      keyboardType: TextInputType.emailAddress,
                                      // controller: _textControllerName,
                                      textInputAction: TextInputAction.next,
                                      cursorColor: Colorss.app_color,
                                      // focusNode: _userFocus,
                                      // onSubmitted: (term) {
                                      //   _fieldFocusChange(
                                      //       context, _userFocus, _passFocus);
                                      // },
                                      decoration: InputDecoration(
                                        border: UnderlineInputBorder(),
                                        hintText: profileLanData != null
                                            ? profileLanData.lbl_Email
                                            : "E-mail",
                                        fillColor: Colors.transparent,
                                        focusColor: Colors.black54,
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 1,
                                              color: Colorss.app_color),
                                        ),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              width: .5, color: Colors.black54),
                                        ),
                                        labelStyle: TextStyle(
                                            fontSize:
                                                SizeConfig.safeBlockHorizontal *
                                                    Dimens.text_4,
                                            color: Colorss.black),
                                        hintStyle: TextStyle(
                                            fontSize:
                                                SizeConfig.safeBlockHorizontal *
                                                    Dimens.text_4,
                                            color: Colorss.black),
                                        errorText: _validateEmail
                                            ? profileLanData != null
                                                ? profileLanData.ph_Enter_Email
                                                : 'Please enter email'
                                            : null,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20.0,
                                    ),
                                    TextField(
                                      enabled: false,
                                      focusNode: FocusNode(),
                                      enableInteractiveSelection: false,
                                      controller: _textMobile,
                                      style: TextStyle(
                                          fontSize:
                                              SizeConfig.safeBlockHorizontal *
                                                  Dimens.text_4,
                                          color: Colorss.black),
                                      keyboardType: TextInputType.phone,
                                      // controller: _textControllerName,
                                      textInputAction: TextInputAction.next,
                                      cursorColor: Colorss.app_color,
                                      // focusNode: _userFocus,
                                      // onSubmitted: (term) {
                                      //   _fieldFocusChange(
                                      //       context, _userFocus, _passFocus);
                                      // },
                                      decoration: InputDecoration(
                                        border: UnderlineInputBorder(),
                                        hintText: profileLanData != null
                                            ? profileLanData.lbl_Mobile
                                            : "Mobile",
                                        fillColor: Colors.transparent,
                                        focusColor: Colors.black54,
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 1,
                                              color: Colorss.app_color),
                                        ),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              width: .5, color: Colors.black54),
                                        ),
                                        labelStyle: TextStyle(
                                            fontSize:
                                                SizeConfig.safeBlockHorizontal *
                                                    Dimens.text_4,
                                            color: Colorss.black),
                                        hintStyle: TextStyle(
                                            fontSize:
                                                SizeConfig.safeBlockHorizontal *
                                                    Dimens.text_4,
                                            color: Colorss.black),
                                        errorText: _validateMobile
                                            ? profileLanData != null
                                                ? profileLanData.ph_Enter_Mobile
                                                : 'Please enter mobile'
                                            : null,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20.0,
                                    ),
                                    TextField(
                                      controller: _textAddress,
                                      style: TextStyle(
                                          fontSize:
                                              SizeConfig.safeBlockHorizontal *
                                                  Dimens.text_4,
                                          color: Colorss.black),
                                      keyboardType: TextInputType.multiline,
                                      // controller: _textControllerName,
                                      textInputAction: TextInputAction.next,
                                      cursorColor: Colorss.app_color,
                                      // focusNode: _userFocus,
                                      // onSubmitted: (term) {
                                      //   _fieldFocusChange(
                                      //       context, _userFocus, _passFocus);
                                      // },
                                      maxLines: 3,
                                      decoration: InputDecoration(
                                        border: UnderlineInputBorder(),
                                        hintText: profileLanData != null
                                            ? profileLanData.lbl_Address
                                            : "Address",
                                        fillColor: Colors.transparent,
                                        focusColor: Colors.black54,
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 1,
                                              color: Colorss.app_color),
                                        ),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              width: .5, color: Colors.black54),
                                        ),
                                        labelStyle: TextStyle(
                                            fontSize:
                                                SizeConfig.safeBlockHorizontal *
                                                    Dimens.text_4,
                                            color: Colorss.black),
                                        hintStyle: TextStyle(
                                            fontSize:
                                                SizeConfig.safeBlockHorizontal *
                                                    Dimens.text_4,
                                            color: Colorss.black),
                                        errorText: _validateAddress
                                            ? profileLanData != null
                                                ? profileLanData
                                                    .ph_Enter_Address
                                                : 'Please enter address'
                                            : null,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20.0,
                                    ),
                                    !cardStatus
                                        ? new Row(
                                            children: <Widget>[
                                              new GestureDetector(
                                                onTap: () {
                                                  print("jkgfshd");

                                                  addwalletbalance("1");
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.transparent,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                10.0)),
                                                    border: Border.all(
                                                        color: Colorss.black,
                                                        width: 3),
                                                  ),
                                                  margin:
                                                      EdgeInsets.only(top: 1),
                                                  child: new Padding(
                                                    padding: EdgeInsets.all(10),
                                                    child: Text(
                                                      "Add Card",
                                                      style: TextStyle(
                                                          color: Colorss.black,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: SizeConfig
                                                                  .safeBlockHorizontal *
                                                              Dimens.text_4_5),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                        : new ListTile(
                                            title: new Text("" + card_no,
                                                style: TextStyle(
                                                    fontSize: SizeConfig
                                                            .safeBlockHorizontal *
                                                        Dimens.text_4,
                                                    color: Colorss.black)),
                                            trailing: new GestureDetector(
                                              onTap: () {
                                                print("jkgfshd");

                                                removeCard();
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.transparent,
                                                  border: Border(
                                                    bottom: BorderSide(
                                                        width: 2.0,
                                                        color: Colors.black),
                                                  ),
                                                ),
                                                margin: EdgeInsets.only(top: 1),
                                                child: new Padding(
                                                  padding:
                                                      EdgeInsets.only(top: 10),
                                                  child: Text(
                                                    "Remove",
                                                    style: TextStyle(
                                                        color: Colorss.black,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: SizeConfig
                                                                .safeBlockHorizontal *
                                                            Dimens.text_4),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                    SizedBox(
                                      height: 20.0,
                                    ),
                                    new Container(
                                      width:
                                          SizeConfig.safeBlockHorizontal * 70,
                                      margin: EdgeInsets.only(
                                          top: SizeConfig.safeBlockVertical * 0,
                                          bottom: 5),
                                      child: AppButton(
                                          title: profileLanData != null
                                              ? profileLanData.btn_Update
                                              : "Update",
                                          onButtonClick: updateProfile,
                                          showIcon: false,
                                          fontSize:
                                              SizeConfig.safeBlockHorizontal *
                                                  Dimens.text_5),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                          new Positioned(
                            top: SizeConfig.safeBlockVertical * 8,
                            left: 0,
                            right: 0,
                            child: GestureDetector(
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
                                    child: _imagemg != null
                                        ? new Container(
                                            width: 90,
                                            height: 90,
                                            decoration: BoxDecoration(
                                                color: Colors.black87,
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                                image: new DecorationImage(
                                                    fit: BoxFit.fill,
                                                    image: MemoryImage(_imagemg
                                                        .readAsBytesSync()))),
                                          )
                                        : profileUrl != null && profileUrl != ""
                                            ? new Container(
                                                width: 90,
                                                height: 90,
                                                decoration: BoxDecoration(
                                                    color: Colors.transparent,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50),
                                                    image: new DecorationImage(
                                                        fit: BoxFit.fill,
                                                        image: NetworkImage(
                                                            // Strings.profile_image_url
                                                            imageurl +
                                                                profileUrl))),
                                              )
                                            : Image.asset(
                                                Images.user,
                                                height: 90,
                                                width: 90,
                                                fit: BoxFit.fill,
                                              ),
                                  ),
                                  if (_validateImage)
                                    Text(
                                      'Please select profile image',
                                      style: TextStyle(
                                          color: Colors.redAccent,
                                          fontSize: 10),
                                    )
                                ],
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  )),
              if (isProgressShow)
                new Positioned(
                    child: new Center(child: CircularProgressIndicator())),
            ],
          ),
        ),
      ),
    ); // This trailing comma makes auto-formatting nicer for build methods.
  }
}
