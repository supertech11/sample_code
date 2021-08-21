import 'package:json_annotation/json_annotation.dart';

import 'package:xplor/Model/Data.dart';
import 'package:xplor/Model/LanguageData.dart';

@JsonSerializable(explicitToJson: true)
class LanguageResponce {
  int statuscode;
  LanguageData result,
      navigation,
      Welcome,
      Profile,
      Messages,
      ride_scooter_image_screen,
      Settings,
      Signin,
      MyWallet,
      Booking,
      Support,
      IpaAddress,
      Address,
      MyStatistics,
      Verification,
      ReportProblem,
      Home,
      Tariff,
      Payments,
      Onboarding1,
      Onboarding2,
      Onboarding3,
      Home_Map;
  String message;
  bool success;

  LanguageResponce(
      {this.result,
      this.navigation,
      this.Tariff,
      this.Payments,
      this.Settings,
      this.Signin,
      this.MyWallet,
      this.Booking,
      this.Profile,
      this.Messages,
      this.Support,
      this.IpaAddress,
      this.Address,
      this.MyStatistics,
      this.Verification,
      this.Home,
      this.Onboarding1,
      this.Onboarding2,
      this.Onboarding3,
      this.Home_Map,
      this.ReportProblem,
      this.Welcome,
      this.message,
      this.success,
      this.statuscode,
      this.ride_scooter_image_screen});

  List<Data> datalist;

  factory LanguageResponce.fromJson(Map<String, dynamic> json) {
    return LanguageResponce(
      success: json['success'],
      statuscode: json['statuscode'],
    );
  }

  factory LanguageResponce.parseLanguage(Map<String, dynamic> json) {
    return LanguageResponce(
      success: json['success'],
      statuscode: json['statuscode'],
      result: LanguageData.fromJson(json["result"]),
    );
  }

  factory LanguageResponce.fromdataJson(Map<String, dynamic> json) {
    return LanguageResponce(
      navigation: LanguageData.fromJsonNavigation(json["Navigation"]),
      Settings: LanguageData.fromJsonSettings(json["Settings"]),
      Signin: LanguageData.fromJsonSignin(json["Signin"]),
      MyWallet: LanguageData.fromJsonMyWallet(json["MyWallet"]),
      Booking: LanguageData.fromJsonBooking(json["Booking"]),
      Support: LanguageData.fromJsonSupport(json["Support"]),
      Address: LanguageData.fromJsonAddress(json["Address"]),
      MyStatistics: LanguageData.fromJsonMyStatistics(json["MyStatistics"]),
      Verification: LanguageData.fromJsonVerification(json["Verification"]),
      ReportProblem: LanguageData.fromJsonReportProblem(json["ReportProblem"]),
      Home: LanguageData.fromJsonHome(json["Home"]),
      IpaAddress: LanguageData.fromJsonIpaAddress(json["IPAddress"]),
      Payments: LanguageData.fromJsonPayments(json["Payments"]),
      Tariff: LanguageData.fromJsonTariff(json["Tariff"]),
      Onboarding1: LanguageData.fromJsonOnboarding1(json["Orboarding1"]),
      Onboarding2: LanguageData.fromJsonOnboarding2(json["Onboarding2"]),
      Onboarding3: LanguageData.fromJsonOnboarding3(json["Onboarding3"]),
      Home_Map: LanguageData.fromJsonHomeMap(json["Home Map"]),
      Welcome: LanguageData.fromJsonWelcome(json["Welcome"]),
      Profile: LanguageData.fromJsonProfile(json["Profile"]),
      Messages: LanguageData.fromJsonMessages(json["Messages"]),
      ride_scooter_image_screen: LanguageData.fromJsonRidescooterimagescreen(
          json["ride_scooter_image_screen"]),
    );
  }

  static List<Data> parselocationList(contestJson) {
    var list = contestJson['data'] as List;
    List<Data> contestList =
        list.map((data) => Data.locationfromJson(data)).toList();
    return contestList;
  }

//  factory UserData.fromJson(Map<String, dynamic> json) => _$UserDataFromJson(json);
//  Map<String, dynamic> toJson() => _$UserDataToJson(this);
}
