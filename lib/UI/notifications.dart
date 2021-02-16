import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:right_access/CommonFiles/common.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as JSON;

import 'package:right_access/ServerFiles/serviceAPI.dart';

List notificationsList = [];

class Notifications extends StatelessWidget {
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
              body: NotificationsExtension()),
        ],
      ),
    );
  }
}

class NotificationsExtension extends StatefulWidget {
  @override
  _NotificationsExtensionState createState() => _NotificationsExtensionState();
}

class _NotificationsExtensionState extends State<NotificationsExtension> {
  @override
  void initState() {
    super.initState();

    ShowLoader(context);
    fetchNotification();
  }

  fetchNotification() async {

    final url = "$baseUrl/user_notifications?limit=20&page=1";
    var result = await CallApi("GET", null, url);
    // var result = await makePostRequest("POST", param, url) ;
    HideLoader(context);

    if (result[kDataCode] == "200") {
      setState(() {
        notificationsList = result[kDataData];
      });
    } else if (result[kDataCode] == "401" || result[kDataCode] == "404" || result[kDataCode] == "422") {
      showAlertDialog(result[kDataMessage], context);
    } else {
      showAlertDialog(result[kDataError], context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return notificationsList.length ==0 ? Center(child: Text(
                      "No Notification Available",
                      style: TextStyle(
                          fontSize: 24,
                          color: Colors.black,
                          fontWeight: FontWeight.w500),
                    ),): Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
      child: ListView.separated(
        itemCount: notificationsList.length,
        padding: EdgeInsets.symmetric(horizontal: 0.0),
        itemBuilder: (BuildContext context, int index) {
          Map notification = notificationsList[index];
          String subject = notification[kDataSubject] != null ?notification[kDataSubject]:"N/A";
          String message = notification[kDataMessage]!= null ?notification[kDataMessage]:"N/A";
          String image = notification[kDataOrganizationLogo]!= null ?"${notification[kDataOrganizationLogo]}/${notification[kDataOrganizationName]}":"";
          return Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: ListTile(
              contentPadding:
                  EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
              title: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                   
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                    child: Container(
                        width: 80,
                        height: 60,
                        child: image.length> 0? CachedNetworkImage(
                            height: 250,
                            fit: BoxFit.fitWidth,
                            imageUrl: image,
                            placeholder: (context, url) => Container(
                              child: Center(
                                  child: CircularProgressIndicator(
                                strokeWidth: 2.0,
                              )),
                            ),
                            errorWidget: (context, url, error) =>
                                Center(child: Icon(Icons.error)),
                          ):Image.asset(
                          "images/app-logo.png",
                          fit: BoxFit.fitHeight,
                        )),
                  ),
                  Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                                        child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                      width: MediaQuery.of(context).size.width ,
                      child: Text(
                        subject,
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Text(
                        message,
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                            fontWeight: FontWeight.w300),
                        maxLines: 10,
                      ),
                    ),
                        ],
                      ),
                    ),
                                      ),
                  ),
                 
                ],
              ),
              onTap: () {
                setState(() {
                  selectedIndex = index;
                  // Navigator.push( context, setNavigationTransition(OrderDetails(orderDetailsObject = order)));
                });
              },
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
            child: Divider(
              color: Colors.black26,
              height: 2,
              thickness: 2,
            ),
          );
        },
      ),
    );
  }
}
