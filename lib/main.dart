import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xplor/AuthScreen/InitSlider.dart';
import 'package:xplor/AuthScreen/Login.dart';
import 'package:xplor/HomeScreen/HomeMap.dart';
// import 'package:permission/permission.dart';
import 'package:move_to_background/move_to_background.dart';

import 'package:xplor/Model/ApiResponce.dart';
import 'package:xplor/Model/LanguageResponce.dart';

import 'package:xplor/api/rest-api.dart';
import 'package:xplor/localization/my_localization.dart';
import 'package:xplor/provider/get_ride_provider.dart';
import 'package:xplor/util/AddScooterHeader.dart';
import 'package:xplor/util/AppButton.dart';
import 'package:xplor/util/Colorss.dart';
import 'package:xplor/util/Dimens.dart';
import 'package:xplor/util/SizeConfig.dart';
import 'package:xplor/util/images.dart';
import 'HomeScreen/RideMap.dart';
import 'localization/language_constants.dart';
import 'package:location_permissions/location_permissions.dart';

var themeData = ThemeData(
    accentColor: Colorss.black,
    primaryColor: Colorss.black,
    primaryColorDark: Colorss.black,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    canvasColor: Colors.transparent,
    toggleableActiveColor: Colorss.toggle_green,
    fontFamily: 'Jeko');
var prefs;
Future<void> main() async {
  // var channel = const MethodChannel('com.micromobility.xplor/background_service');
  // var callbackHandle = PluginUtilities.getCallbackHandle(backgroundMain);
  // channel.invokeMethod('startService', callbackHandle.toRawHandle());

  // CounterService.instance().startCounting();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Crashlytics.instance.enableInDevMode = true;
  // Pass all uncaught errors from the framework to Crashlytics.
  FlutterError.onError = Crashlytics.instance.recordFlutterError;
  prefs = await SharedPreferences.getInstance();
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
//  if (kDebugMode) {
//    // Force disable Crashlytics collection while doing every day development.
//    // Temporarily toggle this to true if you want to test crash reporting in your app.
//    await FirebaseCrashlytics.instance
//        .setCrashlyticsCollectionEnabled(false);
//  } else {
//    // Handle Crashlytics enabled status when not in Debug,
//    // e.g. allow your users to opt-in to crash reporting.
//  }
  runApp(
    ThemeSwitcherWidget(
      initialTheme: themeData,
      child: MyApp(),
    ),
  );
}

class ThemeSwitcher extends InheritedWidget {
  final _ThemeSwitcherWidgetState data;

  const ThemeSwitcher({
    Key key,
    @required this.data,
    @required Widget child,
  })  : assert(child != null),
        super(key: key, child: child);

  static _ThemeSwitcherWidgetState of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(ThemeSwitcher)
            as ThemeSwitcher)
        .data;
  }

  @override
  bool updateShouldNotify(ThemeSwitcher old) {
    return this != old;
  }
}

class ThemeSwitcherWidget extends StatefulWidget {
  final ThemeData initialTheme;
  final Widget child;

  ThemeSwitcherWidget({Key key, this.initialTheme, this.child})
      : assert(initialTheme != null),
        assert(child != null),
        super(key: key);

  @override
  _ThemeSwitcherWidgetState createState() => _ThemeSwitcherWidgetState();
}

class _ThemeSwitcherWidgetState extends State<ThemeSwitcherWidget> {
  ThemeData themeData;

  void switchTheme(ThemeData theme) {
    setState(() {
      themeData = theme;
    });
  }

  @override
  Widget build(BuildContext context) {
    themeData = themeData ?? widget.initialTheme;
    return ThemeSwitcher(
      data: this,
      child: widget.child,
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);

  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState state = context.findAncestorStateOfType<_MyAppState>();
    state.setLocale(newLocale);
  }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale;
  final FirebaseMessaging _fcm = FirebaseMessaging();
  StreamSubscription iosSubscription;

  setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  void initState() {
    super.initState();
    // checkPermissionStatus();
    _fcm.requestNotificationPermissions();
    _saveDeviceToken();
    // PermissionName permissionName = PermissionName.Location;
//    if (Platform.isIOS) {
//      iosSubscription = _fcm.onIosSettingsRegistered.listen((data) {
//        // save the token  OR subscribe to a topic here
//      });
//      _fcm.requestNotificationPermissions(IosNotificationSettings());

    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: ListTile(
              title: Text(message['notification']['title']),
              subtitle: Text(message['notification']['body']),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        // TODO optional
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        // TODO optional
      },
    );
  }

  _saveDeviceToken() async {
    // Get the current user
    String uid = 'jeffd23';
    // FirebaseUser user = await _auth.currentUser();

    // Get the token for this device
    String fcmToken = await _fcm.getToken();

    // Save it to Firestore
    if (fcmToken != null) {
      prefs.setString("notificationid", fcmToken);
      // prefs.setString("operatingSystem", Platform.isIOS ? "Ios" : "Android");
      print("notificationid?? >> " + prefs.getString("notificationid"));
    }
  }

  @override
  void didChangeDependencies() {
    getLocale().then((locale) {
      setState(() {
        this._locale = locale;
      });
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) {
            return RideScrotter();
          },
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'xplor',
        theme: ThemeSwitcher.of(context).themeData,
        locale: _locale,
        supportedLocales: [
          Locale("en", "US"),
          Locale("ar", "SA"),
          Locale("hi", "IN")
        ],
        localizationsDelegates: [
          MyLocalization.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        localeResolutionCallback: (locale, supportedLocales) {
          for (var supportedLocale in supportedLocales) {
            if (supportedLocale.languageCode == locale.languageCode &&
                supportedLocale.countryCode == locale.countryCode) {
              return supportedLocale;
            }
          }
          return supportedLocales.first;
        },
        home: prefs != null &&
                prefs.getBool('islogin') != null &&
                prefs.getBool('islogin')
            ? (prefs.getString('ride_status') == "1" ? RideMap() : HomeMap())
            : MyHomePage(title: 'xplor'),
        routes: {
          "/MenuScreen": (context) => HomeMap(),
          "/Welcome": (context) => MyHomePage(),
          "/RideScreen": (context) => RideMap(),
          "/AddScrooterImage": (context) => AddScooterHeader(),
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  final FirebaseMessaging _fcm = FirebaseMessaging();
  StreamSubscription iosSubscription;

  void onFb() {
    // Crashlytics.instance.crash();
//     Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: InitSlider()));

    if (Welcome != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => InitSlider()),
      );
    } else {
      if (!isProgressShow) {
        getLanguageLabels();
      }
    }

//    Navigator.push(
//      context,
//      MaterialPageRoute(builder: (context) => PaymentURL(selectedUrl:"https://demo-ipg.ctdev.comtrust.ae/PaymentEx/MerchantPay/Payment?lang=en&layout=C0STCBVLEI")),
//    );

    //Navigator.pushNamedAndRemoveUntil(context, "/MenuScreen", (r) => false);
  }

  var prefs, lanRes, Welcome;
  bool isLogin, isProgressShow = false;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  void checkPermissionStatus() async {
    PermissionStatus permissionStatus =
        await LocationPermissions().checkPermissionStatus();
    if (permissionStatus == PermissionStatus.denied) {
      PermissionStatus permission =
          await LocationPermissions().requestPermissions();
      if (permission != PermissionStatus.granted) {
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          width: 150,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 5),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: Text(
            "Permission Denied",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white),
          ),
        ));
        Timer.periodic(Duration(seconds: 1), (timer) {
          exit(0);
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    checkPermissionStatus();
    getDataLanguage();
    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: ListTile(
              title: Text(message['notification']['title']),
              subtitle: Text(message['notification']['body']),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        // TODO optional
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        // TODO optional
      },
    );
  }

  saveLanguage(languageData) async {
    prefs = await SharedPreferences.getInstance();
    prefs.setString('languageData', languageData);
  }

  getDataLanguage() async {
    prefs = await SharedPreferences.getInstance();

    if (prefs.getBool('islogin') != null && prefs.getBool('islogin')) {
      Navigator.pushNamedAndRemoveUntil(context, "/MenuScreen", (r) => false);

      setState(() {
        isLogin = true;
      });
    } else {
      setState(() {
        isLogin = false;
      });
      getLanguageLabels();
      // var data = prefs.getString('languageData');
      // if (data != null) {
      //   Map langMap = jsonDecode(data.toString());
      //   lanRes = LanguageResponce.parseLanguage(langMap);
      //   Welcome = lanRes.result.data.Welcome;
      //   setState(() {});
      //   print(lanRes.result.data.navigation.btn_LogOut);
      //   print(lanRes.result.data.IpaAddress.lbl_server.toString());
      //   if (isLogin != null && isLogin) {
      //     Navigator.pushNamedAndRemoveUntil(
      //         context, "/MenuScreen", (r) => false);
      //   }
      // } else {
      //   getLanguageLabels();
      // }
    }
  }

  Future<String> getLanguageLabels() async {
    try {
      setState(() {
        isProgressShow = true;
      });
      prefs = await SharedPreferences.getInstance();
      ApiService.getLanguageLabels(1).then((response) {
        print('response =======>' + response);
        setState(() {
          isProgressShow = false;
        });
        if (response != null) {
          Map langMap = jsonDecode(response.toString());
          print(langMap.toString());
          var user = ApiResponce.fromJson(langMap);
          if (user.success) {
            saveLanguage(response.toString());
            var lanRes = LanguageResponce.parseLanguage(langMap);
            print(lanRes.result.data.navigation.btn_LogOut);
            prefs.setString(
                'url', lanRes.result.data.IpaAddress.lbl_server.toString());
            Welcome = lanRes.result.data.Welcome;
            setState(() {});
            if (prefs.getBool('islogin') != null && prefs.getBool('islogin')) {
              Navigator.pushNamedAndRemoveUntil(
                  context, "/MenuScreen", (r) => false);
            }
          } else {
            // print('Howdy, ${user.code} ${user.msg}!');
          }
        }
      });
      return "Success";
    } catch (error) {
      print('error =======>' + error);
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      key: _scaffoldKey,
      body: Material(
        child: new Container(
            decoration: BoxDecoration(
              color: Colorss.black,
            ),
            child: new Stack(
              children: <Widget>[
                new Positioned(
                    top: 80,
                    bottom: SizeConfig.safeBlockVertical * 22,
                    left: 5,
                    right: 5,
                    child: new Container(
                      margin: EdgeInsets.only(
                          top: SizeConfig.safeBlockVertical * 0),
                      decoration: BoxDecoration(
                        // color: Colors.white
                        image: DecorationImage(
                          image: AssetImage(Images.splash_new),
                          fit: BoxFit.contain,
                        ),
                      ),
                    )),
                new Positioned(
                    bottom: 20,
                    left: 25,
                    right: 25,
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        new Container(
                          margin: EdgeInsets.only(top: 0, bottom: 5),
                          child: AppButton(
                              title: Welcome != null
                                  ? Welcome.lbl_Get
                                  : "Get Started",
                              showIcon: false,
                              onButtonClick: onFb,
                              fontSize: SizeConfig.safeBlockHorizontal *
                                  Dimens.text_5),
                        ),
                        new Container(
                          margin: EdgeInsets.only(
                              top: SizeConfig.safeBlockVertical * 2, bottom: 5),
                          child: new Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              new Text(
                                  Welcome != null
                                      ? Welcome.lbl_Account
                                      : "Already have a account?",
                                  style: TextStyle(
                                      fontSize: SizeConfig.safeBlockHorizontal *
                                          Dimens.text_3_5,
                                      fontStyle: FontStyle.normal,
                                      fontWeight: FontWeight.w400,
                                      color: Colorss.fontColor)),
                              new GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Login()),
                                  );
                                },
                                child: new Padding(
                                  padding: EdgeInsets.only(left: 5, right: 5),
                                  child: new Text(
                                      Welcome != null
                                          ? Welcome.lbl_Login
                                          : "Log in",
                                      style: TextStyle(
                                          fontSize:
                                              SizeConfig.safeBlockHorizontal *
                                                  Dimens.text_3_5,
                                          fontStyle: FontStyle.normal,
                                          fontWeight: FontWeight.w500,
                                          color: Colorss.fontColor)),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    )),
                if (isProgressShow)
                  new Positioned(
                      child: new Center(child: CircularProgressIndicator())),
              ],
            )),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
