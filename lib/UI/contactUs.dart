import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:right_access/CommonFiles/common.dart';
import 'package:right_access/ServerFiles/serviceAPI.dart';
import 'package:right_access/data/loginData.dart';
import 'package:url_launcher/url_launcher.dart';






class ContactUs extends StatelessWidget {
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
            body: FormKeyboardActions(child: ContactUsExtension()),
          ),
        ],
      ),
    );
  }
}

class ContactUsExtension extends StatefulWidget {
  @override
  _ContactUsExtensionState createState() => _ContactUsExtensionState();
}

class _ContactUsExtensionState extends State<ContactUsExtension> {
  FocusNode messageFocusNode = new FocusNode();

  TextEditingController messageController = TextEditingController();

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
          focusNode: messageFocusNode,
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
    messageFocusNode.addListener(() {
      setState(() {});
    });
  }


  @override
  void dispose() {
    super.dispose();
    messageFocusNode?.removeListener(() {
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                  

                  Padding(
                      padding: const EdgeInsets.fromLTRB(20, 50, 20, 0),
                      child: TextFormField(
                          focusNode: messageFocusNode,
                          controller: messageController,
                          maxLines: 5,
                          maxLength: 500,
                          style: TextStyle(color: Colors.black),
                          textAlign: TextAlign.left,
                          keyboardType: TextInputType.text,
                          decoration: setInputDecorationForEdit(
                              "",
                              "",
                              appThemeColor1,
                              appThemeColor1,
                              appThemeColor1,
                              null,
                              messageFocusNode),
                    ),
                  ),
                    


                  Padding(
                    padding: const EdgeInsets.fromLTRB(30, 20, 20, 0),
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
                                    if (messageController.text.length==0) 
                                    {
                                      showAlert(context, "Please enter message");
                                      return;
                                    }
                                    else if(image==null)
                                    {
                                      showAlert(context, "Please upload a supporting document");
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
    var result = await help(image, messageController.text);
    HideLoader(context);
    if (result[kDataStatus]) {
      ShowSuccessMessage(result[kDataMessage], context);
      Timer(Duration(seconds: 2), ()
      {
        Navigator.pop(context);
      });
    } else {
      ShowErrorMessage(result[kDataError], context);
    }
  }
}
