import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:right_access/CommonFiles/common.dart';
import 'package:right_access/ServerFiles/serviceAPI.dart';
import 'package:right_access/data/loginData.dart';

bool isRemembered = false;
final dateFormat = DateFormat("dd/MM/yyyy");
bool isAdult = false;
String locationError = "";

Map supportData = {};


class SupportPage extends StatelessWidget {
SupportPage(param1);
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Stack(
        children: <Widget>[
          new Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(color: appBackgroundColor)),
          Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0.0,
            leading: GestureDetector(
              onTap: ()
              {
                Navigator.pop(context);
              },
              child: Icon(Icons.close_rounded,)),
              title: Image.asset("images/logo.png",width: 200,),
            ),
            body: FormKeyboardActions(child: SupportPageExtension()),
          ),
        ],
      ),
    );
  }
}



class SupportPageExtension extends StatefulWidget {
  @override
  _SupportPageExtensionState createState() => _SupportPageExtensionState();
}

class _SupportPageExtensionState extends State<SupportPageExtension> {
  FocusNode nameFocusNode = new FocusNode();
  FocusNode phoneFocusNode = new FocusNode();
  FocusNode emailFocusNode = new FocusNode();
  FocusNode descriptionFocusNode = new FocusNode();
  FocusNode organizationNameFocusNode = new FocusNode();
  


  var image;

