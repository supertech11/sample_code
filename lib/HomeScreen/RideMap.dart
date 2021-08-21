import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
// import 'package:permission/permission.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xplor/HomeScreen/update.dart';
import 'package:xplor/Model/ApiResponce.dart';
import 'package:xplor/Model/LanguageResponce.dart';
import 'package:xplor/Screen/AddScooterImage.dart';
import 'package:xplor/Screen/Wallet.dart';
import 'package:xplor/localization/language_constants.dart';
import 'package:xplor/provider/get_ride_provider.dart';
import 'package:xplor/util/ApiControler.dart';
import 'package:xplor/util/AppButton.dart';
import 'package:xplor/util/Colorss.dart';
import 'package:xplor/util/SizeConfig.dart';
import 'package:xplor/util/Dimens.dart';
import 'package:xplor/util/Strings.dart';
import 'package:xplor/util/images.dart';
import 'package:flutter_google_maps/flutter_google_maps.dart';
import 'package:xplor/util/utilities.dart';

class RideMap extends StatefulWidget {
  GlobalKey<InnerDrawerState> innerDrawerKey;
  String url, title;
  var Nearbylocations, Latitude = "0.0", Longitude = "0.0";
  RideMap({
    Key key,
  }) : super(key: key);

  @override
  _RideMapState createState() => _RideMapState();
}

class _RideMapState extends State<RideMap> {
  // reference to our single class that manages the database
  _RideMapState();
  var profile,
      Latitude = "24.9789004",
      Longitude = "55.1760864",
      Nearbylocations;
  bool isProgressShow = true;
  int count = 0;
  final _key = GlobalKey<GoogleMapStateBase>();
  // for my custom icons
  String ridestartdate = "", perMinuteCharge = "", power = "0";
  var prefs;
  var languageHome, lansetting, languageValue;
  String message, imagevalue;
  double walletbance;
  bool status;
  int minuteValue;
  var bareAmount;
  var perMinuteChargevalue;
  var checkbalance, tax, finalAmount;
  bool transactionstatus;
  bool bookingStatus;

  int _pos = 0;
  Timer _timer;
  // var res = ApiResponce.parseRideDetailsResponce(userMap);

  @override
  void initState() {
    setState(() {
      minuteValue = 0;
    });
    _timer = Timer.periodic(new Duration(seconds: 16), (Timer t) => callApi());
    super.initState();
    getDataLanguage();
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
  }

