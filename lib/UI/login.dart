import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
// import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:right_access/CommonFiles/common.dart';
import 'package:right_access/ServerFiles/serviceAPI.dart';
import 'package:right_access/UI/register.dart';
import 'package:right_access/data/loginData.dart';
import 'package:right_access/Globals/globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'dart:convert' as JSON;



TextEditingController mobileController = TextEditingController();


class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: Stack(
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
            //   backgroundColor: appThemeColor1,
            //   elevation: 0.0,
            //   title: Padding(
            //     padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
            //     child: Container(
            //       width: MediaQuery.of(context).size.width,
            //       alignment: Alignment.center,
            //       // child: Text(
            //       //   "Plasma Donor",style: TextStyle(color: Colors.white),
            //       // ),
            //     ),
            //   ),
            //   //  leading: Padding(
            //   //   padding: const EdgeInsets.all(0.0),
            //   //   child: InkWell(
            //   //       child: Container(
            //   //       decoration: BoxDecoration(
            //   //         borderRadius: new BorderRadius.circular(5.0),
            //   //         color: appThemeColor1
            //   //       ),
            //   //       child: Icon(Icons.arrow_back,color: Colors.white,)),
            //   //       onTap: ()
            //   //       {
            //   //         Navigator.pop(context);
            //   //       },
            //   //   ),
            //   // ),
            // ),
            body: FormKeyboardActions(child: LoginExtension()),
          ),
        ],
      ),
    );
  }
}

class LoginExtension extends StatefulWidget {
  @override
  _LoginExtensionState createState() => _LoginExtensionState();
}

class _LoginExtensionState extends State<LoginExtension> {
  FocusNode loginFocusNode = new FocusNode();
  FocusNode passwordFocusNode = new FocusNode();

//  static final FacebookLogin facebookSignIn = new FacebookLogin();
  Map userProfile;


  /// Creates the [KeyboardActionsConfig] to hook up the fields
  /// and their focus nodes to our [FormKeyboardActions].
  KeyboardActionsConfig _buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      keyboardBarColor: Colors.grey[200],
      nextFocus: true,
      actions: [
        KeyboardAction(
          focusNode: loginFocusNode,
        ),
        KeyboardAction(
          focusNode: passwordFocusNode,
        ),
      ],
    );
  }

  final loginKey = GlobalKey<FormState>();

  LoginData loginObj = new LoginData();

  @override
  void initState() {
    FormKeyboardActions.setKeyboardActions(context, _buildConfig(context));
    super.initState();
    loginFocusNode.addListener(() {
      setState(() {});
    });
    passwordFocusNode.addListener(() {
      setState(() {});
    });

    
  }



  @override
  void dispose() {
    super.dispose();
    loginFocusNode?.removeListener(() {
      setState(() {});
    });
    passwordFocusNode.removeListener(() {
      setState(() {});
    });
  }

