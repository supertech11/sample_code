import 'package:flutter/material.dart';
import 'package:xplor/util/Colorss.dart';

import 'package:xplor/util/SizeConfig.dart';

import 'Dimens.dart';

class Item {
  const Item(this.name, this.icon);

  final String name;
  final Icon icon;
}

class CustomAppBar3 extends StatelessWidget {
  CustomAppBar3({
    Key key,
    this.title,
    this.languageValue,
    this.onClickMenu,
    this.onClickNotification,
  }) : super(key: key);
  final Function onClickMenu, onClickNotification;

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title, languageValue;

  void onSkip() {}

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

    return new Container(
      color: Colorss.black,
      child: Row(
        children: <Widget>[
          new Container(
            width: SizeConfig.safeBlockHorizontal * 65,
            child: new Text(title.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize:
                        SizeConfig.safeBlockHorizontal * Dimens.text_4)),
          ),

          IconButton(
              icon: new Icon(Icons.notifications,size: 35,),
              color: Colors.white,
              onPressed: () => {onClickNotification()}),
//          new Container(
//              child:_threeItemPopup()
//          )

        ],
      ),
    );
    // This trailing comma makes auto-formatting nicer for build methods.
  }
}
