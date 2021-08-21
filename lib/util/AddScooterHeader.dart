import 'package:flutter/material.dart';
import 'package:xplor/util/Dimens.dart';

import 'Colorss.dart';
import 'SizeConfig.dart';



class AddScooterHeader extends StatelessWidget {
  String title;
  Function onBackClick;
  double fontSize;

  AddScooterHeader({Key key, this.title,this.onBackClick ,this.fontSize})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return new  Column(
      children: <Widget>[

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
