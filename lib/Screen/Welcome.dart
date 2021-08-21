import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather/weather.dart';
import 'package:xplor/HomeScreen/RideMap.dart';
import 'package:xplor/Model/ApiResponce.dart';
import 'package:xplor/Model/Data.dart';
import 'package:xplor/Model/Ride.dart';
import 'package:xplor/Screen/AddScooterImage.dart';
import 'package:xplor/util/ApiControler.dart';
import 'package:xplor/util/Colorss.dart';
import 'package:xplor/util/Dimens.dart';
import 'package:xplor/util/SizeConfig.dart';
import 'package:xplor/util/Strings.dart';
import 'package:xplor/util/images.dart';
import 'package:xplor/util/utilities.dart';
import 'package:xplor/Model/LanguageResponce.dart';
import 'package:xplor/Screen/Payment.dart';

class Welcome extends StatefulWidget {
  GlobalKey<InnerDrawerState> innerDrawerKey;

  var Nearbylocations, Latitude, Longitude;

  Welcome(
      {Key key,
      @required this.Nearbylocations,
      this.Latitude,
      this.Longitude,
      this.innerDrawerKey})
      : super(key: key);

  callMethod(BuildContext context) => createState().readProfile(context);

  @override
  _WelcomePageState createState() =>
      _WelcomePageState(this.Nearbylocations, this.Latitude, this.Longitude);
}

