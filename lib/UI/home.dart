import 'package:flutter/material.dart';
import 'package:right_access/CommonFiles/common.dart';




class HomeScreen extends StatefulWidget {
  @override
  
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {

    int _pageIndex = 0;
  PageController _pageController;
 List<Widget> tabPages = [
    HomeScreenExtension(),
    Container(
      child: Text("Screen 2"),
      color: Colors.red,
    ),
    Container(
      child: Text("Screen 3"),
      color: Colors.blue,
    ),
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

Widget setBottomMenu()
{
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
          icon: new Image.asset('images/Home-Gray.png',height: 30,width: 30,),
          activeIcon:new Image.asset('images/Home-Red.png',height: 30,width: 30,),
          label: "Home"),
      new BottomNavigationBarItem(
          icon: new Image.asset('images/Notification-Gray.png',height: 30,width: 30,),
          activeIcon:new Image.asset('images/Notification-red.png',height: 30,width: 30,),
          label:"Notification"),
      new BottomNavigationBarItem(
          icon: new Image.asset('images/History-gray.png',height: 30,width: 30,),
          activeIcon: new Image.asset('images/History-Red.png',height: 30,width: 30,),
           label:"History"),
      new BottomNavigationBarItem(
          icon: new Image.asset('images/profile-gray.png',height: 30,width: 30,),
          activeIcon: new Image.asset('images/profile-Red.png',height: 30,width: 30,),
           label:"Profile"),
    ]);
}

 void onPageChanged(int page) {
    setState(() {
      this._pageIndex = page;
    });
  }

  void onTabTapped(int index) {
    this._pageController.animateToPage(index,duration: const Duration(milliseconds: 200),curve: Curves.easeInOut);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:logoText(),
        backgroundColor: Colors.white,
        actions: [
          Image.asset("images/search.png")
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
      )
      ),
    );
  }
}



class HomeScreenExtension extends StatefulWidget {
  @override
  _HomeScreenExtensionState createState() => _HomeScreenExtensionState();
}

class _HomeScreenExtensionState extends State<HomeScreenExtension> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.amberAccent,
      
    );
  }
}