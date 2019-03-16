import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'authentication.dart';
import 'home.dart';
import 'plan.dart';
import 'history.dart';

//This is code for bottom navigation menu

class Dashboard extends StatelessWidget {

  //Used for navigation
  static String tag = 'dashboard';

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Bottom Navigation',
      debugShowCheckedModeBanner: false, //Turns of the "DEBUG" banner in the simulator
      theme: new ThemeData(
        primaryColor: const Color(0xFF612A30),
      ),
      home: new DashboardScreen(title: 'Heroes of the Gym'),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  DashboardScreen({Key key, this.auth, this.userId, this.onSignedOut, this.title, this.signOut})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback signOut;
  final VoidCallback onSignedOut;
  final String userId;
  final String title;

  @override
  _DashboardScreenState createState() => new _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  PageController _pageController;
  int _page = 0;

  @override
  void initState() {
    super.initState();
    _pageController = new PageController();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }


  void navigationTapped(int page) {
    // Animating to the page.
    // You can use whatever duration and curve you like
    _pageController.animateToPage(page,
        duration: const Duration(milliseconds: 10), curve: Curves.ease);
  }

  void onPageChanged(int page) {
    setState(() {
      this._page = page;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          new IconButton(
              icon: Icon(Icons.settings),
              key: Key("settings"),
              onPressed: () { widget.signOut();
              }
          )
        ],
      ),
      body: new PageView(
        children: [
          new Home(),
          new Plan(),
          new History("History screen"),
        ],
        onPageChanged: onPageChanged,
        controller: _pageController,
      ),
      bottomNavigationBar: new Theme(
        data: Theme.of(context).copyWith(
          // sets the background color of the `BottomNavigationBar`
          canvasColor: const Color(0xFF612A30),
          // sets the active color of the `BottomNavigationBar`
          primaryColor: const Color(0xFFFFFFFF),
          // sets the inactive color of the `BottomNavigationBar
          textTheme: Theme.of(context).textTheme.copyWith(caption: new TextStyle(color: new Color.fromRGBO(255,255, 255, 0.5)))
        ),
        child: new BottomNavigationBar(
          items: [
            new BottomNavigationBarItem(
                icon: new Icon(Icons.home,),
                title: new Text("HOME",
                  style: new TextStyle(),)),
            new BottomNavigationBarItem(
                icon: new Icon(Icons.calendar_today,),
                title: new Text("PLAN",
                  style: new TextStyle(),)),
            new BottomNavigationBarItem(icon: new Icon(Icons.history,),
                title: new Text("HISTORY",
                  style: new TextStyle(),))
          ],
          onTap: navigationTapped,
          currentIndex: _page,
        ),
      ),
    );
  }
}
