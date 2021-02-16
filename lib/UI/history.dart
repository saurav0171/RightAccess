import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:right_access/CommonFiles/common.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as JSON;

import 'package:right_access/ServerFiles/serviceAPI.dart';
import 'package:right_access/UI/videoPlayer.dart';

List historyEventsList = [];
int pageNumber = 1;

class History extends StatelessWidget {
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
          Scaffold(backgroundColor: Colors.transparent, body: HistoryExtension()),
        ],
      ),
    );
  }
}

class HistoryExtension extends StatefulWidget {
  @override
  _HistoryExtensionState createState() => _HistoryExtensionState();
}

class _HistoryExtensionState extends State<HistoryExtension> {
  @override
  void initState() {
    super.initState();

    ShowLoader(context);
    fetchPastEvents();
  }

  fetchPastEvents() async {
    final url =
        "$baseUrl/my-events?limit=20&page=1&includes=organization,event,event_preview,event_sponsors,event_modules,event_pre_stage,&type=past";
    var result = await CallApi("GET", null, url);
    HideLoader(context);
    if (result[kDataCode] == "200") {
      setState(() {
        historyEventsList = result[kDataData];
      });
    } else if (result[kDataCode] == "401" || result[kDataCode] == "404" || result[kDataCode] == "422") {
      showAlertDialog(result[kDataMessage], context);
    } else {
      showAlertDialog(result[kDataError], context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
      child: ListView.separated(
        itemCount: historyEventsList.length,
        padding: EdgeInsets.symmetric(horizontal: 0.0),
        itemBuilder: (BuildContext context, int index) {
          Map history = historyEventsList[index];
          String name = history[kDataTitle];
          String description = "Location: ${history[kDataEvent][kDataData][kDataMainVenue]}";
          String image = history[kDataBannerImage];

          return Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: ListTile(
              contentPadding:
                  EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                      padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      child: Container(
                        height: 300,
                      width: MediaQuery.of(context).size.width,
                      child: CachedNetworkImage(
                        fit: BoxFit.cover,
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
                        )),
                  Container(
                    width: MediaQuery.of(context).size.width ,
                    child: Text(
                      name,
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: Text(
                        description,
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
              onTap: () {
                setState(() {
                  selectedIndex = index;
                  Navigator.push(
                                context,
                                setNavigationTransition(VideoPlayerScreen(
                                  isRegister: true,
                                  eventData: historyEventsList[index],isPast: true,
                                )));
                });
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
    );
  }
}
