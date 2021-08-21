import 'package:json_annotation/json_annotation.dart';

import 'LanguageResponce.dart';
import 'UserData.dart';

@JsonSerializable()
class LanguageData {
  LanguageResponce data;
  String btn_LogOut,
      lbl_Statistics,
      lbl_Support,
      lbl_Setting,
      lbl_ProfileImage,
      lbl_Offer,
      lbl_Wallet,lbl_Profile,
      lbl_firstname1,dis_unit,time_unit,
      lbl_FavouriteAddress,
      lbl_email,
      lbl_TermsConditions,
      lbl_Demo,
      lbl_service,
      lbl_Notification,
      lbl_PrivacyPolicy,
      lbl_Language,
      lbl_firstname,
      lbl_PhoneNumber,
      btn_Login,
      lbl_Message,ph_mobile,lbl_Search,
      lbl_Password,
      lbl_Mobile,
      lbl_Topup,
      lbl_Balance,lbl_Complete_Ride,lbl_Payment_Summary,
      lbl_DropOff,
      lbl_PickUp,
      lbl_Tarrif,
      lbl_Distance,
      lbl_price,
      lbl_Timing,
      Timings,lbl_Contact_No,
      lbl_ContactPerson,
      lbl_Email,
      lbl_server,
      lbl_Latitude,
      lbl_Longitude,
      lbl_City,
      lbl_Zip,
      lbl_Country,
      lbl_Address,
      lbl_State,
      lbl_Duration,
      btn_RideHistory,lbl_My_Rides,
      btn_Continue,
      lbl_Verification,
      lbl_NotReceiveSMS,
      //HOME
      lbl_hello,
      lbl_browse_map,
      lbl_hello_msg,
      lbl_near_you,
      lbl_distance,
      lbl_Available,
      //Orboarding1
      lbl_skip,
      lbl_next,
      lbl_locate,
      lbl_intro,
      lbl_Message4,lbl_Message1,lbl_Message3,lbl_Message2,
      //Orboarding2
      lbl_skip2,
      lbl_next2,
      lbl_unlock,
      lbl_intro3,
      //Orboarding13
      lbl_end,
      lbl_intro2,
      lbl_ride,
      lbl_Home,

      // Trrif
      lbl_Pay,
      lbl_Total,
      lbl_Pay_as_you_go,
      lbl_One_Time,
      lbl_Per_Minute_Charge,
      lbl_Ride,
      lbl_Base_Fare,
      //payment
      lbl_Pay_with_card,
      lbl_Total_Minutes,
      lbl_Total_Charge,
      lbl_Coupon_Code,
      lbl_Payment,
      lbl_Payment_Opt,
      lbl_Discount,
      lbl_30Min,
      lbl_Time,
      lbl_Broken_bike,
      lbl_Unauthorized_lock,
      lbl_End_Ride,lbl_scan_qr_code,  lbl_Price,lbl_And,lbl_To_Unlock,lbl_Battery,
      //
      lbl_Login,
      lbl_Get,
      lbl_Account,

  //profile

      ph_Enter_Address,
      ph_Enter_Name,btn_Update,ph_Enter_Mobile,lbl_Name,ph_Enter_Email,lbl_Gallery,lbl_Camera,
  //Settngs

      lbl_Pause,lbl_Flash_On,lbl_Back_Camera,lbl_Flash_Off,lbl_Resume,lbl_Front_Camera,
      Msg_Select_Parking_Location,Msg_Checkout,
      Msg_Close,Msg_Successful,Msg_Ride_Not_Started,

  //ride_scooter_image_screen

      lbl_Select_Image,lbl_Add_Scooter_Image,lbl_Thank_You,lbl_Upload_Image,lbl_Hope

  ;

