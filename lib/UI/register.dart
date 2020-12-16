import 'dart:convert';
import 'dart:io';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:geocoder/geocoder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:location/location.dart';
import 'package:right_access/CommonFiles/common.dart';
import 'package:right_access/ServerFiles/serviceAPI.dart';
import 'package:right_access/data/loginData.dart';
import 'package:right_access/Globals/globals.dart' as globals;



List<String> usersList = ["Wholesaler","Retailer", "Delivery Boy"];
String selectedUser ;



List stateList = [];
List<String> stateListString = [];
String selectedState ; 
Map selectedStateObject = {};

List zoneList = [];
List<String> zoneListString = [];
String selectedZone ; 
Map selectedZoneObject = {};


DateTime dob;
TextEditingController dateController = TextEditingController();


final dateFormat = DateFormat("dd/MM/yyyy");
bool isAdult = false; 
String locationError = "";
LocationData currentLocation;

class Register extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: Stack(
        children: <Widget>[
          new Container(
            height: double.infinity,
            width: double.infinity,
            // color: appThemeColor1,
            decoration: BoxDecoration(color: appBackgroundColor)
            // decoration: setBackgroundImage(),
          ),
          Scaffold(
            // backgroundColor: appThemeColor1,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: appThemeColor1,
              elevation: 0.0,
              title: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                child: Text("REGISTER", style: TextStyle(color:Colors.white),),
              ),
              leading: Padding(
                padding: const EdgeInsets.all(0.0),
                child: InkWell(
                    child: Container(
                    decoration: BoxDecoration(
                      borderRadius: new BorderRadius.circular(5.0),
                      color: appThemeColor1
                    ),
                    child: Icon(Icons.arrow_back,color: Colors.white,)),
                    onTap: ()
                    {
                      Navigator.pop(context);
                    },
                ),
              ),
            ),
            body: FormKeyboardActions(child: RegisterExtension()),
          ),
        ],
      ),
    );
  }
}

class RegisterExtension extends StatefulWidget {
  @override
  _RegisterExtensionState createState() => _RegisterExtensionState();
}

class _RegisterExtensionState extends State<RegisterExtension> {
  FocusNode firstNameFocusNode = new FocusNode();
  FocusNode mobileFocusNode = new FocusNode();
  FocusNode emailFocusNode = new FocusNode();
  FocusNode addressFocusNode = new FocusNode();
  FocusNode cityFocusNode = new FocusNode();
  // FocusNode passwordFocusNode = new FocusNode();
  FocusNode adharFrontImageFocusNode = new FocusNode();
  FocusNode adharBackImageFocusNode = new FocusNode();
  FocusNode panCardImageFocusNode = new FocusNode();
  FocusNode drugLicenseImageFocusNode = new FocusNode();
  FocusNode gstNoImageFocusNode = new FocusNode();

  /// Creates the [KeyboardActionsConfig] to hook up the fields
  /// and their focus nodes to our [FormKeyboardActions].
  KeyboardActionsConfig _buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      keyboardBarColor: Colors.grey[200],
      nextFocus: true,
      actions: [
        KeyboardAction(
          focusNode: firstNameFocusNode,
        ),
        KeyboardAction(
          focusNode: mobileFocusNode,
        ),
        KeyboardAction(
          focusNode: emailFocusNode,
        ),
        KeyboardAction(
          focusNode: addressFocusNode,
        ),
        KeyboardAction(
          focusNode: cityFocusNode,
        ),
        // KeyboardAction(
        //   focusNode: passwordFocusNode,
        // ),
        KeyboardAction(
          focusNode: adharFrontImageFocusNode,
        ),
        KeyboardAction(
          focusNode: adharBackImageFocusNode,
        ),
        KeyboardAction(
          focusNode: panCardImageFocusNode,
        ),
        KeyboardAction(
          focusNode: drugLicenseImageFocusNode,
        ),
        KeyboardAction(
          focusNode: gstNoImageFocusNode,
        ),
        

      ],
    );
  }

  final loginKey = GlobalKey<FormState>();
  File profileImage ;
  TextEditingController frontImageController = TextEditingController();
  TextEditingController backImageController = TextEditingController();
   TextEditingController panImageController = TextEditingController();
  TextEditingController drugLicenseImageController = TextEditingController();
   TextEditingController gstNoImageController = TextEditingController();
  LoginData loginObj = new LoginData();

  @override
  void initState() {
    FormKeyboardActions.setKeyboardActions(context, _buildConfig(context));
    super.initState();
    firstNameFocusNode.addListener(() {
      setState(() {});
    });
    mobileFocusNode.addListener(() {
      setState(() {});
    });
    emailFocusNode.addListener(() {
      setState(() {});
    });
    addressFocusNode.addListener(() {
      setState(() {});
    });
    cityFocusNode.addListener(() {
      setState(() {});
    });
    // passwordFocusNode.addListener(() {
    //   setState(() {});
    // });
    adharFrontImageFocusNode.addListener(() {
      setState(() {});
    });
    adharBackImageFocusNode.addListener(() {
      setState(() {});
    });
    panCardImageFocusNode.addListener(() {
      setState(() {});
    });
    drugLicenseImageFocusNode.addListener(() {
      setState(() {});
    });
    gstNoImageFocusNode.addListener(() {
      setState(() {});
    });
    ShowLoader(context);
    fetchStates();
    // getUserLocation();
    
  }






  fetchStates() async 
  {
    final url = "$baseUrl/state_list";
    var result = await CallApi("GET", null, url);
    if (result[kDataCode] == "200") {
      
       setState(() {
         stateList = result[kDataData];
         stateListString = [];
        for (var i = 0; i < stateList.length; i++) 
        {
            stateListString.add(stateList[i][kDataStateName]);
        }
        fetchZones();
      });
    } else if (result[kDataCode] == "401") {
      
      ShowErrorMessage(result[kDataResult], context);
       HideLoader(context);
    } else {
      ShowErrorMessage(result[kDataError], context);
       HideLoader(context);
    }
   
  }


