import 'dart:convert';
import 'package:flutter/material.dart';


import 'package:qr_code_scanner/qr_code_scanner.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:xplor/Model/LanguageResponce.dart';
import 'package:xplor/Screen/TerrifNew.dart';
import 'package:xplor/util/AppButton.dart';
import 'package:xplor/util/Dimens.dart';
import 'package:xplor/util/SizeConfig.dart';

const flashOn = 'FLASH ON';
const flashOff = 'FLASH OFF';
const frontCamera = 'FRONT CAMERA';
const backCamera = 'BACK CAMERA';

class QRViewExample extends StatefulWidget {
  String adrress;

  QRViewExample({Key key, @required this.adrress}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRViewExampleState(this.adrress);
}

class _QRViewExampleState extends State<QRViewExample> {
  _QRViewExampleState(this.adrress);

  var qrText = '', adrress;
  var flashState = flashOn;
  var cameraState = frontCamera;
  QRViewController controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDataLanguage();
  }

  var prefs;
  var lanRes, lansetting;
  getDataLanguage() async {
    prefs = await SharedPreferences.getInstance();
    var data = prefs.getString('languageData');
    Map langMap = jsonDecode(data.toString());
    lanRes = LanguageResponce.parseLanguage(langMap);

    lansetting = lanRes.result.data.Settings;
    setState(() {});
    print(lanRes.result.data.Settings.lbl_firstname1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(''),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 4,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
              overlay: QrScannerOverlayShape(
                borderColor: Colors.red,
                borderRadius: 10,
                borderLength: 30,
                borderWidth: 10,
                cutOutSize: 300,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text('This is the result of scan: $qrText'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      new Container(
                        width: SizeConfig.safeBlockHorizontal * 70,
                        margin: EdgeInsets.only(
                            top: SizeConfig.safeBlockVertical * 7, bottom: 5),
                        child: AppButton(
                            title: lansetting != null
                                ? flashState == flashOn
                                    ? lansetting.lbl_Flash_On
                                    : lansetting.lbl_Flash_Off
                                : flashState,
                            showIcon: false,
                            onButtonClick: () {
                              if (controller != null) {
                                controller.toggleFlash();
                                if (_isFlashOn(flashState)) {
                                  setState(() {
                                    flashState = flashOff;
                                  });
                                } else {
                                  setState(() {
                                    flashState = flashOn;
                                  });
                                }
                              }
                            },
                            fontSize:
                                SizeConfig.safeBlockHorizontal * Dimens.text_5),
                      ),
//                      Container(
//                        margin: EdgeInsets.all(8),
//                        child: RaisedButton(
//                          onPressed: () {
//                            if (controller != null) {
//                              controller.toggleFlash();
//                              if (_isFlashOn(flashState)) {
//                                setState(() {
//                                  flashState = flashOff;
//                                });
//                              } else {
//                                setState(() {
//                                  flashState = flashOn;
//                                });
//                              }
//                            }
//                          },
//                          child:
//                              Text(lansetting!=null?flashState==flashOn?lansetting.lbl_Flash_On:lansetting.lbl_Flash_Off:flashState, style: TextStyle(fontSize: SizeConfig
//                                  .safeBlockHorizontal *
//                                  Dimens.text_3)),
//                        ),
//                      ),
//                      Container(
//                        margin: EdgeInsets.all(8),
//                        child: RaisedButton(
//                          onPressed: () {
//                            if (controller != null) {
//                              controller.flipCamera();
//                              if (_isBackCamera(cameraState)) {
//                                setState(() {
//                                  cameraState = frontCamera;
//                                });
//                              } else {
//                                setState(() {
//                                  cameraState = backCamera;
//                                });
//                              }
//                            }
//                          },
//                          child:
//                              Text(
//                                  lansetting!=null?cameraState==frontCamera?lansetting.lbl_Front_Camera:lansetting.lbl_Back_Camera:cameraState
//
//
//                                  , style: TextStyle(fontSize: SizeConfig
//                                  .safeBlockHorizontal *
//                                  Dimens.text_3)),
//                        ),
//                      )
                    ],
                  ),
//                  Row(
//                    mainAxisAlignment: MainAxisAlignment.center,
//                    crossAxisAlignment: CrossAxisAlignment.center,
//                    children: <Widget>[
//                      Container(
//                        margin: EdgeInsets.all(8),
//                        child: RaisedButton(
//                          onPressed: () {
//                            controller?.pauseCamera();
//                          },
//                          child: Text(lansetting!=null?lansetting.lbl_Pause:'Pause', style: TextStyle(fontSize: SizeConfig
//                              .safeBlockHorizontal *
//                              Dimens.text_3)),
//                        ),
//                      ),
//                      Container(
//                        margin: EdgeInsets.all(8),
//                        child: RaisedButton(
//                          onPressed: () {
//                            controller?.resumeCamera();
//                          },
//                          child: Text(lansetting!=null?lansetting.lbl_Resume:'Resume', style: TextStyle(fontSize: SizeConfig
//                              .safeBlockHorizontal *
//                              Dimens.text_3)),
//                        ),
//                      )
//                    ],
//                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  bool _isFlashOn(String current) {
    return flashOn == current;
  }

  bool _isBackCamera(String current) {
    return backCamera == current;
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        qrText = scanData;
      });
      if (isfirst) {
        setState(() {
          isfirst = false;
        });
        print("qrTex>>  " + qrText.toString());
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  TerrifNew(qrText: qrText, adrress: adrress)),
        );
//        Navigator.push(
//          context,
//          MaterialPageRoute(builder: (context) => TerrifNew(qrText:qrText,adrress:adrress)),
//        );
        //GetComments();
      }
    });
  }

  bool isProgressShow = true, isfirst = true;

  parse(reply) async {
    setState(() {
      isProgressShow = false;
    });

    if (reply != null) {
      Map userMap = jsonDecode(reply);
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
