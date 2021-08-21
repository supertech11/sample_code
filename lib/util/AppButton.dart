import 'package:flutter/material.dart';
import 'package:xplor/util/Dimens.dart';

import 'Colorss.dart';
import 'SizeConfig.dart';
import 'package:xplor/util/images.dart';
class AppButton extends StatelessWidget {
  String title,languageValue="";
  Function onButtonClick;
  double fontSize;
  bool showIcon;

  AppButton(
      {Key key, this.title, this.onButtonClick, this.fontSize, this.showIcon,this.languageValue})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return new GestureDetector(
      onTap: () {
        this.onButtonClick();
      },
      child: showIcon
          ? Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              elevation: 10,
              child: new Stack(children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colorss.gradient1,
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
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

                  child: new Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                     SizedBox(
                       width: SizeConfig.safeBlockHorizontal * 90-80,
                       child:  Center(

                       child: Padding(
                         padding: EdgeInsets.only(top: 18, bottom: 18),
                         child:  Text(
                           title+"",
                           style: TextStyle(
                               color: Colorss.fontColor,
                               fontSize: fontSize != null
                                   ? fontSize
                                   : SizeConfig.blockSizeHorizontal *
                                   Dimens.text_3_5,

                               fontWeight: FontWeight.w500),
                         ),
                       )
                        ,
                     ),)
                    ],
                  ),
                ),
                
                new Positioned(
                    left:languageValue=="en"? 35:null,
                    right: languageValue!="en"?35:null,
                    bottom: 0,
                    top: 0,
                    child:    new Container(child: Image.asset(
                      Images.qr_code,
                      height: 35,
                      width: 35,
                      fit:
                      BoxFit.contain,
                    ),))
              ],),
            )
          : Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              elevation: 10,
              child: Container(
                decoration: BoxDecoration(
                  color: Colorss.gradient1,
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
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
                padding: EdgeInsets.only(top: 18, bottom: 18),
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
                            fontSize: fontSize != null
                                ? fontSize
                                : SizeConfig.blockSizeHorizontal *
                                    Dimens.text_3_5,

                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              )),
    );
  }
}
