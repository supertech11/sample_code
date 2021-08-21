import 'package:flutter/material.dart';
import 'package:xplor/util/Dimens.dart';

import 'Colorss.dart';
import 'SizeConfig.dart';



class AppHeader extends StatelessWidget {
  String title;
  Function onBackClick;
  double fontSize;

  AppHeader({Key key, this.title,this.onBackClick ,this.fontSize})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return new  Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            GestureDetector(
              onTap: () {
                this.onBackClick();
              },
              child: Padding(
                padding: EdgeInsets.only(
                    top: SizeConfig.safeBlockVertical * 4,
                    left: 25,
                    right: 25),
                child: new Icon(
                  Icons.arrow_back_rounded,
                  size: SizeConfig.safeBlockHorizontal *
                      Dimens.text_7,
                  color: Colorss.white,
                ),
              ),
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                  top: SizeConfig.safeBlockVertical,
                  left: 25,
                  right: 25),
              child: Text(
                title,
                style: TextStyle(
                    fontSize: SizeConfig.safeBlockHorizontal *
                        Dimens.text_7,
                    fontWeight: FontWeight.w600,
                    color: Colorss.white),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
