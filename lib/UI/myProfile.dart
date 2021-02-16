import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:right_access/CommonFiles/common.dart';
import 'package:right_access/Data/loginData.dart';
import "package:right_access/Globals/globals.dart" as globals;
import 'package:right_access/ServerFiles/serviceAPI.dart';
import 'package:async/async.dart';
import 'dart:convert' as convert;
import 'package:http/http.Dart' as http;
import 'dart:convert';


Map userDetailsObject = {};
bool isRemembered = false;
List salutationList = [];
List<String> salutationListString = [];
String selectedSalutation;
Map selectedSalutationObject = {};
List countriesList = [];
List<String> countriesListString = [];
String selectedCountries;
Map selectedCountriesObject = {};




class MyProfile extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
         data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: Stack(
        alignment: AlignmentDirectional.bottomEnd,
        children: <Widget>[
            new Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(color: Colors.white)
              // decoration: setBackgroundImage(),
            ),
            Scaffold(
                backgroundColor: Colors.transparent,
                
                body: FormKeyboardActions(child: MyProfileExtension()),
                
                ),
        ],
      ),
    );
  }
}








class MyProfileExtension extends StatefulWidget {
  @override
  _MyProfileExtensionState createState() => _MyProfileExtensionState();
}

class _MyProfileExtensionState extends State<MyProfileExtension> {


 var image;


  FocusNode firstNameFocusNode = new FocusNode();
  FocusNode lastNameFocusNode = new FocusNode();
  FocusNode emailFocusNode = new FocusNode();
  FocusNode mobileFocusNode = new FocusNode();
  FocusNode passwordFocusNode = new FocusNode();


  TextEditingController firstnameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

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


     globals.notificationContext = context;
    ShowLoader(context);
    fetchProfile();
  }


 

   fetchProfile() async {
    final url = "$baseUrl/me?includes=user_profile";

    var result = await CallApi("GET", null, url);
     
    if (result[kDataCode] == "200") {
      setState(() {
        userDetailsObject = result[kDataData];
        
      });
      fetchCountries();
    }  else if (result[kDataCode] == "401" || result[kDataCode] == "404" || result[kDataCode] == "422") {
      showAlertDialog(result[kDataMessage], context);
      HideLoader(context);
    } else {
      showAlertDialog(result[kDataError], context);
      HideLoader(context);
    }
  }
  setValues()
  {
    setState(() {
      firstnameController.text = userDetailsObject[kDataFirstname];
      lastnameController.text = userDetailsObject[kDataLastname];
      emailController.text = userDetailsObject[kDataEmail];
      phoneController.text = userDetailsObject[kDataMobileNumber];
      selectedSalutation = userDetailsObject[kDataSalutation][kDataData][kDataName];
      int index = salutationList.indexWhere(
                                          (data) =>
                                              data[kDataName] == selectedSalutation);
      selectedSalutationObject = salutationList[index];

     
     int indexCountry = countriesList.indexWhere((data) =>
       "+ ${data[kDataCountryCode].toString()}" == "+ ${userDetailsObject[kDataCountryCode]}");
     selectedCountriesObject = countriesList[indexCountry];
      selectedCountries = "+ ${selectedCountriesObject[kDataPhoneCode].toString()}";


    });
  }

  fetchCountries() async {
    final url = "$baseUrl/countryandsalutations?limit=290&page=1";
    var result = await CallApi("GET", null, url);
    HideLoader(context);
    if (result[kDataCode] == "200") {
      setState(() {
        countriesList = result[kDataCountries][kDataData];
        countriesListString = [];
        for (var i = 0; i < countriesList.length; i++) {
          countriesListString.add("+ ${countriesList[i][kDataPhoneCode].toString()}");
        }
        selectedCountriesObject = countriesList[0];
        selectedCountries = countriesListString[0];


        salutationList = result[kDataSalutations][kDataData];
        salutationListString = [];
        for (var i = 0; i < salutationList.length; i++) {
          salutationListString.add(salutationList[i][kDataName]);
        }
        selectedSalutationObject = salutationList[0];
        selectedSalutation = salutationListString[0];
      });
      setValues();
      // fetchSalutations();
    }  else if (result[kDataCode] == "401" || result[kDataCode] == "404" || result[kDataCode] == "422") {
      showAlertDialog(result[kDataMessage], context);
    } else {
      showAlertDialog(result[kDataError], context);
    }
  }

  // fetchSalutations() async {
  //   final url = "$baseUrl/salutations";
  //   var result = await CallApi("GET", null, url);
  //   HideLoader(context);
  //   if (result[kDataCode] == "200") {
  //     setState(() {
  //       salutationList = result[kDataData];
  //       salutationListString = [];
  //       for (var i = 0; i < salutationList.length; i++) {
  //         salutationListString.add(salutationList[i][kDataName]);
  //       }
  //       selectedSalutationObject = salutationList[0];
  //       selectedSalutation = salutationListString[0];
  //     });

  //     setValues();
  //   }  else if (result[kDataCode] == "401" || result[kDataCode] == "404" || result[kDataCode] == "422") {
  //     showAlertDialog(result[kDataMessage], context);
  //   } else {
  //     showAlertDialog(result[kDataError], context);
  //   }
  // }

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
      if (image != null) {
        ShowLoader(context);
        uploadImage(image);
      }
    });
  }

  Future getCameraImage() async {
    Navigator.pop(context);
    image =
        await ImagePicker.pickImage(source: ImageSource.camera, maxHeight: 700);
    setState(() {
      if (image != null) {
        ShowLoader(context);
         uploadImage(image);
      }
    });
  }
