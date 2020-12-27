import 'package:barcode_scan/barcode_scan.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:page_indicator/page_indicator.dart';
import 'package:right_access/CommonFiles/common.dart';
import 'package:right_access/ServerFiles/serviceAPI.dart';
import 'package:right_access/UI/courses_screen.dart';
import 'package:right_access/UI/inviteRegister.dart';
import 'package:right_access/UI/more_screen.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

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
import '../CommonFiles/common.dart';
import '../CommonFiles/common.dart';
import '../CommonFiles/common.dart';
import '../CommonFiles/common.dart';
import '../CommonFiles/common.dart';
import '../CommonFiles/common.dart';
import '../CommonFiles/common.dart';

int clickedIndex = 0;
String youtubeID = '';
YoutubePlayerController _controller;
class VideoPlayerScreen extends StatefulWidget {
  bool isRegister = false;
  var eventData;

  VideoPlayerScreen({Key key, this.isRegister, this.eventData})
      : super(key: key);
  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  bool isVideoEnded = false;
  bool isRatingDone = false;
  FlickManager flickManager;
  String result = "Hey there!";
  int _pageIndex = 0;

  PageController _pageController;

  static var events;
  List<Widget> tabPages = [];

  @override
  void initState() {
    events = widget.eventData;
    
    tabPages = widget.isRegister?[
      MoreScreen(
        aboutData: events,
      ),
    ]:[
      CoursesScreen(eventData: events,clickedVideo: clickedVideo,),
      MoreScreen(
        aboutData: events,
      ),
    ];
    setState(() {

      
    });
   if (!widget.isRegister) 
   {
     handlyFileType(events[kDataEventModules][kDataData][clickedIndex],clickedIndex);  
   }
    //  flickManager = FlickManager(
    //   videoPlayerController: VideoPlayerController.network(
    //      "https://www.youtube.com/watch?v=9xwazD5SyVg"),
    //       );
    // _pageController = PageController(initialPage: _pageIndex);
   
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }
  handlyFileType(Map eventType, int index)
  {
    switch(eventType[kDataModuleType])
    {
      case "VIDEO":
      {
        setState(() {
           youtubeID=  YoutubePlayer.convertUrlToId(eventType[kDataFileName]);
          _controller = YoutubePlayerController(
          initialVideoId: youtubeID,
          flags: YoutubePlayerFlags(
              autoPlay: true,
              mute: true,
          ),
      )..addListener(listener);
        });
      }
    break;

    case "IMAGE":
    {

    }
    break;

    case "DOCUMENT":
    {

    }
    break;
    }

    
    

  }
   
void listener() {
    setState(() {
        _playerState = _controller.value.playerState;
       
      });
  }
  fetchEvent()
  {

  }