fetchZones() async 
  {
    final url = "$baseUrl/getallzones/1";
    var result = await CallApi("GET", null, url);
    if (result[kDataCode] == "200") {
      
       setState(() {
         zoneList = result[kDataData];
         zoneListString = [];
        for (var i = 0; i < zoneList.length; i++) 
        {
            zoneListString.add(zoneList[i][kDataZone]);
        }
      });
    } else if (result[kDataCode] == "401") {
      
      ShowErrorMessage(result[kDataResult], context);
    } else {
      ShowErrorMessage(result[kDataError], context);
    }
    HideLoader(context);
  }


 getUserLocation() async {//call this async method from whereever you need

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
       currentLocation = myLocation;
    }



  @override
  void dispose() {
    super.dispose();
    firstNameFocusNode?.removeListener(() {
      setState(() {});
    });
    mobileFocusNode?.removeListener(() {
      setState(() {});
    });
    emailFocusNode.removeListener(() {
      setState(() {});
    });
    addressFocusNode.removeListener(() {
      setState(() {});
    });
    cityFocusNode.removeListener(() {
      setState(() {});
    });
    // passwordFocusNode.removeListener(() {
    //   setState(() {});
    // });
    adharFrontImageFocusNode.removeListener(() {
      setState(() {});
    });
    adharBackImageFocusNode.removeListener(() {
      setState(() {});
    });
    panCardImageFocusNode.removeListener(() {
      setState(() {});
    });
    drugLicenseImageFocusNode.removeListener(() {
      setState(() {});
    });
    gstNoImageFocusNode.removeListener(() {
      setState(() {});
    });
    
  }

 void fetchImage(context, int imageIndex){
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc){
          return Container(
            child: new Wrap(
            children: <Widget>[
          new ListTile(
            title: new Text('Gallery'),
            onTap: () => {
              getImage(true,imageIndex),
            }          
          ),
          new ListTile(
            title: new Text('Camera'),
            onTap: () => {
              getImage(false,imageIndex),
              
            },          
          ),
            ],
          ),
          );
      }
    );
}

  Future getImage(bool isGallery, int imageIndex) async {
    var image = await ImagePicker.pickImage(source:isGallery? ImageSource.gallery:ImageSource.camera,imageQuality: 60, maxHeight: 300,maxWidth: 300);
   image = await compressImageFunction(image);
  Navigator.pop(context);

   List<int> imageBytes = await image.readAsBytes();
    String imageB64 = base64Encode(imageBytes);
    print("base 64 =======================$imageB64 ");
    // List paths = image.path.split(".");
    // print("extension of file : ${paths.last}");
 
  setState(() {
      profileImage = image;
      // List<int> imageBytes = await image.readAsBytes();
    // String imageB64 = base64Encode(imageBytes);
    // print("base 64 =======================$imageB64 ");
    List paths = image.path.split("/");
    print("extension of file : ${paths.last}");
    
    switch(imageIndex)
    {
      case 1: 
      { 
        loginObj.idProofFront = imageB64;
        frontImageController.text = paths.last;
      }
      break;

      case 2: 
      { 
        loginObj.idProofBack = imageB64;
        backImageController.text = paths.last;
      }
      break;

      case 3: 
      { 
        loginObj.panCard = imageB64;
        panImageController.text = paths.last;
      }
      break;

      case 4: 
      { 
        loginObj.drugLicense = imageB64;
        drugLicenseImageController.text = paths.last;
      }
      break;

       case 5: 
      { 
        loginObj.gstNo = imageB64;
        gstNoImageController.text = paths.last;
      }
      break;
    }


    });
    

    
    
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // alignment: Alignment.bottomCenter,
      // height: MediaQuery.of(context).size.height - 80,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Form(
          key: loginKey,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: Container(
              // decoration: setBoxDecorationForUpperCorners(Colors.white, Colors.transparent),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    // Padding(
                    //   padding: const EdgeInsets.fromLTRB(50, 30, 50, 20),
                    //   child: Image.asset(
                    //     "images/app-logo.png", height: 100,
                    //     fit: BoxFit.fitWidth,
                    //   ), 
                    
                    // ),

                    Padding(
                      padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
                      child: TextFormField(
                          focusNode: firstNameFocusNode,
                          style: TextStyle(color: Colors.black),
                          textAlign: TextAlign.left,
                          decoration: setInputDecorationForEdit(
                              "Please enter name",
                              "Name",
                              appThemeColor1,
                              appThemeColor1,
                              appThemeColor1,
                              Icons.person,
                              firstNameFocusNode),
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Please enter your name";
                            } else {
                              loginObj.firstName = value;
                            }
                          }),
                    ),



                    Padding(
                      padding: const EdgeInsets.fromLTRB(40, 20, 40, 10),
                      child: Container(
                        padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(5.0),
                                bottomLeft: Radius.circular(5.0),
                                bottomRight: Radius.circular(5.0),
                                topRight: Radius.circular(5.0))),
                        child: DropdownButton<String>(
                          value: selectedUser,
                          hint: Text("User Type",style: TextStyle(color: appThemeColor1,fontSize: 16),),
                          isExpanded: true,
                          iconSize: 24,
                          iconEnabledColor: Colors.white,
                          elevation: 16,
                          style: TextStyle(color: Colors.black,fontSize: 16),
                          underline: Container(
                            height: 0,
                          ),
                          onChanged: (String newValue) {
                            FocusScope.of(context).requestFocus(new FocusNode());
                            setState(() {
                              selectedUser = newValue;
                            });
                          },
                          items: usersList
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    ),







                    Padding(
                      padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
                      child: TextFormField(
                          focusNode: mobileFocusNode,
                          style: TextStyle(color: Colors.black),
                          textAlign: TextAlign.left,
                          keyboardType: TextInputType.phone,
                          maxLength: 10,
                          decoration: setInputDecorationForEdit(
                              "Please enter Mobile No.",
                              "Mobile No.",
                              appThemeColor1,
                              appThemeColor1,
                              appThemeColor1,
                              Icons.mobile_screen_share,
                              mobileFocusNode),
                          validator: (value) {
                            String patttern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
                            RegExp regExp = new RegExp(patttern);
                            if (value.length == 0) {
                                  return 'Please enter mobile number';
                            }
                            else if (!regExp.hasMatch(value)) {
                                  return 'Please enter valid mobile number';
                            }
                            else {
                              loginObj.mobileno = value;
                            }
                            
                            
                          }),
                    ),







                    Padding(
                      padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
                      child: TextFormField(
                          focusNode: emailFocusNode,
                          style: TextStyle(color: Colors.black),
                          textAlign: TextAlign.left,
                          keyboardType: TextInputType.emailAddress,
                          decoration: setInputDecorationForEdit(
                              "Please enter email",
                              "Email",
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
                      padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
                      child: TextFormField(
                          focusNode: addressFocusNode,
                          style: TextStyle(color: Colors.black),
                          textAlign: TextAlign.left,
                          keyboardType: TextInputType.multiline,
                          decoration: setInputDecorationForEdit(
                              "Please enter address",
                              "Address",
                              appThemeColor1,
                              appThemeColor1,
                              appThemeColor1,
                              Icons.person,
                              addressFocusNode),
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Please enter your address";
                            } else {
                              loginObj.address = value;
                            }
                          }),
                    ),








                    Padding(
                      padding: const EdgeInsets.fromLTRB(40, 20, 40, 10),
                      child: Container(
                        padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(5.0),
                                bottomLeft: Radius.circular(5.0),
                                bottomRight: Radius.circular(5.0),
                                topRight: Radius.circular(5.0))),
                        child: DropdownButton<String>(
                          value: selectedState,
                          hint: Text("Choose state",style: TextStyle(color: appThemeColor1,fontSize: 16),),
                          isExpanded: true,
                          iconSize: 24,
                          iconEnabledColor: Colors.white,
                          elevation: 16,
                          style: TextStyle(color: Colors.black,fontSize: 16),
                          underline: Container(
                            height: 0,
                          ),
                          onChanged: (String newValue) {
                            FocusScope.of(context)
                                .requestFocus(new FocusNode());
                            setState(() {
                            selectedState = newValue;
                            int index = stateList.indexWhere((data) => data[kDataStateName] == newValue);
                            selectedStateObject = stateList[index];
                         });
                          },
                          items: stateListString
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    ),



                    Padding(
                      padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
                      child: TextFormField(
                          focusNode: cityFocusNode,
                          style: TextStyle(color: Colors.black),
                          textAlign: TextAlign.left,
                          maxLength: 10,
                          decoration: setInputDecorationForEdit(
                              "Please enter city",
                              "City",
                              appThemeColor1,
                              appThemeColor1,
                              appThemeColor1,
                              Icons.pin_drop,
                              cityFocusNode),
                          validator: (value) {
                            if (value.length == 0) {
                              return 'Please enter city';
                            }
                            else {
                              loginObj.city = value;
                            }
                            
                            
                          }),
                    ),







                     Padding(
                      padding: const EdgeInsets.fromLTRB(40, 20, 40, 10),
                      child: Container(
                        padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(5.0),
                                bottomLeft: Radius.circular(5.0),
                                bottomRight: Radius.circular(5.0),
                                topRight: Radius.circular(5.0))),
                        child: DropdownButton<String>(
                          value: selectedZone,
                          hint: Text("Choose zone",style: TextStyle(color: appThemeColor1,fontSize: 16),),
                          isExpanded: true,
                          iconSize: 24,
                          iconEnabledColor: Colors.white,
                          elevation: 16,
                          style: TextStyle(color: Colors.black,fontSize: 16),
                          underline: Container(
                            height: 0,
                          ),
                          onChanged: (String newValue) {
                            FocusScope.of(context)
                                .requestFocus(new FocusNode());
                            setState(() {
                            selectedZone = newValue;
                            int index = zoneList.indexWhere((data) => data[kDataZone] == newValue);
                            selectedZoneObject = stateList[index];
                         });
                          },
                          items: zoneListString
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    ),










                    // Padding(
                    //   padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
                    //   child: TextFormField(
                    //       focusNode: passwordFocusNode,
                    //       style: TextStyle(color: Colors.black),
                    //       textAlign: TextAlign.left,
                    //       decoration: setInputDecorationForEdit(
                    //           "Please enter Password",
                    //           "Password",
                    //           appThemeColor1,
                    //           appThemeColor1,
                    //           appThemeColor1,
                    //           Icons.lock,
                    //           passwordFocusNode),
                    //       obscureText: true,
                    //       validator: (value) {
                    //         if (value.isEmpty) {
                    //           return "Please enter your password";
                    //         } else {
                    //           loginObj.password = value;
                    //         }
                    //       }),
                    // ),









                    Padding(
                      padding: const EdgeInsets.fromLTRB(40, 20, 40, 0),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: Text("Please Upload your Adhar card's front pic",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                        style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        color: appThemeColor1,
                        fontStyle: FontStyle.normal)),
                      ),
                    ),




                    Padding(
                      padding: const EdgeInsets.fromLTRB(40, 10, 40, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width - 180,
                            child: TextFormField(
                              controller: frontImageController,
                                keyboardType: TextInputType.multiline,
                                focusNode: adharFrontImageFocusNode,
                                enabled: false,
                                style: TextStyle(color: Colors.black),
                                textAlign: TextAlign.left,
                                decoration: setInputDecorationForEdit(
                                    "Browse File",
                                    "File",
                                    appThemeColor1,
                                    appThemeColor1,
                                    appThemeColor1,
                                    Icons.file_upload,
                                    adharFrontImageFocusNode),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return "Please upload file";
                                  } else {
                                    
                                  }
                                }
                                ),
                          ),





                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                        child: Container(
                          width: 90,
                          height: 40,
                          color: appThemeColor1,
                          // decoration: setBoxDecoration(Colors.white),
                          child: FlatButton(
                            child: Text("Browse",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontStyle: FontStyle.normal)),
                            onPressed: () {
                              fetchImage(context,1);
                            },
                          ),
                        ),
                      ),
                        ],
                      ),
                    ),




                    Padding(
                      padding: const EdgeInsets.fromLTRB(40, 20, 40, 0),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: Text("Please Upload your Adhar card's back pic",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                        style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        color: appThemeColor1,
                        fontStyle: FontStyle.normal)),
                      ),
                    ),




                    Padding(
                      padding: const EdgeInsets.fromLTRB(40, 10, 40, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width - 180,
                            child: TextFormField(
                              controller: backImageController,
                                keyboardType: TextInputType.multiline,
                                focusNode: adharBackImageFocusNode,
                                enabled: false,
                                style: TextStyle(color: Colors.black),
                                textAlign: TextAlign.left,
                                decoration: setInputDecorationForEdit(
                                    "Browse File",
                                    "File",
                                    appThemeColor1,
                                    appThemeColor1,
                                    appThemeColor1,
                                    Icons.file_upload,
                                    adharBackImageFocusNode),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return "Please upload file";
                                  } else {
                                    
                                  }
                                }
                                ),
                          ),


                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                        child: Container(
                          width: 90,
                          height: 40,
                          color: appThemeColor1,
                          // decoration: setBoxDecoration(Colors.white),
                          child: FlatButton(
                            child: Text("Browse",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontStyle: FontStyle.normal)),
                            onPressed: () {
                              fetchImage(context,2);
                            },
                          ),
                        ),
                      ),
                        ],
                      ),
                    ),









                    Padding(
                      padding: const EdgeInsets.fromLTRB(40, 20, 40, 0),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: Text("Please Upload your Pan Card Pic",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                        style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        color: appThemeColor1,
                        fontStyle: FontStyle.normal)),
                      ),
                    ),




                    Padding(
                      padding: const EdgeInsets.fromLTRB(40, 10, 40, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width - 180,
                            child: TextFormField(
                              controller: panImageController,
                                keyboardType: TextInputType.multiline,
                                focusNode: panCardImageFocusNode,
                                enabled: false,
                                style: TextStyle(color: Colors.black),
                                textAlign: TextAlign.left,
                                decoration: setInputDecorationForEdit(
                                    "Browse File",
                                    "File",
                                    appThemeColor1,
                                    appThemeColor1,
                                    appThemeColor1,
                                    Icons.file_upload,
                                    panCardImageFocusNode),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return "Please upload file";
                                  } else {
                                    
                                  }
                                }
                                ),
                          ),


                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                        child: Container(
                          width: 90,
                          height: 40,
                          color: appThemeColor1,
                          // decoration: setBoxDecoration(Colors.white),
                          child: FlatButton(
                            child: Text("Browse",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontStyle: FontStyle.normal)),
                            onPressed: () {
                              fetchImage(context,3);
                            },
                          ),
                        ),
                      ),
                        ],
                      ),
                    ),



                 selectedUser == "Wholesaler" ||selectedUser == "Retailer" ? Column(
                    children: <Widget>[

                      Padding(
                      padding: const EdgeInsets.fromLTRB(40, 20, 40, 0),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: Text("Please Upload your Drug Lisence Pic",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                        style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        color: appThemeColor1,
                        fontStyle: FontStyle.normal)),
                      ),
                    ),




                    Padding(
                      padding: const EdgeInsets.fromLTRB(40, 10, 40, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width - 180,
                            child: TextFormField(
                              controller: drugLicenseImageController,
                                keyboardType: TextInputType.multiline,
                                focusNode: drugLicenseImageFocusNode,
                                enabled: false,
                                style: TextStyle(color: Colors.black),
                                textAlign: TextAlign.left,
                                decoration: setInputDecorationForEdit(
                                    "Browse File",
                                    "File",
                                    appThemeColor1,
                                    appThemeColor1,
                                    appThemeColor1,
                                    Icons.file_upload,
                                    drugLicenseImageFocusNode),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return "Please upload file";
                                  } else {
                                    
                                  }
                                }
                                ),
                          ),


                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                        child: Container(
                          width: 90,
                          height: 40,
                          color: appThemeColor1,
                          // decoration: setBoxDecoration(Colors.white),
                          child: FlatButton(
                            child: Text("Browse",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontStyle: FontStyle.normal)),
                            onPressed: () {
                              fetchImage(context,4);
                            },
                          ),
                        ),
                      ),
                        ],
                      ),
                    ),









                    Padding(
                      padding: const EdgeInsets.fromLTRB(40, 20, 40, 0),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: Text("Please Upload your GST No. Pic",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                        style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        color: appThemeColor1,
                        fontStyle: FontStyle.normal)),
                      ),
                    ),




                    Padding(
                      padding: const EdgeInsets.fromLTRB(40, 10, 40, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width - 180,
                            child: TextFormField(
                              controller: gstNoImageController,
                                keyboardType: TextInputType.multiline,
                                focusNode: gstNoImageFocusNode,
                                enabled: false,
                                style: TextStyle(color: Colors.black),
                                textAlign: TextAlign.left,
                                decoration: setInputDecorationForEdit(
                                    "Browse File",
                                    "File",
                                    appThemeColor1,
                                    appThemeColor1,
                                    appThemeColor1,
                                    Icons.file_upload,
                                    gstNoImageFocusNode),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return "Please upload file";
                                  } else {
                                    
                                  }
                                }
                                ),
                          ),





                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                        child: Container(
                          width: 90,
                          height: 40,
                          color: appThemeColor1,
                          // decoration: setBoxDecoration(Colors.white),
                          child: FlatButton(
                            child: Text("Browse",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontStyle: FontStyle.normal)),
                            onPressed: () {
                              fetchImage(context,5);
                            },
                          ),
                        ),
                      ),
                        ],
                      ),
                    ),


                    ],
                  ):Container(),




                    







                    Row(
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(40, 20, 40, 30),
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
                                    SchedulerBinding.instance.addPostFrameCallback((_) =>  createUser(loginObj, context));

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

  void createUser(LoginData register, BuildContext context) async 
  {
    // await fetchCoordinates(register.address);
    Map param = Map();
    param["name"] = register.firstName;
    param["role_id"] = selectedUser=="Retailer"?"3":selectedUser=="Wholesaler"?"2":"4";
    param["mobile"] = register.mobileno;
    param["address"] = register.address;
    param["email"] = register.email;
    param["state_id"] = selectedStateObject[kDataID].toString();
    param["city"] = register.city;
    param["zone_id"] = selectedZoneObject[kDataID].toString();
    param["pan"] = register.panCard.toString();
    param["front_aadhaar"] = register.idProofFront.toString();
    param["back_aadhaar"] = register.idProofBack.toString();
    if (selectedUser!="Delivery Boy") 
    {
      param["drug_lic"] = register.drugLicense.toString();
    }
    else
    {
       param["drug_lic"] =  "";
    }

    if (selectedUser!="Delivery Boy") 
    {
      param["gst"] = register.gstNo.toString();
    }
    else
    {
      param["gst"] = "";
    }
    param["device_type"] = globals.deviceType.toString();
    param["device_token"] = globals.deviceToken;


    final url = "$baseUrl/signup";
    var result = await CallApi("POST", param, url);
    // var result = await makePostRequest("POST", param, url) ;
    HideLoader(context);

    if (result[kDataCode] == "200") {
      if (result[kDataStatusCode] == 200) {
        SetSharedPreference(kDataLoginUser, result[kDataData]);
        globals.globalCurrentUser = result[kDataData];
        
        // if (selectedUser == "Retailer") 
        // {
        //     Navigator.pushAndRemoveUntil( context,   MaterialPageRoute(
        //     builder: (context) => CustomDrawer(positionForDrawer = "other0")),   ModalRoute.withName(""));  
        // }
        // else  if (selectedUser == "Delivery Boy") 
        // {
        //     Navigator.pushAndRemoveUntil( context,   MaterialPageRoute(
        //     builder: (context) => CustomDrawerDelivery(positionForDrawerDelivery = "other0")),   ModalRoute.withName(""));  
        // }
        // else
        // {
        //     Navigator.pushAndRemoveUntil( context,   MaterialPageRoute(
        //     builder: (context) => CustomDrawerWholesaler(positionForDrawerWholesaler = "other0")),   ModalRoute.withName(""));
        // } 
       

      } else {
        ShowErrorMessage(result[kDataResult], context);
      }
    } else {
      ShowErrorMessage(result[kDataError], context);
    }
  }
}
