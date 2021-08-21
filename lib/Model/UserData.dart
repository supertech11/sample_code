import 'package:json_annotation/json_annotation.dart';

import 'package:xplor/Model/Data.dart';

@JsonSerializable(explicitToJson: true)
class UserData {
  int code;
  int status;
  int OTP, version_code;
  String message,
      version,
      primary_id,
      img_path,
      id,
      coupon_code,
      discount_perc,
      is_used;
  bool success;
  Data data, profile, chart;

  bool is_complete_profile;

  UserData(
      {this.data,
      this.datalist,
      this.profile,
      this.chart,
      this.is_complete_profile,
      this.primary_id,
      this.img_path,
      this.status,
      this.code,
      this.message,
      this.success,
      this.version_code,
      this.id,
      this.coupon_code,
      this.discount_perc,
      this.is_used,
      this.version});

  List<Data> datalist;

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      success: json['error'],
      message: json['msg'],
    );
  }

//"id": "2",
//			"coupon_code": "TWO20",
//			"discount_perc": "20",
//			"is_used": "0"

  factory UserData.UserDataCouponDatafromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'],
      coupon_code: json['coupon_code'],
      discount_perc: json['discount_perc'],
      is_used: json['is_used'],
    );
  }

  factory UserData.loyalfromJson(Map<String, dynamic> json) {
    return UserData(
      success: json['status'],
      message: json['message'],
    );
  }

  static List<Data> parselocationList(contestJson) {
    var list = contestJson['data'] as List;
    List<Data> contestList =
        list.map((data) => Data.locationfromJson(data)).toList();
    return contestList;
  }

  Map<String, dynamic> toJson() =>
      {"code": code, "message": message, "status": status};

//  factory UserData.fromJson(Map<String, dynamic> json) => _$UserDataFromJson(json);
//  Map<String, dynamic> toJson() => _$UserDataToJson(this);
}
