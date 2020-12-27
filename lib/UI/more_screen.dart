import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:intl/intl.dart';
import 'package:page_indicator/page_indicator.dart';
import 'package:right_access/CommonFiles/common.dart';
import 'package:http/http.dart' as http;
import 'package:right_access/GoogleCalendar/CalenderClient.dart';
import 'dart:convert' as JSON;

import 'package:right_access/ServerFiles/serviceAPI.dart';
import 'package:url_launcher/url_launcher.dart';

import '../CommonFiles/common.dart';
import '../CommonFiles/common.dart';
import '../CommonFiles/common.dart';
import '../CommonFiles/common.dart';
import '../CommonFiles/common.dart';
import '../CommonFiles/common.dart';
import '../CommonFiles/common.dart';
import '../CommonFiles/common.dart';
import '../CommonFiles/common.dart';
import '../CommonFiles/common.dart';
import '../CommonFiles/common.dart';
import '../CommonFiles/common.dart';
import '../CommonFiles/common.dart';

List notificationsList = [];

class MoreScreen extends StatelessWidget {
  var aboutData;

  MoreScreen({Key key, this.aboutData}) : super(key: key);

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
        Scaffold(
            backgroundColor: Colors.transparent,
            body: NotificationsExtension(aboutData:  this.aboutData,)),
      ],
    );
  }
}

class NotificationsExtension extends StatefulWidget {
  var aboutData;
  NotificationsExtension({Key key, this.aboutData}) : super(key: key);

  @override
  _NotificationsExtensionState createState() => _NotificationsExtensionState();
}

class _NotificationsExtensionState extends State<NotificationsExtension> {

   var format = DateFormat("yyyy-MM-dd HH:mm:ss");
  Map resultData = {};
  @override
  void initState() {
    super.initState();
    resultData = widget.aboutData;
    // ShowLoader(context);
    // fetchNotification();
  }

  // fetchNotification() async {
  //   final url = "$baseUrl/events/2/pre-event?includes=event,event_stage_media";
  //   var result = await CallApi("GET", null,
  //       url); // var result = await makePostRequest("POST", param, url) ;
  //   HideLoader(context);
  //   if (result[kDataCode] == "200") {
  //     resultData = result[kDataData];
  //     setState(() {});
  //   } else if (result[kDataCode] == "422") {
  //     showAlertDialog(result[kDataMessage], context);
  //   } else {
  //     showAlertDialog(result[kDataError], context);
  //   }
  // }

  Future<void> share() async {
    await FlutterShare.share(
        title: 'Event Name',
        text: 'Event description',
        linkUrl: 'https://event.com',
        chooserTitle: 'Chooser To Share');
  }

