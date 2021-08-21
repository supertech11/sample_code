import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:xplor/AuthScreen/Login.dart';
import 'package:xplor/util/Colorss.dart';
import 'package:xplor/util/Dimens.dart';
import 'package:xplor/util/SizeConfig.dart';
import 'package:xplor/util/images.dart';
import 'package:xplor/Model/LanguageResponce.dart';

class InitSlider extends StatefulWidget {
  InitSlider({Key key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<InitSlider> {
  _ProfilePageState();

  bool isProgressShow = true;

  @override
  void initState() {
    super.initState();
    getUserInfo();

  }

  getUserInfo() async {
    prefs = await SharedPreferences.getInstance();
    getDataLanguage();
  }

  _selectPlayer(code, refrence_type) {}

  void _selectPlayermenu() {}

  bool validate_code = false;
  String msgcode = "";

  var prefs;
  int _current = 0;
  final List<String> imgList = [
    "https://res.cloudinary.com/dmnsalontechunity/image/upload/v1602159842/dmn/20171009_114200_g4ce45.jpg",
    "https://res.cloudinary.com/dmnsalontechunity/image/upload/v1602159842/dmn/20200430_182942_kw8jfd.jpg",
    "https://res.cloudinary.com/dmnsalontechunity/image/upload/v1602159842/dmn/20200302_094107_krrz77.jpg",
    "https://res.cloudinary.com/dmnsalontechunity/image/upload/v1602159842/dmn/20200429_190924_mfecuh.jpg",
    "https://res.cloudinary.com/dmnsalontechunity/image/upload/v1602159842/dmn/1_pa1tao.jpg",
    "https://res.cloudinary.com/dmnsalontechunity/image/upload/v1602159842/dmn/20200713_150459_issxbr.jpg",
  ];

  final List<String> imgList2 = [Images.electric_scooter_backside, Images.electric_scooter_backside];
  List<String> titleList = ['', ''];
  List<String> subList = ['', ''];

  var language;

  getDataLanguage() async {
    prefs = await SharedPreferences.getInstance();
    var data = prefs.getString('languageData');
    Map langMap = jsonDecode(data.toString());
    var lanRes = LanguageResponce.parseLanguage(langMap);
    language = lanRes.result.data;
    titleList = [
      language.Onboarding1.lbl_locate,
      language.Onboarding2.lbl_unlock,
      language.Onboarding3.lbl_ride
    ];
    subList = [
      language.Onboarding1.lbl_intro,
      language.Onboarding2.lbl_intro2,
      language.Onboarding3.lbl_intro3
    ];

    setState(() => isProgressShow = false);
  }

  final CarouselController _controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: new Stack(
        children: <Widget>[
          if (isProgressShow != true)
            Container(
              decoration: BoxDecoration(
                color: Colorss.black,
              ),
              child: new Container(
                child: new Column(
                  children: <Widget>[
                    CarouselSlider(
                      carouselController: _controller,
                      items: imgList2
                          .map((item) => Container(
                                child: new Stack(children: [
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        width:SizeConfig.safeBlockHorizontal * 85,
                                        height: SizeConfig.safeBlockVertical * 70,
                                        child: new Image.asset(
                                          item,
                                          fit: BoxFit.fill,
                                        ),
                                      ),

                                    ],
                                  ),


                                  new Positioned( top:0,bottom:0,
                                    left: SizeConfig
                                        .safeBlockHorizontal*40,

                                    right:15,child:           new Container(

                                    margin: EdgeInsets.only(
                                      top: 0,
                                    ),
                                    child: new Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: <Widget>[

                                    new SizedBox(
                                    width: SizeConfig
                                      .safeBlockHorizontal*60,
                                      child:
                                      new Text(titleList[_current]+"",
                                            textAlign: TextAlign.start,
                                            style: TextStyle(

                                                fontSize: SizeConfig
                                                    .safeBlockHorizontal *
                                                    Dimens.text_5,
                                                fontWeight: FontWeight.w700,
                                                color: Colorss.fontColor)),),
                                        _current==0? new SizedBox(
                                         width: SizeConfig
                                             .safeBlockHorizontal*60,
                                         child: new Column(children: [

                                           new Padding(
                                             padding: EdgeInsets.only(top: 15),
                                             child: new Text(_current==0 && language!=null?  language.Onboarding1.lbl_Message1+"":"",
                                                 textAlign: TextAlign.start,
                                                 style: TextStyle(
                                                     fontSize: SizeConfig
                                                         .safeBlockHorizontal *
                                                         Dimens.text_3,
                                                     fontWeight: FontWeight.w400,
                                                     color: Colorss.fontColor)),
                                           ),
                                           new Padding(
                                             padding: EdgeInsets.only(top: 3),
                                             child: new Text(_current==0 && language!=null?  language.Onboarding1.lbl_Message2+"":"",
                                                 textAlign: TextAlign.start,
                                                 style: TextStyle(
                                                     fontSize: SizeConfig
                                                         .safeBlockHorizontal *
                                                         Dimens.text_3,
                                                     fontWeight: FontWeight.w400,
                                                     color: Colorss.fontColor)),
                                           ),
                                           new Padding(
                                             padding: EdgeInsets.only(top: 3),
                                             child: new Text(_current==0 && language!=null?  language.Onboarding1.lbl_Message3+"":"",
                                                 textAlign: TextAlign.start,
                                                 style: TextStyle(
                                                     fontSize: SizeConfig
                                                         .safeBlockHorizontal *
                                                         Dimens.text_3,
                                                     fontWeight: FontWeight.w400,
                                                     color: Colorss.fontColor)),
                                           ),
                                           new Padding(
                                             padding: EdgeInsets.only(top: 3),
                                             child: new Text(_current==0 && language!=null?  language.Onboarding1.lbl_Message4+"":"",
                                                 textAlign: TextAlign.start,
                                                 style: TextStyle(
                                                     fontSize: SizeConfig
                                                         .safeBlockHorizontal *
                                                         Dimens.text_3,
                                                     fontWeight: FontWeight.w400,
                                                     color: Colorss.fontColor)),
                                           ),

                                       ],),):
                                        new SizedBox(
                                          width: SizeConfig
                                              .safeBlockHorizontal*60,
                                          child: new Column(children: [

                                            new Padding(
                                              padding: EdgeInsets.only(top: 15),
                                              child: new Text(_current==1 && language!=null?  language.Onboarding2.lbl_Message1.toString()+"":"",
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                      fontSize: SizeConfig
                                                          .safeBlockHorizontal *
                                                          Dimens.text_3,
                                                      fontWeight: FontWeight.w400,
                                                      color: Colorss.fontColor)),
                                            ),
                                            new Padding(
                                              padding: EdgeInsets.only(top: 3),
                                              child: new Text(_current==1 && language!=null?  language.Onboarding2.lbl_Message2.toString()+"":"",
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                      fontSize: SizeConfig
                                                          .safeBlockHorizontal *
                                                          Dimens.text_3,
                                                      fontWeight: FontWeight.w400,
                                                      color: Colorss.fontColor)),
                                            ),
                                            new Padding(
                                              padding: EdgeInsets.only(top: 3),
                                              child: new Text(_current==1 && language!=null?  language.Onboarding2.lbl_Message3.toString()+"":"",
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                      fontSize: SizeConfig
                                                          .safeBlockHorizontal *
                                                          Dimens.text_3,
                                                      fontWeight: FontWeight.w400,
                                                      color: Colorss.fontColor)),
                                            ),


                                          ],),)
                                      ],
                                    ),
                                  ),)

                                ],),
                              ))
                          .toList(),
                      options: CarouselOptions(
                          height: height,
                          viewportFraction: 1.0,
                          autoPlay: false,
                          aspectRatio: 2.0,
                          onPageChanged: (index, reason) {
                            setState(() {
                              _current = index;
                            });
                            print("_current"+_current.toString());
                            if(_current==0){
                             goToLogin();
                            }

                          }),
                    ),
                  ],
                ),
              ),
            ),
          if (isProgressShow != true)
            new Positioned(
              bottom: 10,
              right: 0,
              left: 0,
              child: new Container(
                color: Colors.transparent,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                  child: new Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: new Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              new GestureDetector(
                                onTap: () {
                                  goToLogin();
                                },
                                child: new Padding(
                                  padding: EdgeInsets.only(left: 15,right: 15),
                                  child: new Text(
                                      language != null
                                          ? language.Onboarding1.lbl_skip
                                          : "Skip",
                                      style: TextStyle(
                                          fontSize:
                                              SizeConfig.safeBlockHorizontal *
                                                  Dimens.text_4,
                                          fontStyle: FontStyle.normal,
                                          fontWeight: FontWeight.w500,
                                          color: Colorss.fontColor)),
                                ),
                              ),
                            ]),
                      ),
                      Expanded(
                        flex: 1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: imgList2.map((url) {
                            int index = imgList2.indexOf(url);
                            return Container(
                              width: 8.0,
                              height: 8.0,
                              margin: EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 2.0),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _current == index
                                    ? Colorss.fontColor
                                    : Colorss.fontColor,
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: new Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              new GestureDetector(
                                onTap: () {
                                  if (_current == 1) {
                                    goToLogin();
                                  } else {
                                    setState(() {
                                      _current == _current + 1;
                                    });
                                    _controller.nextPage();
                                  }
                                },
                                child: new Padding(
                                  padding: EdgeInsets.only(right: 15,left:15),
                                  child: new Text(
                                      language != null
                                          ? (_current == 1)
                                              ? language.Onboarding3.lbl_end
                                              : language.Onboarding1.lbl_next
                                          : "Next",
                                      style: TextStyle(
                                          fontSize:
                                              SizeConfig.safeBlockHorizontal *
                                                  Dimens.text_4,
                                          fontStyle: FontStyle.normal,
                                          fontWeight: FontWeight.w500,
                                          color: Colorss.fontColor)),
                                ),
                              ),
                            ]),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          new Positioned(
              top: 0,
              bottom: 0,
              right: 0,
              left: 0,
              child: new Container(
                  child: new Center(
                child: isProgressShow
                    ? CircularProgressIndicator()
                    : new Container(),
              ))),
        ],
      ),
    );
  }

  goToLogin(){ Navigator.pushReplacement(
    context,
    MaterialPageRoute(
        builder: (context) => Login()),
  );

  }
}