  /// Creates the [KeyboardActionsConfig] to hook up the fields
  /// and their focus nodes to our [FormKeyboardActions].
  KeyboardActionsConfig _buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      keyboardBarColor: Colors.grey[200],
      nextFocus: true,
      actions: [
        KeyboardAction(
          focusNode: nameFocusNode,
        ),
        KeyboardAction(
          focusNode: phoneFocusNode,
        ),
        KeyboardAction(
          focusNode: emailFocusNode,
        ),
        KeyboardAction(
          focusNode: descriptionFocusNode,
        ),
        KeyboardAction(
          focusNode: organizationNameFocusNode,
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
    nameFocusNode.addListener(() {
      setState(() {});
    });
    phoneFocusNode.addListener(() {
      setState(() {});
    });
    emailFocusNode.addListener(() {
      setState(() {});
    });
    descriptionFocusNode.addListener(() {
      setState(() {});
    });
    organizationNameFocusNode.addListener(() {
      setState(() {});
    });
  }



  @override
  void dispose() {
    super.dispose();
    nameFocusNode?.removeListener(() {
      setState(() {});
    });
    phoneFocusNode.removeListener(() {
      setState(() {});
    });
    emailFocusNode.removeListener(() {
      setState(() {});
    });
    descriptionFocusNode.removeListener(() {
      setState(() {});
    });
    organizationNameFocusNode.removeListener(() {
      setState(() {});
    });
  }

  

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Form(
          key: loginKey,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: Container(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                   
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 25,
                        child: Text(
                          "SUPPORT",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 22,
                              color: appThemeColor1,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    
                    // Padding(
                    //   padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    //   child: Container(
                    //     width: MediaQuery.of(context).size.width,
                    //     height: 70,
                    //     child: Text(
                    //       "Please submit your query. We will assist you at the earliest",
                    //       textAlign: TextAlign.center,
                    //       maxLines: 10,
                    //       style: TextStyle(fontSize: 16, color: Colors.black54),
                    //     ),
                    //     alignment: Alignment.center,
                    //   ),
                    // ),
                    // Padding(
                    //   padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                    //   child: Container(
                    //     height: 4,
                    //     color: appThemeColor1,
                    //   ),
                    // ),




                     Padding(
                      padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
                      child: TextFormField(
                          focusNode: nameFocusNode,
                          style: TextStyle(color: Colors.black),
                          textAlign: TextAlign.left,
                          keyboardType: TextInputType.multiline,
                          decoration: setInputDecorationForEdit(
                              "Enter your Name",
                              "Enter your Name",
                              appThemeColor1,
                              appThemeColor1,
                              appThemeColor1,
                              Icons.person,
                              nameFocusNode),
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Please enter your Name";
                            } else {
                              loginObj.firstName = value;
                            }
                          }),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                      child: TextFormField(
                          focusNode: phoneFocusNode,
                          style: TextStyle(color: Colors.black),
                          textAlign: TextAlign.left,
                          keyboardType: TextInputType.phone,
                          decoration: setInputDecorationForEdit(
                              "Please enter Phone Number",
                              "Please enter Phone Number",
                              appThemeColor1,
                              appThemeColor1,
                              appThemeColor1,
                              Icons.phone,
                              phoneFocusNode),
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Please enter Phone Number";
                            }
                            else
                            {
                              loginObj.mobileno  = value;
                            }
                          }),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                      child: TextFormField(
                          focusNode: emailFocusNode,
                          style: TextStyle(color: Colors.black),
                          textAlign: TextAlign.left,
                          keyboardType: TextInputType.emailAddress,
                          decoration: setInputDecorationForEdit(
                              "Please enter your Email Address",
                              "Please enter your Email Address",
                              appThemeColor1,
                              appThemeColor1,
                              appThemeColor1,
                              Icons.email,
                              emailFocusNode),
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Please enter email";
                            } else if (!checkValidEmail(value)) {
                              return "Please enter valid email";
                            } else {
                              loginObj.email = value;
                            }
                          }),
                    ),


                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                      child: TextFormField(
                          focusNode: descriptionFocusNode,
                          style: TextStyle(color: Colors.black),
                          textAlign: TextAlign.left,
                          keyboardType: TextInputType.multiline,
                          decoration: setInputDecorationForEdit(
                              "Enter Description",
                              "Enter Description",
                              appThemeColor1,
                              appThemeColor1,
                              appThemeColor1,
                              Icons.description,
                              descriptionFocusNode),
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Please enter Description";
                            } else {
                              loginObj.address = value;
                            }
                          }),
                    ),
                    
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: TextFormField(
                          focusNode: organizationNameFocusNode,
                          style: TextStyle(color: Colors.black),
                          textAlign: TextAlign.left,
                          keyboardType: TextInputType.text,
                          decoration: setInputDecorationForEdit(
                              "Please enter Organization/Institute",
                              "Please enter Organization/Institute",
                              appThemeColor1,
                              appThemeColor1,
                              appThemeColor1,
                              Icons.location_city,
                              organizationNameFocusNode),
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Please enter Organization/Institute";
                            }
                            else
                            {
                              loginObj.country  = value;
                            }
                          }),
                    ),
                   



                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(20, 30, 20, 50),
                            child: Container(
                              // decoration: setBoxDecoration(Colors.white),
                              child: FlatButton(
                                color: appThemeColor1,
                                child: Text("SUBMIT",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18,
                                        color: Colors.white,
                                        fontStyle: FontStyle.normal)),
                                onPressed: () {
                                  if (loginKey.currentState.validate()) {
                                    ShowLoader(context);
                                    SchedulerBinding.instance
                                        .addPostFrameCallback((_) =>
                                            supportApiCalled(loginObj, context));
                                  }
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    //   child: Container(
                    //     width: MediaQuery.of(context).size.width,
                    //     height: 25,
                    //     child: Text(
                    //       "Powered By Right Access",
                    //       textAlign: TextAlign.center,
                    //       style: TextStyle(fontSize: 18, color: Colors.black54),
                    //     ),
                    //   ),
                    // ),
                    // Padding(
                    //   padding: const EdgeInsets.fromLTRB(10, 0, 10, 30),
                    //   child: Container(
                    //     width: MediaQuery.of(context).size.width,
                    //     height: 25,
                    //     child: Text(
                    //       "It is a long established fact that a reader",
                    //       textAlign: TextAlign.center,
                    //       style: TextStyle(fontSize: 18, color: Colors.black54),
                    //     ),
                    //     alignment: Alignment.center,
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

  void supportApiCalled(LoginData register, BuildContext context) async {
    
     final url = "$baseUrl/contact/submit";
      Map param = Map();
    param["name"] = register.firstName;
    param["organization_name"] = register.country;
    param["phone_number"] = register.mobileno;
    param["description"] = register.address;
    param["email"] = register.email;
    param["event_id"] = supportData[kDataEventId].toString();
    var result = await CallApi("POST", param, url);
    HideLoader(context);
    if (result.length > 0) {
      ShowSuccessMessage(result["msg"], context);
      Timer(Duration(seconds: 2), ()
      {
        Navigator.pop(context, true);
      });
    } else {
      ShowErrorMessage(result[kDataError], context);
    }
  }
}
