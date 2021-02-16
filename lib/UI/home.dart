import 'package:barcode_scan/barcode_scan.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:page_indicator/page_indicator.dart';
import 'package:right_access/CommonFiles/common.dart';
import 'package:right_access/Globals/globals.dart';
import 'package:right_access/ServerFiles/serviceAPI.dart';
import 'package:right_access/UI/contactUs.dart';
import 'package:right_access/UI/history.dart';
import 'package:right_access/UI/inviteRegister.dart';
import 'package:right_access/UI/inviteesList.dart';
import 'package:right_access/UI/loginOptions.dart';
import 'package:right_access/UI/myProfile.dart';
import 'package:right_access/UI/notifications.dart';
import 'package:right_access/UI/offlineEvent.dart';
import 'package:right_access/UI/videoPlayer.dart';
import 'package:smiley_rating_dialog/smiley_rating_dialog.dart';

import 'inviteRegister.dart';

final TextEditingController searchQuery = new TextEditingController();

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final scaffoldState = GlobalKey<ScaffoldState>();
  Widget appBarTitle = Padding(
    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
    child: Image.asset(
      "images/logo.png",
      width: 200,
    ),
  );
  final key = new GlobalKey<ScaffoldState>();

  Icon actionIcon = new Icon(
    Icons.search,
    color: Colors.black87,
    size: 35,
  );
  bool isSearching;
  String searchText = "";

  String result = "Hey there!";
  int _pageIndex = 0;
  PageController _pageController;
  List<Widget> tabPages = [
    HomeScreenExtension(),
    Notifications(),
    History(),
    MyProfile(),
  ];
  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _pageIndex);
    isSearching = false;
  }

  searchListState() {
    searchQuery.addListener(() {
      if (searchQuery.text.isEmpty) {
        setState(() {
          isSearching = false;
          searchText = "";
        });
      } else {
        setState(() {
          isSearching = true;
          searchText = searchQuery.text;
        });
      }
    });
  }

  void handleSearchStart() {
    setState(() {
      isSearching = true;
    });
  }

  void handleSearchEnd() {
    setState(() {
      this.actionIcon = new Icon(
        Icons.search,
        color: Colors.black87,
        size: 35,
      );
      this.appBarTitle = Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: Image.asset(
          "images/logo.png",
          width: 200,
        ),
      );
      isSearching = false;
      searchQuery.clear();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Widget setBottomMenu() {
    return BottomNavigationBar(
        currentIndex: _pageIndex,
        onTap: onTabTapped,
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        items: [
          new BottomNavigationBarItem(
              backgroundColor: Colors.white,
              icon: new Image.asset(
                'images/Home-Gray.png',
                height: 30,
                width: 30,
              ),
              activeIcon: new Image.asset(
                'images/Home-Red.png',
                height: 30,
                width: 30,
              ),
              label: "Home"),
          new BottomNavigationBarItem(
              icon: new Image.asset(
                'images/Notification-Gray.png',
                height: 30,
                width: 30,
              ),
              activeIcon: new Image.asset(
                'images/Notification-red.png',
                height: 30,
                width: 30,
              ),
              label: "Notification"),
          new BottomNavigationBarItem(
              icon: new Image.asset(
                'images/History-gray.png',
                height: 30,
                width: 30,
              ),
              activeIcon: new Image.asset(
                'images/History-Red.png',
                height: 30,
                width: 30,
              ),
              label: "History"),
          new BottomNavigationBarItem(
              icon: new Image.asset(
                'images/profile-gray.png',
                height: 30,
                width: 30,
              ),
              activeIcon: new Image.asset(
                'images/profile-Red.png',
                height: 30,
                width: 30,
              ),
              label: "Profile"),
        ]);
  }

  void onPageChanged(int page) {
    setState(() {
      this._pageIndex = page;
    });
  }

  void onTabTapped(int index) {
    // this._pageController.animateToPage(index,
    //     duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);
    this._pageController.jumpToPage(index);
  }

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

  void handleClick(String value) {
    switch (value) {
      case 'Log out':
        {
          RemoveSharedPreference(kDataLoginUser);
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => LoginOptions()),
              ModalRoute.withName(""));
        }
        break;

        case 'Help':
        {
          Navigator.push(
             context,
              setNavigationTransition(ContactUs()
               )); 
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        appBar: AppBar(
          title: appBarTitle,
          backgroundColor: Colors.white,
          actions: [
            _pageIndex == 0
                ? GestureDetector(
                    child: actionIcon,
                    onTap: () {
                      print("Searched Pressed");
                      setState(() {
                        if (this.actionIcon.icon == Icons.search) {
                          this.actionIcon = new Icon(
                            Icons.close,
                            color: Colors.white,
                          );
                          this.appBarTitle = Row(
                            children: [
                              Expanded(
                                child: new TextField(
                                  controller: searchQuery,
                                  textInputAction: TextInputAction.go,
                                  onEditingComplete: () {
                                    print("${searchQuery.text}");
                                    ShowLoader(context);
                                    updateEventsList(searchQuery.text);
                                    handleSearchEnd();
                                  },
                                  style: new TextStyle(
                                      color: Colors.black, fontSize: 16),
                                  decoration: new InputDecoration(
                                      prefixIcon: new Icon(Icons.search,
                                          color: Colors.black87),
                                      hintText: "Search...",
                                      hintStyle: new TextStyle(
                                          color: Colors.grey.shade400,
                                          fontSize: 16),
                                      enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.black, width: 1),
                                          borderRadius: const BorderRadius.all(
                                            const Radius.circular(5.0),
                                          )),
                                      focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.black, width: 1),
                                          borderRadius: const BorderRadius.all(
                                            const Radius.circular(5.0),
                                          ))),
                                ),
                              ),
                              Container(
                                height: 30,
                                width: 30,
                                child: FlatButton(
                                    onPressed: () {
                                      handleSearchEnd();
                                    },
                                    child: Icon(
                                      Icons.close_rounded,
                                      color: Colors.black,
                                      size: 24,
                                    )),
                              )
                            ],
                          );
                          handleSearchStart();
                        } else {
                          handleSearchEnd();
                        }
                      });
                    },
                  )
                : Container(),
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
            ),
            _pageIndex == 3
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                    child: Container(
                      width: 30,
                      child: PopupMenuButton<String>(
                        icon: Icon(
                          Icons.more_vert,
                          color: Colors.black,
                        ),
                        onSelected: handleClick,
                        itemBuilder: (BuildContext context) {
                          return {"Help","Log out"}
                              .map((String choice) {
                            return PopupMenuItem<String>(
                              value: choice,
                              child: Text(
                                choice,
                                style: TextStyle(
                                    fontSize: 16, color: Colors.black),
                              ),
                            );
                          }).toList();
                        },
                      ),
                    ),
                  )
                : Container()
          ],
        ),
        body: DefaultTabController(
            initialIndex: 0,
            length: 4,
            child: Stack(
              children: <Widget>[
                new Container(
                  height: double.infinity,
                  width: double.infinity,
                  color: appThemeColor1,
                ),
                Scaffold(
                  backgroundColor: Colors.transparent,
                  bottomNavigationBar: setBottomMenu(),
                  body: PageView(
                    physics: NeverScrollableScrollPhysics(),
                    children: tabPages,
                    onPageChanged: onPageChanged,
                    controller: _pageController,
                  ),
                ),
              ],
            )),
      ),
    );
  }
}

