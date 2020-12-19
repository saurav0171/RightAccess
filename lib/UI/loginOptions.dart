import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:right_access/CommonFiles/common.dart';
import 'package:right_access/Data/loginData.dart';
import 'package:right_access/ServerFiles/serviceAPI.dart';
import 'package:right_access/UI/login.dart';
import 'package:right_access/UI/register.dart';
import 'package:right_access/Globals/globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'dart:convert' as JSON;
import 'package:page_indicator/page_indicator.dart';
import 'package:firebase_messaging/firebase_messaging.dart';



TextEditingController mobileController = TextEditingController();
    String _pushToken = '';
    List imagesList = ["images/login.png","images/login.png","images/login.png","images/login.png"];
// FlutterVoipPushNotification _voipPush = FlutterVoipPushNotification();

class LoginOptions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.bottomEnd,
      children: <Widget>[
        new Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(color: appBackgroundColor)
          // decoration: setBackgroundImage(),
        ),
        Scaffold(
            backgroundColor: Colors.transparent,
            // appBar: AppBar(
            //   automaticallyImplyLeading: false,
            //   backgroundColor: Colors.transparent,
            //   elevation: 0.0,
            //   title: Container(
            //       alignment: Alignment.center,
            //       // child: Text(
            //       //   "Login",style: TextStyle(color: Colors.white),
            //       // )
            //       ),
            // ),
            body: LoginOptionExtension()),
      ],
    );
  }
}
class LoginOptionExtension extends StatefulWidget {
  @override
  _LoginOptionExtensionState createState() => _LoginOptionExtensionState();
}

class _LoginOptionExtensionState extends State<LoginOptionExtension> {

final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
 bool _isLoggedIn = false;
  Map userProfile;
bool _initialized = false;
   final loginKey = GlobalKey<FormState>();

  LoginData loginObj = new LoginData();
  
@override void initState()  {
    // TODO: implement initState
    super.initState();
    globals.isInitiallyLoaded = 0;
    globals.notificationContext = context;
  firebaseCloudMessaging_Listeners();
  
  }

 


void firebaseCloudMessaging_Listeners() {
  if (Platform.isIOS) iOS_Permission();

  _firebaseMessaging.getToken().then((token){
    print(token);
    SetSharedPreference(kDataDeviceToken, token);
    globals.deviceToken = token;
    globals.deviceType = Platform.isIOS?1:2;
  });

  
}

void iOS_Permission() {
  _firebaseMessaging.requestNotificationPermissions(
      IosNotificationSettings(sound: true, badge: true, alert: true)
  );
  _firebaseMessaging.onIosSettingsRegistered
      .listen((IosNotificationSettings settings)
  {
    print("Settings registered: $settings");
  });
}






  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: Container(
        alignment: Alignment.bottomCenter,
        height: double.infinity,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 60, 0, 0),
                child: Container(
                  height: MediaQuery.of(context).size.height,
            child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[

                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("RIGHT", style: TextStyle(fontWeight: FontWeight.w900,fontSize: 24,color: appThemeColor1, fontStyle: FontStyle.normal)),
                          Text("ACCESS", style: TextStyle(fontWeight: FontWeight.w500,fontSize: 24,color: Colors.black, fontStyle: FontStyle.normal)),

                        ],
                      ),
                    ),
                    Container(
            height: 300,
            child: PageIndicatorContainer(
                child: PageView.builder(
                  itemCount: imagesList.length,
                  itemBuilder: (BuildContext context, int index) {
                    String image = imagesList[index];
                    // return Image.network(image,
                    //     fit: BoxFit.contain);
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: Center(
                        child: Image.asset(image)
                      ),
                    );
                  },
                ),
                align: IndicatorAlign.bottom,
                length: imagesList.length,
                indicatorSpace: 5.0,
                padding: const EdgeInsets.all(5),
                indicatorColor: Colors.grey.shade300,
                indicatorSelectorColor: appThemeColor1,
                shape: IndicatorShape.circle(size: 10)),
          ),



                   
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(40, 0, 40, 10),
                              child: Container(
                                decoration: setBoxDecoration(Colors.white),
                                child: RaisedButton(
                                  child: Text("SIGN IN",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18,
                                          color: Colors.white,
                                          fontStyle: FontStyle.normal)),
                                  onPressed: () {
                                     Navigator.push( context, setNavigationTransition(Login()));
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),




                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                          child: Container(
                            height: 30,
                            child: FlatButton(
                              child: Text(
                                "REGISTER NOW",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w700),
                              ),
                              textColor: Colors.black,
                              onPressed: () {
                                Navigator.push(
                                  context, setNavigationTransition(Register()));
                              },
                            ),
                          ),
                        ),


                           Padding(
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 25,
                            child: Text(
                                "Powered By Right Access",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 18,
                                     color: Colors.black54),
                              ),
                          ),
                        ),
                        


                         Padding(
                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 25,
                            child: Text(
                                "It is a long established fact that a reader",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black54),
                              ),
                              alignment: Alignment.center,
                          ),
                        ),




                  ],
                ),
            ),
          ),
              ),
        ),
      ),
    );
  }


}


