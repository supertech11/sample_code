import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:xplor/util/Dimens.dart';
import 'package:xplor/util/SizeConfig.dart';
import 'package:xplor/util/Colorss.dart';
import 'package:xplor/util/images.dart';

class GlassWeatherCard extends StatelessWidget {
  final String weather;
  final String weather_detail;
  final String date;
  final String image;
  final VoidCallback onTap;

  const GlassWeatherCard({
    Key key,
    @required this.weather,
    @required this.weather_detail,
    @required this.date,
    @required this.image,
    @required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _media = MediaQuery.of(context).size;

    return InkWell(
      child: Container(
        height: 200,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(children: [
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.6),
                          gradient: LinearGradient(
                              colors: [
                                Colors.white.withOpacity(0.6),
                                Colors.white.withOpacity(0.6)
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight),
                          border:
                              Border.all(color: Colors.white.withOpacity(0.08)),
                          borderRadius: BorderRadius.circular(10)),
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Image.asset(
                                  Images.cloudly,
                                  height: 100,
                                  // width: 50,
                                  fit: BoxFit.fill,
                                ),
                                Expanded(child: Container(
                                  padding: const EdgeInsets.all(16.0),

                                  child: new Column(
                                    children: <Widget>[
                                      RichText(
                                        text: TextSpan(
                                          text: weather,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: SizeConfig
                                                .safeBlockHorizontal *
                                                Dimens.text_7,
                                            fontWeight: FontWeight.w400,
                                          ),
                                          children: <TextSpan>[
                                            TextSpan(
                                                text: weather_detail,
                                                style: TextStyle(
                                                  fontSize: SizeConfig
                                                      .safeBlockHorizontal *
                                                      Dimens.text_4,
                                                  fontWeight: FontWeight.w300,
                                                )),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                              ],
                            ),
                          ),
                          Positioned(
                            // top: 10,
                            bottom: 0.0,
                            child: Container(
                              height: constraints.maxHeight * 0.30,
                              width: constraints.maxWidth,
                              child: MaterialButton(
                                onPressed: () {},
                                colorBrightness: Brightness.light,
                                splashColor: Colors.black,
                                color: Colorss.date_button,
                                textColor: Colors.black45,
                                elevation: 10,
                                padding: const EdgeInsets.only(
                                    top: 15.0, bottom: 15),
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(30))),
                                child: Text(
                                  date,
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: SizeConfig.safeBlockHorizontal *
                                        Dimens.text_4_5,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ]);
          },
        ),
      ),
      onTap: onTap,
    );
  }
}
