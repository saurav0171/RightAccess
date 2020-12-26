import 'package:barcode_scan/barcode_scan.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:right_access/CommonFiles/common.dart';
import 'package:right_access/ServerFiles/serviceAPI.dart';
import 'package:right_access/UI/courses_screen.dart';
import 'package:right_access/UI/inviteRegister.dart';
import 'package:right_access/UI/more_screen.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  bool isRegister = false;

  VideoPlayerScreen({Key key, this.isRegister}) : super(key: key);
  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  bool isVideoEnded = false;
  bool isRatingDone = false;
  FlickManager flickManager;
  String result = "Hey there!";
  int _pageIndex = 0;
  List<Widget> tabPages = [
    CoursesScreen(),
    MoreScreen(),
  ];
  PageController _pageController;

  @override
  void initState() {
    flickManager = FlickManager(
      videoPlayerController: VideoPlayerController.network(
          'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4'),
    );
    _pageController = PageController(initialPage: _pageIndex);
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  void dispose() {
    super.dispose();
    flickManager.dispose();
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

  //lovepreet s
  Future _scanQR() async {
    try {
      String qrResult = await BarcodeScanner.scan();
      setState(() {
        result = qrResult;

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
    if (result[kDataCode] == "200") {
      setState(() {
        var currentEvents = result[kDataData];
      });
      HideLoader(context);
    } else if (result[kDataCode] == "401") {
      ShowErrorMessage(result[kDataResult], context);
      HideLoader(context);
    } else if (result[kDataCode] == "422") {
      ShowErrorMessage(result[kDataMessage], context);
      HideLoader(context);
    } else {
      ShowErrorMessage(result[kDataError], context);
      HideLoader(context);
    }
  }

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
              Container(
                padding: EdgeInsets.all(5),
                height: 200,
                child: Stack(
                  children: [
                    Container(
                      child: FlickVideoPlayer(
                        flickManager: flickManager,
                        flickVideoWithControls: FlickVideoWithControls(
                          controls: FlickPortraitControls(),
                        ),
                        flickVideoWithControlsFullscreen:
                            FlickVideoWithControls(
                          controls: FlickLandscapeControls(),
                        ),
                      ),
                    )
                  ],
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
                      length: 2,
                      child: Stack(
                        children: <Widget>[
                          Scaffold(
                            backgroundColor: Colors.grey,
                            appBar: AppBar(
                              toolbarHeight: 48,
                              bottom: TabBar(
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
