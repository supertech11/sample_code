import 'package:flutter/material.dart';
import 'package:xplor/util/Dimens.dart';
import 'package:xplor/util/SizeConfig.dart';
import 'package:xplor/util/Colorss.dart';
import 'package:xplor/widgets/independent/custom_switch.dart';

class OpenFlutterLanguageLine extends StatelessWidget {
  final String title;
  final String subtitle;
  final double fontSize;
  final VoidCallback onTap;
  final bool showBackIcon;

  final bool enable ;

  const OpenFlutterLanguageLine(
      {Key key,
      @required this.title,
      this.subtitle,
      @required this.onTap,
      this.showBackIcon,

      this.fontSize,this.enable})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0,bottom: 8,left: 10,right: 1),
      child: Container(

        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                          padding: const EdgeInsets.only(top: 0),
                          child:  Text(
                            title,
                            style: TextStyle(
                              color: Colorss.black,
                              fontSize: fontSize != null
                                  ? fontSize
                                  : SizeConfig.safeBlockHorizontal *
                                  Dimens.text_4,
                              fontWeight: FontWeight.w400,
                            ),
                          )
                      )
                      ,

                    ]),
              ),
              if (showBackIcon == true)
                Align(
                  alignment: Alignment.centerRight,
                  child: new Icon(
                    Icons.chevron_right,
                    color: Colorss.grey_color,
                    size: 28,
                  ),
                ),

            ]),
      ),
    );
  }
}