  LanguageData(
      {this.data,
      this.lbl_Available,this.ph_mobile,this.lbl_Search,this.lbl_scan_qr_code,
      this.btn_LogOut,
      this.lbl_Statistics,
      this.lbl_Support,
      this.lbl_Setting,
      this.lbl_ProfileImage,this.lbl_Contact_No,
      this.lbl_Offer,
      this.lbl_Wallet,
      this.lbl_firstname1,
      this.lbl_FavouriteAddress,
      this.lbl_email,
      this.lbl_TermsConditions,
      this.lbl_Demo,
      this.lbl_service,
      this.lbl_Notification,
      this.lbl_PrivacyPolicy,
      this.lbl_Language,
      this.lbl_firstname,
      this.lbl_PhoneNumber, this.dis_unit, this.time_unit,
      this.btn_Login,
      this.lbl_Message,
      this.lbl_Password,
      this.lbl_Mobile,
      this.lbl_Topup,
      this.lbl_Balance,
      this.lbl_DropOff,
      this.lbl_PickUp,
      this.lbl_Tarrif,
      this.lbl_Distance,
      this.lbl_price,
      this.lbl_Timing,
      this.Timings,
      this.lbl_ContactPerson,
      this.lbl_Email,
      this.lbl_server,
      this.lbl_Latitude,
      this.lbl_Longitude,
      this.lbl_City,
      this.lbl_Zip,
      this.lbl_Country,
      this.lbl_Address,
      this.lbl_State,
      this.lbl_Duration,
      this.btn_RideHistory,
      this.btn_Continue,
      this.lbl_Verification,
      this.lbl_NotReceiveSMS,
      this.lbl_hello,
      this.lbl_browse_map,
      this.lbl_hello_msg,
      this.lbl_near_you,
      this.lbl_distance,
      this.lbl_skip,
      this.lbl_next,
      this.lbl_locate,
      this.lbl_intro,
        this.lbl_Message4,
        this. lbl_Message1,
        this.lbl_Message3,  this.lbl_Message2,
      //Orboarding2
      this.lbl_skip2,
      this.lbl_next2,
      this.lbl_unlock,
      this.lbl_intro3,
      //Orboarding13
      this.lbl_end,
      this.lbl_intro2,
      this.lbl_ride,
      this.lbl_Home,
        this.lbl_Profile,
      //Terrif
      this.lbl_Pay,
      this.lbl_Total,
      this.lbl_Pay_as_you_go,
      this.lbl_One_Time,
      this.lbl_Per_Minute_Charge,
      this.lbl_Ride,
      this.lbl_Base_Fare,
      //payment
      this.lbl_Pay_with_card,
      this.lbl_Total_Minutes,
      this.lbl_Total_Charge,
      this.lbl_Coupon_Code,
      this.lbl_Payment,
      this.lbl_Payment_Opt,
      this.lbl_Discount,
      this.lbl_Time,
      this.lbl_30Min,
      this.lbl_Broken_bike,
      this.lbl_End_Ride,
      this.lbl_Unauthorized_lock,

      ///welcome
      this.lbl_Login,
      this.lbl_Get,
      this.lbl_Account,
        this.lbl_My_Rides,


        //profile


        this. ph_Enter_Address,
        this.ph_Enter_Name,  this.btn_Update,  this.ph_Enter_Mobile
        ,this.lbl_Name,this.ph_Enter_Email,this.lbl_Gallery,this.lbl_Camera,

        //setting

        this.lbl_Pause, this.lbl_Flash_On, this.lbl_Back_Camera,
        this.lbl_Flash_Off, this.lbl_Resume, this.lbl_Front_Camera,
        this.Msg_Select_Parking_Location,this.Msg_Checkout,
        this.Msg_Close,this.Msg_Successful,this.Msg_Ride_Not_Started,


        this.lbl_Select_Image,this.lbl_Add_Scooter_Image,this.lbl_Thank_You,
        this.lbl_Upload_Image,this.lbl_Hope,this.lbl_Price,this.lbl_And,
        this.lbl_To_Unlock,this.lbl_Battery,
        this.lbl_Complete_Ride,this.lbl_Payment_Summary,

      });

  factory LanguageData.fromJson(Map<String, dynamic> json) {
    return LanguageData(
      data: LanguageResponce.fromdataJson(json["data"]),
    );
  }

