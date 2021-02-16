import 'package:flutter/material.dart';
import 'package:right_access/CommonFiles/common.dart';

class CoursesScreen extends StatelessWidget {
  var eventData;Function clickedVideo;

  CoursesScreen({Key key, this.eventData,this.clickedVideo}) : super(key: key);
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
              body: CourseExtension(
                eventData: eventData,clickedVideo: clickedVideo,
              )),
        ],
      ),
    );
  }
}

class CourseExtension extends StatefulWidget {
  var eventData; Function clickedVideo;

  CourseExtension({Key key, this.eventData, this.clickedVideo}) : super(key: key);
  @override
  _CourseExtensionState createState() => _CourseExtensionState();
}

class _CourseExtensionState extends State<CourseExtension> {
  List<dynamic> courseList = [];

  @override
  void initState() {
    super.initState();
  courseList = widget.eventData[kDataEventModules][kDataData];
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
                    width: MediaQuery.of(context).size.width - 60,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          courseList[index][kDataTopic] != null?courseList[index][kDataTopic]:"N/A",
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.w500),
                        ),
                        Text(
                          courseList[index][kDataTitle] != null?courseList[index][kDataTitle]:"N/A" ,
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
                        width: 40,
                        height: 40,
                        child: Icon(Icons.visibility_outlined,color: Colors.grey),
                        ),
                  ),
                ],
              ),
              onTap: () {
                setState(() {
                  selectedIndex = index;
                  widget.clickedVideo(index);
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