getTheMobileNumber(String type) async
{
    await showDialog<String>(
      context: context,
      builder: (_){
        return new AlertDialog(
        contentPadding: const EdgeInsets.all(16.0),
        content: new Row(
          children: <Widget>[
            new Expanded(
              child: new TextField(
                autofocus: true,
                maxLength: 10,
                controller: mobileController,
                keyboardType: TextInputType.phone,
                decoration: new InputDecoration(
                    labelText: 'Mobile Number',labelStyle: TextStyle(color: Colors.black)),
              ),
            )
          ],
        ),
        actions: <Widget>[
          new FlatButton(
              child: const Text('CANCEL'),
              onPressed: () {
                Navigator.pop(context);
              }),
          new FlatButton(
              child: const Text('OKAY'),
              onPressed: () {
                String patttern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
                RegExp regExp = new RegExp(patttern);
                if (mobileController.text.isEmpty) 
                {
                  ShowErrorMessage("Please enter Mobile Number", context) ;
                }
                else if (!regExp.hasMatch(mobileController.text)) 
                {
                  ShowErrorMessage("Please enter valid mobile number", context);
                }
                else
                {
                  Navigator.pop(context);
                  ShowLoader(context);
                  loginUser(loginObj, context, type);
                }
                
              })
        ],
      );
      } 
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // alignment: Alignment.center,
      height: MediaQuery.of(context).size.height - 80,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Form(
          key: loginKey,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: Container(
              // decoration: setBoxDecorationForUpperCorners(Colors.white, Colors.transparent),
              color: Colors.transparent,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    
                  // Padding(
                  //     padding: const EdgeInsets.fromLTRB(50, 40, 50, 20),
                  //     child: Image.asset(
                  //       "images/app-logo.png", height: 200,
                  //       fit: BoxFit.fitWidth,
                  //     ),
                  //   ),

                    Padding(
                          padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 25,
                            child: Text(
                                "LOGIN WITH US",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 22,
                                     color: appThemeColor1),
                              ),
                          ),
                        ),

                    Padding(
                      padding: const EdgeInsets.fromLTRB(40, 0, 40, 10),
                      child: TextFormField(
                          focusNode: loginFocusNode,
                          style: TextStyle(color: Colors.black),
                          keyboardType: TextInputType.emailAddress,
                          textAlign: TextAlign.left,
                          decoration: setInputDecorationForEdit(
                              "Please enter email",
                              "Email",
                              Colors.yellow,
                              Colors.orange,
                              Colors.blueGrey,
                              Icons.person,
                              loginFocusNode),
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Please enter your email";
                            } 
                            // else if (!checkValidEmail(value)) {
                            //   return "Please enter valid email";
                            // } 
                            else {
                              loginObj.email = value;
                            }
                          }),
                    ),

                    Padding(
                      padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
                      child: TextFormField(
                          focusNode: passwordFocusNode,
                          style: TextStyle(color: Colors.black),
                          textAlign: TextAlign.left,
                          keyboardType: TextInputType.emailAddress,
                          decoration: setInputDecorationForEdit(
                              "Please enter Password",
                              "Password",
                              Colors.red,
                              Colors.red,
                              Colors.red,
                              Icons.lock,
                              passwordFocusNode),
                          obscureText: true,
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Please enter your password";
                            } else {
                              loginObj.password = value;
                            }
                          }),
                    ),

                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[


                       Container(
                         width: 200,
                         height: 50,
                        //  decoration: setBoxDecoration(Colors.white),
                        color: appThemeColor1,
                         child: FlatButton(
                           color: Colors.transparent,
                           child: Text("LOGIN",
                               style: TextStyle(
                                   fontWeight: FontWeight.w600,
                                   fontSize: 18,
                                   color: Colors.white,
                                   fontStyle: FontStyle.normal)),
                           onPressed: () {
                             if (loginKey.currentState.validate()) {
                                 ShowLoader(context);
                                 SchedulerBinding.instance.addPostFrameCallback((_) => loginUser(loginObj, context, "password"));
                               }
                           },
                         ),
                       ),




                        ],
                      ),
                    ),


                      //   Container(
                      //     width: 200,
                      //     child: FlatButton(
                      //     child: Text(
                      //       "FORGOT PASSWORD?",
                      //       style:
                      //           TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                      //     ),
                      //     textColor: appThemeColor1,
                      //     onPressed: () {
                      //       Navigator.push(
                      //           context, setNavigationTransition(ForgotPassword()));
                      //     },
                      // ),
                      //   ),



                      // Padding(
                      //     padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                      //     child: Container(
                      //       height: 20,
                      //       child: FlatButton(
                      //         child: Text(
                      //           "Not a member yet?",
                      //           style: TextStyle(
                      //               fontSize: 14),
                      //         ),
                      //         textColor: Colors.white,
                      //         onPressed: () {
                                 
                      //         },
                      //       ),
                      //     ),
                      //   ),

                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                          child: Container(
                            height: 30,
                            child: FlatButton(
                              child: Text(
                                "Register",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w700),
                              ),
                              textColor: appThemeColor1,
                              onPressed: () {
                                Navigator.push(
                                  context, setNavigationTransition(Register()));
                              },
                            ),
                          ),
                        ),

                   


                    // Padding(
                    //   padding: const EdgeInsets.fromLTRB(30, 0, 0, 20),
                    //   child: Container(
                    //     width: MediaQuery.of(context).size.width,
                    //     alignment: Alignment.centerLeft,
                    //     height: 30,
                    //     child: FlatButton(
                    //       child: Text(
                    //         "Login Options",
                    //         style: TextStyle(
                    //             fontSize: 17, fontWeight: FontWeight.w700),
                    //       ),
                    //       textColor: appThemeColor1,
                    //       onPressed: () {
                    //         Navigator.pop(context);
                    //       },
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void loginUser(LoginData login, BuildContext context, String loginType) async {


     Map param = Map();
    // param["login_type"] = loginType;
    if (loginType == "password") 
    {
      param["username"] = login.email;
      param["password"] = login.password;
      // param["device_type"] = globals.deviceType.toString();
      // param["device_token"] = globals.deviceToken;
      // param["company_id"] = "1";
    }
    else if (loginType == "facebook") 
    {
      param["facebook_token"] = login.facebookId;
      param["email"] = login.email;
      param["mobile"] = mobileController.text;
    }
    else
    {
      param["google_token"] = login.googleId;
      param["email"] = login.email;
      param["mobile"] = mobileController.text;
    }
    
    

    final url = "$baseUrl/login.json";
    var result = await CallApi("POST", param, url);
    // var result = await makePostRequest("POST", param, url) ;
    HideLoader(context);

    if (result[kDataCode] == "200") {
      if (result[kDataSuccess] == "1") {
        SetSharedPreference(kDataLoginUser, result[kDataData]);
        globals.globalCurrentUser = result[kDataData];
        // Navigator.pushAndRemoveUntil( context,   MaterialPageRoute(
        // builder: (context) => CustomDrawer(positionForDrawer = "other0")),   ModalRoute.withName("") );

      } else {
        ShowErrorMessage(result[kDataMessage], context);
      }
    } else {
      ShowErrorMessage(result[kDataError], context);
    }
  }
}
