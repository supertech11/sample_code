import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_google_maps/flutter_google_maps.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';
import 'package:geolocator/geolocator.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
// import 'package:permission/permission.dart';
import 'package:search_map_place/search_map_place.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xplor/HomeScreen/QRView.dart';
import 'package:xplor/HomeScreen/RideMap.dart';
import 'package:xplor/HomeScreen/drawer_screen.dart';
import 'package:xplor/Model/ApiResponce.dart';
import 'package:xplor/Model/LanguageResponce.dart';
import 'package:xplor/Screen/AddScooterImage.dart';
import 'package:xplor/Screen/Notification.dart';
import 'package:xplor/Screen/Payment.dart';
import 'package:xplor/Screen/Profile.dart';
import 'package:xplor/Screen/Welcome.dart';
import 'package:xplor/localization/language_constants.dart';
import 'package:xplor/util/ApiControler.dart';
import 'package:xplor/util/AppButton.dart';
import 'package:xplor/util/AppButtonPay.dart';
import 'package:xplor/util/Colorss.dart';
import 'package:xplor/util/CustomAppBar3.dart';
import 'package:xplor/util/SizeConfig.dart';
import 'package:xplor/util/Dimens.dart';
import 'package:xplor/util/Strings.dart';
import 'package:xplor/util/images.dart';
import 'package:xplor/util/utilities.dart';

class HomeMap extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<HomeMap> {
  // reference to our single class that manages the database
  _SettingsState();

  GlobalKey<InnerDrawerState> innerDrawerKey;
  var profile, Latitude = "24.9789004", Longitude = "55.1760864", Nearbylocations;
  bool isProgressShow = true;
  int _currentIndex = 0, markerPos, bottominfoStatus;
  bool isPreView = true, isNoRecord = true,keyboardIsOpen=false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _key = GlobalKey<GoogleMapStateBase>();
  String message = "";
  // PermissionName permissionName = PermissionName.Location;


  @override
  void initState() {
    super.initState();
    getDataLanguage();

    KeyboardVisibilityNotification().addNewListener(
      onChange: (bool visible) {
        print("visible>> "+visible.toString());
       setState(() {
          keyboardIsOpen = visible;
        });
      },
    );

  }

  GotoMarker() {
    if (markerPos != null &&
        Nearbylocations != null &&
        Nearbylocations.length > 0) {
      final bounds = GeoCoord(double.parse(Nearbylocations[markerPos].latitude),
          double.parse(Nearbylocations[markerPos].longitude));
      GoogleMap.of(_key).moveCamera(bounds, animated: true, zoom: 15);

      print("latitude>home> " + Nearbylocations[markerPos].latitude);
      print("longitude>home> " + Nearbylocations[markerPos].longitude);
    }
  }

  GotoCurrentLocation() {
    final bounds = GeoCoord(double.parse(Latitude), double.parse(Longitude));
    GoogleMap.of(_key).moveCamera(bounds, animated: true, zoom: 15);
  }

  getLoc() async {
    var islocationAllow = prefs.getString('islocationAllow');

    if(islocationAllow!=null&&islocationAllow=="1"){
          await Geolocator.getCurrentPosition().then((value) => {
          print("<>getCurrentPosition>>> " + value.toString()),
          parselatlong(value)
        });
    }else{
      showWarningLocationDialog(context, Strings.alert, Strings.location_msg);
      await setmapData();
    }






//    await Geolocator.getLastKnownPosition().then(
//        (value) => {print("<>>>> " + value.toString()),
//          parselatlong(value)
//
//        });

//    await Geolocator.checkPermission().then(
//        (value) => {print("<>getCurrentPosition>>> " + value.toString())});
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
      setmapData();
    } else {
      Future.delayed(const Duration(milliseconds: 100), () {
        getLoc();
      });
    }
  }