Future<dynamic> uploadImage(File image) async {
  var response;
  

  try {
    dynamic user = await GetSharedPreference(kDataLoginUser);
    Map<String, String> headers = {
      "Accept": "application/json",
      "Authorization": "Bearer ${user[kDataToken].toString()}",
      "Content-Type": "multipart/form-data"
    };

    var stream = new http.ByteStream(DelegatingStream.typed(image.openRead()));
    // get file length
    var length = await image.length();

    // string to uri
    var uri = Uri.parse(baseUrl + '/me/profile-image');

    // create multipart request
    var request = new http.MultipartRequest("POST", uri);

    request.headers.addAll(headers);

    // multipart that takes file.. here this "image_file" is a key of the API request
    var multipartFile = new http.MultipartFile('image', stream, length,
        filename: "Profile");

    // add file to multipart
    request.files.add(multipartFile);

    // send request to upload image
   await request.send().then((responsee) async {
      responsee.stream.transform(utf8.decoder).listen((value) {
        response = value;
        
      });
    }).catchError((e) {
      print(e);
      HideLoader(context);
    });
  } on TimeoutException catch (_) {
    // A timeout occurred.
    var jsonError = {
      kDataResult: "Server not responding. Please try again later",
      kDataCode: "500"
    };
    HideLoader(context);
    return jsonError;
  } on SocketException catch (_) {
    // Other exception
    var jsonError = {
      kDataResult: "Something went wrong. Please try again later.",
      kDataCode: "500"
    };
    HideLoader(context);
    return jsonError;
  }
  HideLoader(context);
  try {
    var jsonResponse = convert.jsonDecode(response);
    print(jsonResponse);
    setState(() {
      userDetailsObject = jsonResponse[kDataData];
    });
    return jsonResponse;
    
  } on Exception catch (_) {
    var jsonError = {
      kDataResult: "Something went wrong. Please try again later.",
      kDataCode: "500"
    };
    return jsonError;
  }
  
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


                    userDetailsObject.length>0?Padding(
              padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
              child: GestureDetector(
                onTap: ()
                {
                  _optionsDialogBox();
                },
                              child: Stack(
                                children: [
                                  Container(
                      height: 150,
                      width: 150,
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                      radius: 20,
                      backgroundImage: NetworkImage(userDetailsObject[kDataMediumProfileImage])
                    ),
                    ),

                  Positioned(
                        bottom: 0,
                        right: 10,
                        child: new Container(
                          padding: EdgeInsets.all(1),
                          constraints: BoxConstraints(
                            minWidth: 25,
                            minHeight: 25,
                          ),
                          child: Icon(Icons.camera_alt,size: 25,),
                        ))
                                ],
                ),
              ),
            ):Container(),
                    
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
                                  hint: Text(
                                    "Mr",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 18),
                                    textAlign: TextAlign.center,
                                  ),
                                  isExpanded: true,
                                  iconSize: 24,
                                  iconEnabledColor: Colors.black,
                                  elevation: 16,
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 16,),
                                  underline: Container(
                                    height: 0,
                                  ),
                                  onChanged: (String newValue) {
                                    FocusScope.of(context)
                                        .requestFocus(new FocusNode());
                                    setState(() {
                                      selectedSalutation = newValue;
                                      int index = salutationList.indexWhere(
                                          (data) =>
                                              data[kDataName] == newValue);
                                      selectedSalutationObject =
                                          salutationList[index];
                                    });
                                  },
                                  items: salutationListString
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Container(
                                        width: 80,
                                        child: Text(value,textAlign: TextAlign.center,)),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                child: TextFormField(
                                    focusNode: firstNameFocusNode,
                                    controller: firstnameController,
                                    style: TextStyle(color: Colors.black),
                                    textAlign: TextAlign.left,
                                    decoration: InputDecoration(
                                      labelStyle: TextStyle(
                                        color: firstNameFocusNode.hasFocus
                                            ? appThemeColor1
                                            : Colors.black,
                                      ),
                                      // fillColor: Colors.transparent,
                                      // filled: true,
                                      errorStyle:
                                          TextStyle(color: Colors.black),
                                      labelText: "Enter your First Name",
                                      hintText: "Enter your First Name",
                                      prefixIcon: Icon(
                                        Icons.person,
                                        color: appThemeColor1,
                                      ),
                                      focusColor: firstNameFocusNode.hasFocus
                                          ? appThemeColor1
                                          : Colors.black,
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.black45, width: 1),
                                          borderRadius: const BorderRadius.only(
                                            topRight: Radius.circular(15.0),
                                            bottomRight: Radius.circular(15.0),
                                          )),
                                      disabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.black45, width: 1),
                                          borderRadius: const BorderRadius.only(
                                            topRight: Radius.circular(15.0),
                                            bottomRight: Radius.circular(15.0),
                                          )),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.black45, width: 1),
                                          borderRadius: const BorderRadius.only(
                                            topRight: Radius.circular(15.0),
                                            bottomRight: Radius.circular(15.0),
                                          )),
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
                          controller: lastnameController,
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
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
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
                          value: selectedCountries,
                          hint: Text(
                            "93",
                            style:
                                TextStyle(color: Colors.black45, fontSize: 18),
                          ),
                          isExpanded: true,
                          iconSize: 24,
                          iconEnabledColor: Colors.white,
                          elevation: 16,
                          style: TextStyle(color: Colors.black, fontSize: 14),
                          underline: Container(
                            height: 0,
                          ),
                          onChanged: (String newValue) {
                            FocusScope.of(context)
                                .requestFocus(new FocusNode());
                            setState(() {
                              selectedCountries = newValue;
                              int index = countriesList.indexWhere((data) =>
                                  "+ ${data[kDataPhoneCode].toString()}" == newValue);
                              selectedCountriesObject = countriesList[index];
                            });
                          },
                          items: countriesListString
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Container(
                                width: 80,
                                child: Text(value,textAlign: TextAlign.center,)),
                            );
                          }).toList(),
                        ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                child: TextFormField(
                                    focusNode: mobileFocusNode,
                                    controller: phoneController,
                                    style: TextStyle(color: Colors.black),
                                    textAlign: TextAlign.left,
                                    keyboardType: TextInputType.phone,
                                    decoration: InputDecoration(
                                      labelStyle: TextStyle(
                                        color: firstNameFocusNode.hasFocus
                                            ? appThemeColor1
                                            : Colors.black,
                                      ),
                                      // fillColor: Colors.transparent,
                                      // filled: true,
                                      errorStyle:
                                          TextStyle(color: Colors.black),
                                      labelText: "Enter your Phone Number",
                                      hintText: "Enter your Phone Number",
                                      prefixIcon: Icon(
                                        Icons.mobile_screen_share,
                                        color: appThemeColor1,
                                      ),
                                      focusColor: firstNameFocusNode.hasFocus
                                          ? appThemeColor1
                                          : Colors.black,
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.black45, width: 1),
                                          borderRadius: const BorderRadius.only(
                                            topRight: Radius.circular(15.0),
                                            bottomRight: Radius.circular(15.0),
                                          )),
                                      disabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.black45, width: 1),
                                          borderRadius: const BorderRadius.only(
                                            topRight: Radius.circular(15.0),
                                            bottomRight: Radius.circular(15.0),
                                          )),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.black45, width: 1),
                                          borderRadius: const BorderRadius.only(
                                            topRight: Radius.circular(15.0),
                                            bottomRight: Radius.circular(15.0),
                                          )),
                                    ),
                                    validator: (value) {
                                      String patttern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
                                      RegExp regExp = new RegExp(patttern);
                                      if (value.length == 0) {
                                        return 'Please enter Phone Number';
                                      } else if (!regExp.hasMatch(value)) {
                                        return 'Please enter valid Phone Number';
                                      } else {
                                        loginObj.mobileno = value;
                                      }
                                    }),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),





                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                            child: Container(
                              // decoration: setBoxDecoration(Colors.white),
                              height: 50,
                              width: MediaQuery.of(context).size.width - 100,
                              child: FlatButton(
                                color: appThemeColor1,
                                child: Text("UPDATE",
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




                    //  Row(
                    //   children: <Widget>[
                    //     Expanded(
                    //       child: Padding(
                    //         padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
                    //         child: Container(
                    //           // decoration: setBoxDecoration(Colors.white),
                    //           child: FlatButton(
                    //             color: appThemeColor1,
                    //             child: Text("LOGOUT",
                    //                 style: TextStyle(
                    //                     fontWeight: FontWeight.w600,
                    //                     fontSize: 18,
                    //                     color: Colors.white,
                    //                     fontStyle: FontStyle.normal)),
                    //             onPressed: () {
                    //               RemoveSharedPreference(kDataLoginUser);
                    //               Navigator.pushAndRemoveUntil(
                    //               context,
                    //               MaterialPageRoute(builder: (context) => LoginOptions()),
                    //               ModalRoute.withName(""));
                    //             },
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //   ],
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

  void createUser(LoginData register, BuildContext context) async {
    // await fetchCoordinates(register.address);
    Map param = Map();
    param["salutation_id"] = selectedSalutationObject[kDataID].toString();
    param["first_name"] = register.firstName;
    param["last_name"] = register.lastName;
    param["mobile_number"] = register.mobileno;

    final url = "$baseUrl/me";
    var result = await CallApi("POST", param, url);
    // var result = await makePostRequest("POST", param, url) ;
    HideLoader(context);

    if (result[kDataCode] == "200") {
     dynamic user = await GetSharedPreference(kDataLoginUser);
      user[kDataUser] = result[kDataData];
      SetSharedPreference(kDataLoginUser, user);
      ShowSuccessMessage("Profile updated successfully", context);
      
    } else if (result[kDataCode] == "422") {
      Map error = result[kDataError];
      ShowErrorMessage(error.values.first[0], context);
    } else {
      ShowErrorMessage(result[kDataError], context);
    }
  }
}