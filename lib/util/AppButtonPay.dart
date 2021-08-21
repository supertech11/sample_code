import 'package:flutter/material.dart';
import 'package:xplor/util/Dimens.dart';

import 'Colorss.dart';
import 'SizeConfig.dart';



class AppButtonPay extends StatelessWidget {
  String title;
  Function onButtonClick;
  double fontSize;

  AppButtonPay({Key key, this.title,this.onButtonClick ,this.fontSize})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return new GestureDetector(
    onTap: (){
      this.onButtonClick();
    }

    ,child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
elevation: 10,
        child:Container(
          decoration: BoxDecoration(
            color:  Colorss.gradient1,
            borderRadius: BorderRadius.all( Radius.circular(20.0) ),
            gradient: LinearGradient(
              // Where the linear gradient begins and ends
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              // Add one stop for each color. Stops should increase from 0 to 1
              colors: [
                Colorss.buttongradient1,
                Colorss.buttongradient2,
              ],
            ),


          ),
          padding: EdgeInsets.all(10),
          child: new Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[

              Padding(
                padding: EdgeInsets.only(left: 15),
                child: Text(
                  title,
                  style: TextStyle(
                      color: Colorss.fontColor,
                      fontSize: fontSize!=null?fontSize:  SizeConfig.blockSizeHorizontal * Dimens.text_3_5,

                      fontWeight: FontWeight.w500),
                ),
              ),

            ],
          ),
        )),);
  }
}
