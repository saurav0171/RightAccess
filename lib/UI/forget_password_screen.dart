
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
// import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:right_access/CommonFiles/common.dart';
import 'package:right_access/Globals/globals.dart' as globals;
import 'package:right_access/ServerFiles/serviceAPI.dart';
import 'package:right_access/UI/register.dart';
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

  getTheMobileNumber(String type) async {
    await showDialog<String>(
        context: context,
        builder: (_) {
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
                        labelText: 'Mobile Number',
                        labelStyle: TextStyle(color: Colors.black)),
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
                    if (mobileController.text.isEmpty) {
                      ShowErrorMessage("Please enter Mobile Number", context);
                    } else if (!regExp.hasMatch(mobileController.text)) {
                      ShowErrorMessage(
                          "Please enter valid mobile number", context);
                    } else {
                      Navigator.pop(context);
                      ShowLoader(context);
                      loginUser(loginObj, context, type);
                    }
                  })
            ],
          );
        });
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
                          Text("RIGHT",
                              style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 24,
                                  color: appThemeColor1,
                                  fontStyle: FontStyle.normal)),
                          Text("ACCESS",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 24,
                                  color: Colors.black,
                                  fontStyle: FontStyle.normal)),
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
                              color: appThemeColor1,
                              fontWeight: FontWeight.w600),
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
                          style: TextStyle(fontSize: 16, color: Colors.black54),
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
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: 30,
                            height: 30,
                            child: FlatButton(
                              padding: EdgeInsets.symmetric(
                                  vertical: 0.0, horizontal: 0.0),
                              color: Colors.transparent,
                              child: Icon(
                                isRemembered
                                    ? Icons.check_box
                                    : Icons.check_box_outline_blank,
                                size: 30,
                                color: Colors.black45,
                              ),
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
                              style:
                              TextStyle(fontSize: 16, color: Colors.black),
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
                              child: Text("Change Password",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18,
                                      color: Colors.white,
                                      fontStyle: FontStyle.normal)),
                              onPressed: () {
                                if (loginKey.currentState.validate()) {
                                  ShowLoader(context);
                                  SchedulerBinding.instance
                                      .addPostFrameCallback((_) => loginUser(
                                      loginObj, context, "password"));
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 15, 10, 0),
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
      ),
    );
  }

  void loginUser(
      LoginData login, BuildContext context, String loginType) async {
    Map param = Map();
    param["email"] = login.email;
    param["password"] = login.password;

    final url = "$baseUrl/login";
    var result = await CallApi("POST", param, url);
    HideLoader(context);

    if (result[kDataCode] == "200") {
      SetSharedPreference(kDataLoginUser, result[kDataData]);
      globals.globalCurrentUser = result[kDataData][kDataUser];
      if (isRemembered) {
        Map remember = {kDataEmail: login.email, kDataPassword: login.password};
        SetSharedPreference(kDataRemembered, remember);
      } else {
        RemoveSharedPreference(kDataRemembered);
      }

    } else if (result[kDataCode] == "422") {
      ShowErrorMessage(result[kDataMessage], context);
    } else {
      ShowErrorMessage(result[kDataError], context);
    }
  }
}