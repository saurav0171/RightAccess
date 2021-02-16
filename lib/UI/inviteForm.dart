import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:right_access/CommonFiles/common.dart';
import 'package:right_access/ServerFiles/serviceAPI.dart';
import 'package:right_access/UI/contacts.dart';
import 'package:right_access/data/loginData.dart';

bool isRemembered = false;
final dateFormat = DateFormat("dd/MM/yyyy");
bool isAdult = false;
String locationError = "";
Map _contactObj = {};
Map inviteID = {};

class InviteForm extends StatelessWidget {
  InviteForm(param1);
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
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.arrow_back,
                  )),
              title: Image.asset(
                "images/logo.png",
                width: 200,
              ),
            ),
            body: FormKeyboardActions(child: InviteFormExtension()),
          ),
        ],
      ),
    );
  }
}

class InviteFormExtension extends StatefulWidget {
  @override
  _InviteFormExtensionState createState() => _InviteFormExtensionState();
}

class _InviteFormExtensionState extends State<InviteFormExtension> {
  FocusNode nameFocusNode = new FocusNode();
  FocusNode lastNameFocusNode = new FocusNode();
  FocusNode emailFocusNode = new FocusNode();
  FocusNode mobileFocusNode = new FocusNode();

  TextEditingController nameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileController = TextEditingController();

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
          focusNode: lastNameFocusNode,
        ),
        KeyboardAction(
          focusNode: mobileFocusNode,
        ),
        KeyboardAction(
          focusNode: emailFocusNode,
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
    lastNameFocusNode.addListener(() {
      setState(() {});
    });
    mobileFocusNode.addListener(() {
      setState(() {});
    });
    emailFocusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    nameFocusNode?.removeListener(() {
      setState(() {});
    });
    lastNameFocusNode.removeListener(() {
      setState(() {});
    });
    mobileFocusNode.removeListener(() {
      setState(() {});
    });
    emailFocusNode.removeListener(() {
      setState(() {});
    });
  }

  fetchContact(Map contact)
  {

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
                      padding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 25,
                        child: Text(
                          "INVITE FRIENDS",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 22,
                              color: appThemeColor1,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                      child: Container(
                        height: 4,
                        color: appThemeColor1,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                      child: TextFormField(
                          focusNode: nameFocusNode,
                          controller: nameController,
                          style: TextStyle(color: Colors.black),
                          textAlign: TextAlign.left,
                          keyboardType: TextInputType.text,
                          decoration: setInputDecorationForEdit(
                              "Please enter your Name",
                              "Please enter your Name",
                              appThemeColor1,
                              appThemeColor1,
                              appThemeColor1,
                              Icons.account_circle_rounded,
                              nameFocusNode),
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Please enter Name";
                            }
                             else {
                              loginObj.firstName = value;
                            }
                          }),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                      child: TextFormField(
                          focusNode: lastNameFocusNode,
                          controller: lastNameController,
                          style: TextStyle(color: Colors.black),
                          textAlign: TextAlign.left,
                          keyboardType: TextInputType.multiline,
                          decoration: setInputDecorationForEdit(
                              "Enter your Last Name",
                              "Enter your Last Name",
                              appThemeColor1,
                              appThemeColor1,
                              appThemeColor1,
                              Icons.person,
                              lastNameFocusNode),
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Please enter your Last Name";
                            } else {
                              loginObj.lastName = value;
                            }
                          }),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                      child: TextFormField(
                          focusNode: emailFocusNode,
                          controller: emailController,
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
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                                focusNode: mobileFocusNode,
                                controller: mobileController,
                                style: TextStyle(color: Colors.black),
                                textAlign: TextAlign.left,
                                keyboardType: TextInputType.emailAddress,
                                decoration: setInputDecorationForEdit(
                                    "Please enter your Mobile",
                                    "Please enter your Mobile",
                                    appThemeColor1,
                                    appThemeColor1,
                                    appThemeColor1,
                                    Icons.email,
                                    emailFocusNode),
                                validator: (value) {
                                  String patttern =
                                      r'(^(?:[+0]9)?[0-9]{10,12}$)';
                                  RegExp regExp = new RegExp(patttern);
                                  if (value.length == 0) {
                                    return 'Please enter Phone Number';
                                  }
                                  //  else if (!regExp.hasMatch(value)) {
                                  //   return 'Please enter valid Phone Number';
                                  // }
                                  else {
                                    loginObj.mobileno = value;
                                  }
                                }),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                            child: Container(
                              width: 50,
                              height: 50,
                              child: InkWell(
                                child: Icon(
                                  Icons.contact_phone,
                                  size: 40,
                                  color: Colors.grey,
                                ),
                                onTap: () async{
                                      Map status = await Navigator.push(
                                                      context,
                                                      MaterialPageRoute(builder: (context) => ContactList(contactObj = _contactObj)),
                                                    ) as Map;
                                                    if (status != null && status.length > 0) 
                                                    {
                                                      setState(() {
                                                        _contactObj = status;
                                                        nameController.text = _contactObj[kDataName];
                                                        mobileController.text = _contactObj[kDataMobile];
                                                        emailController.text = _contactObj[kDataEmail];
                                                      });
                                                    }
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
                            child: Container(
                              // decoration: setBoxDecoration(Colors.white),
                              child: FlatButton(
                                color: appThemeColor1,
                                child: Text("REGISTER",
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
                                            createUser(loginObj, context));
                                  }
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
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

  void createUser(LoginData register, BuildContext context) async {
    Map param = Map();
    param["first_name"] = register.firstName;
    param["last_name"] = register.lastName;
    param["mobile"] = register.mobileno;
    param["email"] = register.email;
    param["info"] = "This is an invitation to an event";

    Map users = {
      "users": [param]
    };

    final url = "$baseUrl/invitations/${inviteID[kDataID].toString()}/users";
    var result = await CallApi("POST", users, url);
    HideLoader(context);
    if (result[kDataCode] == "200") {
      ShowSuccessMessage("User invited successfully", context);
      Timer(Duration(seconds: 2), () {
        Navigator.pop(context, true);
      });
    } else if (result[kDataCode] == "401" || result[kDataCode] == "404" || result[kDataCode] == "422") {
      showAlertDialog(result[kDataMessage], context);
    } else {
      showAlertDialog(result[kDataError], context);
    }
  }
}
