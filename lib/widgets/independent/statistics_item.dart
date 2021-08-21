import 'package:flutter/material.dart';
import 'package:xplor/util/Colorss.dart';
import 'package:xplor/util/SizeConfig.dart';
import 'package:xplor/util/Dimens.dart';

class StatisticItem extends StatelessWidget {
  final String title;
  final String value;
  final String sign;
  final VoidCallback onTap;
  final IconData icon;
  final Color iconColor;

  const StatisticItem(
      {Key key,
      @required this.title,
      @required this.value,
      @required this.sign,
      @required this.icon,
      @required this.iconColor,
      @required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _media = MediaQuery.of(context).size;

    return InkWell(
      child: Container(
        width: _media.width - 40,
        // height: 200,
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
          ),
        ], color: Colors.white, borderRadius: BorderRadius.circular(20)),
        child: ListTile(
          contentPadding: EdgeInsets.all(10.0),
          leading: Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 5.0),
            child: new Icon(
              icon,
              size: SizeConfig.safeBlockHorizontal * Dimens.text_7,
              color: iconColor,
            ),
          ),
          title: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text(
              title,
              style: TextStyle(
                color: Colors.black38,
                fontSize: SizeConfig.safeBlockHorizontal * Dimens.text_3_5,
              ),
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.all(4.0),
            child: RichText(
              maxLines: 3,
              text: TextSpan(
                text: value+"",

                style: TextStyle(
                    color: Colors.black,
                    fontSize: SizeConfig.safeBlockHorizontal * Dimens.text_7,
                    fontWeight: FontWeight.w600,
                   ),
                children: <TextSpan>[
                  TextSpan(
                      text: sign,
                      style: TextStyle(
                        fontSize:
                            SizeConfig.safeBlockHorizontal * Dimens.text_3_5,
                        fontWeight: FontWeight.w600,
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
      onTap: onTap,
    );
  }
}
