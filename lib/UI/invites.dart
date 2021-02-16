import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/games/v1.dart';
import 'package:photo_view/photo_view.dart';
import 'package:right_access/CommonFiles/common.dart';
import 'package:right_access/Globals/globals.dart';
import 'package:right_access/ServerFiles/serviceAPI.dart';
import 'package:right_access/UI/inviteForm.dart';
import 'package:right_access/UI/videoPlayer.dart';

List invites = [];
Map requestInviteObj = {};

class Invites extends StatefulWidget {
  Invites(param);
  @override
  _InvitesState createState() => _InvitesState();
}

class _InvitesState extends State<Invites> {
  TextEditingController messageController = TextEditingController();
  @override
  void initState() {
    super.initState();
    notificationContext = context;
    ShowLoader(context);
    fetchInvites();
  }

  fetchInvites() async {
    String eventID = requestInviteObj.containsKey(kDataEventId)
        ? requestInviteObj[kDataEventId].toString()
        : requestInviteObj[kDataID].toString();
    final url =
        "$baseUrl/event/register/users?event_id=$eventID&includes=event,user";
    // Map param = {};
    // param["event_id"] = eventID;
    var result = await CallApi("GET", null, url);
    HideLoader(context);
    if (result[kDataCode] == "200") {
      setState(() {
        invites = result[kDataData];
      });
    } else if (result[kDataCode] == "401" ||
        result[kDataCode] == "404" ||
        result[kDataCode] == "422") {
      showAlertDialog(result[kDataMessage], context);
    } else {
      showAlertDialog(result[kDataError], context);
    }
  }

  requestAction(Map invite, bool isAccept) async {
    var url = "$baseUrl/event/register/users/${invite[kDataID].toString()}/accept";
    Map param = {};
    if (!isAccept)
    {
      url = "$baseUrl/event/register/users/${invite[kDataID].toString()}/decline";
      param["message"] = messageController.text;
    }
    var result = await CallApi("POST", param, url);
    HideLoader(context);
    if (result[kDataCode] == "200") {
      if (!isAccept) 
      {
        Navigator.pop(context);
      }
      showAlert(context, result[kDataMessage]);
    } else if (result[kDataCode] == "401" || result[kDataCode] == "404" || result[kDataCode] == "422") {
      showAlertDialog(result[kDataMessage], context);
    } else {
      showAlertDialog(result[kDataError], context);
    }
  }

_showDialog(Map invite) async {
    await showDialog<String>(
      context: context,
      child: new AlertDialog(
        contentPadding: const EdgeInsets.all(16.0),
        content: new Row(
          children: <Widget>[
            new Expanded(
              child: new TextField(
                controller: messageController,
                autofocus: true,
                decoration: new InputDecoration(
                    labelText: 'Reason', hintText: 'Reason'),
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
              child: const Text('SEND'),
              onPressed: () {
                ShowLoader(notificationContext);
                requestAction(invite, false);
              })
        ],
      ),
    );
  }
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
              decoration: BoxDecoration(color: appBackgroundColor)
              // decoration: setBackgroundImage(),
              ),
          Scaffold(
              backgroundColor: Colors.transparent,
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
              body:invites.length==0?Center(child: Text(
                      "No Invites Available",
                      style: TextStyle(
                          fontSize: 24,
                          color: Colors.black,
                          fontWeight: FontWeight.w500),
                    ),):
                    Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                child: ListView.separated(
                  itemCount: invites.length,
                  padding: EdgeInsets.symmetric(horizontal: 0.0),
                  itemBuilder: (BuildContext context, int index) {
                    Map invitesObj = invites[index];
                    String name = invitesObj[kDataUser][kDataData][kDataName];
                    String email =
                        "Email: ${invitesObj[kDataUser][kDataData][kDataEmail]}";
                    String image = invitesObj[kDataUser][kDataData]
                            .containsKey(kDataThumbProfileImage)
                        ? invitesObj[kDataUser][kDataData]
                            [kDataThumbProfileImage]
                        : "";
                   String document = invitesObj
                            .containsKey(kDataDocument)
                        ? invitesObj
                            [kDataDocument]
                        : "";

                    return Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: ListTile(
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 0.0, horizontal: 0.0),
                        title: Column(
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: Container(
                                    height: 50,
                                    width: 50,
                                    child: image.length > 0
                                        ? CircleAvatar(
                                            radius: 20,
                                            backgroundImage:
                                                NetworkImage(image))
                                        : Image.asset(
                                            "images/default-profile.png"),
                                  ),
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width - 180,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: Text(
                                          name,
                                          style: TextStyle(
                                              fontSize: 17,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 5, 0, 0),
                                        child: Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: Text(
                                            email,
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.black87,
                                                fontWeight: FontWeight.w400),
                                            maxLines: 10,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                               document.length>0? Container(
                                  child:FlatButton(onPressed: ()
                                  {
                                    showDialog(
                                context: context,
                                builder: (_) {
                                  return AlertDialog(
                                      backgroundColor: Colors.transparent,
                                      content: Container(
                                          height: 300,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              50,
                                          decoration: BoxDecoration(
                                              color: Colors.transparent),
                                          child: PhotoView(
                                            imageProvider:
                                                CachedNetworkImageProvider(
                                              document,
                                            ),
                                            loadingBuilder:
                                                (context, imageChunkEvent) {
                                              return Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                strokeWidth: 2.0,
                                              ));
                                            },
                                            backgroundDecoration: BoxDecoration(
                                                color: Colors.transparent),
                                          )));
                                });
                                  }, child: Text(
                                            "Document",
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: appThemeColor1,
                                                fontWeight: FontWeight.w600),
                                          ))
                                ):Container()
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 0, 5, 0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.green,
                                          borderRadius: BorderRadius.circular(5)),
                                      height: 30,
                                      width: 120,
                                      child: FlatButton(
                                          onPressed: () {
                                            ShowLoader(context);
                                            requestAction(invitesObj, true);
                                          },
                                          child: Text(
                                            "APPROVE",
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500),
                                          )),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 0, 5, 0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: appThemeColor1,
                                          borderRadius: BorderRadius.circular(5)),
                                      height: 30,
                                      width: 120,
                                      child: FlatButton(
                                          onPressed: () {
                                            _showDialog(invitesObj);
                                          },
                                          child: Text(
                                            "DECLINE",
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500),
                                          )),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        onTap: () {
                          setState(() {});
                        },
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                      child: Divider(
                        color: Colors.black12,
                        height: 2,
                        thickness: 1,
                      ),
                    );
                  },
                ),
              )),
        ],
      ),
    );
  }
}