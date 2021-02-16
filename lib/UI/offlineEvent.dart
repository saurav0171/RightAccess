import 'package:barcode_scan/barcode_scan.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:page_indicator/page_indicator.dart';
import 'package:right_access/CommonFiles/common.dart';
import 'package:right_access/ServerFiles/serviceAPI.dart';
import 'package:right_access/UI/courses_screen.dart';
import 'package:right_access/UI/inviteRegister.dart';
import 'package:right_access/UI/inviteesList.dart';
import 'package:right_access/UI/more_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:youtube_player_flutter/youtube_player_flutter.dart';

int clickedIndex = 0;
DateTime startingTime;
DateTime endingTime;
int likeClickedStatus = 0;

class OfflineEvent extends StatefulWidget {
   bool isRegister;
  bool isPast;
  var eventData;

  OfflineEvent({Key key, this.isRegister, this.eventData, this.isPast})
      : super(key: key);
  @override
  _OfflineEventState createState() => _OfflineEventState();
}

class _OfflineEventState extends State<OfflineEvent> {
  bool isRatingDone = false;
  FlickManager flickManager;
  String result = "Hey there!";
  int _pageIndex = 0;
  var format = DateFormat("yyyy-MM-dd HH:mm:ss");
  PageController _pageController;
  final _webviewKey = UniqueKey();

  static var events;
  List<Widget> tabPages = [];

  @override
  void initState() {
    events = widget.eventData;
    initialSetup();    
  }

  initialSetup()
  {
    likeClickedStatus = 0; 
    startingTime = format.parse(events[kDataStartDateTime]);
    endingTime = format.parse(events[kDataEndDateTime]);

    tabPages =[
            MoreScreen(
              aboutData: events,
              isRegister: false,
              isPast: widget.isPast,
            ),
          ];
  _pageController = PageController(initialPage: _pageIndex);

  }

  getMonth(int mon) {
    String month = "";
    switch (mon) {
      case 1:
        month = "JAN";
        break;
      case 2:
        month = "FEB";
        break;
      case 3:
        month = "MAR";
        break;
      case 4:
        month = "APR";
        break;
      case 5:
        month = "MAY";
        break;
      case 6:
        month = "JUN";
        break;
      case 7:
        month = "JUL";
        break;
      case 8:
        month = "AUG";
        break;
      case 9:
        month = "SEP";
        break;
      case 10:
        month = "OCT";
        break;
      case 11:
        month = "NOV";
        break;
      case 12:
        month = "DEC";
        break;

      default:
    }
    return month;
  }

 



  @override
  void dispose() {
    super.dispose();
  
  }

  void onPageChanged(int page) {
    setState(() {
      this._pageIndex = page;
    });
  }

  void onTabTapped(int index) {
    this._pageController.animateToPage(index,
        duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);
  }

