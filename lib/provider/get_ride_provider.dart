import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xplor/Model/LanguageResponce.dart';

class RideScrotter with ChangeNotifier {
  String message, image;
  bool status;
  double walletBalace;
  bool transactionstatus;
  bool bookingStatus;

  Future<void> getUserScotterBalance(bookingId) async {
    final prefs = await SharedPreferences.getInstance();
    var datavalue = prefs.getString('url');
    var authToken = prefs.getString('authToken');
    print("*********???????///////" + authToken);
    try {
      final response = await http.get(
        datavalue + "/Xplor/api/user/checkiInformationiInRiding/$bookingId",
        headers: {"content-type": "application/json", "AUTHTOKEN": authToken},
      );

      var resData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        message = resData['result']['message'];
        status = resData['success'];
      }
      print("Wallt///" + resData.toString());
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> getWalletBalance() async {
    final prefs = await SharedPreferences.getInstance();
    var datavalue = prefs.getString('url');
    print("@@@@@@@@"+datavalue);
    var authToken = prefs.getString('authToken');
    var id = prefs.getString('id');
    print("*********???????///////" + authToken);
    try {
      // "http://172.104.34.79:8080/Xplor/api/user/profile/checkbalance/$id",
      final response = await http.get(
        datavalue + "/Xplor/api/user/profile/checkbalance/$id",
        headers: {"content-type": "application/json", "AUTHTOKEN": authToken},
      );

      var resData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        walletBalace = resData['result']['walletBalace'];
      }
      print("Ride detail///" + resData.toString());
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> getRideDetail(rideId) async {
    final prefs = await SharedPreferences.getInstance();
    var datavalue = prefs.getString('url');
    var authToken = prefs.getString('authToken');
    print("******" + rideId);
    // var id = prefs.getString('id');
    print("*********???????///////" + authToken);
    print("http://172.104.34.79:8080/Xplor/api/user/booking/$rideId");
    try {
      // "http://172.104.34.79:8080/Xplor/api/user/profile/checkbalance/$id",
      final response = await http.get(
        datavalue + "/Xplor/api/user/booking/$rideId",
        headers: {"content-type": "application/json", "AUTHTOKEN": authToken},
      );

      var resData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        bookingStatus = resData['result']['data']['bookingStatus'];
        transactionstatus =
            resData['result']['data']['paymentId']['transactionStatus'];
        image = resData['result']['data']['images'];
      }
      print("Wallt///" + resData.toString());
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }
}
