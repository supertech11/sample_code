import 'package:flutter/material.dart';
import 'package:xplor/util/Dimens.dart';
import 'package:xplor/util/SizeConfig.dart';
import 'package:xplor/util/Colorss.dart';
import 'package:xplor/util/images.dart';

class PayItem extends StatelessWidget {
  final String name;
  final String image;
  final bool isSelected;
  final VoidCallback onTap;

  const PayItem({
    Key key,
    @required this.name,
    @required this.image,
    @required this.isSelected,
    @required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _media = MediaQuery.of(context).size;
    return InkWell(
      child: Container(
        width: _media.width - 40,
        child: CheckboxListTile(
          title: Container(
            decoration: BoxDecoration(
                border: Border(
              bottom: BorderSide(
                color: Colors.black12,
                // width: 1.0,
              ),
            )),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(name),
                  Image.asset(
                    image,
                    width: 50,
                  ),
                ],
              ),
            ),
          ),
          value: isSelected,
          onChanged: (newValue) {
            // setState(() {
            //   checkedValue = newValue;
            // });
          },
          controlAffinity:
              ListTileControlAffinity.leading, //  <-- leading Checkbox
        ),
      ),
      onTap: onTap,
    );
  }
}
