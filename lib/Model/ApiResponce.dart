import 'package:json_annotation/json_annotation.dart';
import 'package:xplor/Model/ApiData.dart';

import 'package:xplor/Model/Data.dart';
import 'package:xplor/Model/Data.dart';
import 'package:xplor/Model/LanguageData.dart';

@JsonSerializable(explicitToJson: true)
class ApiResponce {
  int statuscode, id;
  Map<String, dynamic> booking;
  ApiData result;
  Data appoffer;
  String message,
      cardNo,
      mobile,
      authToken,
      Latitude,
      Longitude,
      firebaseId,
      contactNo,
      openTime,
      closedTime,
      name,
      email,
      description,
      firstName,
      lastName,
      address,
      city,
      state,
      country,
      zip,
      profileImage,
      drivingLicense,
      licenseImage,
      timezoneId,
      qrCode,
      iotDeviceId,
      bookingId,
      PaymentPortal,
      PaymentPage,
      TransactionID,
      ResponseDescription,
      CallBackUrl,
      CardNumber,
      distance,
      totalAvailableScooter,
      deviceId,
      scooterId,
      registrationNo,
      imei,
      totalRideTime,
      totalDistance,
      totalCharges,
      tax,
      walletAmount,
      advanceAmount,
      discountPrice,
      fareAmount,
      totalPaymentAmount;

  bool notification, card_added;
  double latitude, longitude;
  ApiData scooterIddata;
  bool success;
  Data tarrifId, paymentIdData;
  ApiResponce Transaction;
  List<Data> cordinateList;

  ApiResponce({
    this.booking,
    this.result,
    this.tarrifId,
    this.paymentIdData,
    this.cordinateList,
    this.scooterIddata,
    this.appoffer,
    this.Transaction,
    this.message,
    this.notification,
    this.Latitude,
    this.PaymentPortal,
    this.PaymentPage,
    this.TransactionID,
    this.ResponseDescription,
    this.Longitude,
    this.distance,
    this.tax,
    this.totalAvailableScooter,
    this.CallBackUrl,
    this.success,
    this.cardNo,
    this.CardNumber,
    this.statuscode,
    this.card_added,
    this.mobile,
    this.authToken,
    this.firebaseId,
    this.id,
    this.contactNo,
    this.openTime,
    this.closedTime,
    this.name,
    this.email,
    this.description,
    this.firstName,
    this.lastName,
    this.longitude,
    this.address,
    this.state,
    this.city,
    this.country,
    this.latitude,
    this.drivingLicense,
    this.profileImage,
    this.zip,
    this.licenseImage,
    this.walletAmount,
    this.timezoneId,
    this.deviceId,
    this.scooterId,
    this.registrationNo,
    this.imei,
    this.qrCode,
    this.iotDeviceId,
    this.bookingId,
    this.totalRideTime,
    this.totalDistance,
    this.totalCharges,
    this.advanceAmount,
    this.discountPrice,
    this.fareAmount,
    this.totalPaymentAmount,
  });

  List<Data> datalist;

  factory ApiResponce.parseWallet(Map<String, dynamic> json) {
    return ApiResponce(
      success: json['success'],
      statuscode: json['statuscode'],
      result: ApiData.fromJsonWallet(json["result"]),
    );
  }

  factory ApiResponce.parseMystatistic(Map<String, dynamic> json) {
    return ApiResponce(
      success: json['success'],
      statuscode: json['statuscode'],
      result: ApiData.fromJsonMystatistic(json["result"]),
    );
  }

  factory ApiResponce.parseProfileRes(Map<String, dynamic> json) {
    return ApiResponce(
      success: json['success'],
      statuscode: json['statuscode'],
      result: ApiData.fromJsonProfile(json["result"]),
    );
  }

  factory ApiResponce.parseSupportResponce(Map<String, dynamic> json) {
    return ApiResponce(
      success: json['success'],
      statuscode: json['statuscode'],
      result: ApiData.fromSupportJson(json["result"]),
    );
  }

  factory ApiResponce.parseRideDetailsResponce(Map<String, dynamic> json) {
    return ApiResponce(
      success: json['success'],
      statuscode: json['statuscode'],
      result: ApiData.fromRideDetailsJson(json["result"]),
    );
  }

//  "totalRideTime": 18,
//  "advanceAmount": 3,
//  "discountPrice": 0,
//  "fareAmount": 3,
//  "totalPaymentAmount": 10,
//  "walletAmount": 0,

  factory ApiResponce.fromRideDetailsJson(Map<String, dynamic> json) {
    return ApiResponce(
      totalRideTime: json['totalRideTime'].toString(),
      advanceAmount: json['advanceAmount'].toString(),
      discountPrice: json['discountPrice'].toString(),
      tax: json['tax'].toString(),
      fareAmount: json['fareAmount'].toString(),
      totalPaymentAmount: json['totalPaymentAmount'].toString(),
      walletAmount: json['walletAmount'].toString(),
    );
  }