  @override
  void dispose() {
    super.dispose();
    flickManager.dispose();
       _controller.dispose();
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
  clickedVideo(int index)
  {
    print("Clicked index : $index");
   setState(() {
      clickedIndex = index;
   });
    handlyFileType(events[kDataEventModules][kDataData][index],index);
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
    final url = "$baseUrl/attendance/mark/$code";

    var param = {};

    var result = await CallApi("POST", param, url);
    HideLoader(context);
    if (result[kDataCode] == "200") {
      setState(() {
        var currentEvents = result[kDataData];
      });
    } else if (result[kDataCode] == "401") {
      showAlertDialog(result[kDataResult], context);
    } else if (result[kDataCode] == "422") {
      showAlertDialog(result[kDataMessage], context);
    } else {
      showAlertDialog(result[kDataError], context);
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
    return Stack(
      children: <Widget>[
        new Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(gradient: setGradientColor())),
        Scaffold(
          appBar: AppBar(
            title: logoText(),
            backgroundColor: Colors.white,
            actions: [
              GestureDetector(
                child: Image.asset(
                  "images/search.png",
                  height: 30,
                  width: 30,
                ),
                onTap: () {
                  print("Searched Pressed");
                },
              ),
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
             !widget.isRegister? Container(
                padding: EdgeInsets.all(5),
                height: 200,
                child: Container(
                  child: events[kDataEventModules][kDataData][clickedIndex][kDataModuleType] == "VIDEO"?GestureDetector(
                    onTap: () {
                      print("PAuseed");
                    },
                                      child: YoutubePlayer(
                        controller: _controller,
                        showVideoProgressIndicator: true,
                        progressIndicatorColor: Colors.amber,
                        onEnded: (YoutubeMetaData metaData)
                        {
                          print("ENDED");
                        },
                        onReady: ()
                        {
                          // _controller.addListener(listener);
                          print("ENDED");
                         print("${ _playerState.toString()}");
                        },
                        progressColors: ProgressBarColors(
                            playedColor: Colors.amber,
                            handleColor: Colors.amberAccent,
                        ),
                    ),
                  ):events[kDataEventModules][kDataData][clickedIndex][kDataModuleType] == "IMAGE"? Container(
              color: Colors.black,
              height: 200,
              child: PageIndicatorContainer(
                  child: PageView.builder(
                    itemCount: 1,
                    itemBuilder: (BuildContext context, int index) {
                      String image = events[kDataEventModules][kDataData][clickedIndex][kDataFileName];
                      // return Image.network(image,
                      //     fit: BoxFit.contain);
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: Center(child: Image.asset(image)),
                      );
                    },
                  ),
                  align: IndicatorAlign.bottom,
                  length: 1,
                  indicatorSpace: 5.0,
                  padding: const EdgeInsets.all(5),
                  indicatorColor: Colors.grey.shade300,
                  indicatorSelectorColor: appThemeColor1,
                  shape: IndicatorShape.circle(size: 10)),
            ):Center(child: Icon(Icons.text_snippet,color: appThemeColor1,size: 100,)),
                  // child: FlickVideoPlayer(
                  //   flickManager: flickManager,
                  //   flickVideoWithControls: FlickVideoWithControls(
                  //     controls: FlickPortraitControls(),
                  //   ),
                  //   flickVideoWithControlsFullscreen:
                  //       FlickVideoWithControls(
                  //     controls: FlickLandscapeControls(),
                  //   ),
                  // ),
                ),
              ):Container(
                                      height: 200,
                                      width: MediaQuery.of(context).size.width,
                                      child:  CachedNetworkImage(
                          height: 250,
                          fit: BoxFit.fill,
                          imageUrl: widget.isRegister?events[kDataBannerImage]:events[kDataEventPreStage][kDataData][kDataBannerImage],
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
              Visibility(
                visible: widget.isRegister,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context, setNavigationTransition(InviteRegister()));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Color(0xFFFFFFFF),
                        borderRadius: BorderRadius.circular(0)),
                    height: 48,
                    child: Center(
                      child: Text(
                        "REGISTER NOW",
                        style: TextStyle(color: primaryColor),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                  child: DefaultTabController(
                      initialIndex: 0,
                      length: widget.isRegister?1:2,
                      child: Stack(
                        children: <Widget>[
                          Scaffold(
                            backgroundColor: Colors.grey.shade100,
                            appBar: AppBar(
                              toolbarHeight: 48,
                              bottom:widget.isRegister?TabBar(
                                indicatorColor: Colors.white,
                                tabs: [
                                  Tab(
                                    child: Text(
                                      "More",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                 
                                ],
                              ) : TabBar(
                                indicatorColor: Colors.white,
                                tabs: [
                                  Tab(
                                    child: Text(
                                      "Courses",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                 Tab(
                                    child: Text(
                                      "More",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            body: PageView(
                              children: tabPages,
                              onPageChanged: onPageChanged,
                            ),
                          ),
                        ],
                      )))
            ],
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: appThemeColor2,
            onPressed: () {
              setState(() {});
            },
            child: Icon(
              Icons.share,
            ),
          ), // This trailing comma makes auto-formatting nicer for build methods.
        ),
      ],
    );
  }
}
