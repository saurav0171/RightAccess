import 'package:flutter/material.dart';
import 'package:page_indicator/page_indicator.dart';
import 'package:right_access/CommonFiles/common.dart';
import 'package:right_access/ServerFiles/serviceAPI.dart';
import 'package:right_access/UI/history.dart';
import 'package:right_access/UI/notifications.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  int _pageIndex = 0;
  PageController _pageController;
  List<Widget> tabPages = [
    HomeScreenExtension(),
    Notifications(),
    History(),
    Container(
      child: Text("Screen 4"),
      color: Colors.green,
    ),
  ];
  @override
  void initState() {
    super.initState();

    _pageController = PageController(initialPage: _pageIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Widget setBottomMenu() {
    return BottomNavigationBar(
        currentIndex: _pageIndex,
        // selectedLabelStyle: TextStyle(color: Colors.black45),
        // unselectedLabelStyle: TextStyle(color: Colors.grey),
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
    this._pageController.animateToPage(index,
        duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              print("BARCODE Scanner Pressed");
            },
          )
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
                  children: tabPages,
                  onPageChanged: onPageChanged,
                  controller: _pageController,
                ),
              ),
            ],
          )),
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
  fetchCurrentEvents() async {
    final url =
        "$baseUrl/my-events?limit=20&page=1&includes=organization,event_sponsors,event_modules";
    var result = await CallApi("GET", null, url);
    if (result[kDataCode] == "200") {
      setState(() {});
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

  fetchPastEvents() async {
    final url =
        "$baseUrl/my-events?limit=20&page=1&includes=organization,event_sponsors,event_modules&type=past";
    var result = await CallApi("GET", null, url);
    if (result[kDataCode] == "200") {
      setState(() {});
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
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: [
          Container(
            color: Colors.black,
            height: 200,
            child: PageIndicatorContainer(
                child: PageView.builder(
                  itemCount: imagesList.length,
                  itemBuilder: (BuildContext context, int index) {
                    String image = imagesList[index];
                    // return Image.network(image,
                    //     fit: BoxFit.contain);
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: Center(child: Image.asset(image)),
                    );
                  },
                ),
                align: IndicatorAlign.bottom,
                length: imagesList.length,
                indicatorSpace: 5.0,
                padding: const EdgeInsets.all(5),
                indicatorColor: Colors.grey.shade300,
                indicatorSelectorColor: appThemeColor1,
                shape: IndicatorShape.circle(size: 10)),
          ),

          Container(
            width: MediaQuery.of(context).size.width,
            height: 40,
            color: Colors.white,
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
              child: Text(
                              "Active Events",
                              style: TextStyle(
                                  fontSize: 18,
                                  color: appThemeColor1,
                                  fontWeight: FontWeight.w700),
                            ),
            ),
          ),
          Container(
            height: 300,
            color: Colors.white,
            child: ListView.separated(
              itemCount: 6,
              padding: EdgeInsets.symmetric(horizontal: 0.0),
              itemBuilder: (BuildContext context, int index) {
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
                              height: 100,
                              width: MediaQuery.of(context).size.width,
                              child: Image.asset(
                                "images/banner.png",
                                fit: BoxFit.fill,
                              )),
                        ),
                        Container(
                          wi
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                            "New Scientish Events",
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.w500),
                          ),
                          Text(
                            "Location: Playground, Sector 17, Chandigarh",
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                                fontWeight: FontWeight.w300),
                          ),
                            ],
                          ),
                        )
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
          ),
        ],
      ),
    );
  }
}