  factory LanguageData.fromJsonHome(Map<String, dynamic> json) {
    return LanguageData(
      lbl_hello: json['lbl_hello'],
      lbl_browse_map: json['lbl_browse_map'],
      lbl_hello_msg: json['lbl_hello_msg'],
      lbl_near_you: json['lbl_near_you'],
      lbl_distance: json['lbl_distance'],
      lbl_Available: json['lbl_Available'],
    );
  }

//
//  "lbl_Pay_with_card": "Pay with another card",
//  "lbl_Total_Minutes": "Total Minutes",
//  "lbl_Total_Charge": "Total Charge",
//  "lbl_Pay": "Pay",
//  "lbl_Coupon_Code": "Coupon Code",
//  "lbl_Payment": "Payment",
//  "lbl_Total": "Total",
//  "lbl_Payment_Opt": "Payment Options",
//  "lbl_Balance": "Balance",
//  "lbl_Discount": "Discount",
//  "lbl_Wallet": "Wallet"

  factory LanguageData.fromJsonPayments(Map<String, dynamic> json) {
    return LanguageData(
      lbl_Discount: json['lbl_Discount'],
      lbl_Pay: json['lbl_Pay'],
      lbl_Wallet: json['lbl_Wallet'],
      lbl_Pay_with_card: json['lbl_Pay_with_card'],
      lbl_Total_Minutes: json['lbl_Total_Minutes'],
      lbl_Total_Charge: json['lbl_Total_Charge'],
      lbl_Coupon_Code: json['lbl_Coupon_Code'],
      lbl_Payment: json['lbl_Payment'],
      lbl_Total: json['lbl_Total'],
      lbl_Payment_Opt: json['lbl_Payment_Opt'],
      lbl_Balance: json['lbl_Balance'],
      lbl_Payment_Summary: json['lbl_Payment_Summary'],
      lbl_Complete_Ride: json['lbl_Complete_Ride'],


    );
  }

  factory LanguageData.fromJsonTariff(Map<String, dynamic> json) {
    return LanguageData(
      lbl_Pay: json['lbl_Pay'],
      lbl_Total: json['lbl_Total'],
      lbl_Pay_as_you_go: json['lbl_Pay_as_you_go'],
      lbl_One_Time: json['lbl_One_Time'],
      lbl_Wallet: json['lbl_Wallet'],
      lbl_Per_Minute_Charge: json['lbl_Per_Minute_Charge'],
      lbl_Ride: json['lbl_Ride'],
      lbl_Base_Fare: json['lbl_Base_Fare'],
      lbl_Tarrif: json['lbl_Tarrif'],
    );
  }

  factory LanguageData.fromJsonOnboarding1(Map<String, dynamic> json) {
    return LanguageData(
      lbl_skip: json['lbl_skip'],
      lbl_next: json['lbl_next'],
      lbl_locate: json['lbl_locate'],
      lbl_intro: json['lbl_intro'],

      lbl_Message4: json['lbl_Message4'],
      lbl_Message3: json['lbl_Message3'],
      lbl_Message2: json['lbl_Message2'],
      lbl_Message1: json['lbl_Message1']


    );
  }




  factory LanguageData.fromJsonOnboarding2(Map<String, dynamic> json) {
    return LanguageData(
      lbl_skip2: json['lbl_skip'],
      lbl_next2: json['lbl_next'],
      lbl_unlock: json['lbl_unlock'],
      lbl_intro2: json['lbl_intro'],
      lbl_Message3: json['lbl_Message3'],
      lbl_Message2: json['lbl_Message2'],
      lbl_Message1: json['lbl_Message1']
    );
  }

  factory LanguageData.fromJsonOnboarding3(Map<String, dynamic> json) {
    return LanguageData(
      lbl_end: json['lbl_end'],
      lbl_intro3: json['lbl_intro'],
      lbl_ride: json['lbl_ride'],
    );
  }

  factory LanguageData.fromJsonVerification(Map<String, dynamic> json) {
    return LanguageData(
      btn_Continue: json['btn_Continue'],
      lbl_Verification: json['lbl_Verification'],
      lbl_NotReceiveSMS: json['lbl_NotReceiveSMS'],
    );
  }

//  "lbl_Broken_bike": "Broken Bike",
//  "lbl_Unauthorized_lock": "Unauthorized lock"
  factory LanguageData.fromJsonReportProblem(Map<String, dynamic> json) {
    return LanguageData(
      lbl_Broken_bike: json['lbl_Broken_bike'],
      lbl_Unauthorized_lock: json['lbl_Unauthorized_lock'],
      lbl_End_Ride: json['lbl_End_Ride'],
    );
  }

