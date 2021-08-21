import 'package:flutter/material.dart';
import 'package:xplor/util/Dimens.dart';
import 'package:xplor/util/SizeConfig.dart';

class SupportLine extends StatelessWidget {
  final String label;
  final String detail;
  // final VoidCallback onTap;

  const SupportLine({
    Key key,
    @required this.label,
    @required this.detail,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Row(
          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
                child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
              child: Text(
                label +"",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: SizeConfig.safeBlockHorizontal * Dimens.text_3_5
                    // fontWeight: FontWeight.bold,
                    ),
              ),
            )),
            Expanded(
                child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
              child: Text(
                detail+"",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: SizeConfig.safeBlockHorizontal * Dimens.text_3_5
                    // fontWeight: FontWeight.bold,
                    ),
              ),
            )),
          ]),
      // ),
      // onTap: onTap,
    );
  }
}
