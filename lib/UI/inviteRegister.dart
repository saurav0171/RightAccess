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



List<String> usersList = ["Mr","Mrs"];
String selectedUser ;
bool isRemembered = false;



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
            body: FormKeyboardActions(child: InviteRegisterExtension()),
          ),
        ],
      ),
    );
  }
}



class InviteRegisterExtension extends StatefulWidget {
  @override
  _InviteRegisterExtensionState createState() => _InviteRegisterExtensionState();
}

class _InviteRegisterExtensionState extends State<InviteRegisterExtension> {
  FocusNode firstNameFocusNode = new FocusNode();
  FocusNode mobileFocusNode = new FocusNode();
  FocusNode emailFocusNode = new FocusNode();
  FocusNode addressFocusNode = new FocusNode();
  FocusNode passwordFocusNode = new FocusNode();
  // FocusNode passwordFocusNode = new FocusNode();
  FocusNode confirmPasswordFocusNode = new FocusNode();

  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  

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
          focusNode: passwordFocusNode,
        ),
        // KeyboardAction(
        //   focusNode: passwordFocusNode,
        // ),
        KeyboardAction(
          focusNode: confirmPasswordFocusNode,
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
    passwordFocusNode.addListener(() {
      setState(() {});
    });
    // passwordFocusNode.addListener(() {
    //   setState(() {});
    // });
    confirmPasswordFocusNode.addListener(() {
      setState(() {});
    });
    
    // ShowLoader(context);
    // fetchStates();
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
    passwordFocusNode.removeListener(() {
      setState(() {});
    });
    // passwordFocusNode.removeListener(() {
    //   setState(() {});
    // });
    confirmPasswordFocusNode.removeListener(() {
      setState(() {});
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
                                "REGISTRATION WITH US",
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
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: Container(
                        height: 100,
                        child: Row(
                          children: [


                            Container(
                              width: 70,
                              height: 60,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.black45,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(15.0),
                                      bottomLeft: Radius.circular(15.0),
                                      bottomRight: Radius.circular(0.0),
                                      topRight: Radius.circular(0.0))),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                child: DropdownButton<String>(
                                  value: selectedUser,
                                  hint: Text("Mr",style: TextStyle(color: Colors.black,fontSize: 18),textAlign: TextAlign.center,),
                                  isExpanded: true,
                                  iconSize: 24,
                                  iconEnabledColor: Colors.black,
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



                            Expanded(
                                  child: Container(
                                  // decoration: BoxDecoration(
                                  // border: Border.all(
                                  //   color: Colors.black45,
                                  //   width: 1.0,
                                  // ),
                                  // borderRadius: BorderRadius.only(
                                  //     topLeft: Radius.circular(0.0),
                                  //     bottomLeft: Radius.circular(0.0),
                                  //     bottomRight: Radius.circular(15.0),
                                  //     topRight: Radius.circular(15.0))
                                      // ),
                                                            child: TextFormField(
                                  focusNode: firstNameFocusNode,
                                  style: TextStyle(color: Colors.black),
                                  textAlign: TextAlign.left,
                                  decoration: InputDecoration(
                                    labelStyle: TextStyle(
                                        color:firstNameFocusNode.hasFocus?appThemeColor1:Colors.black,
                                        ),
                                    // fillColor: Colors.transparent,
                                    // filled: true,
                                    errorStyle: TextStyle(color: Colors.black),
                                    labelText: "Enter your First Name",
                                    hintText: "Enter your First Name",
                                    prefixIcon: Icon(
                                            Icons.person,
                                            color:appThemeColor1,
                                          ),
                                    focusColor: firstNameFocusNode.hasFocus?appThemeColor1:Colors.black,
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.black45,width: 1),
                                      borderRadius: const BorderRadius.only(
                                        topRight: Radius.circular(15.0),bottomRight: Radius.circular(15.0),
                                        
                                      )
                                          
                                      ),
                                    disabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.black45,width: 1),
                                      borderRadius: const BorderRadius.only(
                                        topRight: Radius.circular(15.0),bottomRight: Radius.circular(15.0),
                                        
                                      )
                                          
                                      ),
                                    focusedBorder: OutlineInputBorder(
                                      
                                      borderSide: BorderSide(color: Colors.black45,width: 1),
                                      borderRadius: const BorderRadius.only(
                                        topRight: Radius.circular(15.0),bottomRight: Radius.circular(15.0),
                                        
                                      )
                                      
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return "Please enter your First Name";
                                    } else {
                                      loginObj.firstName = value;
                                    }
                                  }),
                                                          ),
                            ),
                          ],
                        ),
                      ),
                    ),



                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                      child: TextFormField(
                          focusNode: addressFocusNode,
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
                              addressFocusNode),
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Please enter your Last Name";
                            } else {
                              loginObj.lastName = value;
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
                          focusNode: mobileFocusNode,
                          style: TextStyle(color: Colors.black),
                          textAlign: TextAlign.left,
                          keyboardType: TextInputType.phone,
                          maxLength: 10,
                          decoration: setInputDecorationForEdit(
                              "Enter your Phone Number",
                              "Enter your Phone Number",
                              appThemeColor1,
                              appThemeColor1,
                              appThemeColor1,
                              Icons.mobile_screen_share,
                              mobileFocusNode),
                          validator: (value) {
                            String patttern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
                            RegExp regExp = new RegExp(patttern);
                            if (value.length == 0) {
                                  return 'Please enter Phone Number';
                            }
                            else if (!regExp.hasMatch(value)) {
                                  return 'Please enter valid Phone Number';
                            }
                            else {
                              loginObj.mobileno = value;
                            }
                            
                            
                          }),
                    ),



                     Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                      child: TextFormField(
                          focusNode: emailFocusNode,
                          controller: passwordController,
                          style: TextStyle(color: Colors.black),
                          textAlign: TextAlign.left,
                          keyboardType: TextInputType.emailAddress,
                          decoration: setInputDecorationForEdit(
                              "Enter your Password",
                              "Enter your Password",
                              appThemeColor1,
                              appThemeColor1,
                              appThemeColor1,
                              Icons.lock,
                              passwordFocusNode),
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Please enter Password";
                            }  else {
                              loginObj.password = value;
                            }
                          }),
                    ),






                      Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: TextFormField(
                          focusNode: emailFocusNode,
                          controller: confirmPasswordController,
                          style: TextStyle(color: Colors.black),
                          textAlign: TextAlign.left,
                          keyboardType: TextInputType.emailAddress,
                          decoration: setInputDecorationForEdit(
                              "Enter Confirm Password",
                              "Enter Confirm Password",
                              appThemeColor1,
                              appThemeColor1,
                              appThemeColor1,
                              Icons.lock,
                              passwordFocusNode),
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Please enter Confirm Password";
                            }
                            else if(passwordController.text != confirmPasswordController.text)
                            {
                                 return "Password didn't match Confirm Password";
                            }  else {
                              loginObj.confirmPassword = value;
                            }
                          }),
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
                         child: Container(
                           width: MediaQuery.of(context).size.width - 80,
                                   child: Text(
                                    "I Accept Terms & Conditions and Privacy Policy",
                                    textAlign: TextAlign.start,
                                    maxLines: 10,
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black),
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
                                    SchedulerBinding.instance.addPostFrameCallback((_) =>  createUser(loginObj, context));

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
                                style: TextStyle(
                                    fontSize: 18,
                                     color: Colors.black54),
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