  factory LanguageData.fromJsonMyStatistics(Map<String, dynamic> json) {
    return LanguageData(
      lbl_Duration: json['lbl_Duration'],
      lbl_Distance: json['lbl_Distance'],
      btn_RideHistory: json['btn_RideHistory'],
      lbl_My_Rides: json['lbl_My_Rides'],

    );
  }

//  "lbl_And": "And",

//  "lbl_Battery": "Battery",


//  "lbl_To_Unlock": "to unlock",


//  "lbl_Price": "Price"


  factory LanguageData.fromJsonHomeMap(Map<String, dynamic> json) {
    return LanguageData(
      lbl_Distance: json['lbl_Distance'],
      lbl_Time: json['lbl_Time'],
      lbl_30Min: json['lbl_30Min'],
      lbl_End_Ride: json['lbl_End_Ride'],
      lbl_scan_qr_code: json['lbl_scan_qr_code'],

      lbl_To_Unlock: json['lbl_To_Unlock'],
      lbl_And: json['lbl_And'],
      lbl_Battery: json['lbl_Battery'],
      lbl_Price: json['lbl_Price'],


    );
  }

//  "Profile": {
//  "ph_Enter_Email": "Please Enter Email",
//  "lbl_Mobile": "Mobile",
//  "lbl_Name": "Name",


//  },


  factory LanguageData.fromJsonProfile(Map<String, dynamic> json) {
    return LanguageData(
      lbl_Camera: json['lbl_Camera'],
      lbl_Gallery: json['lbl_Gallery'],
      lbl_Name: json['lbl_Name'],
      lbl_Mobile: json['lbl_Mobile'],
      ph_Enter_Email: json['ph_Enter_Email'],

      ph_Enter_Name: json['ph_Enter_Name'],
      btn_Update: json['btn_Update'],
      ph_Enter_Mobile: json['ph_Enter_Mobile'],

      ph_Enter_Address: json['ph_Enter_Address'],
      lbl_Email: json['lbl_Email'],
      lbl_Address: json['lbl_Address'],
    );
  }
//  "Messages": {
//  "Msg_Select_Parking_Location": "Please select Parking location",
//  "Msg_Checkout": "Checkout",
//  "Msg_Close": "Close",
//  "Msg_Successful": "Successful",
//  "Msg_Ride_Not_Started": "Sorry, Ride is not started"
//  }

//  "ride_scooter_image_screen": {
//  "lbl_Select_Image": "Please select scooter image",
//  "lbl_Add_Scooter_Image": "Add Scooter Image",
//  "lbl_Thank_You": "Thank You",
//  "lbl_Upload_Image": "Upload Image",
//  "lbl_Hope": "We hope you had a great ride!"
//  },

  factory LanguageData.fromJsonRidescooterimagescreen(Map<String, dynamic> json) {
    return LanguageData(
      lbl_Select_Image: json['lbl_Select_Image'],
      lbl_Add_Scooter_Image: json['lbl_Add_Scooter_Image'],
      lbl_Thank_You: json['lbl_Thank_You'],
      lbl_Upload_Image: json['lbl_Upload_Image'],
      lbl_Hope: json['lbl_Hope'],
    );
  }

  factory LanguageData.fromJsonMessages(Map<String, dynamic> json) {
    return LanguageData(
      Msg_Select_Parking_Location: json['Msg_Select_Parking_Location'],
      Msg_Checkout: json['Msg_Checkout'],
      Msg_Close: json['Msg_Close'],
      Msg_Successful: json['Msg_Successful'],
      Msg_Ride_Not_Started: json['Msg_Ride_Not_Started'],
    );
  }
  factory LanguageData.fromJsonWelcome(Map<String, dynamic> json) {
    return LanguageData(
      lbl_Login: json['lbl_Login'],
      lbl_Get: json['lbl_Get'],
      lbl_Account: json['lbl_Account'],
    );
  }

//  "lbl_Login": "Log in",
//  "lbl_Get": "Get Started",
//  "lbl_Account": "Already have a account?"

