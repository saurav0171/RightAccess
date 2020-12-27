import 'dart:async';
import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:launch_review/launch_review.dart';
import 'package:location/location.dart';
import 'package:package_info/package_info.dart';
import 'package:right_access/CommonFiles/common.dart';
import 'package:right_access/Globals/globals.dart';
import 'package:right_access/Globals/globals.dart' as globals;
import 'package:right_access/ServerFiles/serviceAPI.dart';

FirebaseAnalytics analytics = FirebaseAnalytics();
FirebaseAnalyticsObserver observer =
    FirebaseAnalyticsObserver(analytics: analytics);
final dateFormat = DateFormat("dd/MM/yyyy");
bool isAdult = false;
bool isAccept = false;
LocationData currentLocation;
String locationError = "";

void main() => runApp(new MaterialApp(
      debugShowCheckedModeBanner: false,
      home: new SplashScreen(),
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: analytics),
      ],
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: appThemeColor1,
        accentColor: appThemeColor1,

        // Define the default font family.
        fontFamily: '-',
      ),
    ));

bool toShowTitle = false;

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // ShowLoader(context);
    // getUserLocation();

      startTime();


    firebaseCloudMessaging_Listeners();

    Timer(Duration(seconds: 2), () {
      setState(() {
        toShowTitle = true;
      });
    });
  }

  getUserLocation() async {
    //call this async method from where ever you need

    LocationData myLocation;

    Location location = new Location();
    try {
      myLocation = await location.getLocation();
      print("myLocation : $myLocation");
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        setState(() {
          locationError = 'Please grant permission';
        });
        print(locationError);
      }
      if (e.code == 'PERMISSION_DENIED_NEVER_ASK') {
        setState(() {
          locationError =
              'Permission denied- Please enable it from app settings';
        });
        print(locationError);
      }
      if (e.code == 'SERVICE_STATUS_DISABLED') {
        setState(() {
          locationError =
              'Location Service Disabled- Please enable it from app settings';
        });
        print(locationError);
      }
      // ShowErrorMessage(error, context);
      showDialog(
          context: context,
          builder: (_) => new AlertDialog(
                title: new Text("Location Service"),
                content: new Text(locationError),
                actions: <Widget>[
                  FlatButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("OK"))
                ],
              ));
      myLocation = null;
    }
    globalLocationData = myLocation;
  }

  String mesg = "";

  void firebaseCloudMessaging_Listeners() {
    globals.firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('on message $message');

        if (Platform.isIOS) {
          mesg = message["aps"][kDataAlert][kDataBody];
        } else {
          mesg = message[kDataNotification][kDataBody];
        }
        showDialogForNotification(mesg);
      },
      onResume: (Map<String, dynamic> message) async {
        print('on resume $message');
        if (Platform.isIOS) {
          mesg = message["aps"][kDataAlert][kDataBody];
        } else {
          mesg = message[kDataNotification][kDataBody];
        }
        showDialogForNotification(mesg);
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('on launch $message');
        if (Platform.isIOS) {
          mesg = message["aps"][kDataAlert][kDataBody];
        } else {
          mesg = message[kDataNotification][kDataBody];
        }
        showDialogForNotification(mesg);
      },
    );
  }

  showDialogForNotification(String msg) {
    showDialog(
      context: globals.notificationContext,
      builder: (BuildContext context) {
        return PopupNotification(messageNotification = msg);
      },
    );
  }

  checkVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    String appName = packageInfo.appName;
    String packageName = packageInfo.packageName;
    String version = packageInfo.version;
    String buildNumber = packageInfo.buildNumber;

    var param = {
      "device": Platform.isIOS ? "ios" : "android",
    };

    final url = "$baseUrl/latest_api";
    var result = await CallApi("POST", param, url);
    HideLoader(context);
    if (result[kDataCode] == "200") {
      if (version != result[kDataResult] && result[kDataBypass] == 0) {
        showVersionAlertDialog(context,
            "New update available. Please update your app for error free user experience.");
      } else {
        startTime();
      }
    } else if (result[kDataCode] == "401") {
      showVersionAlertDialog(context, result[kDataError]);
    } else {}
  }

  showVersionAlertDialog(BuildContext context, String message) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        if (message ==
            "New update available. Please update your app for error free user experience.") {
          Platform.isIOS
              ? LaunchReview.launch(
                  writeReview: false,
                  iOSAppId: "1499460905",
                )
              : LaunchReview.launch(
                  androidAppId: "com.lyallpuremporium.lyallpur_emporium_app");
        }

        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Lyallpur Emporium"),
      content: Text(message),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  startTime() {
    Timer(Duration(seconds: 3), () {
      print("Yeah, this line is printed after 3 seconds");
      checkAuthorization();
    });
  }

  checkAuthorization() async {
    SetHomePage(0, "other0");
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.white,
      body: new Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // Container(decoration: BoxDecoration(
          //   gradient: setGradientColor()
          // ),),

          Center(
            child: Container(
                alignment: Alignment.bottomCenter,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: new BoxDecoration(
                    image: new DecorationImage(
                        // alignment: Alignment(0.0, 0.0),
                        fit: BoxFit.fitWidth,
                        image: AssetImage("images/splash.jpg")))),
          ),

        ],
      )),
    );
  }
}

String messageNotification;

class PopupNotification extends StatefulWidget {
  PopupNotification(param0);

  @override
  _PopupNotificationState createState() => _PopupNotificationState();
}

class _PopupNotificationState extends State<PopupNotification> {
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Center(
          child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: AlertDialog(
          title: Text(
            "Medit",
            style: TextStyle(fontSize: 16, color: appThemeColor1),
          ),
          content: Container(
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width - 150),
              child: Text(
                messageNotification,
                maxLines: 20,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.left,
              )),
          actions: [
            FlatButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      )),
    );
  }
}
