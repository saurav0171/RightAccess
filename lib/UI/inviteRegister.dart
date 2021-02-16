import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:right_access/CommonFiles/common.dart';
import 'package:right_access/ServerFiles/serviceAPI.dart';
import 'package:right_access/data/loginData.dart';
import 'package:url_launcher/url_launcher.dart';

bool isRemembered = false;
final dateFormat = DateFormat("dd/MM/yyyy");
bool isAdult = false;
String locationError = "";

Map eventObj = {};


List professionsList = [];
List<String> professionsListString = [];
String selectedProfessions;
Map selectedProfessionsObject = {};

class InviteRegister extends StatelessWidget {
  InviteRegister(param);
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
              child: Icon(Icons.arrow_back,)),
              title: Image.asset("images/logo.png",width: 200,),
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
    print("Obj[kDataUserRegistrationStatus]: ${eventObj[kDataUserRegistrationStatus]}");
    ShowLoader(context);
    fetchProfessions();
  }

  fetchProfessions() async {
    final url = "$baseUrl/professions/listing";
    var result = await CallApi("GET", null, url);
    HideLoader(context);
    if (result[kDataCode] == "200") {
      setState(() {
        professionsList = result[kDataData];
        professionsListString = [];
        for (var i = 0; i < professionsList.length; i++) {
          professionsListString.add(professionsList[i][kDataName]);
        }
      });
      // fetchSalutations();
    }  else if (result[kDataCode] == "401" || result[kDataCode] == "404" || result[kDataCode] == "422") {
      showAlertDialog(result[kDataMessage], context);
    } else {
      showAlertDialog(result[kDataError], context);
    }
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



  skipRegister() async
  {
    Map param = Map();    
    
    final url = "$baseUrl/events/${eventObj[kDataEventId].toString()}/register/skip";
    var result = await CallApi("POST", param, url);
    // var result = await makePostRequest("POST", param, url) ;
    HideLoader(context);

    if (result[kDataCode] == "200") {
      ShowSuccessMessage(result[kDataMessage], context);
      Timer(Duration(seconds: 2), ()
      {
        Navigator.pop(context, true);
      });
       
    } else if (result[kDataCode] == "422") {
     
      ShowErrorMessage(result[kDataMessage], context);
    } else {
      ShowErrorMessage(result[kDataError], context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return eventObj[kDataUserRegistrationStatus] == false? Container(
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
                          "Thanks for registering!",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 22,
                              color: appThemeColor1,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                    //   child: Container(
                    //     width: MediaQuery.of(context).size.width,
                    //     height: 25,
                    //     child: Text(
                    //       "REGISTER WITH US",
                    //       textAlign: TextAlign.center,
                    //       style: TextStyle(
                    //           fontSize: 22,
                    //           color: appThemeColor1,
                    //           fontWeight: FontWeight.w600),
                    //     ),
                    //   ),
                    // ),
                      // Padding(
                      //   padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                      //   child: Container(
                      //     width: MediaQuery.of(context).size.width,
                      //     height: 70,
                      //     child: Text(
                      //       "Request a call back regarding Right Access's B2B\nofferings Using the form below.",
                      //       textAlign: TextAlign.center,
                      //       maxLines: 10,
                      //       style: TextStyle(fontSize: 16, color: Colors.black54),
                      //     ),
                      //     alignment: Alignment.center,
                      //   ),
                      // ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                      child: Container(
                        height: 4,
                        color: appThemeColor1,
                      ),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    //   child: TextFormField(
                    //       focusNode: professionFocusNode,
                    //       controller: professionController,
                    //       style: TextStyle(color: Colors.black),
                    //       textAlign: TextAlign.left,
                    //       keyboardType: TextInputType.text,
                    //       decoration: setInputDecorationForEdit(
                    //           "Please enter your Profession",
                    //           "Please enter your Profession",
                    //           appThemeColor1,
                    //           appThemeColor1,
                    //           appThemeColor1,
                    //           Icons.account_circle_rounded,
                    //           professionFocusNode),
                    //       validator: (value) {
                    //         if (value.isEmpty) {
                    //           return "Please enter City";
                    //         }
                    //       }),
                    // ),

                     Padding(
                       padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                       child: Container(
                         alignment: Alignment.center,
                         height: 60,
                         decoration: BoxDecoration(
                           borderRadius: BorderRadius.circular(15),
                           border: Border.all(color: Colors.black45)
                         ),
                         child: Padding(
                           padding: const EdgeInsets.fromLTRB(15, 0, 10, 0),
                           child: DropdownButton<String>(
                             value: selectedProfessions,
                             hint: Text(
                               "Select a Profession",
                               style: TextStyle(color: Colors.grey.shade400, fontSize: 16),
                             ),
                             isExpanded: true,
                             iconSize: 24,
                             elevation: 16,
                             style: TextStyle(
                               color: Colors.black,
                               fontSize: 16,
                             ),
                             underline: Container(
                               height: 0,
                             ),
                             onChanged: (String newValue) {
                               FocusScope.of(context).requestFocus(new FocusNode());
                               setState(() {
                                   selectedProfessions = newValue;
                                   int index = professionsList
                                       .indexWhere((data) => data[kDataName] == newValue);
                                   selectedProfessionsObject = professionsList[index];
                               });
                             },
                             items: professionsListString
                                   .map<DropdownMenuItem<String>>((String value) {
                               return DropdownMenuItem<String>(
                                   value: value,
                                   child: Container(
                                       alignment: Alignment.centerLeft,
                                       child: Text(
                                         value,
                                       )),
                               );
                             }).toList(),
                           ),
                         ),
                       ),
                     ),
                    // Padding(
                    //   padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    //   child: TextFormField(
                    //       focusNode: organizationNameFocusNode,
                    //       controller: organizationNameController,
                    //       style: TextStyle(color: Colors.black),
                    //       textAlign: TextAlign.left,
                    //       keyboardType: TextInputType.text,
                    //       decoration: setInputDecorationForEdit(
                    //           "Please enter Organization/Institute",
                    //           "Please enter Organization/Institute",
                    //           appThemeColor1,
                    //           appThemeColor1,
                    //           appThemeColor1,
                    //           Icons.location_city,
                    //           organizationNameFocusNode),
                    //       validator: (value) {
                    //         if (value.isEmpty) {
                    //           return "Please enter Organization/Institute";
                    //         }
                    //       }),
                    // ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
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


                  Padding(
                    padding: const EdgeInsets.fromLTRB(30, 30, 20, 0),
                    child: Container(
                      // alignment: Alignment.centerLeft,
                      child: Text(
                              "Upload Supporting Documents",
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              style: TextStyle(fontSize: 16, color: Colors.black54),
                            ),
                    ),
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
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
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
                              child: GestureDetector(
                                  child: RichText(
                                  text:TextSpan(
                                    children:[
                                      TextSpan(
                                        text: "I Accept ",
                                       style: TextStyle(
                                      fontSize: 14, color: Colors.black),
                                      ),
                                      TextSpan(
                                        text: "Terms & Conditions and Privacy Policy",
                                       style: TextStyle(
                                      fontSize: 14, color: Colors.black,fontWeight: FontWeight.w800),
                                      )
                                    ]
                                  ) 
                                 
                                ),
                                onTap: ()
                                {
                                  launch("https://rightaccess.org/privacy-policy");
                                },
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
                                    /*if (cityController.text.length==0||(selectedProfessions==null|| selectedProfessions.length==0))
                                    {
                                      showAlert(context, "All Fields are mandatory");
                                      return;
                                    }
                                    else if(image==null)
                                    {
                                      showAlert(context, "Please upload a supporting document");
                                      return;
                                    }*/
                                     if(!isRemembered)
                                    {
                                      showAlert(context, "Please accept Terms and Conditions");
                                      return;
                                    }
                                    ShowLoader(context);
                                    SchedulerBinding.instance
                                        .addPostFrameCallback((_) =>
                                            createUser(loginObj, context));
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
                                child: Text("SKIP",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18,
                                        color: Colors.white,
                                        fontStyle: FontStyle.normal)),
                                onPressed: () {
                                  ShowLoader(context);
                                  skipRegister();
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
    ):Container(child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 100,
                        child: Text(
                          "Your Registration request is under review. Kindly wait for the result",
                          textAlign: TextAlign.center,
                          maxLines: 10,
                          style: TextStyle(fontSize: 16, color: Colors.black54),
                        ),
                        alignment: Alignment.center,
                      ),);
  }

  void createUser(LoginData register, BuildContext context) async {
    var result = await inviteRegistration(image, selectedProfessionsObject[kDataID].toString(),
        cityController.text, isRemembered,eventObj[kDataEventId].toString());
    // var result = await makePostRequest("POST", param, url) ;
    HideLoader(context);
    if (result[kDataData].length > 0) {
      ShowSuccessMessage(result[kDataMessage], context);
      Timer(Duration(seconds: 2), ()
      {
        Navigator.pop(context, true);
      });
    } else {
      ShowErrorMessage(result[kDataError], context);
    }
  }
}
