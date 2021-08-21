import 'package:flutter/material.dart';
import 'package:xplor/util/Dimens.dart';
import 'package:xplor/util/SizeConfig.dart';
import 'package:xplor/util/Colorss.dart';
import 'package:xplor/util/images.dart';
class TariffItem extends StatelessWidget {
  final String amount;
  final String distance;
  final bool isSelected;
  final VoidCallback onTap;
  const TariffItem({
    Key key,
    @required this.amount,
    @required this.distance,
    @required this.isSelected,
    @required this.onTap,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final _media = MediaQuery.of(context).size;
    return InkWell(
      child: Container(
        width: _media.width - 40,
        // height: 200,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
            ),
          ],
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: isSelected
              ? Border.all(
            color: Colorss.primary,
            width: 2,
          )
              : Border.all(
            color: Colors.white,
            width: 2,
          ),
        ),
        child: new Stack(
          children: [
            Padding(
              padding:
              const EdgeInsets.symmetric(vertical: 25.0, horizontal: 5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Text(
                      amount,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize:
                        SizeConfig.safeBlockHorizontal * Dimens.text_7,
                        fontWeight:
                        isSelected ? FontWeight.w700 : FontWeight.w400,
                      ),
                    ),
                  ),
                  // ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 2.0),
                    child: Text(
                      distance,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize:
                        SizeConfig.safeBlockHorizontal * Dimens.text_7,
                        fontWeight:
                        isSelected ? FontWeight.w700 : FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            isSelected
                ? Positioned(
              right: 5.0,
              bottom: 5.0,
              child: Center(
                child: Container(
                  child: Image.asset(
                    Images.check_icon,
                    width: SizeConfig.safeBlockHorizontal * 5,
                    height: SizeConfig.safeBlockHorizontal * 5,
                  ),
                ),
              ),
            )
                : Container(),
          ],
        ),
      ),
      onTap: onTap,
    );
  }
}