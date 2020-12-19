import 'package:flutter/material.dart';
import 'package:right_access/CommonFiles/common.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as JSON;

import 'package:right_access/ServerFiles/serviceAPI.dart';

List notificationsList = [];


class Notifications extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.bottomEnd,
      children: <Widget>[
        new Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(color: appBackgroundColor)
            // decoration: setBackgroundImage(),
            ),
        Scaffold(backgroundColor: Colors.transparent, body: NotificationsExtension()),
      ],
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

    // ShowLoader(context);
    // fetchNotification();
  }

  fetchNotification() async {


     Map param = Map();
    // param["login_type"] = loginType;
    param["limit"] = "10";
    // param["page"] = pageNumber.toString();
    param["title"] = "";
    param["includes"] = "organization,event_sponsors,event_modules";
    param["type"] = "past";



    final url = "$baseUrl/my-events";
    var result = await CallApi("POST", param, url);
    // var result = await makePostRequest("POST", param, url) ;
    HideLoader(context);

    if (result[kDataCode] == "200") {
      if (result[kDataSuccess] == "1") {

      } else {
        ShowErrorMessage(result[kDataMessage], context);
      }
    }
    else if(result[kDataCode] == "422")
    {
        ShowErrorMessage(result[kDataMessage], context);
    } else {
      ShowErrorMessage(result[kDataError], context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
      child: ListView.separated(
        itemCount: 6,
        padding: EdgeInsets.symmetric(horizontal: 0.0),
        itemBuilder: (BuildContext context, int index) {
          
          return Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(vertical: 0.0,horizontal: 0.0),
              title: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                    

                    Container(
                      width: 200,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                                "New Scientish Events",
                                style: TextStyle(
                                    fontSize: 16,
                                     color: Colors.black,fontWeight: FontWeight.w500),
                              ),


                               Text(
                                "Location: Playground, Sector 17, Chandigarh",
                                style: TextStyle(
                                    fontSize: 14,
                                     color: Colors.black54,fontWeight: FontWeight.w300),
                                     maxLines: 5,
                              ),
                        ],
                      ),
                    ),

                    Expanded(
                                          child: Container(
                        
                      ),
                    ),


                            Padding(
                      padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      child: Container(
                        width:80,
                        height: 60,
                        child:Image.asset("images/banner.png",fit: BoxFit.fill,)
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
