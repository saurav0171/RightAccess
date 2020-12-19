import 'dart:async';
import 'dart:io';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:launch_review/launch_review.dart';
import 'package:location/location.dart';
import 'package:right_access/CommonFiles/common.dart';
import 'package:right_access/Globals/globals.dart';
import 'package:right_access/ServerFiles/serviceAPI.dart';
import 'package:package_info/package_info.dart';
import 'package:right_access/Globals/globals.dart' as globals;

FirebaseAnalytics analytics = FirebaseAnalytics();
FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(analytics: analytics);
final dateFormat = DateFormat("dd/MM/yyyy");
bool isAdult = false;
bool isAccept = false;
LocationData currentLocation;
String locationError = "";

void main() => 
  runApp(new MaterialApp(
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



bool toShowTitle = false ;
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

    Timer(Duration(seconds:  2), ()
    {
      setState(() {
        toShowTitle = true;
      });
    });

  }


 getUserLocation() async {//call this async method from where ever you need

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
            locationError = 'Permission denied- Please enable it from app settings';
          });
          print(locationError);
        }
        if (e.code == 'SERVICE_STATUS_DISABLED') {
          setState(() {
            locationError = 'Location Service Disabled- Please enable it from app settings';
          });
          print(locationError);
        }
        // ShowErrorMessage(error, context);
        showDialog(context: context, 
        builder: (_) => new AlertDialog(
            title: new Text("Location Service"),
            content: new Text(locationError),
            actions: <Widget>[
              FlatButton(onPressed: ()
              {
                  Navigator.pop(context);
              }, child: Text("OK"))
            ],
        )
            );
        myLocation = null;
      }
       globalLocationData = myLocation;
    }



String mesg = "";
void firebaseCloudMessaging_Listeners() {
  globals.firebaseMessaging.configure(
    onMessage: (Map<String, dynamic> message) async {
      print('on message $message');
      
      if (Platform.isIOS)
      {
          mesg = message["aps"][kDataAlert][kDataBody];
      }
      else
      {
          mesg = message[kDataNotification][kDataBody];
      }
      showDialogForNotification(mesg);
    
    },
    onResume: (Map<String, dynamic> message) async {
      print('on resume $message');
      if (Platform.isIOS)
      {
          mesg = message["aps"][kDataAlert][kDataBody];
      }
      else
      {
          mesg = message[kDataNotification][kDataBody];
      }
       showDialogForNotification(mesg);
    },
    onLaunch: (Map<String, dynamic> message) async {
      print('on launch $message');
      if (Platform.isIOS)
      {
          mesg = message["aps"][kDataAlert][kDataBody];
      }
      else
      {
          mesg = message[kDataNotification][kDataBody];
      }
       showDialogForNotification(mesg);
    },
  );
}

showDialogForNotification(String msg)
{
  showDialog(
   context: globals.notificationContext,
   builder: (BuildContext context) {
     return PopupNotification( messageNotification = msg);
  },
  );
}



  checkVersion() async
   {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();

      String appName = packageInfo.appName;
      String packageName = packageInfo.packageName;
      String version = packageInfo.version;
      String buildNumber = packageInfo.buildNumber;

      var param = {
        "device":Platform.isIOS?"ios":"android",
      };

      final url = "$baseUrl/latest_api";
      var result = await CallApi("POST", param, url);
      HideLoader(context);
      if (result[kDataCode] == "200")
      {
        if (version != result[kDataResult] && result[kDataBypass] == 0)
        {
            showVersionAlertDialog(context,"New update available. Please update your app for error free user experience.");
        }
        else
        {
          startTime();
        }
        
      }
      else if (result[kDataCode] == "401") 
      {
        showVersionAlertDialog(context,result[kDataError]);
      } 
      else {
        
      }
      
  }

showVersionAlertDialog(BuildContext context,String message) {

  // set up the button
  Widget okButton = FlatButton(
    child: Text("OK"),
    onPressed: () 
    {
      if (message == "New update available. Please update your app for error free user experience.") {
         Platform.isIOS? LaunchReview.launch(writeReview: false,iOSAppId: "1499460905",):LaunchReview.launch(androidAppId: "com.lyallpuremporium.lyallpur_emporium_app");
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

  checkAuthorization() async
  {
      // String authorisation = await GetSharedPreference(kDataIsAuthorized);
      // if (authorisation == null)
      // {
      //    Navigator.push( context, setNavigationTransition(AgeVerification()));
      // }
      // else
      // {
         SetHomePage(0, "other0");
      // }
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


          


          
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Center(
              child: Container(
                alignment: Alignment.bottomCenter,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height - 150,
                  decoration: new BoxDecoration(
                    
                      image: new DecorationImage(
                          // alignment: Alignment(0.0, 0.0),
                          fit: BoxFit.fitWidth,
                          image: AssetImage("images/image.png")))),
            ),
          ),


         Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 30),
            child: AnimatedOpacity(
              opacity: toShowTitle ? 1.0 : 0.0,
              duration: Duration(seconds: 2),
                          child: Container(
                height: 70,
                child: logoText(),
              ),
            ),
          )
        ],
      )),
    );
  }
}




