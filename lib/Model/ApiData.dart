import 'package:json_annotation/json_annotation.dart';
import 'package:xplor/Model/ApiResponce.dart';
import 'package:xplor/Model/Data.dart';

import 'LanguageResponce.dart';
import 'UserData.dart';

@JsonSerializable()
class ApiData {
  Map<String, dynamic> booking;
  ApiResponce data,
      support,
      profile,
      scoterDetails,
      rideDetails,
      paymentTransaction;
  String walletBalace,
      message,
      Duration,
      Amount,
      Distance,
      paymentstatus,
      walletid,
      power;
  List<Data> datalist;

  List<ApiResponce> geofenceList;

  Data tarrifIdata;

  ApiData(
      {this.booking,
      this.data,
      this.power,
      this.walletBalace,
      this.message,
      this.support,
      this.datalist,
      this.profile,
      this.walletid,
      this.Duration,
      this.Amount,
      this.Distance,
      this.scoterDetails,
      this.rideDetails,
      this.paymentTransaction,
      this.tarrifIdata,
      this.paymentstatus,
      this.geofenceList});

  factory ApiData.fromJsonWallet(Map<String, dynamic> json) {
    return ApiData(
      walletBalace: json['walletBalace'].toString(),
      message: json['message'],
    );
  }

  factory ApiData.fromJsonMystatistic(Map<String, dynamic> json) {
    return ApiData(
      Duration: json['Duration'].toString(),
      Amount: json['Amount'].toString(),
      Distance: json['Distance'].toString(),
      message: json['message'],
    );
  }

//  "Amount": 0.0,
//  "Duration": 23,
//  "message": " Fetch Successfully",
//  "Distance": 17.0

  factory ApiData.fromJsonProfile(Map<String, dynamic> json) {
    return ApiData(
      profile: ApiResponce.fromProfileJson(json["profile"]),
    );
  }

  factory ApiData.fromloginJson(Map<String, dynamic> json) {
    return ApiData(
      data: ApiResponce.fromlogindataJson(json["data"]),
    );
  }

  factory ApiData.fromProfileJson(Map<String, dynamic> json) {
    return ApiData(
      data: ApiResponce.fromlogindataJson(json["profile"]),
    );
  }

  factory ApiData.fromSupportJson(Map<String, dynamic> json) {
    return ApiData(
      support: ApiResponce.fromSupportdataJson(json["support"]),
    );
  }

  factory ApiData.fromRideDetailsJson(Map<String, dynamic> json) {
    return ApiData(
      data: ApiResponce.fromRideDetailsJson(json["data"]),
    );
  }

  factory ApiData.fromPrivacyPolicyTermsJson(Map<String, dynamic> json) {
    return ApiData(
      data: ApiResponce.fromPrivacyPolicyTermsdataJson(json["data"]),
    );
  }

  factory ApiData.fromMyRideHistoryJson(Map<String, dynamic> json) {
    return ApiData(
      datalist: parseRideHistoryList(json),
    );
  }

  factory ApiData.fromMyNotificationJson(Map<String, dynamic> json) {
    return ApiData(
      datalist: parseNotificationList(json),
    );
  }

  factory ApiData.fromNearbylocationsJson(Map<String, dynamic> json) {
    return ApiData(
      datalist: parseNearbylocationsList(json),
    );
  }

  factory ApiData.fromgeofenceJson(Map<String, dynamic> json) {
    return ApiData(
      geofenceList: parsegeofenceList(json),
    );
  }

  factory ApiData.fromStartRideJson(Map<String, dynamic> json) {
    return ApiData(
      rideDetails: ApiResponce.fromStartRideJson(json["data"]),
    );
  }

  factory ApiData.ScooterfromJson(Map<String, dynamic> json) {
    return ApiData(
      tarrifIdata: Data.TerrifListfromJson(json["tarrifId"]),
    );
  }

  factory ApiData.ScooterfrompowerJson(Map<String, dynamic> json) {
    return ApiData(
      power: json['power'].toString(),
    );
  }

  factory ApiData.fromStopRideJson(Map<String, dynamic> json) {
    return ApiData(
      rideDetails: ApiResponce.fromStopRideJson(json["data"]),
    );
  }

  factory ApiData.fromSavepaymentJson(Map<String, dynamic> json) {
    return ApiData(
      paymentstatus: json['paymentstatus'].toString(),
      data: ApiResponce.parseSavePaymentResponce(json["data"]),
      walletid: json['walletid'].toString(),
    );
  }
  factory ApiData.fromWalletpaymentJson(Map<String, dynamic> json) {
    return ApiData(
      paymentstatus: json['paymentstatus'].toString(),
      walletid: json['walletid'].toString(),
    );
  }
  factory ApiData.fromSaveWalletpaymentJson(Map<String, dynamic> json) {
    return ApiData(
      paymentstatus: json['paymentstatus'].toString(),
      data: ApiResponce.parseSavePaymentResponce(json["data"]),
    );
  }

  factory ApiData.fromTerrifsJson(Map<String, dynamic> json) {
    return ApiData(
      scoterDetails: ApiResponce.fromScoterdetailsJson(json["data"]),
    );
  }

  factory ApiData.fromOfferJson(Map<String, dynamic> json) {
    return ApiData(
      datalist: parseOfferList(json),
    );
  }

  factory ApiData.frommessageJson(Map<String, dynamic> json) {
    return ApiData(
      message: json['message'],
    );
  }

  static List<Data> parseRideHistoryList(contestJson) {
    var list = contestJson['data'] as List;
    List<Data> contestList =
        list.map((data) => Data.rideHistoryListfromJson(data)).toList();
    return contestList;
  }

  static List<Data> parseNotificationList(contestJson) {
    var list = contestJson['data'] as List;
    List<Data> contestList =
        list.map((data) => Data.notificationListfromJson(data)).toList();
    return contestList;
  }

  static List<ApiResponce> parsegeofenceList(contestJson) {
    var list = contestJson['data'] as List;
    List<ApiResponce> contestList =
        list.map((data) => ApiResponce.fromgeofencingIddataJson(data)).toList();
    return contestList;
  }

  static List<Data> parseNearbylocationsList(contestJson) {
    var list = contestJson['data'] as List;
    List<Data> contestList =
        list.map((data) => Data.nearbylocationsListfromJson(data)).toList();
    return contestList;
  }

  static List<Data> parseTerrifList(contestJson) {
    var list = contestJson['data'] as List;
    List<Data> contestList =
        list.map((data) => Data.TerrifListfromJson(data)).toList();
    return contestList;
  }

  static List<Data> parseOfferList(contestJson) {
    var list = contestJson['data'] as List;
    List<Data> contestList =
        list.map((data) => Data.OfferListfromJson(data)).toList();
    return contestList;
  }
}
