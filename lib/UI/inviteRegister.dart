import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:location/location.dart';
import 'package:right_access/CommonFiles/common.dart';
import 'package:right_access/Globals/globals.dart' as globals;
import 'package:right_access/ServerFiles/serviceAPI.dart';
import 'package:right_access/data/loginData.dart';

bool isRemembered = false;
final dateFormat = DateFormat("dd/MM/yyyy");
bool isAdult = false;
String locationError = "";
LocationData currentLocation;

class InviteRegister extends StatelessWidget {
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
              iconTheme: IconThemeData(
                color: Colors.black, //change your color here
              ),
              title: Text("Events"),
              centerTitle: true,
            ),
            body: FormKeyboardActions(child: InviteRegisterExtension()),
          ),
        ],
      ),
    );
  }
}

class InviteRegisterExtension extends StatefulWidget {
  @override
  _InviteRegisterExtensionState createState() =>
      _InviteRegisterExtensionState();
}

class _InviteRegisterExtensionState extends State<InviteRegisterExtension> {
  FocusNode professionFocusNode = new FocusNode();
  FocusNode organizationNameFocusNode = new FocusNode();
  FocusNode cityFocusNode = new FocusNode();

  TextEditingController professionController = TextEditingController();
  TextEditingController organizationNameController = TextEditingController();
  TextEditingController cityController = TextEditingController();

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
          focusNode: professionFocusNode,
        ),
        KeyboardAction(
          focusNode: organizationNameFocusNode,
        ),
        KeyboardAction(
          focusNode: cityFocusNode,
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
    professionFocusNode.addListener(() {
      setState(() {});
    });
    organizationNameFocusNode.addListener(() {
      setState(() {});
    });
    cityFocusNode.addListener(() {
      setState(() {});
    });
  }

  getUserLocation() async {
    //call this async method from whereever you need
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
    currentLocation = myLocation;
  }

  @override
  void dispose() {
    super.dispose();
    professionFocusNode?.removeListener(() {
      setState(() {});
    });
    organizationNameFocusNode.removeListener(() {
      setState(() {});
    });
    cityFocusNode.removeListener(() {
      setState(() {});
    });
  }

  Future<void> _optionsDialogBox() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: new SingleChildScrollView(
              child: new ListBody(
                children: <Widget>[
                  GestureDetector(
                    child: new Text('Take a picture'),
                    onTap: getCameraImage,
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                  ),
                  GestureDetector(
                    child: new Text('Select from gallery'),
                    onTap: getGalleryImage,
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future getGalleryImage() async {
    Navigator.pop(context);
    image = await ImagePicker.pickImage(
        source: ImageSource.gallery, maxHeight: 700);
    setState(() {
      if (image != null) {}
    });
  }

  Future getCameraImage() async {
    Navigator.pop(context);
    image =
        await ImagePicker.pickImage(source: ImageSource.camera, maxHeight: 700);
    setState(() {
      if (image != null) {}
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
                          "THANK YOU",
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
                        height: 25,
                        child: Text(
                          "REGISTER WITH US",
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
                          "Request a call back regarding Together's B2B\nofferings Using the form below.",
                          textAlign: TextAlign.center,
                          maxLines: 10,
                          style: TextStyle(fontSize: 16, color: Colors.black54),
                        ),
                        alignment: Alignment.center,
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
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                      child: TextFormField(
                          focusNode: professionFocusNode,
                          controller: professionController,
                          style: TextStyle(color: Colors.black),
                          textAlign: TextAlign.left,
                          keyboardType: TextInputType.text,
                          decoration: setInputDecorationForEdit(
                              "Please enter your Profession",
                              "Please enter your Profession",
                              appThemeColor1,
                              appThemeColor1,
                              appThemeColor1,
                              Icons.account_circle_rounded,
                              professionFocusNode),
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Please enter City";
                            }
                          }),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                      child: TextFormField(
                          focusNode: organizationNameFocusNode,
                          controller: organizationNameController,
                          style: TextStyle(color: Colors.black),
                          textAlign: TextAlign.left,
                          keyboardType: TextInputType.text,
                          decoration: setInputDecorationForEdit(
                              "Please enter Organization Name",
                              "Please enter Organization Name",
                              appThemeColor1,
                              appThemeColor1,
                              appThemeColor1,
                              Icons.location_city,
                              organizationNameFocusNode),
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Please enter Organization Name";
                            }
                          }),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                      child: TextFormField(
                          focusNode: cityFocusNode,
                          controller: cityController,
                          style: TextStyle(color: Colors.black),
                          textAlign: TextAlign.left,
                          keyboardType: TextInputType.text,
                          decoration: setInputDecorationForEdit(
                              "Please enter City",
                              "Please enter City",
                              appThemeColor1,
                              appThemeColor1,
                              appThemeColor1,
                              Icons.add_location,
                              cityFocusNode),
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Please enter City";
                            }
                          }),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (image == null) {
                          _optionsDialogBox();
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 16.0),
                        height: 180,
                        child: GestureDetector(
                          child: Container(
                              padding: EdgeInsets.all(5.0),
                              width: 150,
                              height: 150,
                              child: Stack(
                                children: <Widget>[
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        padding: EdgeInsets.all(0.0),
                                        height: 120,
                                        width: 200,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.black,
                                              width: 1.0,
                                            ),
                                            color: Colors.grey.withAlpha(30),
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(10.0),
                                                bottomLeft:
                                                    Radius.circular(10.0),
                                                bottomRight:
                                                    Radius.circular(10.0),
                                                topRight:
                                                    Radius.circular(10.0))),
                                        child: ClipRRect(
                                            borderRadius:
                                                new BorderRadius.circular(8.0),
                                            child: image == null
                                                ? Icon(
                                                    Icons.add_a_photo,
                                                    color: appThemeColor1,
                                                    size: 80,
                                                  )
                                                : Image.file(
                                                    image,
                                                    fit: BoxFit.cover,
                                                  )),
                                      ),
                                    ],
                                  ),
                                  Visibility(
                                      visible: image != null,
                                      child: Container(
                                        height: 30,
                                        alignment: Alignment.topRight,
                                        child: GestureDetector(
                                          onTap: () {
                                            if (image != null) {
                                              image = null;
                                            }
                                            setState(() {});
                                          },
                                          child: Icon(
                                            Icons.clear,
                                            color: Colors.black,
                                            size: 30,
                                          ),
                                        ),
                                      ))
                                ],
                              )),
                          onTap: _optionsDialogBox,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                            child: Container(
                              width: MediaQuery.of(context).size.width - 80,
                              child: Text(
                                "I Accept Terms & Conditions and Privacy Policy",
                                textAlign: TextAlign.start,
                                maxLines: 10,
                                style: TextStyle(
                                    fontSize: 14, color: Colors.black),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
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
                                            createUser(loginObj, context));
                                  }
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
                            child: Container(
                              // decoration: setBoxDecoration(Colors.white),
                              child: FlatButton(
                                color: appThemeColor1,
                                child: Text("Go Back",
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
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
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
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 30),
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

  void createUser(LoginData register, BuildContext context) async {
    var result = await inviteRegistration(image, professionController.text,
        cityController.text, organizationNameController.text, isRemembered);
    // var result = await makePostRequest("POST", param, url) ;
    HideLoader(context);
    if (result[kDataCode] == "200") {
      if (result[kDataStatusCode] == 200) {
        SetSharedPreference(kDataLoginUser, result[kDataData]);
        globals.globalCurrentUser = result[kDataData];
      } else {
        ShowErrorMessage(result[kDataResult], context);
      }
    } else {
      ShowErrorMessage(result[kDataError], context);
    }
  }
}
