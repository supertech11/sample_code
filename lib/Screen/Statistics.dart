import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xplor/Model/ApiResponce.dart';
import 'package:xplor/Model/LanguageResponce.dart';
import 'package:xplor/Screen/RideHistory.dart';
import 'package:xplor/util/ApiControler.dart';
import 'package:xplor/util/AppHeader.dart';

import 'package:xplor/util/Colorss.dart';
import 'package:xplor/util/Dimens.dart';
import 'package:xplor/util/SizeConfig.dart';
import 'package:xplor/util/Strings.dart';
import 'package:xplor/util/utilities.dart';
import 'package:xplor/widgets/independent/statistics_item.dart';
class Statistics extends StatefulWidget {
  Statistics({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _StatisticsPageState createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<Statistics> {
  var profile;
  bool isProgressShow = false;

  @override
  void initState() {
    super.initState();
    getDataLanguage();
  }

  getMystatistic() async {
    final prefs = await SharedPreferences.getInstance();
    var authToken = prefs.getString('authToken');
    var id = prefs.getString('id');
    setState(() {
      isProgressShow = true;
    });
    var dio = Dio();
    dio.interceptors.add(LogInterceptor(requestBody: true));

    new ApiControler()
        .dioAuthGet(context, authToken, Strings.mystatistic + "/" + id, {
      "authToken": authToken,
    }).then((onValue) {
      parseMystatistic(onValue);
    });
  }

  var mystatisticData;

  parseMystatistic(reply) async {
    setState(() {
      isProgressShow = false;
    });

    if (reply != null) {
      Map userMap = jsonDecode(reply);
      var user = ApiResponce.fromJson(userMap);
      if (user.success) {
        mystatisticData = ApiResponce.parseMystatistic(userMap);
      } else {
        new Utilities()
            .showAlertDialog(context, Strings.alert, user.result.message, "OK");
        // print('Howdy, ${user.code} ${user.msg}!');
      }
    }
  }

  getallbookingbyuserid() async {
    var authToken = prefs.getString('authToken');
    var id = prefs.getString('id');
    setState(() {
      // isProgressShow = true;
    });
    var dio = Dio();
    dio.interceptors.add(LogInterceptor(requestBody: true));

    new ApiControler().dioAuthGet(
        context, authToken, Strings.getallbookingbyuserid + "/" + id, {
      "authToken": authToken,
    }).then((onValue) {
      parsegetallOffers(onValue);
    });
  }

  var offerData;

  parsegetallOffers(reply) async {
    setState(() {
//      isProgressShow = false;
    });

    if (reply != null) {
      Map userMap = jsonDecode(reply);
      var user = ApiResponce.fromJson(userMap);
      if (user.success) {
        var data = ApiResponce.parseOfferList(userMap);
        offerData = data.result.datalist;
      } else {
        new Utilities()
            .showAlertDialog(context, Strings.alert, user.result.message, "OK");
        // print('Howdy, ${user.code} ${user.msg}!');
      }
    }
  }

  var prefs;
  var lanRes, lansetting;

  getDataLanguage() async {
    setState(() {
      isProgressShow = true;
    });
    prefs = await SharedPreferences.getInstance();
    var data = prefs.getString('languageData');
    Map langMap = jsonDecode(data.toString());

//
//    var now2 = new DateTime.now();
//    //var now3 = new DateFormat("yyyy-MM-dd HH:mm:ss").format(now2);
//    String rideStartdate = new DateFormat("yyyy-MM-dd HH:mm:ss").format(now2);
//    prefs.setString('rideStartdate', rideStartdate.toString());
//    prefs.setString('perMinuteCharge', "2".toString());
//    print("ridestartdate>> "+rideStartdate);
//    print("ridestartdate dddd>> "+  prefs.getString('rideStartdate'));
//    print("perMinuteCharge>> "+ prefs.getString('perMinuteCharge'));

    lanRes = LanguageResponce.parseLanguage(langMap);
    lansetting = lanRes.result.data.Settings;

    if (lanRes != null) {
      setState(() {
        isProgressShow = false;
      });
      print('lbl_Duration' + lanRes.result.data.MyStatistics.lbl_Duration);
    }
    // getallbookingbyuserid();
    getMystatistic();
  }

  void showRideHistory() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RideHistory()),
    );
    //validate();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Material(
          color: Colorss.primary,
          child: new Stack(
            children: <Widget>[
              new Container(
                  decoration: BoxDecoration(
                    color: Colorss.gradient1,
                    gradient: LinearGradient(
                      // Where the linear gradient begins and ends
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      // Add one stop for each color. Stops should increase from 0 to 1
                      colors: [
                        Colorss.hgradient1,
                        Colorss.hgradient2,
                      ],
                    ),
                  ),
                  child: new ListView(
                    children: <Widget>[
                      new Container(
                          child: AppHeader(
                        title: lanRes != null
                            ? lanRes.result.data.navigation.lbl_Statistics
                            : Strings.my_statistics,
                        onBackClick: () {
                          Navigator.pop(context);
                        },
                      ))
                    ],
                  )),
              new Positioned(
                  top: SizeConfig.safeBlockVertical * 27,
                  child: new Container(
                    margin: EdgeInsets.only(),
                    padding: EdgeInsets.only(left: 25, right: 25),
                    height: SizeConfig.safeBlockVertical * 90,
                    width: SizeConfig.safeBlockHorizontal * 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(55.0),
                          bottomLeft: Radius.circular(0.0)),
                    ),
                    child: new Column(
                      children: <Widget>[],
                    ),
                  )),
              new Positioned(
                top: SizeConfig.safeBlockVertical * 17,
                child: new Container(
                  margin: EdgeInsets.only(top: 0),
                  height: SizeConfig.safeBlockVertical * 90,
                  width: SizeConfig.safeBlockHorizontal * 100,
                  child: new Column(
                    children: <Widget>[
                      new Container(
                        padding: EdgeInsets.only(left: 25, right: 25),
                        child: new Column(
                          children: [
                            SizedBox(
                              height: 30.0,
                            ),
                            StatisticItem(
                                title: lanRes != null
                                    ? lanRes
                                        .result.data.MyStatistics.lbl_Duration
                                    : Strings.duration,
                                icon: Icons.access_time,
                                iconColor: Colorss.purpal,
                                value: mystatisticData != null
                                    ? mystatisticData.result.Duration != null &&
                                            mystatisticData.result.Duration !=
                                                "null"
                                        ? mystatisticData.result.Duration
                                        : "0"
                                    : "0",
                                sign: lansetting != null
                                    ? " " + lansetting.time_unit
                                    : ' mins',
                                onTap: (() => {})),
                            SizedBox(
                              height: 30.0,
                            ),
                            StatisticItem(
                                title: lanRes != null
                                    ? lanRes
                                        .result.data.MyStatistics.lbl_Distance
                                    : Strings.distance,
                                icon: Icons.alt_route,
                                iconColor: Colorss.orange,
                                value: mystatisticData != null
                                    ? new Utilities().meterToKm(
                                        mystatisticData.result.Distance)
                                    : "0",
                                sign: lansetting != null
                                    ? " " + lansetting.dis_unit
                                    : ' km',
                                onTap: (() => {
                                      // widget.changeView(
                                      //   changeType: ViewChangeType.Exact, index: 3)
                                    })),
                            SizedBox(
                              height: 30.0,
                            ),
                          ],
                        ),
                      ),
                      new Container(
                        width: SizeConfig.safeBlockHorizontal * 70,
                        margin: EdgeInsets.only(
                            top: SizeConfig.safeBlockVertical * 20, bottom: 5),
                        child: new MaterialButton(
                          onPressed: showRideHistory,
                          colorBrightness: Brightness.light,
                          splashColor: Colors.white,
                          color: Colors.black,
                          textColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.only(top: 18.0, bottom: 18),
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30))),
                          child: new Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              new Text(
                                  lanRes != null
                                      ? lanRes.result.data.MyStatistics
                                          .btn_RideHistory
                                      : Strings.ride_history,
                                  style: TextStyle(
                                      fontSize: SizeConfig.safeBlockHorizontal *
                                          Dimens.text_4,
                                      fontWeight: FontWeight.w500,
                                      fontStyle: FontStyle.normal,
                                      color: Colors.white)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (isProgressShow)
                new Positioned(
                    child: new Center(child: CircularProgressIndicator()))
            ],
          )),
    ); // This trailing comma makes auto-formatting nicer for build methods.
  }
}
