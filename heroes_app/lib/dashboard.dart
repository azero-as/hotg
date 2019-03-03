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
        primaryColor: const Color(0xFF4FB88B),
        secondaryHeaderColor: const Color(0xFF5DC6D9),
        accentColor: const Color(0xFFFFAD32),
      ),
      home: new DashboardScreen(title: 'Heroes of the Gym'),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  DashboardScreen({Key key, this.auth, this.userId, this.onSignedOut, this.title})
      : super(key: key);

  final BaseAuth auth;
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

  _signOut() async {
    try {
      await widget.auth.signOut();
      widget.onSignedOut();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          new FlatButton(
              child: new Text('Logout',
                  style: new TextStyle(fontSize: 17.0, color: Colors.white)),
              onPressed: _signOut
          )],
      ),
      body: new PageView(
        children: [
          new Home("Home screen"),
          new Plan(),
          new History("History screen"),
        ],
        onPageChanged: onPageChanged,
        controller: _pageController,
      ),
      bottomNavigationBar: new Theme(
        data: Theme.of(context).copyWith(
          // sets the background color of the `BottomNavigationBar`
          canvasColor: const Color(0xFFEDEDED),
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