  @override
  void deactivate() {
    // Pauses video while navigating to next page.
    // _controller.pause();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Stack(
        children: <Widget>[
          new Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(gradient: setGradientColor())),
          Scaffold(
            appBar: AppBar(
              title: Image.asset(
                "images/logo.png",
                width: 200,
              ),
              backgroundColor: Colors.white,
              actions: [
                // GestureDetector(
                //   child: Image.asset(
                //     "images/search.png",
                //     height: 30,
                //     width: 30,
                //   ),
                //   onTap: () {
                //     print("Searched Pressed");
                //   },
                // ),
                // GestureDetector(
                //   child: Padding(
                //     padding: const EdgeInsets.fromLTRB(20, 0, 10, 0),
                //     child: Image.asset(
                //       "images/barcode.png",
                //       height: 30,
                //       width: 30,
                //     ),
                //   ),
                //   onTap: () {
                //     _scanQR();
                //   },
                // )
              ],
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                        height: 200,
                        width: MediaQuery.of(context).size.width,
                        child: WebView(
                          key: _webviewKey,
                          initialUrl:events[kDataBannerUrl],
                          javascriptMode: JavascriptMode.unrestricted,
                        ),
                      ),
                    
                Container(
                    height: 60,
                    width: MediaQuery.of(context).size.width,
                    color: appEventColor,
                    child: Row(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width - 150,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                child: Text(
                                  widget.eventData[kDataTitle]
                                      .toString()
                                      .toUpperCase(),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 50,
                            width: 130,
                            child: CachedNetworkImage(
                              height: 60,
                              fit: BoxFit.fill,
                              imageUrl:events[kDataOrganizationLogo],
                              placeholder: (context, url) => Container(
                                child: Center(
                                    child: CircularProgressIndicator(
                                  strokeWidth: 2.0,
                                )),
                              ),
                              errorWidget: (context, url, error) =>
                                  Center(child: Icon(Icons.error)),
                            ),
                          ),
                        ),
                      ],
                    )),
                Expanded(
                    child: DefaultTabController(
                        initialIndex: 0,
                        length:  1,
                        child: Stack(
                          children: <Widget>[
                            Scaffold(
                              backgroundColor: Colors.transparent,
                              appBar: AppBar(
                                backgroundColor: Colors.grey.shade300,
                                toolbarHeight: 48,
                                automaticallyImplyLeading: false,
                                title: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                               width: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                270,
                                                child: TabBar(
                                                  onTap: onTabTapped,
                                                  indicatorColor: Colors.black,
                                                  indicatorWeight: 1,
                                                  tabs: [
                                                    Tab(
                                                      child: Text(
                                                        "More",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Expanded(child:Container()),
                                             Row(
                                               children:[
                                                  Container(
                                                      width: 55,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .fromLTRB(
                                                                    0, 1, 0, 0),
                                                            child: Text(
                                                              "STARTING ON",
                                                              style: TextStyle(
                                                                  color:
                                                                      appEventColor,
                                                                  fontSize: 8,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                            ),
                                                          ),
                                                          Text(
                                                            startingTime.day
                                                                .toString(),
                                                            style: TextStyle(
                                                                color:
                                                                    appEventColor,
                                                                fontSize: 17,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w800),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .fromLTRB(
                                                                    0, 0, 0, 1),
                                                            child: Text(
                                                              getMonth(
                                                                  startingTime
                                                                      .month),
                                                              style: TextStyle(
                                                                  color:
                                                                      appEventColor,
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                              Container(
                                                width: 55,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      "ENDING ON",
                                                      style: TextStyle(
                                                          color: appEventColor,
                                                          fontSize: 8,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                    Text(
                                                      endingTime.day.toString(),
                                                      style: TextStyle(
                                                          color: appEventColor,
                                                          fontSize: 17,
                                                          fontWeight:
                                                              FontWeight.w800),
                                                    ),
                                                    Text(
                                                      getMonth(
                                                          endingTime.month),
                                                      style: TextStyle(
                                                          color: appEventColor,
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    )
                                                  ],
                                                ),
                                              )
                                               ]
                                             )
                                            ],
                                          )
                              ),
                              body: PageView(
                                children: tabPages,
                                onPageChanged: onPageChanged,
                                controller: _pageController,
                              ),
                            ),
                          ],
                        ))),
              ],
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Visibility(
              visible: (widget.isRegister && !widget.isPast) ||
                  (!widget.isRegister && events[kDataHasInviteAccess]),
              child: SizedBox(
                width: 200,
                height: 40,
                child: FloatingActionButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide.none),
                  backgroundColor: Colors.red,
                  onPressed: () {
                    setState(() {});
                  },
                  child: GestureDetector(
                    onTap: () {
                      if (!widget.isRegister && events[kDataHasInviteAccess]) {
                        Navigator.push(
                            context,
                            setNavigationTransition(InviteesList(
                              inviteObj = widget.eventData,
                            )));
                      } else {
                        Navigator.push(
                            context,
                            setNavigationTransition(
                                InviteRegister(eventObj = widget.eventData)));
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10)),
                      height: 48,
                      child: Center(
                        child: Text(
                          (!widget.isRegister && events[kDataHasInviteAccess])
                              ? "INVITE"
                              : "REGISTER NOW",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ), // This trailing comma makes auto-formatting nicer for build methods.
          ),
        ],
      ),
    );
  }
}