setmapData(){
  GotoCurrentLocation();
  getNearbylocations();
  getGeofence();
}
  setMarker() {
    GoogleMap.of(_key).clearMarkers();
    if (Latitude != null && Latitude != "null" && Latitude != "") {
      GoogleMap.of(_key).addMarkerRaw(
        GeoCoord(double.parse(Latitude), double.parse(Longitude)),
        info: "Current Location",

      );
    }

    if (Nearbylocations != null && Nearbylocations.length > 0) {
      for (int i = 0; i < Nearbylocations.length; i++) {
        GoogleMap.of(_key).addMarkerRaw(
          GeoCoord(double.parse(Nearbylocations[i].latitude),
              double.parse(Nearbylocations[i].longitude)),
          icon: Images.map_pin,
          info: Nearbylocations[i].geofencingIddata.name,
          onTap: (latLng) async {
            print("latLng.latLng>> " + latLng.toString());
            var geoCord = latLng.split(',');
            var latitude = geoCord[0].split("(")[1].toString();
            for (int i = 0; i < Nearbylocations.length; i++) {
              if (Nearbylocations[i].latitude == latitude) {
                markerPos = i;
              }
            }

            bottominfoStatus = 0;
            setState(() {});
//          await showDialog(
//            context: context,
//            builder: (context) => AlertDialog(
//              content: Text(
//                  'This dialog dgd  dd  vvg>>  '+latitude+"  >>   "+"  markerPos>> "+markerPos.toString()),
//              actions: <Widget>[
//                FlatButton(
//                  onPressed: Navigator.of(context).pop,
//                  child: Text('CLOSE'),
//                ),
//              ],
//            ),
//          );
          },
          onInfoWindowTap: () async {
            await showDialog(
              context: context,
              builder: (context) => AlertDialog(
                content: Text(
                    'This dialog was opened by tapping on the InfoWindow!'),
                actions: <Widget>[
                  FlatButton(
                    onPressed: Navigator.of(context).pop,
                    child: Text('CLOSE'),
                  ),
                ],
              ),
            );
          },
        );
      }
    }
    if (markerPos != null) {
      bottominfoStatus = 0;
      setState(() {});
      GotoMarker();
    }


  }

  openQrCode() {

    var bookingId =prefs.getString('bookingId');
    var ride_status = prefs.getString('ride_status');

//    print("ride_status>> "+ride_status.toString());
    bool cardStatus = prefs.getBool('card_added') ?? false;
    if (bookingId != null && bookingId != "") {
      if (ride_status == "1") {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => RideMap()),
        );
      }
      if (ride_status == "2") {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddScooterImage()),
        );
      } else if (ride_status == "3") {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Payment()),
        );
      }
    } else {
      if (cardStatus) {
        if (markerPos != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => QRViewExample(
                    adrress: Nearbylocations[markerPos].geofencingIddata.name)),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => QRViewExample(adrress: "")),
          );
        }
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Profile()),
        );
      }
    }
  }

  getNearbylocations() async {
    final prefs = await SharedPreferences.getInstance();
    var authToken = prefs.getString('authToken');
    setState(() {
      isProgressShow = true;
    });
    var dio = Dio();
    dio.interceptors.add(LogInterceptor(requestBody: true));
    new ApiControler().dioAuthPost(
        context,
        authToken,
        Strings.getNearbylocations,
        {"latitude": Latitude, "longitude": Longitude}).then((onValue) {
      parse(onValue);
    });
  }

  parse(reply) async {
    setState(() {
      isProgressShow = false;
    });

    if (reply != null) {
      Map userMap = jsonDecode(reply);
      var user = ApiResponce.fromJson(userMap);
      if (user.success) {
        var data = ApiResponce.parseNearbylocations(userMap);
        Nearbylocations = data.result.datalist;
        setState(() {});
        setMarker();
      } else {
        setMarker();
        new Utilities()
            .showAlertDialog(context, Strings.alert, user.result.message, "OK");
        // print('Howdy, ${user.code} ${user.msg}!');
      }
    }
  }


  getGeofence() async {
    final prefs = await SharedPreferences.getInstance();
    var authToken = prefs.getString('authToken');

    setState(() {
      isProgressShow = true;
    });
    var dio = Dio();
    dio.interceptors.add(LogInterceptor(requestBody: true));

    new ApiControler().dioAuthGet(
        context,
        authToken,
        Strings.getAllGeoFencing,{
      "authToken": authToken,
    }
       ).then((onValue) {
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
    var  polygon = <GeoCoord>[];
    if (geofenceList != null && geofenceList.length > 0) {
      for (int i = 0; i < geofenceList.length; i++) {
        var item=geofenceList[i];
        polygon= <GeoCoord>[];
        for (int j = 0; j < item.cordinateList.length; j++) {
          polygon.add(GeoCoord(double.parse(item.cordinateList[j].latitude),
            double.parse(item.cordinateList[j].longitude)));
        }
        GoogleMap.of(_key).addPolygon(
          i.toString(),
          polygon,
               strokeWidth:3,
          fillOpacity:0,
          fillColor: Colors.transparent,
          strokeColor:Colors.black,
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
  void _selectPlayer() {
    innerDrawerKey.currentState.toggle();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: new Container(
          height: 65,
          color: Colorss.black,
          child: new CustomAppBar3(
            title:
                lanRes != null && lanRes.result.data.navigation.lbl_Home != null
                    ? lanRes.result.data.navigation.lbl_Home
                    : "Home",
            onClickMenu: _selectPlayer,
            onClickNotification: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MainNotification()),
              );
            },
          ),
        ),
      ),
      drawer: AppDrawer(),
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Colorss.white_bg,
            ),
            child: new Container(
              padding: EdgeInsets.only(top: 0),
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
                    padding: EdgeInsets.only(top: 70.0, right: 8),
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
            top: 15,
            left: MediaQuery.of(context).size.width * 0.05,
            child: SearchMapPlaceWidget(
              apiKey:Strings.googleAPIKey,

              onSelected: (place) async {
                final geolocation = await place.geolocation;
                print(geolocation.coordinates.toString());
                var geoCord = geolocation.coordinates.toString().split(',');
                Latitude = geoCord[0].split("(")[1].toString();
                Longitude = geoCord[1].split(")")[0].toString();
                print(Latitude.toString());
                print(Longitude.toString());
                getNearbylocations();
                final bounds = GeoCoord(
                  double.parse(Latitude),
                  double.parse(Longitude),
                );
                GoogleMap.of(_key).moveCamera(bounds, animated: true, zoom: 16);
              },
            ),
          ),
          !keyboardIsOpen?  Positioned(
            top: 125,
            right: 15,
            child: GestureDetector(
              onTap: () {
                prefs.setString('markerPos', "");
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Welcome(
                            Nearbylocations: Nearbylocations,
                            Latitude: Latitude,
                            Longitude: Longitude,
                          )),
                ).then((value) {
                  String strmarkerPos = prefs.getString('markerPos');
                  if (strmarkerPos != "") {
                    markerPos = int.parse(strmarkerPos);
                    setMarker();
                  }
                });
              },
              child: new Card(
                shape: CircleBorder(),
                child: Padding(
                    padding: EdgeInsets.all(6),
                    child: Image.asset(
                      Images.ic_place_black,
                      height: 24,
                    )),
              ),
            ),
          ):new Container(),
          !keyboardIsOpen? Positioned(
            left: 0,
            right: 0,
            bottom: SizeConfig.safeBlockVertical * 0,
            child: bottomRideDetail,
          ):new Container(),
          _currentIndex == 0 &&
                  bottominfoStatus != null &&
                  bottominfoStatus == 0&&!keyboardIsOpen
              ? new Positioned(
                  left: languageValue == "en" ? 10 : null,
                  right: languageValue != "en" ? 10 : null,
                  bottom: languageValue == "en"
                      ? SizeConfig.safeBlockVertical * 21
                      : SizeConfig.safeBlockVertical * 23,
                  child: new Container(
                    height: SizeConfig.safeBlockVertical * 18,
                    width: SizeConfig.safeBlockHorizontal * 33,
                    child: Image.asset(
                      languageValue == "en"? Images.bike:Images.bike_ar,
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                )
              : new Container()
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
              color: _currentIndex == 0 &&
                      bottominfoStatus != null &&
                      bottominfoStatus == 0
                  ? Colorss.white
                  : Colors.transparent,
              child: new Column(
                children: [
                  _currentIndex == 0 &&
                          bottominfoStatus != null &&
                          bottominfoStatus == 0
                      ? new Container(
                          width: SizeConfig.safeBlockHorizontal * 100,
                          margin: EdgeInsets.only(
                              left: SizeConfig.safeBlockHorizontal * 5,
                              right: SizeConfig.safeBlockHorizontal * 5),
                          child: new Column(
                            children: [
                              Row(

                                  children: <Widget>[
                                    new Container(
                                      height: SizeConfig.safeBlockVertical * 10,
                                      width:
                                          SizeConfig.safeBlockHorizontal * 25,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          new SizedBox(
                                            width:
                                                SizeConfig.safeBlockHorizontal *
                                                    58,
                                            child: Text(
                                                Nearbylocations[markerPos]
                                                        .geofencingIddata
                                                        .name +
                                                    "",
                                                textAlign: TextAlign.end,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                    fontSize: SizeConfig
                                                            .safeBlockHorizontal *
                                                        Dimens.text_4)),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 8.0),
                                            child: RichText(
                                              text: TextSpan(
                                                text: languageHome != null
                                                    ? languageHome.lbl_distance
                                                            .toString() +
                                                        ' '
                                                    : 'Distance ',
                                                style: TextStyle(
                                                  color: Colors.black45,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: SizeConfig
                                                          .safeBlockHorizontal *
                                                      Dimens.text_3,
                                                ),
                                                children: <TextSpan>[
                                                  TextSpan(
                                                      text: lansetting != null
                                                          ? new Utilities().meterToKm(
                                                                  Nearbylocations[
                                                                          markerPos]
                                                                      .distance) +
                                                              " " +
                                                              lansetting
                                                                  .dis_unit
                                                          : new Utilities().meterToKm(
                                                                  Nearbylocations[
                                                                          markerPos]
                                                                      .distance) +
                                                              " km",
                                                      style: TextStyle(
                                                        fontSize: SizeConfig
                                                                .safeBlockHorizontal *
                                                            Dimens.text_4,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      )),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ]),
                              SizedBox(height: 15,),
                              new Container(
                                child: new Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    new Container(
                                        width:
                                            SizeConfig.safeBlockHorizontal * 41,
                                        child: new Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            new Container(
                                              margin: EdgeInsets.only(
                                                  right: SizeConfig
                                                          .safeBlockHorizontal *
                                                      2,
                                                  left: SizeConfig
                                                          .safeBlockHorizontal *
                                                      2),
                                              height: SizeConfig
                                                      .safeBlockHorizontal *
                                                  5,
                                              width: SizeConfig
                                                      .safeBlockHorizontal *
                                                  5,
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
                                                    width: SizeConfig
                                                            .safeBlockHorizontal *
                                                        32,
                                                    child: Text(
                                                        languageHomemap
                                                            .lbl_Battery
                                                            .toString(),
                                                        style: TextStyle(
                                                            fontSize: SizeConfig
                                                                    .safeBlockHorizontal *
                                                                Dimens.text_3,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: Colors
                                                                .black45)),
                                                  ),
                                                  new SizedBox(
                                                    width: SizeConfig
                                                            .safeBlockHorizontal *
                                                        32,
                                                    child: Text(
                                                        Nearbylocations[markerPos]
                                                                .power +
                                                            "%",
                                                        style: TextStyle(
                                                            fontSize: SizeConfig
                                                                    .safeBlockHorizontal *
                                                                Dimens.text_4,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            color:
                                                                Colorss.black)),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        )),
                                    new SizedBox(
                                        width:
                                            SizeConfig.safeBlockHorizontal * 41,
                                        child: new Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            new Container(
                                              margin: EdgeInsets.only(
                                                  right: SizeConfig
                                                          .safeBlockHorizontal *
                                                      2,
                                                  left: SizeConfig
                                                          .safeBlockHorizontal *
                                                      2),
                                              height: SizeConfig
                                                      .safeBlockHorizontal *
                                                  5,
                                              width: SizeConfig
                                                      .safeBlockHorizontal *
                                                  5,
                                              child:
                                                  Image.asset(Images.price_tag),
                                            ),
                                            new SizedBox(
                                              width: SizeConfig
                                                      .safeBlockHorizontal *
                                                  32,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                      languageHomemap.lbl_Price
                                                              .toString() +
                                                          "",
                                                      style: TextStyle(
                                                          fontSize: SizeConfig
                                                                  .safeBlockHorizontal *
                                                              Dimens.text_3,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color:
                                                              Colors.black45)),
                                                  Text(
                                                      Nearbylocations[markerPos]
                                                              .tarrifIdata
                                                              .perMinuteCharge +
                                                          "" +
                                                          Strings.app_currncy +
                                                          "/Min",
                                                      style: TextStyle(
                                                          fontSize: SizeConfig
                                                                  .safeBlockHorizontal *
                                                              Dimens.text_3_5,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          color:
                                                              Colorss.black)),
                                                  Text(
                                                      languageHomemap.lbl_And
                                                          .toString(),
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: TextStyle(
                                                          fontSize: SizeConfig
                                                                  .safeBlockHorizontal *
                                                              Dimens.text_3,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color:
                                                              Colors.black45)),
                                                  Text(
                                                      Nearbylocations[markerPos]
                                                              .tarrifIdata
                                                              .baseAmount +
                                                          "" +
                                                          Strings.app_currncy +
                                                          "  " +
                                                          languageHomemap
                                                              .lbl_To_Unlock
                                                              .toString(),
                                                      style: TextStyle(
                                                          fontSize: SizeConfig
                                                                  .safeBlockHorizontal *
                                                              Dimens.text_3,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color:
                                                              Colors.black)),
                                                ],
                                              ),
                                            ),
                                          ],
                                        )),
                                  ],
                                ),
                              )
                            ],
                          ))
                      : new Container(),
                  SizedBox(height: 10,),
                  new Container(
                    width: SizeConfig.safeBlockHorizontal * 90,
                    margin: EdgeInsets.only(
                        top: SizeConfig.safeBlockVertical * 0, bottom: 5),
                    child: AppButton(
                        title: languageHomemap != null &&
                                languageHomemap.lbl_scan_qr_code != null
                            ? languageHomemap.lbl_scan_qr_code.toString()
                            : 'Scan QR Code',
                        showIcon: true,
                        languageValue:languageValue,
                        onButtonClick: openQrCode,
                        fontSize:
                            SizeConfig.safeBlockHorizontal * Dimens.text_5),
                  )
                ],
              )),
        ],
      ),
    ));
  }

  var languageHome,
      languageHomemap,
      lansetting,
      languageMessages,
      lanRes,
      languageValue;
  var prefs;

  getDataLanguage() async {
    prefs = await SharedPreferences.getInstance();
    var data = prefs.getString('languageData');
    Map langMap = jsonDecode(data.toString());
    lanRes = LanguageResponce.parseLanguage(langMap);
    languageValue = prefs.getString(LAGUAGE_CODE) ?? "en";

    print("languageValue>> " + languageValue.toString());
    languageHome = lanRes.result.data.Home;
    languageMessages = lanRes.result.data.Messages;
    languageHomemap = lanRes.result.data.Home_Map;
    lansetting = lanRes.result.data.Settings;
    print(languageHome.toString());
    getLoc();
  }

  void showWarningLocationDialog(context, title, msg) {
    new Utilities()
        .showWarningDialog(context, Strings.alert, msg, "I agree","Cancel",() => {
          print("okk"),
    prefs.setString('islocationAllow',"1"),
  getLoc(),
          Navigator.pop(context)


        });
  }

}
