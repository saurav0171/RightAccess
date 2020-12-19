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
bool isRemembered = false;


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
  TextEditingController loginController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

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

   
  setValues();
    
  }

setValues() async
{
    bool status = await sharedPreferenceContainsKey(kDataRemembered);
    if (status) 
    {
      Map remember = GetSharedPreference(kDataRemembered);
      loginController.text = remember[kDataEmail];
      passwordController.text = remember[kDataPassword];
    }
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
                    
                  Padding(
                      padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("RIGHT", style: TextStyle(fontWeight: FontWeight.w900,fontSize: 24,color: appThemeColor1, fontStyle: FontStyle.normal)),
                          Text("ACCESS", style: TextStyle(fontWeight: FontWeight.w500,fontSize: 24,color: Colors.black, fontStyle: FontStyle.normal)),

                        ],
                      ),
                    ),


                    

                    Padding(
                          padding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 25,
                            child: Text(
                                "LOGIN WITH US",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 22,
                                     color: appThemeColor1,fontWeight: FontWeight.w600),
                              ),
                          ),
                        ),


                         Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 70,
                            child: Text(
                                "Request a call back regarding Together's B2B offerings using the form below.",
                                textAlign: TextAlign.center,
                                maxLines: 10,
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black54),
                              ),
                              alignment: Alignment.center,
                          ),
                        ),




                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 40, 20, 10),
                      child: TextFormField(
                          focusNode: loginFocusNode,
                          controller: loginController,
                          style: TextStyle(color: Colors.black),
                          keyboardType: TextInputType.emailAddress,
                          textAlign: TextAlign.left,
                          decoration: setInputDecorationForEdit(
                              "Email or mobile phone  number",
                              "Email or mobile phone  number",
                              Colors.yellow,
                              Colors.orange,
                              Colors.blueGrey,
                              Icons.person,
                              loginFocusNode),
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Please enter your email or mobile";
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
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: TextFormField(
                          focusNode: passwordFocusNode,
                          controller: passwordController,
                          style: TextStyle(color: Colors.black),
                          textAlign: TextAlign.left,
                          keyboardType: TextInputType.emailAddress,
                          decoration: setInputDecorationForEdit(
                              "Email Password",
                              "Email Password",
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
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[


                       Container(
                         width: 30,
                         height: 30,
                         child: FlatButton(
                           padding: EdgeInsets.symmetric(vertical: 0.0,horizontal: 0.0),
                           color: Colors.transparent,
                           child: Icon(isRemembered?Icons.check_box:Icons.check_box_outline_blank,size: 30,color: Colors.black45,),
                           onPressed: () {
                             setState(() {
                               isRemembered = !isRemembered;
                               
                             });
                           },
                         ),
                       ),

                       Padding(
                         padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                         child: Text(
                                  "Remember Me",
                                  textAlign: TextAlign.center,
                                  maxLines: 10,
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black),
                                ),
                       ),




                        ],
                      ),
                    ),






                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[

                          Container(
                         width: 280,
                         height: 40,
                        alignment: Alignment.bottomRight,
                         child: FlatButton(
                           color: Colors.transparent,
                           child: Text("Forgot Password?",
                               style: TextStyle(
                                   fontWeight: FontWeight.w600,
                                   fontSize: 15,
                                   color: appThemeColor1,
                                   fontStyle: FontStyle.normal)),
                           onPressed: () {
                            //  if (loginKey.currentState.validate()) {
                            //      ShowLoader(context);
                            //      SchedulerBinding.instance.addPostFrameCallback((_) => loginUser(loginObj, context, "password"));
                            //    }
                           },
                         ),
                       ),


                       Container(
                         width: 280,
                         height: 50,
                         decoration: BoxDecoration(
                           borderRadius: BorderRadius.circular(5),
                           color: appThemeColor1,
                         ),
                        //  decoration: setBoxDecoration(Colors.white),
                        
                         child: FlatButton(
                           color: Colors.transparent,
                           child: Text("SIGN IN",
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
                          padding: const EdgeInsets.fromLTRB(0, 15, 0, 20),
                          child: Container(
                            height: 30,
                            child: FlatButton(
                              child: Text(
                                "REGISTER NOW",
                                style: TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.w500),
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
                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
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

  void loginUser(LoginData login, BuildContext context, String loginType) async {


     Map param = Map();
    // param["login_type"] = loginType;
    param["email"] = login.email;
    param["password"] = login.password;
    
    

    final url = "$baseUrl/login";
    var result = await CallApi("POST", param, url);
    // var result = await makePostRequest("POST", param, url) ;
    HideLoader(context);

    if (result[kDataCode] == "200") {
      SetSharedPreference(kDataLoginUser, result[kDataData]);
        globals.globalCurrentUser = result[kDataData];
        if (isRemembered) {
                                 
        Map remember = {kDataEmail: login.email,kDataPassword:login.password};
        SetSharedPreference(kDataRemembered, remember);
        }
        else
        {
          RemoveSharedPreference(kDataRemembered);
        }
        // Navigator.pushAndRemoveUntil( context,   MaterialPageRoute(
        // builder: (context) => CustomDrawer(positionForDrawer = "other0")),   ModalRoute.withName("") );
        
    }
    else if(result[kDataCode] == "422")
    {
        ShowErrorMessage(result[kDataMessage], context);
    } else {
      ShowErrorMessage(result[kDataError], context);
    }
  }
}
