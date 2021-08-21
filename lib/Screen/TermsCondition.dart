import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/html_parser.dart';
import 'package:flutter_html/style.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xplor/Model/ApiResponce.dart';
import 'package:xplor/Model/LanguageResponce.dart';
import 'package:xplor/localization/language_constants.dart';
import 'package:xplor/util/ApiControler.dart';
import 'package:xplor/util/AppHeader.dart';
import 'package:xplor/util/Colorss.dart';
import 'package:xplor/util/Dimens.dart';
import 'package:xplor/util/SizeConfig.dart';
import 'package:xplor/util/Strings.dart';
import 'package:xplor/util/images.dart';

import 'package:xplor/widgets/independent/menu_line.dart';
import 'package:xplor/widgets/independent/pay_item.dart';

class TermsCondition extends StatefulWidget {
  TermsCondition({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<TermsCondition> {
  var profile;
  var prefs;
  var lanRes, languageValue;

  @override
  void initState() {
    super.initState();
    getDataLanguage();
  }

  getDataLanguage() async {
    prefs = await SharedPreferences.getInstance();
    var data = prefs.getString('languageData');
    Map langMap = jsonDecode(data.toString());
    lanRes = LanguageResponce.parseLanguage(langMap);
    print(lanRes.result.data.Settings.lbl_firstname1);
    getTermsByLanguageId();
  }

  getTermsByLanguageId() async {
    final prefs = await SharedPreferences.getInstance();
    var authToken = prefs.getString('authToken');
    languageValue = prefs.getString(LAGUAGE_CODE) ?? "en";
    var id = languageValue == "en" ? "1" : "2";

    var dio = Dio();
    dio.interceptors.add(LogInterceptor(requestBody: true));

    new ApiControler()
        .dioGet(context, Strings.getTermsByLanguageId + "/" + id, {
      "authToken": authToken,
    }).then((onValue) {
      parse(onValue);
    });
  }

  var supportData;

  parse(reply) async {
    setState(() {});

    if (reply != null) {
      Map userMap = jsonDecode(reply);
      var user = ApiResponce.fromJson(userMap);
      if (user.success) {
        supportData = ApiResponce.parsePrivacyPolicyTermsResponce(userMap);
        htmlData = supportData.result.data.description;
        setState(() {});
      } else {}
    }
  }

  var htmlData = """
<div class=\"ql-editor\" data-gramm=\"false\" contenteditable=\"true\"><p></p></div><div class=\"ql-clipboard\" contenteditable=\"true\" tabindex=\"-1\"></div><div class=\"ql-tooltip ql-hidden\"><a class=\"ql-preview\" target=\"_blank\" href=\"about:blank\"></a><input type=\"text\" data-formula=\"e=mc^2\" data-link=\"https://quilljs.com\" data-video=\"Embed URL\"><a class=\"ql-action\"></a><a class=\"ql-remove\"></a></div>
 
""";

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Colorss.white,
      appBar: PreferredSize(
        preferredSize: Size(0.0, 0.0),
        child: Container(),
      ),
      body: new Column(
        children: [
          new Container(
              padding: EdgeInsets.only(top: 0, bottom: 10),
              decoration: BoxDecoration(
                color: Colorss.gradient1,
                gradient: LinearGradient(
                  // Where the linear gradient begins and ends
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  // Add one stop for each color. Stops should increase from 0 to 1
                  colors: [
                    Colorss.hgradient1,
                    Colorss.hgradient2,
                  ],
                ),
              ),
              child: new Column(
                children: <Widget>[
                  new Container(
                      child: AppHeader(
                    title: lanRes != null
                        ? lanRes.result.data.Settings.lbl_TermsConditions
                        : Strings.terms_conditions,
                    onBackClick: () {
                      Navigator.pop(context);
                    },
                  ))
                ],
              )),
          Expanded(
              child: new ListView(
            children: [
              Html(
                data: htmlData,
                //Optional parameters:
                style: {
                  "html": Style(
                    backgroundColor: Colors.white,
//              color: Colors.white,
                  ),
//            "h1": Style(
//              textAlign: TextAlign.center,
//            ),
                  "table": Style(
                    backgroundColor: Color.fromARGB(0x50, 0xee, 0xee, 0xee),
                  ),
                  "tr": Style(
                    border: Border(bottom: BorderSide(color: Colors.grey)),
                  ),
                  "th": Style(
                    padding: EdgeInsets.all(6),
                    backgroundColor: Colors.grey,
                  ),
                  "td": Style(
                    padding: EdgeInsets.all(6),
                    alignment: Alignment.topLeft,
                  ),
                  "var": Style(fontFamily: 'serif'),
                },
                customRender: {
                  "flutter":
                      (RenderContext context, Widget child, attributes, _) {
                    return FlutterLogo(
                      style: (attributes['horizontal'] != null)
                          ? FlutterLogoStyle.horizontal
                          : FlutterLogoStyle.markOnly,
                      textColor: context.style.color,
                      size: context.style.fontSize.size * 5,
                    );
                  },
                },
                onLinkTap: (url) {
                  print("Opening $url...");
                },
                onImageTap: (src) {
                  print(src);
                },
                onImageError: (exception, stackTrace) {
                  print(exception);
                },
              )
            ],
          ))
        ],
      ),
    ); // This trailing comma makes auto-formatting nicer for build methods.
  }
}
