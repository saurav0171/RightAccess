import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:right_access/CommonFiles/common.dart';
import 'package:right_access/ServerFiles/serviceAPI.dart';
import 'package:right_access/UI/inviteForm.dart';
import 'package:right_access/UI/invites.dart';
import 'package:right_access/UI/videoPlayer.dart';

List inviteesList = [];
Map inviteObj = {};
Map inviteIDObject = {};

class InviteesList extends StatefulWidget {
  InviteesList(param1);
  @override
  _InviteesListState createState() => _InviteesListState();
}

class _InviteesListState extends State<InviteesList> {
  @override
  void initState() {
    super.initState();

    ShowLoader(context);
    fetchInvitees();
  }

  fetchInvitees() async {
    String eventID = inviteObj.containsKey(kDataEventId)
        ? inviteObj[kDataEventId].toString()
        : inviteObj[kDataID].toString();
    final url =
        "$baseUrl/invitations/list?event_id=$eventID&includes=invitation_lists";
    // Map param = {};
    // param["event_id"] = eventID;
    var result = await CallApi("GET", null, url);
    HideLoader(context);
    if (result[kDataCode] == "200") {
      setState(() {
        inviteesList = result[kDataData][kDataInvitationLists][kDataData];
        inviteIDObject = result[kDataData];
      });
    } else if (result[kDataCode] == "401" ||
        result[kDataCode] == "404" ||
        result[kDataCode] == "422") {
      showAlertDialog(result[kDataMessage], context);
    } else {
      showAlertDialog(result[kDataError], context);
    }
  }

  sendInvitation(Map user) async {
    final url =
        "$baseUrl/invitations/${user[kDataInvitationId].toString()}/send-mail/${user[kDataID].toString()}";
    Map param = {};
    // param["invitation_list_user_id"] = user[kDataID].toString();
    param["invite_subject"] = "Right Access Invitaion";
    param["message"] = "You are invited to join us at the Right Access event.";
    var result = await CallApi("POST", param, url);
    HideLoader(context);
    if (result[kDataCode] == "200") {
      showAlert(context, "Email sent successfully");
    } else if (result[kDataCode] == "401" ||
        result[kDataCode] == "404" ||
        result[kDataCode] == "422") {
      showAlertDialog(result[kDataMessage], context);
    } else {
      showAlertDialog(result[kDataError], context);
    }
  }

  sendInvitationToAll() async {
    final url =
        "$baseUrl/invitations/${inviteIDObject[kDataID].toString()}/send-mail";
    Map param = {};
    param["invite_subject"] = "Right Access Invitaion";
    param["message"] = "You are invited to join us at the Right Access event.";
    var result = await CallApi("POST", param, url);
    HideLoader(context);
    if (result[kDataCode] == "200") {
      showAlert(context, "Email sent successfully");
    } else if (result[kDataCode] == "401" ||
        result[kDataCode] == "404" ||
        result[kDataCode] == "422") {
      showAlertDialog(result[kDataMessage], context);
    } else {
      showAlertDialog(result[kDataError], context);
    }
  }

  void handleClick(String value) {
    switch (value) {
      case 'SEND EMAIL TO ALL':
        {
          ShowLoader(context);
          sendInvitationToAll();
        }
        break;

      case 'APPROVE REQUEST':
        Navigator.push(
            context,
            setNavigationTransition(Invites(
              requestInviteObj = inviteObj,
            )));
        break;
    }
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
              floatingActionButton: FloatingActionButton(
                  onPressed: () async {
                    bool result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              InviteForm(inviteID = inviteIDObject)),
                    );
                    if (result != null && result) {
                      ShowLoader(context);
                      fetchInvitees();
                    }
                  },
                  elevation: 0.0,
                  child: new Icon(Icons.group_add),
                  backgroundColor: appThemeColor1),
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
                actions: [
                  // Padding(
                  //   padding: const EdgeInsets.all(10.0),
                  //   child: Container(
                  //     decoration: BoxDecoration(
                  //         color: appThemeColor1,
                  //         borderRadius:
                  //             BorderRadius.circular(5)),
                  //     height: 20,
                  //     width: 100,
                  //     child: FlatButton(
                  //         onPressed: () async {
                  //           ShowLoader(context);
                  //           sendInvitationToAll();
                  //         },
                  //         child: Text(
                  //           "SEND TO ALL",
                  //           style: TextStyle(
                  //               fontSize: 11,
                  //               color: Colors.white,
                  //               fontWeight:
                  //                   FontWeight.w300),
                  //         )),
                  //   ),
                  // ),
                  // Padding(
                  //   padding: const EdgeInsets.all(10.0),
                  //   child: Container(
                  //     decoration: BoxDecoration(
                  //         color: appThemeColor1,
                  //         borderRadius:
                  //             BorderRadius.circular(5)),
                  //     height: 20,
                  //     width: 100,
                  //     child: FlatButton(
                  //         onPressed: () async {
                  //           Navigator.push(
                  //             context,
                  //             setNavigationTransition(Invites(
                  //               requestInviteObj = inviteObj,
                  //             )));
                  //         },
                  //         child: Text(
                  //           "REQUESTS",
                  //           style: TextStyle(
                  //               fontSize: 11,
                  //               color: Colors.white,
                  //               fontWeight:
                  //                   FontWeight.w300),
                  //         )),
                  //   ),
                  // ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                    child: Container(
                      width: 30,
                      child: PopupMenuButton<String>(
                        icon: Icon(
                          Icons.more_vert,
                          color: Colors.black,
                        ),
                        onSelected: handleClick,
                        itemBuilder: (BuildContext context) {
                          return {"SEND EMAIL TO ALL", "APPROVE REQUEST"}
                              .map((String choice) {
                            return PopupMenuItem<String>(
                              value: choice,
                              child: Text(
                                choice,
                                style: TextStyle(
                                    fontSize: 16, color: Colors.black),
                              ),
                            );
                          }).toList();
                        },
                      ),
                    ),
                  )
                ],
              ),
              body: inviteesList.length==0?Center(child: Text(
                      "No Invitees Available",
                      style: TextStyle(
                          fontSize: 24,
                          color: Colors.black,
                          fontWeight: FontWeight.w500),
                    ),):
                    Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                child: ListView.separated(
                  itemCount: inviteesList.length,
                  padding: EdgeInsets.symmetric(horizontal: 0.0),
                  itemBuilder: (BuildContext context, int index) {
                    Map invitees = inviteesList[index];
                    String name =
                        "${invitees[kDataFirstname]} ${invitees[kDataLastname]}";
                    String email = "Email: ${invitees[kDataEmail]}";
                    String mobile = "Mobile: ${invitees[kDataMobile]}";
                    String status = "Status: ${invitees[kDataStatus]}";

                    return Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: ListTile(
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 0.0, horizontal: 0.0),
                        title: Row(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width - 120,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    child: Text(
                                      name,
                                      style: TextStyle(
                                          fontSize: 17,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 5, 0, 0),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
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
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 5, 0, 0),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      child: Text(
                                        mobile,
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.black87,
                                            fontWeight: FontWeight.w400),
                                        maxLines: 10,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 5, 0, 0),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      child: Text(
                                        status,
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
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: appThemeColor1,
                                    borderRadius: BorderRadius.circular(5)),
                                height: 25,
                                width: 90,
                                child: FlatButton(
                                    onPressed: () async {
                                      ShowLoader(context);
                                      sendInvitation(invitees);
                                    },
                                    child: Text(
                                      "SEND EMAIL",
                                      style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w300),
                                    )),
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