class AgeVerification extends StatefulWidget {
  @override
  _AgeVerificationState createState() => _AgeVerificationState();
}

class _AgeVerificationState extends State<AgeVerification> {
FocusNode dobFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Material(
          child: Container(
            height: MediaQuery.of(context).size.height,
            alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
          Padding(
          padding: const EdgeInsets.fromLTRB(30, 0, 30, 5),
          child: DateTimeField(
            onChanged: (DateTime value)
            {
              print("object");
               setState(() {
                 if (value != null)
                 {
                    int diffDays = DateTime.now().difference(value).inDays;
                    int years = (diffDays/365).round();
                    isAdult = (years >= 25 );  
                  }
                  else
                  {
                    isAdult = false;
                  }
               });
            },
            decoration: setInputDecoration(
              "Please enter DOB",
                "DOB",
                appThemeColor1,
                appThemeColor1,
                appThemeColor1,
                Icons.calendar_today,
                dobFocusNode
                        ),

            format: dateFormat,
            textAlign: TextAlign.left,
            resetIcon: Icon(
              Icons.calendar_today,
              color: appThemeColor1,
            ),
            onShowPicker: (context, currentValue) {
              return showDatePicker(
                initialDatePickerMode: DatePickerMode.year,
                  context: context,
                  firstDate: DateTime(1900),
                  initialDate: currentValue ?? DateTime.now(),
                  builder: (BuildContext context, Widget child) {
                      return Theme(
                        data: ThemeData(
                        // Define the default brightness and colors.
                        brightness: Brightness.dark,
                        primaryColor: Colors.red,
                        accentColor: appThemeColor1,
                        // dialogBackgroundColor: Colors.black,
                        // dialogTheme: DialogTheme(
                        //   backgroundColor: Colors.red
                        // )

                      ),
                        child: child,
                      );
                    },
                  lastDate: DateTime.now());
            },

            validator: (value) {
              if (value == null) {
                return "Please enter your Date of Birth";
              } else {
               
                
                setState(() {
                  int diffDays = DateTime.now().difference(value).inDays;
                int years = (diffDays/365).round();
                  isAdult = (years >= 25 );
                });
              }
            },
          ),
        ),


         Padding(
                                              padding: const EdgeInsets.fromLTRB(30, 10, 0, 10),
                                              child: Row(
                                                children:[
                                                  InkWell(
                                                    child: Icon(isAccept?Icons.check_box:Icons.check_box_outline_blank,color:appThemeColor1,size: 30,),
                                                    onTap: ()
                                                    {
                                                      setState(() {
                                                        isAccept = !isAccept;
                                                      });
                                                    },
                                                    ),

                                                  Padding(
                                                    padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                                    child: Container(
                                                      constraints: BoxConstraints(
                                                        maxWidth: MediaQuery.of(context).size.width - 80
                                                      ),
                                                      child: Text("I agree to the T&C and Policy to follow this app",
                                                      overflow: TextOverflow.ellipsis,
                                                      maxLines: 3,
                                                      style: TextStyle(
                                                          fontWeight: FontWeight.w600,
                                                          fontSize: 15,
                                                          color: Colors.black,
                                                          fontStyle: FontStyle.normal)),
                                                    ),
                                                  ),




                                                ],
                                              ),
                                            ),




                                                   Padding(
                             padding: const EdgeInsets.fromLTRB(0, 20, 0, 30),
                             child: Container(
                             width: 250,
                             height: 50,
                             decoration: setBoxDecoration(Colors.white),
                             child: RaisedButton(
                               color: (isAccept && isAdult)?appThemeColor1:appThemeColor1.withAlpha(150),
                               child: Text("Proceed",
                                   style: TextStyle(
                                       fontWeight: FontWeight.w600,
                                       fontSize: 18,
                                       color: Colors.white,
                                       fontStyle: FontStyle.normal)),
                               onPressed: () {
                                 if (isAccept && isAdult)
                                 {  
                                    SetSharedPreference(kDataIsAuthorized, "true");

                                    Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
                                    SetHomePage(0, "other0");
                                 }
                               },
                             ),
                           ),
                            ),
                            
          ],),
        
      ),
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
             title: Text("Medit",style: TextStyle(fontSize: 16,color: appThemeColor1),),
           content: Container(
           constraints: BoxConstraints(
           maxWidth: MediaQuery.of(context).size.width - 150
        ),
        child: Text(messageNotification,maxLines: 20,
        overflow: TextOverflow.ellipsis,textAlign: TextAlign.left,)
        ),

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