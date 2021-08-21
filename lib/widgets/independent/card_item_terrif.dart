import 'package:flutter/material.dart';
import 'package:xplor/util/SizeConfig.dart';
import 'package:xplor/util/images.dart';

class CreditCardTerrif extends StatelessWidget {
  final String color;
  final String image;
  final String value,title;

  CreditCardTerrif({this.color, this.image, this.value,this.title});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return new Row(
    mainAxisAlignment: MainAxisAlignment.center
    ,children: [
     Container(
        width: SizeConfig.safeBlockHorizontal *90,
        decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(image),
              fit: BoxFit.cover,
            ),

           ),

        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Image.asset(
                    Images.master_card,
                    width: 80,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 50,
            ),
            Row(
              children: <Widget>[
                Column(
                  children: [
                   SizedBox(
                     width: SizeConfig.safeBlockHorizontal *90,

                     child:  Padding(
                     padding: const EdgeInsets.only(left: 16.0,right: 16),
                     child: Text(title,
                         textAlign: TextAlign.start,
                         style: TextStyle(
                           color: Colors.black,
                           fontSize: 20,
                         )),
                   ),),
                    SizedBox(
                      width: SizeConfig.safeBlockHorizontal *90,

                      child:   Padding(
                      padding: const EdgeInsets.only(top: 4.0, left: 16.0,right: 16),
                      child: Text(
                       value,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 22,
                            fontWeight: FontWeight.w700),
                      ),
                    ),)
                  ],
                ),
              ],
            )
          ],
        ),
      )

    ],);
  }
}