class _WelcomePageState extends State<Welcome>
    with SingleTickerProviderStateMixin {
  _WelcomePageState(
    this.Nearbylocations,
    this.Latitude,
    this.Longitude,
  );

  var profile, Latitude = "0.0", Longitude = "0.0";
  var cardIndex = 0;
  ScrollController scrollController;
  var currentColor = Color.fromRGBO(231, 129, 109, 1.0);
  bool isProgressShow = false;
  var cardsList = [
    Ride("Personal", Icons.account_circle, 9, 0.83),
    Ride("Work", Icons.work, 12, 0.24),
    Ride("Home", Icons.home, 7, 0.32)
  ];

  AnimationController animationController;
  ColorTween colorTween;
  CurvedAnimation curvedAnimation;
  String key = '856822fd8e22db5e1ba48c0e7d69844a', name = "", message = "";
  var profileUrl, imageurl;
  WeatherFactory ws;
  List<Weather> _data = [];

  @override
  void initState() {
    super.initState();
    getDataLanguage();
    ws = new WeatherFactory(key);
    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 60));
    scrollController = new ScrollController();
    readProfile(context);
    if (Nearbylocations == null) {
      if (Latitude != null) {
        getNearbylocations();
      } else {
        getLoc();
      }
    }
    //queryWeather();
  }

  isinit() {}

  requestPermissions() async {
    getLoc();
  }

  readProfile(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    var profileRes = prefs.getString('profile');
    var url = prefs.getString('url');
    // print('profileRes' + profileRes);
    if (profileRes != null) {
      Map profileMap = jsonDecode(profileRes.toString());
      // print('profileMap' + profileMap.toString());
      var profile = ApiResponce.fromlogindataJson(profileMap);

      profileUrl = profile.profileImage;
      imageurl = imageurl = url + "/Xplor/images/";
      print('profile >>>>>>>>' + name.toString());
      if (profile.firstName == null || profile.firstName == "null") {
        name = "";
        setState(() {});
      } else {
        name = profile.firstName;
        setState(() {});
      }
    }
    // print('profile' + profile);
  }

  Weather weather;
  String place = "";

  void queryWeather() async {
    /// Removes keyboard

    weather = await ws.currentWeatherByLocation(
        double.parse(Latitude), double.parse(Longitude));
    setState(() {
      _data = [weather];
    });
    double celsius = weather.temperature.celsius;
    double fahrenheit = weather.temperature.celsius;
    double kelvin = weather.temperature.kelvin;
    place = weather.areaName;
    String weatherMain = weather.weatherMain;
    setState(() {});
//    print("<>>>> " + _data.toString());
//    print("<>>weatherMain>> " + weatherMain.toString());
//    print("<>>celsius>> " + celsius.toString());
//    print("<>>fahrenheit>> " + fahrenheit.toString());
//    print("<>>kelvin>> " + kelvin.toString());
//    print("<>>place>> " + place.toString());
  }

  getLoc() async {
    await Geolocator.getCurrentPosition().then((value) => {
          print("<>getCurrentPosition>>> " + value.toString()),
          parselatlong(value)
          // parselatlong(value)
        });
//    await Geolocator.getLastKnownPosition().then(
//        (value) => {
//          print("<>>>> " + value.toString()),
//          parselatlong(value)
//        });

//    await Geolocator.checkPermission().then(
//        (value) => {print("<>getCurrentPosition>>> " + value.toString())});
  }

  parselatlong(value) {
    List<String> aa = value.toString().split(",");
    List<String> arLatitude = aa[0].split(":");
    List<String> arLongitude = aa[1].split(":");
    print("<>parselatlong>>> " + aa[0].toString());
    print("<>parselatlong>>> " + aa[1].toString());
    Latitude = arLatitude[1].toString();
    Longitude = arLongitude[1].toString();
    print("<>parselatlong>>Latitude> " + Latitude);
    print("<>parselatlong>Longitude>> " + Longitude);

    if (Latitude != null && Latitude != "null" && Latitude != "") {
      getNearbylocations();
    } else {
      Future.delayed(const Duration(milliseconds: 100), () {
// Here you can write your code

        requestPermissions();
      });
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

  List<Data> Nearbylocations = new List();

  parse(reply) async {
    setState(() {
      isProgressShow = false;
    });

    if (reply != null) {
      Map userMap = jsonDecode(reply);
      var user = ApiResponce.fromJson(userMap);
      if (user.success) {
        var data = ApiResponce.parseNearbylocations(userMap);
        Nearbylocations = new List();

        Nearbylocations.addAll(data.result.datalist);

        setState(() {});
      } else {
        new Utilities()
            .showAlertDialog(context, Strings.alert, user.result.message, "OK");
        // print('Howdy, ${user.code} ${user.msg}!');
      }
    }
  }

  var prefs;
  var languageHome, lansetting;

  getDataLanguage() async {
    prefs = await SharedPreferences.getInstance();
    var data = prefs.getString('languageData');

    Map langMap = jsonDecode(data.toString());
    var lanRes = LanguageResponce.parseLanguage(langMap);
    languageHome = lanRes.result.data.Home;
    lansetting = lanRes.result.data.Settings;
    print(languageHome.toString());
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  getCurrentDate() {
    try {
      final DateTime now = DateTime.now();

      final DateFormat formatter = DateFormat('dd MMMM, EEEE');
      final String formatted = formatter.format(now);
      return formatted.toString();
    } catch (E) {
      return "Expired!!";
    }
  }

  gotoHomemap(position) {
    var bookingId = prefs.getString('bookingId');
    if (bookingId != null && bookingId != "") {
      var ride_status = prefs.getString('ride_status');
      if (ride_status == "1") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => RideMap()),
        );
      }
      if (ride_status == "2") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AddScooterImage()),
        );
      } else if (ride_status == "3") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Payment()),
        );
      }
    } else {
      print("latitude>> " + Nearbylocations[position].latitude);
      print("longitude>> " + Nearbylocations[position].longitude);
      prefs.setString('markerPos', position.toString());
      Navigator.pop(context);
//      Navigator.push(
//        context,
//        MaterialPageRoute(
//            builder: (context) => HomeMap(
//                Nearbylocations: Nearbylocations,
//                Latitude: Latitude,
//                Longitude: Longitude,
//                markerPos: position)),
//      );
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(0.0, 0.0),
        child: Container(),
      ),
      body: Material(
        color: Colorss.black,
        child: Container(
          child: new Stack(
            children: <Widget>[
              new Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0.0, vertical: 20.0),
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5.0, horizontal: 24.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  profileUrl != null && profileUrl != ""
                                      ? new Container(
                                          width: 90,
                                          height: 90,
                                          decoration: BoxDecoration(
                                              color: Colors.transparent,
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              border: Border.all(
                                                color: Colors.white,
                                                //                   <--- border color
                                                width: 4.0,
                                              ),
                                              image: new DecorationImage(
                                                  fit: BoxFit.fill,
                                                  image: NetworkImage(
                                                      imageurl + profileUrl))),
                                        )
                                      : Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              width: 4,
                                              color: Colors.white,
                                            ),
                                          ),
                                          child: Image.asset(
                                            Images.user,
                                            height: 90,
                                            width: 90,
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  24.0, 12.0, 24.0, 10.0),
                              child: Text(
                                languageHome != null
                                    ? languageHome.lbl_hello +
                                        " " +
                                        name.toString() +
                                        ","
                                    : "Hello ",
                                style: TextStyle(
                                  fontSize: SizeConfig.safeBlockHorizontal *
                                      Dimens.text_7,
                                  color: Colorss.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24.0),
                              child: Text(
                                languageHome != null
                                    ? languageHome.lbl_hello_msg
                                    : "Wanna take a ride today ?",
                                style: TextStyle(
                                  color: Colorss.white,
                                  fontSize: SizeConfig.safeBlockHorizontal *
                                      Dimens.text_4,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              new Positioned(
                  top: SizeConfig.safeBlockVertical * 30,
                  left: 0,
                  right: 0,
                  child: new Container(
                    height: SizeConfig.safeBlockVertical * 72,
                    padding: EdgeInsets.only(bottom: 10.0),
                    child: new Column(
                      children: [
                        Nearbylocations != null
                            ? new Container(
                                child: Expanded(
                                  child: new Container(
                                    child: ListView.builder(
                                      itemCount: Nearbylocations.length,
                                      itemBuilder: (context, position) {
                                        final item = Nearbylocations[position];
                                        return ListTile(
                                            contentPadding:
                                                EdgeInsets.all(10.0),
                                            title: Container(
                                              margin: EdgeInsets.only(
                                                  left: 20,
                                                  right: 20,
                                                  bottom:
                                                      Nearbylocations.length -
                                                                  1 ==
                                                              position
                                                          ? 100
                                                          : 0),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Container(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: <Widget>[
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Center(
                                                          child: Image.asset(
                                                            Images.bike,
                                                            height: SizeConfig
                                                                    .safeBlockHorizontal *
                                                                50,
                                                            width: SizeConfig
                                                                    .safeBlockHorizontal *
                                                                40,
                                                            fit: BoxFit
                                                                .fitHeight,
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: <Widget>[
                                                            SizedBox(
                                                              width: SizeConfig
                                                                      .safeBlockHorizontal *
                                                                  80,
                                                              child:
                                                                  new GestureDetector(
                                                                onTap: () {
                                                                  gotoHomemap(
                                                                      position);
                                                                },
                                                                child:
                                                                    new Container(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              14),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: Colorss
                                                                        .white,
                                                                    borderRadius:
                                                                        BorderRadius.all(
                                                                            Radius.circular(15.0)),
                                                                    gradient:
                                                                        LinearGradient(
                                                                      // Where the linear gradient begins and ends
                                                                      begin: Alignment
                                                                          .centerLeft,
                                                                      end: Alignment
                                                                          .centerRight,
                                                                      // Add one stop for each color. Stops should increase from 0 to 1
                                                                      colors: [
                                                                        Colorss
                                                                            .buttongradient1,
                                                                        Colorss
                                                                            .buttongradient2,
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  child:
                                                                      new Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .center,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: <
                                                                        Widget>[
                                                                      RichText(
                                                                        text:
                                                                            TextSpan(
                                                                          text: languageHome != null
                                                                              ? "" + languageHome.lbl_distance.toString() + ' '
                                                                              : 'Distance ',
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                SizeConfig.safeBlockHorizontal * Dimens.text_4,
                                                                            fontStyle:
                                                                                FontStyle.normal,
                                                                            color:
                                                                                Colorss.fontColor,
                                                                          ),
                                                                          children: <
                                                                              TextSpan>[
                                                                            TextSpan(
                                                                                text: Nearbylocations != null && lansetting != null ? new Utilities().meterToKm(Nearbylocations[position].distance) + " " + lansetting.dis_unit : '',
                                                                                style: TextStyle(
                                                                                  fontSize: SizeConfig.safeBlockHorizontal * Dimens.text_4_5,
                                                                                  fontWeight: FontWeight.w700,
                                                                                )),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                                height: 8.0),
                                                            Padding(
                                                              padding: const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      8.0,
                                                                  vertical:
                                                                      4.0),
                                                              child: Text(
                                                                Nearbylocations !=
                                                                        null
                                                                    ? Nearbylocations[position]
                                                                            .geofencingIddata
                                                                            .name +
                                                                        ""
                                                                    : '',
                                                                maxLines: 1,
                                                                style: TextStyle(
                                                                    fontSize: SizeConfig
                                                                            .safeBlockHorizontal *
                                                                        Dimens
                                                                            .text_4,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left: 8.0,
                                                                      right: 8),
                                                              child: Text(
                                                                Nearbylocations[
                                                                            position]
                                                                        .geofencingIddata
                                                                        .address
                                                                        .toString() +
                                                                    "",
                                                                maxLines: 3,
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: SizeConfig
                                                                          .safeBlockHorizontal *
                                                                      Dimens
                                                                          .text_3,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ));
                                      },
                                    ),
                                  ),
                                ),
                              )
                            : new Container()
                      ],
                    ),
                  )),
              new Positioned(
                  top: 50,
                  left: 0,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: EdgeInsets.only(left: 25, right: 25),
                      child: new Icon(
                        Icons.arrow_back_rounded,
                        size: SizeConfig.safeBlockHorizontal * Dimens.text_7,
                        color: Colorss.white,
                      ),
                    ),
                  )),
              if (isProgressShow)
                new Positioned(
                    child: new Center(child: CircularProgressIndicator())),
            ],
          ),
        ),
      ),
    ); // This trailing comma makes auto-formatting nicer for build methods.
  }
}
