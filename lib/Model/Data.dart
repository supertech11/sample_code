import 'package:json_annotation/json_annotation.dart';
import 'package:xplor/Model/ApiResponce.dart';

import 'UserData.dart';

@JsonSerializable()
class Data {
  int is_first_login, id;
  Data tarrifIdata,paymentIdData;
  String name,
      address,
      geofencingId,power,
      city,
      state,
      country,
      zip,
      latitude,
      longitude,
      distance,
      totalAvailableScooter,
      baseAmount,
      perMinuteCharge,
      broadcastId,
      createdDate,
      tarrifId,
      offerId,
      imageName,
      description,
      code,
      bookingDate,
      bookingTime,
      totalDistance,
      totalRideTime,
      totalCharges,
      //payment
      paymentId,
      advanceAmount,
      agent,
      tax,
      discountPrice,
      damagedAmount,
      fareAmount,
      totalAmount,
      totalPaymentAmount,
      finalPrice,
      bookingPrice;
  ApiResponce geofencingIddata;
  Data(
      {this.address,
      this.geofencingId,this.geofencingIddata,
      this.totalAvailableScooter,
      this.finalPrice,this.power,this.tarrifIdata,
      this.bookingPrice,this.paymentIdData,
      this.id,
      this.name,
      this.city,
      this.state,
      this.country,
      this.zip,
      this.latitude,
      this.longitude,
      this.distance,
      this.baseAmount,
      this.perMinuteCharge,
      this.tarrifId,
      this.broadcastId,
      this.createdDate,
      this.offerId,
      this.imageName,
      this.description,
      this.code,
      this.bookingDate,
      this.bookingTime,
      this.totalDistance,
      this.totalRideTime,
      this.paymentId,
      this.advanceAmount,
      this.agent,
      this.tax,
      this.discountPrice,
      this.damagedAmount,
      this.fareAmount,
      this.totalAmount,this.totalCharges,
      this.totalPaymentAmount});



  factory Data.applyofferfromJson(Map<String, dynamic> json) {
    return Data(
      discountPrice: json['discountPrice'].toString(),
      bookingPrice: json['bookingPrice'].toString(),
      finalPrice: json['finalPrice'].toString(),
    );
  }

  factory Data.rideHistoryListfromJson(Map<String, dynamic> json) {
    return Data(
      id: json['id'],
      bookingDate: json['bookingDate'].toString(),
      bookingTime: json['bookingTime'].toString(),
      totalDistance: json['totalDistance'].toString(),
      totalRideTime: json['totalRideTime'].toString(),
      totalCharges: json['totalCharges'].toString(),
      paymentIdData:Data.PaymentfromJson(json["paymentId"]),
    );
  }

//  {
//  "id": 10,
//  "broadcastId": null,
//  "name": "Booking",
//  "description": "Sonuu Start riding  and Booking id 10",
//  "image": null,
//  "createdDate": null,
//  "modifiedDate": null,
//  "timezoneId": null
//  },

  factory Data.notificationListfromJson(Map<String, dynamic> json) {
    return Data(
      id: json['id'],
      broadcastId: json['broadcastId'],
      name: json['name'],
      description: json['description'],
      createdDate: json['createdDate'].toString(),
    );
  }

//  "id": 2,
//  "geofencingId": "GEF773692",
//  "name": "Vijay Nagar",
//  "address": "Vijay Nagar",
//  "city": "Indore",
//  "state": "MP",
//  "country": "dubai",
//  "zip": "452010",
//  "latitude": 23.1231,
//  "longitude": 104.21354,
//  "createdDate": null,
//  "modifiedDate": null,
//  "timezoneId": null,
//  "distance": 2896829.0,
//  "corrdinates": [],
//  "active": true

  factory Data.nearbylocationsListfromJson(Map<String, dynamic> json) {
    return Data(
      id: json['id'],
      power: json['power'].toString(),
      geofencingId: json['geofencingId'].toString(),
      name: json['name'],
      address: json['address'],
      city: json['city'],
      state: json['state'],
      country: json['country'],
      zip: json['zip'],
      latitude: json['latitude'].toString(),
      longitude: json['longitude'].toString(),
      distance: json['distance'].toString(),
      totalAvailableScooter: json['totalAvailableScooter'].toString(),
      geofencingIddata: ApiResponce.fromgeofencingIddataJson(json["geofencingId"]),
      tarrifIdata: Data.TerrifListfromJson(json["tarrifId"]),
    );
  }



  factory Data.geofenceListfromJson(Map<String, dynamic> json) {
    return Data(
      id: json['id'],
      latitude: json['latitude'].toString(),
      longitude: json['longitude'].toString(),

    );
  }

//  {
//  "id": 1,
//  "offerId": null,
//  "name": "First Five",
//  "code": "First_Five",
//  "description": null,
//  "imageName": null,
//  "startDate": 1610907609000,
//  "endDate": 1611080409000,
//  "createdDate": null,
//  "modifiedDate": null,
//  "timezoneId": "Asia/India",
//  "active": true
//  }

  factory Data.OfferListfromJson(Map<String, dynamic> json) {
    return Data(
      id: json['id'],
      offerId: json['offerId'].toString(),
      name: json['name'],
      code: json['code'],
      description: json['description'],
      imageName: json['imageName'],
    );
  }

  factory Data.TerrifListfromJson(Map<String, dynamic> json) {
    return Data(
      id: json['id'],
      baseAmount: json['baseAmount'].toString(),
      name: json['name'],
      perMinuteCharge: json['perMinuteCharge'].toString(),
      tarrifId: json['tarrifId'],
    );
  }

//  "id": 29,
//  "paymentId": "#REF7736929",
//  "advanceAmount": 3,
//  "agent": null,
//  "gatewayType": null,
//  "gatewayAgentCharge": 0,
//  "tax": 0,
//  "discountPrice": 0,
//  "damagedAmount": 0,
//  "fareAmount": 123,
//  "totalAmount": 126,
//  "totalPaymentAmount": 0,

  factory Data.PaymentfromJson(Map<String, dynamic> json) {
    return Data(
      discountPrice: json['discountPrice'].toString(),
      damagedAmount: json['damagedAmount'].toString(),
      fareAmount: json['fareAmount'].toString(),
      totalAmount: json['totalAmount'].toString(),
      totalPaymentAmount: json['totalPaymentAmount'].toString(),
      id: json['id'],
      paymentId: json['paymentId'].toString(),
      advanceAmount: json['advanceAmount'].toString(),
      agent: json['agent'].toString(),
      tax: json['tax'].toString(),
    );
  }

  factory Data.locationfromJson(Map<String, dynamic> json) {
    return Data();
  }

  Map<String, dynamic> toJson() => {
//        'OTP': OTP,
      };
//  factory Address.fromJson(Map<String, dynamic> json) => _$AddressFromJson(json);
//  Map<String, dynamic> toJson() => _$AddressToJson(this);
}
