import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
// import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:right_access/CommonFiles/common.dart';
import 'package:right_access/ServerFiles/serviceAPI.dart';
import 'package:right_access/data/loginData.dart';

TextEditingController mobileController = TextEditingController();
bool isRemembered = false;

class ForgotPassword extends StatelessWidget {
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
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            body: FormKeyboardActions(child: ForgetPasswordExtension()),
          ),
        ],
      ),
    );
  }
}

class ForgetPasswordExtension extends StatefulWidget {
  @override
  _ForgetPasswordExtensionState createState() => _ForgetPasswordExtensionState();
}

class _ForgetPasswordExtensionState extends State<ForgetPasswordExtension> {
  FocusNode loginFocusNode = new FocusNode();
  TextEditingController loginController = TextEditingController();
  Map userProfile;
  final loginKey = GlobalKey<FormState>();
  LoginData loginObj = new LoginData();

  @override
  void initState() {
    super.initState();
    loginFocusNode.addListener(() {
      setState(() {});
    });
  }



  @override
  void dispose() {
    super.dispose();
    loginFocusNode?.removeListener(() {
      setState(() {});
    });
  }



  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[

                  Container(
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
              onTap: ()
              {
              Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 50, 0, 0),
                child: Container(
                      height: 30,
                      width: 30,
                      child: Icon(Icons.arrow_back,color: Colors.black,)),
              )),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 70, 0, 10),
                    child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: Image.asset("images/logo.png",width: 200,),
                  ),
                  ),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 60, 20, 0),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 25,
                      child: Text(
                        "FORGOT PASSWORD",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 22,
                            color: appThemeColor1,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 70,
                      child: Text(
                        "Request a call back regarding Right Access's B2B offerings using the form below.",
                        textAlign: TextAlign.center,
                        maxLines: 10,
                        style: TextStyle(fontSize: 16, color: Colors.black54),
                      ),
                      alignment: Alignment.center,
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                    child: TextFormField(
                        focusNode: loginFocusNode,
                        controller: loginController,
                        style: TextStyle(color: Colors.black),
                        keyboardType: TextInputType.emailAddress,
                        textAlign: TextAlign.left,
                        decoration: setInputDecorationForEdit(
                            "Email",
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
                    padding: const EdgeInsets.fromLTRB(10, 40, 0, 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: 280,
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: appThemeColor1,
                          ),
                          child: FlatButton(
                            color: Colors.transparent,
                            child: Text("Submit",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontStyle: FontStyle.normal)),
                            onPressed: () {
                              if (loginKey.currentState.validate()) {
                                ShowLoader(context);
                                SchedulerBinding.instance
                                    .addPostFrameCallback((_) => forgotPassword(
                                    loginObj, context, "password"));
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: 280,
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: appThemeColor1,
                          ),
                          child: FlatButton(
                            color: Colors.transparent,
                            child: Text("Login",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontStyle: FontStyle.normal)),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 60, 10, 0),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 25,
                      child: Text(
                        "Powered By Right Access",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18, color: Colors.black54),
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
                        style: TextStyle(fontSize: 18, color: Colors.black54),
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
    );
  }

  void forgotPassword(
      LoginData login, BuildContext context, String loginType) async {
    Map param = Map();
    param["email"] = login.email;

    final url = "$baseUrl/password/email";
    var result = await CallApi("POST", param, url);
    HideLoader(context);

    if (result[kDataCode] == "200") {
      ShowSuccessMessage(result["msg"], context);

    } else if (result[kDataCode] == "422") {
      ShowErrorMessage(result[kDataMessage], context);
    } else {
      ShowErrorMessage(result[kDataError], context);
    }
  }
}