List imagesList = [
  "images/login.png",
  "images/login.png",
  "images/login.png",
  "images/login.png"
];

List currentEvents = [];
List upcomingEvents = [];

class HomeScreenExtension extends StatefulWidget {
  @override
  _HomeScreenExtensionState createState() => _HomeScreenExtensionState();
}

class _HomeScreenExtensionState extends State<HomeScreenExtension> {
  @override
  void initState() {
    super.initState();
    updateEventsList = fetchCurrentEvents;
    if (mounted) {
      ShowLoader(context);
      fetchCurrentEvents("");
    }
  }

  fetchCurrentEvents(String query) async {
    final url =
        "$baseUrl/my-events?limit=20&page=1&includes=organization,event_sponsors,event_modules,event_pre_stage,event_preview&title=$query";

    var result = await CallApi("GET", null, url);
    if (result[kDataCode] == "200") {
      setState(() {
        currentEvents = result[kDataData];
      });
      fetchUpcomingEvents(query);
    } else if (result[kDataCode] == "401" ||
        result[kDataCode] == "404" ||
        result[kDataCode] == "422") {
      showAlertDialog(result[kDataMessage], context);
    } else {
      showAlertDialog(result[kDataError], context);
    }
  }

  fetchUpcomingEvents(String query) async {
    final url =
        "$baseUrl/my-events?limit=20&page=1&includes=organization,event,event_preview,event_sponsors,event_modules,event_stage_media,event_pre_stage&type=recommended&title=$query";
    var result = await CallApi("GET", null, url);
    HideLoader(context);
    if (result[kDataCode] == "200") {
      setState(() {
        upcomingEvents = result[kDataData];
      });
    } else if (result[kDataCode] == "401" ||
        result[kDataCode] == "404" ||
        result[kDataCode] == "422") {
      showAlertDialog(result[kDataMessage], context);
    } else {
      showAlertDialog(result[kDataError], context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Container(
        color: Colors.white,
        height: MediaQuery.of(context).size.height - 140,
        child: Column(
          children: [
            // Container(
            //   color: Colors.black,
            //   height: 150,
            //   child: PageIndicatorContainer(
            //       child: PageView.builder(
            //         itemCount: imagesList.length,
            //         itemBuilder: (BuildContext context, int index) {
            //           String image = imagesList[index];
            //           // return Image.network(image,
            //           //     fit: BoxFit.contain);
            //           return Padding(
            //             padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            //             child: Center(child: Image.asset(image)),
            //           );
            //         },
            //       ),
            //       align: IndicatorAlign.bottom,
            //       length: imagesList.length,
            //       indicatorSpace: 5.0,
            //       padding: const EdgeInsets.all(5),
            //       indicatorColor: Colors.grey.shade300,
            //       indicatorSelectorColor: appThemeColor1,
            //       shape: IndicatorShape.circle(size: 10)),
            // ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 2, 0, 0),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 30,
                color: Colors.white,
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                  child: Text(
                    "My Events",
                    style: TextStyle(
                        fontSize: 16,
                        color: appThemeColor1,
                        fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ),
            currentEvents.length > 0
                ? Container(
                  height: 300,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: Container(
                      color: Colors.white,
                      child: PageIndicatorContainer(
                          child: PageView.builder(
                            itemCount: currentEvents.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (BuildContext context, int index) {
                              Map current = currentEvents[index];
                              String name = current[kDataTitle];
                              String description =
                                  "Location: ${current[kDataMainVenue]}";
                              String image = current[kDataEventPreStage]
                                  [kDataData][kDataBannerImage];
                              return Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                child: Container(
                                  width: MediaQuery.of(context).size.width -
                                      20,
                                  child: ListTile(
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 0.0, horizontal: 0.0),
                                    title: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                            padding:
                                                const EdgeInsets.fromLTRB(
                                                    0, 5, 0, 5),
                                            child: Container(
                                             height: 200,
                                              width:
                                                  MediaQuery.of(context)
                                                      .size
                                                      .width,
                                              child: CachedNetworkImage(
                                                fit: BoxFit.fill,
                                                imageUrl: image,
                                                placeholder:
                                                    (context, url) =>
                                                        Container(
                                                  child: Center(
                                                      child:
                                                          CircularProgressIndicator(
                                                    strokeWidth: 2.0,
                                                  )),
                                                ),
                                                errorWidget: (context,
                                                        url, error) =>
                                                    Center(
                                                        child: Icon(
                                                            Icons.error)),
                                              ),
                                            )),
                                        Container(
                                          height: 80,
                                          width: MediaQuery.of(context)
                                              .size
                                              .width,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment
                                                        .start,
                                                children: [
                                                  Container(
                                                    width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width -
                                                        120,
                                                        height: 50,
                                                    child: Text(
                                                      name,
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          color: Colors
                                                              .black,
                                                          fontWeight:
                                                              FontWeight
                                                                  .w500),
                                                      maxLines: 100,
                                                      overflow:
                                                          TextOverflow
                                                              .ellipsis,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets
                                                                .fromLTRB(
                                                            0, 3, 0, 3),
                                                    child: Container(
                                                      width: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width -
                                                          120,
                                                          height: 30,
                                                      child: Text(
                                                        description,
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            color: Colors
                                                                .black54,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w300),
                                                        maxLines: 10,
                                                        overflow:
                                                            TextOverflow
                                                                .ellipsis,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Expanded(child: Container()),
                                              Padding(
                                                padding: const EdgeInsets
                                                    .fromLTRB(0, 0, 5, 0),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      decoration: BoxDecoration(
                                                          color: Color(
                                                              0xFF3EC433),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      5)),
                                                      height: 25,
                                                      width: 80,
                                                      child: FlatButton(
                                                          onPressed: () {
                                                            Navigator.push(
                                                                context,
                                                                setNavigationTransition(
                                                                    VideoPlayerScreen(
                                                                  isRegister:
                                                                      false,
                                                                  eventData:
                                                                      currentEvents[
                                                                          index],
                                                                  isPast:
                                                                      false,
                                                                )));
                                                          },
                                                          child: Text(
                                                            "WATCH",
                                                            style: TextStyle(
                                                                fontSize:
                                                                    12,
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w300),
                                                          )),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    onTap: () {
                                      setState(() {
                                        selectedIndex = index;
                                        Navigator.push(
                                            context,
                                            setNavigationTransition(
                                                VideoPlayerScreen(
                                              isRegister: false,
                                              eventData:
                                                  currentEvents[index],
                                              isPast: false,
                                            )));
                                      });
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                          align: IndicatorAlign.bottom,
                          length: currentEvents.length,
                          indicatorSpace: 5.0,
                          padding: const EdgeInsets.all(5),
                          indicatorColor: Colors.grey.shade300,
                          indicatorSelectorColor: appThemeColor1,
                          shape: IndicatorShape.circle(size: 10)),
                    ),
                  ),
                )
                : Container(
                    height: 100,
                    child: Center(
                      child: Text(
                        "No Record Found",
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),

            Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 5),
              child: Container(
                color: Colors.black12,
                height: 3,
                width: MediaQuery.of(context).size.width,
              ),
            ),

            Container(
              width: MediaQuery.of(context).size.width,
              height: 30,
              color: Colors.white,
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 0, 0, 5),
                child: Text(
                  "Recommended Events",
                  style: TextStyle(
                      fontSize: 16,
                      color: appThemeColor1,
                      fontWeight: FontWeight.w700),
                ),
              ),
            ),
            upcomingEvents.length > 0
                ? Container(
                  height: MediaQuery.of(context).size.height - 550,
                  color: Colors.white,
                  child: ListView.separated(
                    itemCount: upcomingEvents.length,
                    padding: EdgeInsets.symmetric(horizontal: 0.0),
                    itemBuilder: (BuildContext context, int index) {
                      Map upcoming = upcomingEvents[index];
                      String name = upcoming[kDataTitle];
                      String description =
                          "Location: ${upcoming[kDataEvent][kDataData][kDataMainVenue]}";
                      String image = upcoming[kDataBannerImage];
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 0.0, horizontal: 0.0),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                child: Container(
                                    width:
                                        MediaQuery.of(context).size.width,
                                    child: CachedNetworkImage(
                                      height: 200,
                                      fit: BoxFit.fill,
                                      imageUrl: image,
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
                                    )),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 0, 0, 5),
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                120,
                                            child: Text(
                                              name,
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.black,
                                                  fontWeight:
                                                      FontWeight.w500),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.fromLTRB(
                                                    0, 3, 0, 0),
                                            child: Row(
                                              children: [
                                                Container(
                                                  width:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width -
                                                          120,
                                                  child: Text(
                                                    description,
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        color:
                                                            Colors.black54,
                                                        fontWeight:
                                                            FontWeight
                                                                .w300),
                                                    maxLines: 10,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      Expanded(child: Container()),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.fromLTRB(
                                                    0, 0, 5, 0),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: appThemeColor1,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5)),
                                              height: 25,
                                              width: 90,
                                              child: FlatButton(
                                                  onPressed: () async {
                                                    bool status =
                                                        await Navigator
                                                            .push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              InviteRegister(
                                                                  eventObj =
                                                                      upcomingEvents[
                                                                          index])),
                                                    );
                                                    if (status != null &&
                                                        status) {
                                                      ShowLoader(context);
                                                      fetchUpcomingEvents(
                                                          "");
                                                      Navigator.push(
                                                          context,
                                                          setNavigationTransition(
                                                              VideoPlayerScreen(
                                                            isRegister:
                                                                true,
                                                            eventData:
                                                                upcomingEvents[
                                                                    index],
                                                            isPast: false,
                                                          )));
                                                    }
                                                  },
                                                  child: Text(
                                                    "REGISTER",
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight
                                                                .w300),
                                                  )),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                          onTap: () {
                            setState(() {
                              selectedIndex = index;
                              Navigator.push(
                                  context,
                                  setNavigationTransition(VideoPlayerScreen(
                                    isRegister: true,
                                    eventData: upcomingEvents[index],
                                    isPast: false,
                                  )));
                            });
                          },
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: Divider(
                          color: Colors.black12,
                          height: 2,
                          thickness: 1,
                        ),
                      );
                    },
                  ),
                )
                : Container(
                    height: 100,
                    child: Center(
                      child: Text(
                        "No Record Found",
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