  factory ApiResponce.fromSupportdataJson(Map<String, dynamic> json) {
    return ApiResponce(
      contactNo: json['contactNo'],
      closedTime: json['closedTime'],
      name: json['name'],
      openTime: json['openTime'],
      email: json['email'],
    );
  }

//  "id": 12,
//  "iotDeviceId": "C3:4F:34:18:F1:D4",
//  "qrCode": "66655500397",
//  "bookingId": "RIDE7736912",

//  "id": 29,
//  "iotDeviceId": "234546",
//  "qrCode": "66655500397",
//  "bookingId": "RIDE7736929",
//  "bookingDate": "04/02/2021",
//  "bookingTime": "07:03:08",
//  "totalDistance": null,
//  "totalRideTime": 41,

//
//  "PaymentPortal": "https://demo-ipg.ctdev.comtrust.ae/PaymentEx/MerchantPay/Payment?lang=en&layout=C0STCBVLEI",
//  "PaymentPage": "https://demo-ipg.ctdev.comtrust.ae/PaymentEx/MerchantPay/Payment?lang=en&layout=C0STCBVLEI",
//  "ResponseCode": "0",
//  "ResponseClass": "0",
//  "ResponseDescription": "Request Processed Successfully",
//  "ResponseClassDescription": "Success",
//  "Language": null,
//  "ApprovalCode": null,
//  "Account": null,
//  "OrderID": null,
//  "CardNumber": null,
//  "CardToken": null,
//  "CardBrand": null,
//  "TransactionID": "266167636365",

  factory ApiResponce.fromSavepaymentJson(Map<String, dynamic> json) {
    return ApiResponce(
      PaymentPortal: json['PaymentPortal'].toString(),
      CardNumber: json['CardNumber'].toString(),
      PaymentPage: json['PaymentPage'].toString(),
      ResponseDescription: json['ResponseDescription'].toString(),
      TransactionID: json['TransactionID'],
      CallBackUrl: json['CallBackUrl'],
    );
  }

  factory ApiResponce.fromStopRideJson(Map<String, dynamic> json) {
    return ApiResponce(
      totalDistance: json['totalDistance'].toString(),
      totalRideTime: json['totalRideTime'].toString(),
      totalCharges: json['totalCharges'].toString(),
      iotDeviceId: json['iotDeviceId'],
      qrCode: json['qrCode'],
      bookingId: json['bookingId'],
      scooterIddata: ApiData.ScooterfromJson(json["scooterId"]),
      paymentIdData: Data.PaymentfromJson(json["paymentId"]),
    );
  }

  factory ApiResponce.fromStartRideJson(Map<String, dynamic> json) {
    return ApiResponce(
      iotDeviceId: json['iotDeviceId'],
      qrCode: json['qrCode'],
      bookingId: json['bookingId'],
      scooterIddata: ApiData.ScooterfrompowerJson(json["scooterId"]),
    );
  }