  parseRidevalueh(reply) async {
    setState(() {
      isProgressShow = false;
    });

    if (reply != null) {
      Map userMap = jsonDecode(reply);
      var user = ApiResponce.fromJson(userMap);
      if (user.success) {
        // prefs.setString('ride_status', "3");

        var data = ApiResponce.parseStopRide(userMap);
        // rideData = data.result.rideDetails;
        // paymentdata = data.result.rideDetails.paymentIdData;
        // terrifData = data.result.rideDetails.scooterIddata.tarrifIdata;
        // print("iotDeviceId>>  " +
        //     data.result.rideDetails.iotDeviceId.toUpperCase());
        print('ride ended');
        prefs.setBool('endrideDone', true);
        new Utilities().showToast(
          context,
          user.result.message,
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AddScooterImage()),
        );
      } else {
        new Utilities()
            .showAlertDialog(context, Strings.alert, user.result.message, "OK");
        // print('Howdy, ${user.code} ${user.msg}!');
      }
    }
  }

  callApi() async {
    final prefs = await SharedPreferences.getInstance();
    print("bookingId " + prefs.getString('bookingId'));
    await Provider.of<RideScrotter>(context, listen: false)
        .getUserScotterBalance(prefs.getString('bookingId'));
    await Provider.of<RideScrotter>(context, listen: false).getWalletBalance();
    await Provider.of<RideScrotter>(context, listen: false)
        .getRideDetail(prefs.getString('bookingId'));
    message = Provider.of<RideScrotter>(context, listen: false).message;
    walletbance =
        Provider.of<RideScrotter>(context, listen: false).walletBalace;
    print("****" + minuteValue.toString());
    setState(() {
      count++;
      status = Provider.of<RideScrotter>(context, listen: false).status;
      transactionstatus =
          Provider.of<RideScrotter>(context, listen: false).transactionstatus;
      setState(() {
        imagevalue =
            Provider.of<RideScrotter>(context, listen: false).image.toString();
        bookingStatus =
            Provider.of<RideScrotter>(context, listen: false).bookingStatus;
      });
      bareAmount = prefs.getDouble('bareAmount');
      perMinuteChargevalue = double.parse(prefs.getString('perMinuteCharge'));
      print("*****|/////" + bareAmount.toString());
      print("*****|/////" + perMinuteChargevalue.toString());
    });
    checkbalance = bareAmount + (perMinuteChargevalue * minuteValue);
    tax = checkbalance * 0.05;
    finalAmount = checkbalance + tax;
    prefs.setDouble('fareAmount', checkbalance);
    prefs.setInt('minutes', minuteValue);
    print("fareAmount" + checkbalance.round().toString());
    print("****total " + finalAmount.round().toString());
    var balance = walletbance.round() - 1;
    print(balance - finalAmount.round());
    print(balance);
    print("booking status " + bookingStatus.toString());
    print("transactionstatus status " + transactionstatus.toString());
    print('image ***' + imagevalue);
    if (bookingStatus == false) {
      prefs.setString('ride_status', "0");
      prefs.setString('bookingId', "");
      Navigator.pushNamedAndRemoveUntil(context, "/MenuScreen", (r) => false);
    } else if (transactionstatus == true && bookingStatus == true) {
      prefs.setBool('endrideDone', true);
      prefs.setString('ride_status', "2");
      prefs.setBool('forceendride', true);
      if (imagevalue != null) {
        prefs.setString("imageupload", imagevalue.toString());
      }
      Fluttertoast.showToast(
          msg: "Your ride ended successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AddScooterImage()),
      );
    } else if (transactionstatus == false && bookingStatus == true) {
      print("Ride Still On");
      // that means payment not done  and ride already start
      // redirect timmer screen
    }
    if (message == "NULL") {
      print('Ride on');
    } else {
      if (count == 3) {
        print(count);
        Fluttertoast.showToast(
            msg: message,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            textColor: Colors.white,
            fontSize: 16.0);
        setState(() {
          count = 0;
        });
      } else {
        print(2);
      }

      setState(() {
        Provider.of<RideScrotter>(context, listen: false).message = "NULL";
      });
    }
  }

  checkBalanceApi() async {
    final prefs = await SharedPreferences.getInstance();
    print("bookingId " + prefs.getString('bookingId'));
    await Provider.of<RideScrotter>(context, listen: false).getWalletBalance();
    walletbance =
        Provider.of<RideScrotter>(context, listen: false).walletBalace;
    print("****" + minuteValue.toString());
    if (message == "NULL") {
      return;
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    _timer = null;
    super.dispose();
  }

  getDataLanguage() async {
    prefs = await SharedPreferences.getInstance();
    languageValue = prefs.getString(LAGUAGE_CODE) ?? "en";
    ridestartdate = prefs.getString('rideStartdate') ?? "";
    perMinuteCharge = prefs.getString('perMinuteCharge') ?? "";
    power = prefs.getString('power') ?? "";
    var data = prefs.getString('languageData');
    Map langMap = jsonDecode(data.toString());
    var lanRes = LanguageResponce.parseLanguage(langMap);
    languageHome = lanRes.result.data.Home_Map;
    lansetting = lanRes.result.data.Settings;
    print(languageHome.toString());
    getLoc();
    setState(() {});
    starttimer();
  }

  getLoc() async {
    var islocationAllow = prefs.getString('islocationAllow');
    if (islocationAllow != null && islocationAllow == "1") {
      await Geolocator.getCurrentPosition().then((value) => {print("<>getCurrentPosition>>> " + value.toString()),
            parselatlong(value)
          });
    } else {
      showWarningLocationDialog(context, Strings.alert, Strings.location_msg);
    }

//    await Geolocator.getLastKnownPosition().then(
//            (value) => {
//              print("<>>>> " + value.toString()),
//          parselatlong(value)
//            });

    await Geolocator.checkPermission().then(
        (value) => {print("<>getCurrentPosition>>> " + value.toString())});
  }

  parselatlong(value) {
    List<String> aa = value.toString().split(",");
    List<String> arLatitude = aa[0].split(":");
    List<String> arLongitude = aa[1].split(":");
    Latitude = arLatitude[1].toString();
    Longitude = arLongitude[1].toString();
    print("<>parselatlong>>Latitude> " + Latitude);
    print("<>parselatlong>Longitude>> " + Longitude);
    if (Latitude != null && Latitude != "null" && Latitude != "") {
      setMapData();
    } else {
      Future.delayed(const Duration(milliseconds: 100), () {
        getLoc();
      });
    }
  }

  setMapData() {
    getGeofence();
    GotoCurrentLocation();
    setMarker();
  }

  getGeofence() async {
    final prefs = await SharedPreferences.getInstance();
    var authToken = prefs.getString('authToken');

    setState(() {
      isProgressShow = true;
    });
    var dio = Dio();
    dio.interceptors.add(LogInterceptor(requestBody: true));

    new ApiControler()
        .dioAuthGet(context, authToken, Strings.getAllGeoFencing, {
      "authToken": authToken,
    }).then((onValue) {
      parseGeofence(onValue);
    });
  }

  var geofenceList;
  parseGeofence(reply) async {
    setState(() {
      isProgressShow = false;
    });

    if (reply != null) {
      Map userMap = jsonDecode(reply);
      var user = ApiResponce.fromJson(userMap);
      if (user.success) {
        var data = ApiResponce.parseGeofences(userMap);
        geofenceList = data.result.geofenceList;
        setGeoFence();
      }
    }
  }

  setGeoFence() {
    GoogleMap.of(_key).clearPolygons();
    var polygon = <GeoCoord>[];
    if (geofenceList != null && geofenceList.length > 0) {
      for (int i = 0; i < geofenceList.length; i++) {
        var item = geofenceList[i];
        polygon = <GeoCoord>[];
        for (int j = 0; j < item.cordinateList.length; j++) {
          polygon.add(GeoCoord(double.parse(item.cordinateList[j].latitude),
              double.parse(item.cordinateList[j].longitude)));
        }
        GoogleMap.of(_key).addPolygon(
          i.toString(),
          polygon,
          strokeWidth: 3,
          fillOpacity: 0,
          fillColor: Colors.transparent,
          strokeColor: Colors.black,
          onTap: (polygonId) async {
//            await showDialog(
//              context: context,
//              builder: (context) => AlertDialog(
//                content: Text(
//                    item.name,
//                ),
//                actions: <Widget>[
//                  FlatButton(
//                    onPressed: Navigator.of(context).pop,
//                    child: Text('CLOSE'),
//                  ),
//                ],
//              ),
//            );
          },
        );
      }
    }
  }

  setMarker() {
    var lat = prefs.getDouble('ridelatitude');
    var long = prefs.getDouble('ridelongitude');
    print(lat.toString());
    GoogleMap.of(_key).clearMarkers();
    if (lat != null && long != "null" && lat != "") {
      GoogleMap.of(_key).addMarkerRaw(
        GeoCoord(double.parse(lat.toString()), double.parse(long.toString())),
        info: "Ride Location",
        icon: Images.map_pin,
      );
    }
  }

  GotoCurrentLocation() {
    var lat = prefs.getDouble('ridelatitude');
    var long = prefs.getDouble('ridelongitude');
    final bounds =
        GeoCoord(double.parse(lat.toString()), double.parse(long.toString()));
    GoogleMap.of(_key).moveCamera(bounds, animated: true, zoom: 15);
  }

  void showWarningLocationDialog(context, title, msg) {
    new Utilities().showWarningDialog(
        context,
        Strings.alert,
        msg,
        "I agree",
        "Cancel",
        () => {
              print("okk"),
              prefs.setString('islocationAllow', "1"),
              getLoc(),
              Navigator.pop(context)
            });
  }

  // @override
  // void dispose() {
  //   // TODO: implement dispose
  //   super.dispose();
  // }

  void starttimer() async {
    Stream.periodic(Duration(seconds: 1)).listen((_) {
      print("location change");
      if (mounted) super.setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Colorss.white_bg,
            ),
            child: new Container(
              child: GoogleMap(
                key: _key,
                markers: {
                  //  22.71792 75.8333
                  Latitude != null
                      ? Marker(
                          GeoCoord(
                              double.parse(Latitude), double.parse(Longitude)),
                          onTap: (latLng) {
                            // you have latitude and longitude here
                          },
                          icon: Images.map_pin,
                        )
                      : null,
                },
                initialZoom: 15,
                initialPosition: Latitude != null
                    ? GeoCoord(double.parse(Latitude), double.parse(Longitude))
                    : null,
                // Los Angeles, CA
                mapType: MapType.terrain,

                interactive: true,
                onTap: (coord) => {
//                          _scaffoldKey.currentState.showSnackBar(SnackBar(
//                          content: Text(""),
//                          duration: const Duration(seconds: 2),
//                          ))
                },
                mobilePreferences: const MobileMapPreferences(
                    padding: EdgeInsets.only(top: 30.0, right: 8, bottom: 200),
                    trafficEnabled: false,
                    zoomControlsEnabled: false,
                    myLocationEnabled: true,
                    compassEnabled: true,
                    myLocationButtonEnabled: true),

                webPreferences: WebMapPreferences(
                  fullscreenControl: true,
                  zoomControl: true,
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: SizeConfig.safeBlockVertical * 0,
            child: bottomRideDetail,
          ),
          new Positioned(
            left: languageValue == "en" ? 10 : null,
            right: languageValue == "en" ? null : 10,
            bottom: languageValue == "en"
                ? SizeConfig.safeBlockVertical * 19
                : SizeConfig.safeBlockVertical * 21,
            child: new Container(
              height: SizeConfig.safeBlockVertical * 18,
              width: SizeConfig.safeBlockHorizontal * 33,
              child: Image.asset(
                languageValue == "en" ? Images.bike : Images.bike_ar,
                fit: BoxFit.fitHeight,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget get bottomRideDetail {
    return new Container(
        child: ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(30),
      ),
      child: Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          Container(
              padding: const EdgeInsets.only(
                  right: 12, left: 12, top: 0, bottom: 10),
              color: Colorss.white,
              child: new Column(
                children: [
                  new Column(
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            new Container(
                              height: SizeConfig.safeBlockVertical * 10,
                              width: SizeConfig.safeBlockHorizontal * 25,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 12, right: 12),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  SizedBox(
                                    width: SizeConfig.safeBlockHorizontal * 61,
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: RichText(
                                        textAlign: TextAlign.end,
                                        text: TextSpan(
                                          text: languageHome != null
                                              ? "" +
                                                  languageHome.lbl_30Min +
                                                  " "
                                              : 'Per mins ',
                                          style: TextStyle(
                                            color: Colors.black45,
                                            fontWeight: FontWeight.w500,
                                            fontSize:
                                                SizeConfig.safeBlockHorizontal *
                                                    Dimens.text_3,
                                          ),
                                          children: <TextSpan>[
                                            TextSpan(
                                                text: perMinuteCharge +
                                                    Strings.app_currncy,
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: SizeConfig
                                                          .safeBlockHorizontal *
                                                      Dimens.text_4,
                                                  fontWeight: FontWeight.w700,
                                                )),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: SizeConfig.safeBlockHorizontal * 61,
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: RichText(
                                        textAlign: TextAlign.end,
                                        text: TextSpan(
                                          text: languageHome != null
                                              ? languageHome.lbl_Time + " "
                                              : 'Time ',
                                          style: TextStyle(
                                            color: Colors.black45,
                                            fontWeight: FontWeight.w500,
                                            fontSize:
                                                SizeConfig.safeBlockHorizontal *
                                                    Dimens.text_3,
                                          ),
                                          children: <TextSpan>[
                                            TextSpan(
                                                text: lansetting != null
                                                    ? setDate(ridestartdate)
                                                    : '0 mins',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: SizeConfig
                                                          .safeBlockHorizontal *
                                                      Dimens.text_4,
                                                  fontWeight: FontWeight.w700,
                                                )),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ]),
                      SizedBox(
                        height: 15,
                      ),
                      new Container(
                        width: SizeConfig.safeBlockHorizontal * 90,
                        margin: EdgeInsets.only(
                            left: SizeConfig.safeBlockHorizontal * 5,
                            right: SizeConfig.safeBlockHorizontal * 5),
                        child: new Row(
                          children: [
                            Expanded(
                                flex: 1,
                                child: new Row(
                                  children: [
                                    new Container(
                                      margin: EdgeInsets.only(
                                          right:
                                              SizeConfig.safeBlockHorizontal *
                                                  2,
                                          left: SizeConfig.safeBlockHorizontal *
                                              2),
                                      height:
                                          SizeConfig.safeBlockHorizontal * 5,
                                      width: SizeConfig.safeBlockHorizontal * 5,
                                      child: Image.asset(
                                          Images.ic_battery_full_black),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          new SizedBox(
                                            width:
                                                SizeConfig.safeBlockHorizontal *
                                                    34,
                                            child: Text(
                                                languageHome != null
                                                    ? languageHome.lbl_Battery
                                                        .toString()
                                                    : "Battery",
                                                style: TextStyle(
                                                    fontSize: SizeConfig
                                                            .safeBlockHorizontal *
                                                        Dimens.text_3,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.black45)),
                                          ),
                                          new SizedBox(
                                            width:
                                                SizeConfig.safeBlockHorizontal *
                                                    34,
                                            child: Text(power + "%",
                                                style: TextStyle(
                                                    fontSize: SizeConfig
                                                            .safeBlockHorizontal *
                                                        Dimens.text_4,
                                                    fontWeight: FontWeight.w700,
                                                    color: Colorss.black)),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                )),
                            Container(
                              child: Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Wallet()),
                                      );
                                    },
                                    child: Text(
                                      'Add Amount',
                                      style: TextStyle(
                                        fontSize:
                                            SizeConfig.safeBlockHorizontal *
                                                    Dimens.text_4 +
                                                2,
                                        fontWeight: FontWeight.w700,
                                        color: Colorss.black,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                            //     AppButton(
                            //     title: "Home  ",
                            //     showIcon: false,
                            //     onButtonClick: () {
                            //       // prefs.setString('ride_status', "2");
                            //       Navigator.pushReplacement(
                            //         context,
                            //         MaterialPageRoute(
                            //             builder: (context) => HomeMap()),
                            //       );
                            //     },
                            //     fontSize:
                            //         SizeConfig.safeBlockHorizontal * Dimens.text_5 - 8
                            // ),
                          ],
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  new Container(
                    width: SizeConfig.safeBlockHorizontal * 90,
                    margin: EdgeInsets.only(
                        top: SizeConfig.safeBlockVertical * 0, bottom: 5),
                    child: AppButton(
                        title: languageHome != null &&
                                languageHome.lbl_End_Ride != null
                            ? languageHome.lbl_End_Ride.toString()
                            : "End Ride",
                        showIcon: false,
                        onButtonClick: () {
                          setState(() {
                            prefs.setBool('forceendride', false);
                            prefs.setBool('endrideDone', false);
                            prefs.setString('ride_status', "2");
                            prefs.setString("imageupload", null.toString());
                            walletbance = Provider.of<RideScrotter>(context,
                                    listen: false)
                                .walletBalace;
                            bareAmount = prefs.getDouble('bareAmount');
                            perMinuteChargevalue = double.parse(
                                prefs.getString('perMinuteCharge'));
                            print("*****|/////" + bareAmount.toString());
                            print("*****|/////" +
                                perMinuteChargevalue.toString());
                            prefs.setInt('minutes', minuteValue);
                          });
                          var authToken = prefs.getString('authToken');
                          var bookingId = prefs.getString('bookingId');
                          checkbalance =
                              bareAmount + (perMinuteChargevalue * minuteValue);
                          tax = checkbalance * 0.05;
                          finalAmount = checkbalance + tax;
                          print("checkbalance" + checkbalance.toString());
                          prefs.setDouble('fareAmount', checkbalance);
                          var dio = Dio();
                          dio.interceptors
                              .add(LogInterceptor(requestBody: true));

                          new ApiControler().dioAuthPost(
                              context, authToken, Strings.stopRide, {
                            "bookingId": bookingId,
                            "totalRideTime": minuteValue,
                            "forceendride": false,
                            "paymentId": {
                              "fareAmount": checkbalance,
                              "tax": tax,
                              "totalAmount": finalAmount
                            }
                            // "authToken": authToken,
                          }).then((onValue) {
                            parseRidevalueh(onValue);
                          });
                        },
                        fontSize:
                            SizeConfig.safeBlockHorizontal * Dimens.text_5),
                  )
                ],
              )),
        ],
      ),
    ));
  }

  setDate(date) {
    try {
      print("date>> " + date);
      var now = new DateTime.now();
      var date4 = DateTime.parse(date);
      // var date4 = DateTime.parse("2019-10-10 03:30:00");
      var different = now.difference(date4);
      different.inMinutes;
      var hoursMillis = 1 * 60 * 1000;
      var timeDiff = (different.inMilliseconds - hoursMillis);
      int seconds = ((different.inMilliseconds / 1000) % 60).toInt();
      int minutes = ((timeDiff / (1000 * 60)) % 60).toInt();
      int hours = ((timeDiff / (1000 * 60 * 60)) % 24).toInt();
      int diffDays = (timeDiff / (24 * 60 * 60 * 1000)).toInt();
      var s = (diffDays == 0 ? "" : diffDays.toString() + " days ") +
          hours.toString() +
          " hrs " +
          minutes.toString() +
          " mins " +
          seconds.toString() +
          " sec";
      int min = 0;
      if (different.inMinutes != null) {
        min = different.inMinutes;
        setState(() {
          minuteValue = different.inMinutes;
        });
      }
      return min.toString() + " min " + seconds.toString() + " sec";
    } catch (E) {
      return "0 ";
    }
  }
}

class Utils {
  static String mapStyles = '''[
  {
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#f5f5f5"
      }
    ]
  },
  {
    "elementType": "labels.icon",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  },
  {
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#616161"
      }
    ]
  },
  {
    "elementType": "labels.text.stroke",
    "stylers": [
      {
        "color": "#f5f5f5"
      }
    ]
  },
  {
    "featureType": "administrative.land_parcel",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#bdbdbd"
      }
    ]
  },
  {
    "featureType": "poi",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#eeeeee"
      }
    ]
  },
  {
    "featureType": "poi",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#757575"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#e5e5e5"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#9e9e9e"
      }
    ]
  },
  {
    "featureType": "road",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#ffffff"
      }
    ]
  },
  {
    "featureType": "road.arterial",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#757575"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#dadada"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#616161"
      }
    ]
  },
  {
    "featureType": "road.local",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#9e9e9e"
      }
    ]
  },
  {
    "featureType": "transit.line",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#e5e5e5"
      }
    ]
  },
  {
    "featureType": "transit.station",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#eeeeee"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#c9c9c9"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#9e9e9e"
      }
    ]
  }
]''';
}
