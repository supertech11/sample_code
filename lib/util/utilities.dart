import 'dart:async';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:email_validator/email_validator.dart';

import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

import 'package:toast/toast.dart';
import 'package:xplor/util/Dimens.dart';
import 'package:xplor/util/SizeConfig.dart';
import 'package:xplor/util/Strings.dart';

import 'images.dart';

class Utilities {
  bool isNumeric(String str) {
    try {
      var value = double.parse(str);
      return true;
    } on FormatException {
      return false;
    }
  }
  setDate(timeInMillis){
    var date = DateTime.fromMillisecondsSinceEpoch(int.parse(timeInMillis));
    var formattedDate = DateFormat.yMMMd().format(date);
    return formattedDate.toString();
  }
  String meterToKm(value) {
    var kmval="0";
    if(value==null || value==""){
      return kmval;
    }
    try {
      var meter = double.parse(value);
      kmval=(meter/1000).toStringAsFixed(1);

      return kmval;
    } on FormatException {
      return kmval;
    }


  }
  String setFormate(value) {
    if(value==null){
      return "0";
    }
    print(value);
    final formatter = new NumberFormat("#,##,###");

    return "₹" + formatter.format(value) + "/-";
  }
  String setFormate22(value) {
    if(value==null){
      return "0";
    }
    print(value);
    final formatter = new NumberFormat("#,##,###");

    return "" + formatter.format(value) + "/-";
  }
  String setjoinpartFormate(value) {
    if(value==null){
      return "0";
    }
    print(value);
    final formatter = new NumberFormat("#,##,###");

    return "" + formatter.format(value) + "";
  }
   getSpecialFormatewinamount(WinnerList) {
    var value=0.0;
    for(int i=0;i<WinnerList.length;i++){
      if(WinnerList[i].startRank==WinnerList[i].startRank ){
        value=value+ double.parse(  WinnerList[i].winAmount);
      }else{
        var diff= double.parse( WinnerList[i].startRank)==double.parse(WinnerList[i].startRank)+1;
        value=value+ double.parse(WinnerList[i].winAmount)*double.parse(diff.toString());

      }
    }


    if(value==null){
      return "0";
    }
    print(value);
    final formatter = new NumberFormat("#,##,###");

    return value;
  }
  String setSpecialFormate(WinnerList) {
var value=0.0;
    for(int i=0;i<WinnerList.length;i++){
      if(WinnerList[i].startRank==WinnerList[i].startRank ){
        value=value+ double.parse(  WinnerList[i].winAmount);
      }else{
      var diff= double.parse( WinnerList[i].startRank)==double.parse(WinnerList[i].startRank)+1;
      value=value+ double.parse(WinnerList[i].winAmount)*double.parse(diff.toString());

      }
    }


    if(value==null){
      return "0";
    }
    print(value);
    final formatter = new NumberFormat("#,##,###");

    return "₹" + formatter.format(value) + "/-";
  }

  String format(double n) {
    return "₹" + n.toStringAsFixed(n.truncateToDouble() == n ? 0 : 2) + "/-";
  }

  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);
  bool checkEmailValidation(String string) {
    String patttern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regExp = new RegExp(patttern);
    if (new Utilities().isNumeric(string)) {
      if (string.length == 10 && regExp.hasMatch(string)) {
        return true;
      } else {
        return false;
      }
    } else {
      if (EmailValidator.validate(string)) {
        return true;
      } else {
        return false;
      }
    }
  }

// Method to convert the connectivity to a string value
  String getConnectionValue(var connectivityResult) {
    String status = '';
    switch (connectivityResult) {
      case ConnectivityResult.mobile:
        status = 'Mobile';
        break;
      case ConnectivityResult.wifi:
        status = 'Wi-Fi';
        break;
      case ConnectivityResult.none:
        status = 'None';
        break;
      default:
        status = 'None';
        break;
    }
    return status;
  }

  Future<bool> isNetworkConnected(context) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      // I am connected to a mobile network.
      print("I am connected to network");
      return true;
    } else {
      print("I am  not connected to a mobile network");
      showAlertDialog(context, Strings.alert, Strings.network_error, "OK");
      return false;
      // I am connected to a wifi network.
    }
  }

  static Future<bool> checkInternetConnectivity() async {
    bool isConnected;
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        isConnected = true;
      }
    } on SocketException catch (_) {
      isConnected = false;
    }
    return isConnected;
  }

  void showToast(context, String msg, {int duration, int gravity}) {
    Toast.show(msg, context, duration: duration, gravity: gravity);
  }

  void showAlertDialog(context, title, msg, btnName) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(title),
          content: new Text(msg),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(btnName),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),

          ],
        );
      },
    );
  }
  void showWarningDialog(context, title, msg, btnNameok,btnNamecancel,VoidCallback onOkPress) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(title),
          content: new Text(msg),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(btnNamecancel),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text(btnNameok),
              onPressed: onOkPress,
            ),
          ],
        );
      },
    );
  }








}
