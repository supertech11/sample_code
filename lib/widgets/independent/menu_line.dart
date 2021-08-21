import 'package:flutter/material.dart';
import 'package:xplor/util/Dimens.dart';
import 'package:xplor/util/SizeConfig.dart';
import 'package:xplor/util/Colorss.dart';
import 'package:xplor/widgets/independent/custom_switch.dart';

class OpenFlutterMenuLine extends StatelessWidget {
  final String title;
  final String subtitle;
  final double fontSize;
  final VoidCallback onTap;
  final bool showBackIcon;
  final bool showToggle;
  final bool enable ;

  const OpenFlutterMenuLine(
      {Key key,
      @required this.title,
      this.subtitle,
      @required this.onTap,
      this.showBackIcon,
      this.showToggle,
      this.fontSize,this.enable})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.only(top: 10.0,bottom: 10),
        child: Container(
          decoration: BoxDecoration(
              border: Border(
            bottom: BorderSide(
              color: Colorss.grey_color,
              // width: 1.0,
            ),
          )),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          title,
                          style: TextStyle(
                            color: Colorss.black,
                            fontSize: fontSize != null
                                ? fontSize
                                : SizeConfig.safeBlockHorizontal *
                                    Dimens.text_4,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        subtitle != null
                            ? Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Text(
                                  subtitle,
                                  style: TextStyle(
                                      color: Colorss.black,
                                      fontSize: SizeConfig.safeBlockHorizontal *
                                          Dimens.text_4,
                                      fontWeight: FontWeight.w600),
                                ),
                              )
                            : Container(),
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
                if (showToggle == true)
                  Align(
                    alignment: Alignment.centerRight,
                    child: CustomSwitch(
                      value: enable,
                      onChanged: (bool val) {
                       this.onTap();
                      },
                    ),
                  ),
              ]),
        ),
      ),
      // ),
      onTap:showToggle == true?null: onTap,
    );
  }
}
