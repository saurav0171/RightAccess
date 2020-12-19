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



bool isRemembered = false;


List salutationList = [];
List<String> salutationListString = [];
String selectedSalutation ; 
Map selectedSalutationObject = {};




List countriesList = [];
List<String> countriesListString = [];
String selectedCountries ; 
Map selectedCountriesObject = {};



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
            // appBar: AppBar(
            //   automaticallyImplyLeading: false,
            //   backgroundColor: appThemeColor1,
            //   elevation: 0.0,
            //   title: Padding(
            //     padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
            //     child: Text("REGISTER", style: TextStyle(color:Colors.white),),
            //   ),
            //   leading: Padding(
            //     padding: const EdgeInsets.all(0.0),
            //     child: InkWell(
            //         child: Container(
            //         decoration: BoxDecoration(
            //           borderRadius: new BorderRadius.circular(5.0),
            //           color: appThemeColor1
            //         ),
            //         child: Icon(Icons.arrow_back,color: Colors.white,)),
            //         onTap: ()
            //         {
            //           Navigator.pop(context);
            //         },
            //     ),
            //   ),
            // ),
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
  FocusNode lastNameFocusNode = new FocusNode();
  FocusNode emailFocusNode = new FocusNode();
  FocusNode mobileFocusNode = new FocusNode();
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
          focusNode: lastNameFocusNode,
        ),
        KeyboardAction(
          focusNode: emailFocusNode,
        ),
        KeyboardAction(
          focusNode: mobileFocusNode,
        ),
        KeyboardAction(
          focusNode: passwordFocusNode,
        ),
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
    lastNameFocusNode.addListener(() {
      setState(() {});
    });
    emailFocusNode.addListener(() {
      setState(() {});
    });
    mobileFocusNode.addListener(() {
      setState(() {});
    });
    passwordFocusNode.addListener(() {
      setState(() {});
    });
    confirmPasswordFocusNode.addListener(() {
      setState(() {});
    });
    
    ShowLoader(context);
    fetchCountries();
    // getUserLocation();
    
  }






  fetchCountries() async 
  {
    final url = "$baseUrl/countries";
    var result = await CallApi("GET", null, url);
    if (result[kDataCode] == "200") {
      
       setState(() {
         countriesList = result[kDataData];
         countriesListString = [];
        for (var i = 0; i < countriesList.length; i++) 
        {
            countriesListString.add(countriesList[i][kDataAttributes][kDataName]);
        }
        
      });
      fetchSalutations();
    } else if (result[kDataCode] == "401") {
      
      ShowErrorMessage(result[kDataResult], context);
       HideLoader(context);
    } 
    else if(result[kDataCode] == "422")
    {
        ShowErrorMessage(result[kDataMessage], context);
         HideLoader(context);
    } else {
      ShowErrorMessage(result[kDataError], context);
       HideLoader(context);
    }
   
  }


  fetchSalutations() async 
  {
    final url = "$baseUrl/salutations";
    var result = await CallApi("GET", null, url);
     HideLoader(context);
    if (result[kDataCode] == "200") {
      
       setState(() {
         salutationList = result[kDataData];
         salutationListString = [];
        for (var i = 0; i < salutationList.length; i++) 
        {
            salutationListString.add(salutationList[i][kDataName]);
        }
        selectedSalutationObject = salutationList[0];
        selectedSalutation =  salutationListString[0];
        
      });
      
    } else if (result[kDataCode] == "401") {
      
      ShowErrorMessage(result[kDataResult], context);
    } 
    else if(result[kDataCode] == "422")
    {
        ShowErrorMessage(result[kDataMessage], context);
      
    } else {
      ShowErrorMessage(result[kDataError], context);
    }
  
  }



  @override
  void dispose() {
    super.dispose();
    firstNameFocusNode?.removeListener(() {
      setState(() {});
    });
    lastNameFocusNode.removeListener(() {
      setState(() {});
    });
    emailFocusNode.removeListener(() {
      setState(() {});
    });
    mobileFocusNode?.removeListener(() {
      setState(() {});
    });
    passwordFocusNode.removeListener(() {
      setState(() {});
    });
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
                              constraints: BoxConstraints(maxWidth: 80),
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
                                  value: selectedSalutation,
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
                                      selectedSalutation = newValue;
                                      int index = salutationList.indexWhere((data) => data[kDataName] == newValue);
                                      selectedSalutationObject = salutationList[index];
                                    });
                                  },
                                  items: salutationListString
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
                          focusNode: lastNameFocusNode,
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
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                      child: Container(
                        padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black45,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15.0),
                                bottomLeft: Radius.circular(15.0),
                                bottomRight: Radius.circular(15.0),
                                topRight: Radius.circular(15.0))),
                        child: DropdownButton<String>(
                          value: selectedCountries,
                          hint: Text("Choose country",style: TextStyle(color: Colors.black45,fontSize: 16),),
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
                            selectedCountries = newValue;
                            int index = countriesList.indexWhere((data) => data[kDataAttributes][kDataName] == newValue);
                            selectedCountriesObject = countriesList[index];
                         });
                          },
                          items: countriesListString
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
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                      child: TextFormField(
                          focusNode: passwordFocusNode,
                          controller: passwordController,
                          style: TextStyle(color: Colors.black),
                          textAlign: TextAlign.left,
                          obscureText: true,
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
                          focusNode: confirmPasswordFocusNode,
                          controller: confirmPasswordController,
                          style: TextStyle(color: Colors.black),
                          textAlign: TextAlign.left,
                          obscureText: true,
                          keyboardType: TextInputType.emailAddress,
                          decoration: setInputDecorationForEdit(
                              "Enter Confirm Password",
                              "Enter Confirm Password",
                              appThemeColor1,
                              appThemeColor1,
                              appThemeColor1,
                              Icons.lock,
                              confirmPasswordFocusNode),
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
     param["salutation_id"] = selectedSalutationObject[kDataID].toString();
    param["first_name"] = register.firstName;
    param["last_name"] =  register.lastName;
    param["mobile_number"] = register.mobileno;
    param["password"] = register.password;
    param["email"] = register.email;
    param["country_code"] = selectedCountriesObject[kDataID].toString();
    param["terms_and_conditions"] = isRemembered?"1":"0";


    final url = "$baseUrl/register";
    var result = await CallApi("POST", param, url);
    // var result = await makePostRequest("POST", param, url) ;
    HideLoader(context);

    if (result[kDataCode] == "200") {
       SetSharedPreference(kDataLoginUser, result[kDataData]);
        globals.globalCurrentUser = result[kDataData];
    } else if(result[kDataCode] == "422")
    {
      Map error = result[kDataError];
      ShowErrorMessage(error.values.first[0], context);
    } else {
      ShowErrorMessage(result[kDataError], context);
    }
  }
}