  Future<void> openMap(double latitude, double longitude) async {
    // String googleUrl = 'https://www.google.com/maps/search/?api=v1&query=$latitude,$longitude';
    String googleUrl = 'https://maps.googleapis.com/maps/api/place/findplacefromtext/output?parameters';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }

CalendarClient calendarClient = CalendarClient();
  addToCalendar()
  {
    for (var i = 0; i < resultData[kDataEventModules][kDataData].length; i++) 
    {
      calendarClient.insert(
                  resultData[kDataEventModules][kDataData][i][kDataTopic],
                  format.parse(resultData[kDataEventModules][kDataData][i][kDataStartDateTime]),
                  format.parse(resultData[kDataEventModules][kDataData][i][kDataEndDateTime]),
                );  
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
      child: Expanded(
          child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: Container(
                height: 0.5,
                color: Colors.grey,
              ),
            ),
            //saurabh
            Theme(
                data: Theme.of(context)
                    .copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  trailing: IconButton(
                    onPressed: () {},
                    icon: new Stack(
                      children: <Widget>[
                        new Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.grey,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                  leading: IconButton(
                    icon: new Stack(
                      children: <Widget>[
                        new Icon(
                          Icons.error_outline,
                          color: Colors.grey,
                          size: 24,
                        ),
                      ],
                    ),
                  ),
                  title: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "About this Course",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                        child: Text(
                          resultData["long_description"].toString(),
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                )),
            Padding(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: Container(
                height: 0.5,
                color: Colors.grey,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  color: Color(0xFFFFFFFF),
                  borderRadius: BorderRadius.circular(0)),
              child: ListTile(
                onTap: () {
                  share();
                },
                leading: IconButton(
                  onPressed: () {
                    share();
                  },
                  icon: new Stack(
                    children: <Widget>[
                      new Icon(
                        Icons.share,
                        color: Colors.grey,
                        size: 24,
                      ),
                    ],
                  ),
                ),
                title: Text(
                  "Share this course",
                  style: TextStyle(color: Colors.grey),
                ),
                trailing: IconButton(
                  icon: new Stack(
                    children: <Widget>[
                      new Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.grey,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: Container(
                height: 0.5,
                color: Colors.grey,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  color: Color(0xFFFFFFFF),
                  borderRadius: BorderRadius.circular(0)),
              child: ListTile(
                leading: IconButton(
                  icon: new Stack(
                    children: <Widget>[
                      new Icon(
                        Icons.download_sharp,
                        color: Colors.grey,
                        size: 24,
                      ),
                    ],
                  ),
                ),
                title: Text(
                  "Download Resourses",
                  style: TextStyle(color: Colors.grey),
                ),
                trailing: IconButton(
                  icon: new Stack(
                    children: <Widget>[
                      new Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.grey,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: Container(
                height: 0.5,
                color: Colors.grey,
              ),
            ),
            Theme(
                data: Theme.of(context)
                    .copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  trailing: IconButton(
                    icon: new Stack(
                      children: <Widget>[
                        new Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.grey,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                  leading: IconButton(
                    icon: new Stack(
                      children: <Widget>[
                        new Icon(
                          Icons.calendar_today,
                          color: Colors.grey,
                          size: 24,
                        ),
                      ],
                    ),
                  ),
                  title: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Course Schedule",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  children: <Widget>[
                   Padding(
                     padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                     child: Column(
              children: resultData[kDataEventModules][kDataData].map<Widget>(
                (option) =>  Padding(
                  padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:[
                        Text(
                                        option[kDataStartDateTime].toString().split(" ")[0],
                                        style: TextStyle(
                                            fontSize: 14,
                                             color: Colors.black,fontWeight: FontWeight.w500),
                                      ),

                                      Text(
                                        option[kDataEndDateTime].toString().split(" ")[0],
                                        style: TextStyle(
                                            fontSize: 14,
                                             color: Colors.black,fontWeight: FontWeight.w500),
                                      )
                      ]
                  ),
                ),
           ).toList(), 

                     ),
                   ),
                    
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 5, 20, 10),
                      child: Container(
                        height: 40,
                        width: MediaQuery.of(context).size.width,
                        color: Colors.grey,
                        child: FlatButton(onPressed: ()
                        {
                          addToCalendar();
                        }, child: Text(
                  "Add to Calendar",
                  style: TextStyle(color: Colors.white),
                )),
                      ),
                    )
                    
                  ],
                )
                ),
            Padding(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: Container(
                height: 0.5,
                color: Colors.grey,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  color: Color(0xFFFFFFFF),
                  borderRadius: BorderRadius.circular(0)),
              child: ListTile(
                onTap: () {
                  openMap(30.9010, 75.8573);
                },
                leading: IconButton(
                  icon: new Stack(
                    children: <Widget>[
                      new Icon(
                        Icons.location_on,
                        color: Colors.grey,
                        size: 24,
                      ),
                    ],
                  ),
                ),
                title: Text(
                  "Location / Direction",
                  style: TextStyle(color: Colors.grey),
                ),
                trailing: IconButton(
                  icon: new Stack(
                    children: <Widget>[
                      new Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.grey,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: Container(
                height: 0.5,
                color: Colors.grey,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  color: Color(0xFFFFFFFF),
                  borderRadius: BorderRadius.circular(0)),
              child: ExpansionTile(
                leading: IconButton(
                  icon: new Stack(
                    children: <Widget>[
                      new Icon(
                        Icons.sports,
                        color: Colors.grey,
                        size: 24,
                      ),
                    ],
                  ),
                ),
                title: Text(
                  "Sponsors",
                  style: TextStyle(color: Colors.grey),
                ),
                trailing: IconButton(
                  icon: new Stack(
                    children: <Widget>[
                      new Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.grey,
                        size: 20,
                      ),
                    ],
                  ),
                ),
                children: [

                  Container(
              color: Colors.black,
              height: 200,
              child: PageIndicatorContainer(
                  child: PageView.builder(
                    itemCount: resultData[kDataEventSponsors][kDataData].length,
                    itemBuilder: (BuildContext context, int index) {
                      String image = resultData[kDataEventSponsors][kDataData][index][kDataImage];
                      // return Image.network(image,
                      //     fit: BoxFit.contain);
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child:  CachedNetworkImage(
                          height: 250,
                          fit: BoxFit.fitHeight,
                          imageUrl: image,
                          placeholder: (context, url) => Container(
                            child: Center(
                                child: CircularProgressIndicator(
                              strokeWidth: 2.0,
                            )),
                          ),
                          errorWidget: (context, url, error) =>
                              Center(child: Icon(Icons.error)),
                        ),
                      );
                    },
                  ),
                  align: IndicatorAlign.bottom,
                  length: resultData[kDataEventSponsors][kDataData].length,
                  indicatorSpace: 5.0,
                  padding: const EdgeInsets.all(5),
                  indicatorColor: Colors.grey.shade300,
                  indicatorSelectorColor: appThemeColor1,
                  shape: IndicatorShape.circle(size: 10)),
            ),

                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: Container(
                height: 0.5,
                color: Colors.grey,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  color: Color(0xFFFFFFFF),
                  borderRadius: BorderRadius.circular(0)),
              child: ListTile(
                leading: IconButton(
                  icon: new Stack(
                    children: <Widget>[
                      new Icon(
                        Icons.headset_mic_sharp,
                        color: Colors.grey,
                        size: 24,
                      ),
                    ],
                  ),
                ),
                title: Text(
                  "Support",
                  style: TextStyle(color: Colors.grey),
                ),
                trailing: IconButton(
                  icon: new Stack(
                    children: <Widget>[
                      new Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.grey,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: Container(
                height: 0.5,
                color: Colors.grey,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  color: Color(0xFFFFFFFF),
                  borderRadius: BorderRadius.circular(0)),
              child: ListTile(
                leading: IconButton(
                  icon: new Stack(
                    children: <Widget>[
                      new Icon(
                        Icons.flag_outlined,
                        color: Colors.grey,
                        size: 24,
                      ),
                    ],
                  ),
                ),
                title: Text(
                  "Help",
                  style: TextStyle(color: Colors.grey),
                ),
                trailing: IconButton(
                  icon: new Stack(
                    children: <Widget>[
                      new Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.grey,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: Container(
                height: 0.5,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      )),
    );
  }
}
