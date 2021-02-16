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
import 'package:right_access/UI/offlineEvent.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

import 'package:youtube_player_flutter/youtube_player_flutter.dart';

int clickedIndex = 0;
String youtubeID = '';
DateTime startingTime;
DateTime endingTime;
YoutubePlayerController _controller;
int likeClickedStatus = 0;

class VideoPlayerScreen extends StatefulWidget {
  bool isRegister;
  bool isPast;
  var eventData;

  VideoPlayerScreen({Key key, this.isRegister, this.eventData, this.isPast})
      : super(key: key);
  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  bool isVideoEnded = false;
  bool isRatingDone = false;
  bool isVideoStopped = false;
  FlickManager flickManager;
  String result = "Hey there!";
  int _pageIndex = 0;
  var format = DateFormat("yyyy-MM-dd HH:mm:ss");
  PageController _pageController;

  static var events;
  List<Widget> tabPages = [];

  @override
  void initState() {
    events = widget.eventData;
    initialSetup();    
  }

  initialSetup()
  {
    isVideoStopped = false; 
    likeClickedStatus = 0; 
    if (!widget.isRegister) {
      startingTime = format.parse(events[kDataStartDateTime]);
      endingTime = format.parse(events[kDataEndDateTime]);
    } else {
      startingTime =
          format.parse(events[kDataEvent][kDataData][kDataStartDateTime]);
      endingTime =
          format.parse(events[kDataEvent][kDataData][kDataEndDateTime]);
    }

    tabPages = widget.isRegister
        ? [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Container(
                  child: Html(
                    data: events.containsKey("long_description")? events["long_description"]:events[kDataEvent][kDataData]["long_description"],
                  ),
                ),
              ),
            ),
            MoreScreen(
              aboutData: events,
              isRegister: widget.isRegister,
              isPast: widget.isPast,
            ),
          ]
        : [
            CoursesScreen(
              eventData: events,
              clickedVideo: clickedVideo,
            ),
            MoreScreen(
              aboutData: events,
              isRegister: widget.isRegister,
              isPast: widget.isPast,
            ),
          ];
    setState(() {
      if (!widget.isRegister &&
          events[kDataEventModules][kDataData].length > 0) {
        handlyFileType(
            events[kDataEventModules][kDataData][clickedIndex], clickedIndex);
      }
    });

    VideoPlayerController videoPlayerController;
    super.initState();
    _pageController = PageController(initialPage: _pageIndex);

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
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

  handlyFileType(Map eventType, int index) {
    switch (eventType[kDataModuleType]) {
      case "VIDEO":
        {
          setState(() {
            if (eventType[kDataFileName].toString().contains("youtu")) {
              if (_controller == null || !mounted) {
                youtubeID =
                    YoutubePlayer.convertUrlToId(eventType[kDataFileName]);
                _controller = YoutubePlayerController(
                  initialVideoId: youtubeID == null ? "" : youtubeID,
                  flags: YoutubePlayerFlags(
                    autoPlay: true,
                    mute: false,
                  ),
                )..addListener(listener);
              } else {
                youtubeID =
                    YoutubePlayer.convertUrlToId(eventType[kDataFileName]);
                _controller.load(youtubeID);
              }
            } else {
              VideoPlayerController videoPlayerController =
                  VideoPlayerController.network(eventType[kDataFileName]);
              videoPlayerController.addListener(() {
                print("Return");
                  // if (videoPlayerController.value.position ==
                  //         videoPlayerController.value.duration &&
                  //     !videoPlayerController.value.isPlaying &&
                  //     !isVideoStopped) {
                  //   print("Video Ended  ");
                  //   setState(() {
                  //     isVideoStopped = true;
                  //   });
                  //   sendVideoTime();
                  // }
              });
              flickManager = FlickManager(
                videoPlayerController: videoPlayerController,
                onVideoEnd: () {},
              );

              flickManager.flickVideoManager.addListener(() {
                print(
                    "Video Ended  ${flickManager.getPlayerControlsTimeout()}");
              });
              flickManager.flickControlManager.addListener(() {
                print(
                    "Video Ended  ${flickManager.getPlayerControlsTimeout()}");
              });
              flickManager.flickControlManager.addListener(() {
                print(
                    "Video Ended  ${flickManager.getPlayerControlsTimeout()}");
              });
            }
          });
        }
        break;

      case "IMAGE":
        {}
        break;

      case "DOCUMENT":
        {
          launch(eventType[kDataFileName]);
        }
        break;
    }
  }

  void listener() {
    setState(() {
      _playerState = _controller.value.playerState;
      print("_playerState: $_playerState");
      if (_playerState == PlayerState.paused ||
          _playerState == PlayerState.ended && !isVideoStopped) {
        print("_controller.value.position : ${_controller.value.position}");
        // ShowLoader(context);
        // sendVideoTime();
         setState(() {
          isVideoStopped = true;
         });
      }
    });
  }

  sendVideoTime() async {
    // await fetchCoordinates(register.address);
    Map param = Map();
    param["event_id"] = events[kDataID].toString();
    param["module_id"] =
        events[kDataEventModules][kDataData][clickedIndex][kDataID].toString();
    List time = _controller.value.position.toString().split(".")[0].split(":");
    param["time"] = (int.parse(time[1]) * 60 + int.parse(time[2])).toString();

    final url = "$baseUrl/user_module_tracking";
    var result = await CallApi("POST", param, url);
    // var result = await makePostRequest("POST", param, url) ;
    setState(() {
      HideLoader(context);
    });

    if (result[kDataCode] == "200") {
      // ShowSuccessMessage(result[kDataMessage], context);
      //showAlert(context, result[kDataMessage]);

    } else if (result[kDataCode] == "422") {
      ShowErrorMessage(result[kDataMessage], context);
    } else {
      ShowErrorMessage(result[kDataError], context);
    }
  }

 

  @override
  void dispose() {
    super.dispose();
    // flickManager.dispose();
    if (_controller != null) {
      _controller = null;
      _controller.dispose();
    }
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
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

  clickedVideo(int index) {
    print("Clicked index : $index");
    setState(() {
      clickedIndex = index;
      isVideoStopped = false;
    });
    handlyFileType(events[kDataEventModules][kDataData][index], index);
  }

  //lovepreet s
  Future _scanQR() async {
    try {
      String qrResult = await BarcodeScanner.scan();
      setState(() {
        result = qrResult;
        // new changes........
        // new changes again ......

        print(qrResult);
        ShowLoader(context);
        postAttendence(qrResult);
      });
    } on PlatformException catch (ex) {
      if (ex.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          result = "Camera permission was denied";
        });
      } else {
        setState(() {
          result = "Unknown Error $ex";
        });
      }
    } on FormatException {
      setState(() {
        result = "You pressed the back button before scanning anything";
      });
    } catch (ex) {
      setState(() {
        result = "Unknown Error $ex";
      });
    }
  }

  postAttendence(String code) async {
    final url = "$baseUrl/attendance/mark/$code?includes=event.organization,event.event_sponsors,event.event_modules,event.event_pre_stage,event.event_preview";

    var param = {};

    var result = await CallApi("POST", param, url);
    HideLoader(context);
    if (result[kDataCode] == "200") {
      setState(() {
        var eventData = result[kDataData][kDataEvent][kDataData];
        Navigator.push(
            context,
            setNavigationTransition(OfflineEvent(
              eventData: eventData,
              isRegister: true,
              isPast: false,
            )));
      });
    } else if (result[kDataCode] == "401" ||
        result[kDataCode] == "404" ||
        result[kDataCode] == "422") {
      showAlertDialog(result[kDataMessage], context);
    } else {
      showAlertDialog(result[kDataError], context);
    }
  }
  
  likeOrDislike(bool isLike) async
  {
    var url = "$baseUrl/user_reactions/module/${events[kDataEventModules][kDataData][clickedIndex][kDataID].toString()}/like";
    if (!isLike) 
    {
        url = "$baseUrl/user_reactions/module/${events[kDataEventModules][kDataData][clickedIndex][kDataID].toString()}/dislike";
    }
    var result = await CallApi("POST", {}, url);
    // var result = await makePostRequest("POST", param, url) ;
     HideLoader(context);

    if (result[kDataCode] == "200") {
      
    showAlert(context, isLike?"Video Liked":"Video Disliked");
    } else if (result[kDataCode] == "422") {
      ShowErrorMessage(result[kDataMessage], context);
    } else {
      ShowErrorMessage(result[kDataError], context);
    }
  }
  
  

  @override
  void deactivate() {
    // Pauses video while navigating to next page.
    // _controller.pause();
    super.deactivate();
  }

  PlayerState _playerState;
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
                GestureDetector(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 10, 0),
                    child: Image.asset(
                      "images/barcode.png",
                      height: 30,
                      width: 30,
                    ),
                  ),
                  onTap: () {
                    _scanQR();
                  },
                )
              ],
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                !widget.isRegister
                    ? Container(
                        padding: EdgeInsets.all(5),
                        height: 200,
                        child: Container(
                          child: (events[kDataEventModules][kDataData].length >
                                      0 &&
                                  events[kDataEventModules][kDataData]
                                          [clickedIndex][kDataModuleType] ==
                                      "VIDEO")
                              ? Stack(children: [
                                  events[kDataEventModules][kDataData]
                                              [clickedIndex][kDataFileName]
                                          .toString()
                                          .contains("youtu")
                                      ? YoutubePlayer(
                                          controller: _controller,
                                          showVideoProgressIndicator: true,
                                          progressIndicatorColor: Colors.amber,
                                          onEnded: (YoutubeMetaData metaData) {
                                            print("ENDED");
                                          },
                                          onReady: () {
                                            // _controller.addListener(listener);
                                            print("ENDED");
                                            print("${_playerState.toString()}");
                                          },
                                          progressColors: ProgressBarColors(
                                            playedColor: Colors.amber,
                                            handleColor: Colors.amberAccent,
                                          ),
                                        )
                                      : FlickVideoPlayer(
                                          flickManager: flickManager,
                                          flickVideoWithControls:
                                              FlickVideoWithControls(
                                            controls: FlickPortraitControls(),
                                          ),
                                          flickVideoWithControlsFullscreen:
                                              FlickVideoWithControls(
                                            controls: FlickLandscapeControls(),
                                          ),
                                        ),
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    alignment: Alignment.bottomRight,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        GestureDetector(
                                          child: Container(
                                            height: 30,
                                            width: 30,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.black),
                                            child: Icon(
                                              Icons.thumb_up_alt,
                                              size: 25,
                                              color:likeClickedStatus==1? Colors.green:Colors.grey,
                                            ),
                                          ),
                                          onTap: () {
                                            setState(() {
                                              likeClickedStatus = 1; 
                                              ShowLoader(context);
                                              likeOrDislike(true);
                                            });
                                          },
                                        ),
                                        GestureDetector(
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                5, 0, 5, 0),
                                            child: Container(
                                              height: 30,
                                              width: 30,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.black),
                                              child: Icon(
                                                Icons.thumb_down_alt,
                                                size: 25,
                                                color: likeClickedStatus==2?appThemeColor1:Colors.grey,
                                              ),
                                            ),
                                          ),
                                          onTap: () {
                                            setState(() {
                                              likeClickedStatus = 2;
                                              ShowLoader(context);
                                              likeOrDislike(false);
                                            });
                                          },
                                        )
                                      ],
                                    ),
                                  )
                                ])
                              : (events[kDataEventModules][kDataData].length >
                                          0 &&
                                      events[kDataEventModules][kDataData]
                                              [clickedIndex][kDataModuleType] ==
                                          "IMAGE")
                                  ? Container(
                                      color: Colors.black,
                                      height: 200,
                                      child: PageIndicatorContainer(
                                          child: PageView.builder(
                                            itemCount: 1,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              String image =
                                                  events[kDataEventModules]
                                                              [kDataData]
                                                          [clickedIndex]
                                                      [kDataFileName];
                                              // return Image.network(image,
                                              //     fit: BoxFit.contain);
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        10, 0, 10, 0),
                                                child: Center(
                                                    child: Image.asset(image)),
                                              );
                                            },
                                          ),
                                          align: IndicatorAlign.bottom,
                                          length: 1,
                                          indicatorSpace: 5.0,
                                          padding: const EdgeInsets.all(5),
                                          indicatorColor: Colors.grey.shade300,
                                          indicatorSelectorColor:
                                              appThemeColor1,
                                          shape:
                                              IndicatorShape.circle(size: 10)),
                                    )
                                  : (events[kDataEventModules][kDataData]
                                                  .length >
                                              0 &&
                                          events[kDataEventModules][kDataData]
                                                      [clickedIndex]
                                                  [kDataModuleType] ==
                                              "DOCUMENT")
                                      ? Center(
                                          child: Icon(
                                          Icons.text_snippet,
                                          color: appThemeColor1,
                                          size: 100,
                                        ))
                                      : Container(
                                          height: 200,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: CachedNetworkImage(
                                            height: 250,
                                            fit: BoxFit.fill,
                                            imageUrl: widget.isRegister
                                                ? events[kDataBannerImage]
                                                : events[kDataEventPreStage]
                                                        [kDataData]
                                                    [kDataBannerImage],
                                            placeholder: (context, url) =>
                                                Container(
                                              child: Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                strokeWidth: 2.0,
                                              )),
                                            ),
                                            errorWidget:
                                                (context, url, error) => Center(
                                                    child: Icon(Icons.error)),
                                          ),
                                        ),
                        ),
                      )
                      :Container(
                        height: 200,
                        width: MediaQuery.of(context).size.width,
                        child: CachedNetworkImage(
                          height: 250,
                          fit: BoxFit.fill,
                          imageUrl: widget.isRegister
                              ? events[kDataBannerImage]
                              : events[kDataEvent][kDataData]
                                  [kDataBannerImage],
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
                              imageUrl: widget.isRegister
                                  ? events[kDataEvent][kDataData]
                                      [kDataOrganizationLogo]
                                  : events[kDataOrganizationLogo],
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
                        length: (!widget.isRegister &&
                                events[kDataEventModules][kDataData].length ==
                                    0)
                            ? 1
                            : 2,
                        child: Stack(
                          children: <Widget>[
                            Scaffold(
                              backgroundColor: Colors.transparent,
                              appBar: AppBar(
                                backgroundColor: Colors.grey.shade300,
                                toolbarHeight: 48,
                                automaticallyImplyLeading: false,
                                title: (!widget.isRegister &&
                                        events[kDataEventModules][kDataData]
                                                .length ==
                                            0)
                                    ? Row(
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
                                                  child: Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                      "More",
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          !widget.isPast
                                              ? Container(
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
                                                          getMonth(startingTime
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
                                                )
                                              : Container(),
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
                                                  getMonth(endingTime.month),
                                                  style: TextStyle(
                                                      color: appEventColor,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      )
                                    : widget.isRegister
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    150,
                                                child: TabBar(
                                                  onTap: onTabTapped,
                                                  indicatorColor: Colors.black,
                                                  indicatorWeight: 1,
                                                  tabs: [
                                                    Tab(
                                                      child: Text(
                                                        "About",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black),
                                                      ),
                                                    ),
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
                                              !widget.isPast
                                                  ? Container(
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
                                                    )
                                                  : Container(),
                                              Container(
                                                width: 55,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      widget.isPast
                                                          ? "ENDED ON"
                                                          : "ENDING ON",
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
                                            ],
                                          )
                                        : Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    150,
                                                child: TabBar(
                                                  indicatorColor: Colors.black,
                                                  indicatorWeight: 1,
                                                  onTap: onTabTapped,
                                                  tabs: [
                                                    Tab(
                                                      child: Text(
                                                        "Courses",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black),
                                                      ),
                                                    ),
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
                                              Container(
                                                width: 55,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      "STARTING ON",
                                                      style: TextStyle(
                                                          color: appEventColor,
                                                          fontSize: 8,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                    Text(
                                                      startingTime.day
                                                          .toString(),
                                                      style: TextStyle(
                                                          color: appEventColor,
                                                          fontSize: 17,
                                                          fontWeight:
                                                              FontWeight.w800),
                                                    ),
                                                    Text(
                                                      getMonth(
                                                          startingTime.month),
                                                      style: TextStyle(
                                                          color: appEventColor,
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w600),
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
                                            ],
                                          ),
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
                              : "REGISTER FOR FREE",
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


