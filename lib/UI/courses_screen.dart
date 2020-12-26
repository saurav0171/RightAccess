import 'package:flutter/material.dart';
import 'package:right_access/CommonFiles/common.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as JSON;

import 'package:right_access/ServerFiles/serviceAPI.dart';

class CoursesScreen extends StatelessWidget {
  var eventData;

  CoursesScreen({Key key, this.eventData}) : super(key: key);
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
            body: CourseExtension(
              eventData: eventData,
            )),
      ],
    );
  }
}

class CourseExtension extends StatefulWidget {
  var eventData;

  CourseExtension({Key key, this.eventData}) : super(key: key);
  @override
  _CourseExtensionState createState() => _CourseExtensionState();
}

class _CourseExtensionState extends State<CourseExtension> {
  List<dynamic> courseList = [];

  @override
  void initState() {
    super.initState();
    if (widget.eventData == null) {
      ShowLoader(context);
      fetchNotification();
    }
  }

  fetchNotification() async {
    final url = "$baseUrl/events/2/pre-event?includes=event,event_stage_media";
    var result = await CallApi("GET", null, url);
    HideLoader(context);

    if (result[kDataCode] == "200") {
      courseList = result[kDataData]['event_stage_media']['data'] as List;
      setState(() {});
    } else if (result[kDataCode] == "422") {
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
        itemCount: courseList.length,
        padding: EdgeInsets.symmetric(horizontal: 0.0),
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: ListTile(
              contentPadding:
                  EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
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
                          courseList[index]["name"],
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.w500),
                        ),
                        Text(
                          courseList[index]["caption"],
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                              fontWeight: FontWeight.w300),
                          maxLines: 5,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                    child: Container(
                        width: 80,
                        height: 60,
                        child: Image.network(
                          courseList[index]["file_url"],
                          fit: BoxFit.fill,
                        )),
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