  factory LanguageData.fromJsonAddress(Map<String, dynamic> json) {
    return LanguageData(
      lbl_Latitude: json['lbl_Latitude'],
      lbl_Longitude: json['lbl_Longitude'],
      lbl_Zip: json['lbl_Zip'],
      lbl_City: json['lbl_City'],
      lbl_Country: json['lbl_Country'],
      lbl_Address: json['lbl_Address'],
      lbl_State: json['lbl_State'],
    );
  }

  factory LanguageData.fromJsonSupport(Map<String, dynamic> json) {
    return LanguageData(
      Timings: json['Timings'],
      lbl_ContactPerson: json['lbl_ContactPerson'],
      lbl_Email: json['lbl_Email'],
      lbl_Contact_No: json['lbl_Contact_No'],

    );
  }

  factory LanguageData.fromJsonIpaAddress(Map<String, dynamic> json) {
    return LanguageData(
      lbl_server: json['lbl_server'],
    );
  }

  factory LanguageData.fromJsonBooking(Map<String, dynamic> json) {
    return LanguageData(
      lbl_DropOff: json['lbl_DropOff'],
      lbl_PickUp: json['lbl_PickUp'],
      lbl_Tarrif: json['lbl_Tarrif'],
      lbl_Distance: json['lbl_Distance'],
      lbl_Timing: json['lbl_Timing'],
      lbl_price: json['lbl_price'],
    );
  }

  factory LanguageData.fromJsonSignin(Map<String, dynamic> json) {
    return LanguageData(
      btn_Login: json['btn_Login'],
      lbl_Message: json['lbl_Message'],
      lbl_Password: json['lbl_Password'],
      lbl_Mobile: json['lbl_Mobile'],
        ph_mobile: json['ph_mobile'],
        lbl_Search: json['lbl_Search'],

    );
  }

  factory LanguageData.fromJsonMyWallet(Map<String, dynamic> json) {
    return LanguageData(
      lbl_Topup: json['lbl_Topup'],
      lbl_Balance: json['lbl_Balance'],
    );
  }


//  "lbl_Pause": "Pause",
//   "lbl_Flash_On": "FLASH ON",
//  "lbl_Back_Camera": "BACK CAMERA",
//  "lbl_Flash_Off": "FLASH OFF",
//
//  "lbl_Resume": "Resume",
//  "lbl_Front_Camera": "FRONT CAMERA"



  factory LanguageData.fromJsonSettings(Map<String, dynamic> json) {
    return LanguageData(
      lbl_Pause: json['lbl_Pause'],
      lbl_Flash_On: json['lbl_Flash_On'],
      lbl_Back_Camera: json['lbl_Back_Camera'],
      lbl_Flash_Off: json['lbl_Flash_Off'],
      lbl_Resume: json['lbl_Resume'],

      lbl_Front_Camera: json['lbl_Front_Camera'],



      lbl_firstname1: json['lbl_firstname1'],
      lbl_FavouriteAddress: json['lbl_FavouriteAddress'],
      lbl_email: json['lbl_email'],
      lbl_TermsConditions: json['lbl_TermsConditions'],
      lbl_Demo: json['lbl_Demo'],
      lbl_service: json['lbl_service'],
      lbl_Notification: json['lbl_Notification'],
      lbl_PrivacyPolicy: json['lbl_PrivacyPolicy'],
      lbl_Language: json['lbl_Language'],
      lbl_firstname: json['lbl_firstname'],
      lbl_PhoneNumber: json['lbl_PhoneNumber'],
      dis_unit: json['dis_unit'],
        time_unit: json['time_unit'],


    );
  }

  factory LanguageData.fromJsonNavigation(Map<String, dynamic> json) {
    return LanguageData(
      btn_LogOut: json['btn_LogOut'],
      lbl_Support: json['lbl_Support'],
      lbl_Statistics: json['lbl_Statistics'],
      lbl_ProfileImage: json['lbl_ProfileImage'],
      lbl_Setting: json['lbl_Setting'],
      lbl_Offer: json['lbl_Offer'],
      lbl_Wallet: json['lbl_Wallet'],
      lbl_Profile: json['lbl_Profile'],
      lbl_Home: json['lbl_Home'],
      lbl_Notification: json['lbl_Notification'],
    );
  }
}