  factory ApiResponce.fromScoterdetailsJson(Map<String, dynamic> json) {
    return ApiResponce(
      deviceId: json['deviceId'],
      scooterId: json['scooterId'],
      name: json['name'],
      registrationNo: json['registrationNo'],
      imei: json['imei'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      tarrifId: Data.TerrifListfromJson(json["tarrifId"]),
    );
  }

  factory ApiResponce.fromgeofencingIddataJson(Map<String, dynamic> json) {
    return ApiResponce(
      distance: json['distance'].toString(),
      totalAvailableScooter: json['totalAvailableScooter'].toString(),
      name: json['name'],
      address: json['address'],
      cordinateList: parseGeofenceList(json),
    );
  }

  static List<Data> parseGeofenceList(contestJson) {
    var list = contestJson['corrdinates'] as List;
    List<Data> contestList =
        list.map((data) => Data.geofenceListfromJson(data)).toList();
    return contestList;
  }

  factory ApiResponce.parsePrivacyPolicyTermsResponce(
      Map<String, dynamic> json) {
    return ApiResponce(
      success: json['success'],
      statuscode: json['statuscode'],
      result: ApiData.fromPrivacyPolicyTermsJson(json["result"]),
    );
  }

  factory ApiResponce.fromPrivacyPolicyTermsdataJson(
      Map<String, dynamic> json) {
    return ApiResponce(
      description: json['description'],
    );
  }

  factory ApiResponce.parseSavePaymentResponce(Map<String, dynamic> json) {
    return ApiResponce(
      Transaction: ApiResponce.fromSavepaymentJson(json["Transaction"]),
    );
  }

  factory ApiResponce.parseLoginResponce(Map<String, dynamic> json) {
    return ApiResponce(
      success: json['success'],
      statuscode: json['statuscode'],
      result: ApiData.fromloginJson(json["result"]),
    );
  }

  factory ApiResponce.parseProfileResponce(Map<String, dynamic> json) {
    return ApiResponce(
      success: json['success'],
      statuscode: json['statuscode'],
      result: ApiData.fromProfileJson(json["result"]),
    );
  }

  factory ApiResponce.fromlogindataJson(Map<String, dynamic> json) {
    // print('json', json['id'].toString());
    return ApiResponce(
      id: json['id'],
      mobile: json['mobile'],
      authToken: json['authToken'],
      firebaseId: json['firebaseId'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      address: json['address'],
      city: json['city'],
      state: json['state'],
      country: json['country'],
      zip: json['zip'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      profileImage: json['profileImage'],
      drivingLicense: json['drivingLicense'],
      licenseImage: json['licenseImage'],
      walletAmount: json['walletAmount'].toString(),
      timezoneId: json['timezoneId'],
      notification: json['notification'],
      card_added: json['card_added'],
      cardNo: json['cardNo'].toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'mobile': mobile,
        'authToken': authToken,
        'firebaseId': firebaseId,
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'address': address,
        'city': city,
        'state': state,
        'country': country,
        'zip': zip,
        'latitude': latitude,
        'longitude': longitude,
        'profileImage': profileImage,
        'drivingLicense': drivingLicense,
        'licenseImage': licenseImage,
        'walletAmount': walletAmount,
        'timezoneId': timezoneId
      };

  factory ApiResponce.fromJson(Map<String, dynamic> json) {
    return ApiResponce(
      success: json['success'],
      statuscode: json['statuscode'],
      result: ApiData.frommessageJson(json["result"]),
    );
  }

  factory ApiResponce.frompaycomsaveJson(Map<String, dynamic> json) {
    return ApiResponce(
      success: json['success'],
      statuscode: json['statuscode'],
      result: ApiData.frommessageJson(json["result"]),
    );
  }

  factory ApiResponce.fromlatlongJson(Map<String, dynamic> json) {
    return ApiResponce(
      Latitude: json['Latitude'].toString(),
      Longitude: json['Longitude'].toString(),
    );
  }

  factory ApiResponce.parseMyNotification(Map<String, dynamic> json) {
    return ApiResponce(
      success: json['success'],
      statuscode: json['statuscode'],
      result: ApiData.fromMyNotificationJson(json["result"]),
    );
  }

  factory ApiResponce.parseRideHistory(Map<String, dynamic> json) {
    return ApiResponce(
      success: json['success'],
      statuscode: json['statuscode'],
      result: ApiData.fromMyRideHistoryJson(json["result"]),
    );
  }

  factory ApiResponce.parseNearbylocations(Map<String, dynamic> json) {
    return ApiResponce(
      success: json['success'],
      statuscode: json['statuscode'],
      result: ApiData.fromNearbylocationsJson(json["result"]),
    );
  }

  factory ApiResponce.parseGeofences(Map<String, dynamic> json) {
    return ApiResponce(
      success: json['success'],
      statuscode: json['statuscode'],
      result: ApiData.fromgeofenceJson(json["result"]),
    );
  }

  factory ApiResponce.parseTerrifList(Map<String, dynamic> json) {
    return ApiResponce(
      success: json['success'],
      statuscode: json['statuscode'],
      result: ApiData.fromTerrifsJson(json["result"]),
    );
  }

  factory ApiResponce.parseStartRide(Map<String, dynamic> json) {
    return ApiResponce(
      success: json['success'],
      statuscode: json['statuscode'],
      result: ApiData.fromStartRideJson(json["result"]),
    );
  }

  factory ApiResponce.parseApplyoffer(Map<String, dynamic> json) {
    return ApiResponce(
      success: json['success'],
      statuscode: json['statuscode'],
      appoffer: Data.applyofferfromJson(json["result"]),
    );
  }

  factory ApiResponce.parseSavepayment(Map<String, dynamic> json) {
    return ApiResponce(
      success: json['success'],
      statuscode: json['statuscode'],
      result: ApiData.fromSavepaymentJson(json["result"]),
    );
  }
  factory ApiResponce.parseWalletpayment(Map<String, dynamic> json) {
    return ApiResponce(
      success: json['success'],
      statuscode: json['statuscode'],
      result: ApiData.fromWalletpaymentJson(json["result"]),
    );
  }
  factory ApiResponce.parseSaveWaletpayment(Map<String, dynamic> json) {
    return ApiResponce(
      success: json['success'],
      statuscode: json['statuscode'],
      result: ApiData.fromSaveWalletpaymentJson(json["result"]),
    );
  }

  factory ApiResponce.parseStopRide(Map<String, dynamic> json) {
    return ApiResponce(
      success: json['success'],
      statuscode: json['statuscode'],
      result: ApiData.fromStopRideJson(json["result"]),
    );
  }

  factory ApiResponce.parseOfferList(Map<String, dynamic> json) {
    return ApiResponce(
      success: json['success'],
      statuscode: json['statuscode'],
      result: ApiData.fromOfferJson(json["result"]),
    );
  }

  static List<Data> parselocationList(contestJson) {
    var list = contestJson['data'] as List;
    List<Data> contestList =
        list.map((data) => Data.locationfromJson(data)).toList();
    return contestList;
  }

  factory ApiResponce.fromProfileJson(Map<String, dynamic> json) {
    return ApiResponce(
      id: json['id'],
      mobile: json['mobile'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
    );
  }

//  factory UserData.fromJson(Map<String, dynamic> json) => _$UserDataFromJson(json);
//  Map<String, dynamic> toJson() => _$UserDataToJson(this);
}
