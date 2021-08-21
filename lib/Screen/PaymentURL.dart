import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xplor/Model/LanguageResponce.dart';
import 'package:xplor/util/AppHeader.dart';
import 'package:xplor/util/Colorss.dart';
import 'package:xplor/util/Strings.dart';

class PaymentURL extends StatefulWidget {
  const PaymentURL(
      {Key key, this.selectedUrl, this.TransactionID, this.CallBackUrl})
      : super(key: key);

  final String selectedUrl, TransactionID, CallBackUrl;

  @override
  _MyHomePageState createState() =>
      _MyHomePageState(this.selectedUrl, this.TransactionID, this.CallBackUrl);
}

const kAndroidUserAgent =
    'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.94 Mobile Safari/537.36';

class _MyHomePageState extends State<PaymentURL> {
  // Instance of WebView plugin

  String selectedUrl, TransactionID, CallBackUrl;

  _MyHomePageState(this.selectedUrl, this.TransactionID, this.CallBackUrl);

  // On destroy stream

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final _history = [];

  @override
  void initState() {
    super.initState();
    getDataLanguage();
  }

  var prefs;
  var languageTerrif, languageMyWallet, languagePayment, languageMessages;

  getDataLanguage() async {
    prefs = await SharedPreferences.getInstance();
    var data = prefs.getString('languageData');
    Map langMap = jsonDecode(data.toString());
    var lanRes = LanguageResponce.parseLanguage(langMap);
    languageMessages = lanRes.result.data.Messages;
    languagePayment = lanRes.result.data.Payments;
    print(languageTerrif.toString());
    setState(() {});
  }

  @override
  void dispose() {
    // Every listener should be canceled, the same should be done with this stream.
    super.dispose();
  }

  double progress = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colorss.white_bg,
        child: Column(
            children: <Widget>[
          new Container(
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
            padding: EdgeInsets.only(
              bottom: 5,
              top: 5,
            ),
            child: new Container(
              child: AppHeader(
                title: languageMessages != null
                    ? languageMessages.Msg_Checkout
                    : Strings.checkout,
                onBackClick: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),

          (progress != 1.0)
              ? LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(Colorss.app_color))
              : null, // Should be removed while showing
          Expanded(
            child: Container(
              child: InAppWebView(
                initialUrl: selectedUrl,
                initialHeaders: {},
                onWebViewCreated: (InAppWebViewController controller) {
                  var data = "TransactionID=" + TransactionID;
                  controller.postUrl(
                      url: selectedUrl, postData: utf8.encode(data));
                },
                onLoadStart: (InAppWebViewController controller, String url) {
                  print("url>> " + url);
                  if (url == CallBackUrl) {
                    Navigator.pop(context);
                    // Add your URL here
                    // TODO open native page
                  }
                },
                onProgressChanged:
                    (InAppWebViewController controller, int progress) {
                  setState(() {
                    this.progress = progress / 100;
                  });
                },
              ),
            ),
          )
        ].where((Object o) => o != null).toList()),
      ),
    ); //Remove null widgets
  }
}
