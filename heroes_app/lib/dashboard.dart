import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'authentication.dart';
import 'home.dart';
import 'plan.dart';
import 'history.dart';
import 'models/user.dart';
import 'models/workout.dart';
import 'package:scoped_model/scoped_model.dart';

class DashboardScreen extends StatefulWidget {
  DashboardScreen({Key key, this.auth, this.userId, this.onSignedOut, this.readyToSignOut, this.onSignedIn, this.onStartWorkout, this.onActiveWorkout, this.onSummary, this.index})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback readyToSignOut;
  final VoidCallback onSignedOut;
  final String userId;
  final VoidCallback onSignedIn;
  final VoidCallback onStartWorkout;
  final VoidCallback onActiveWorkout;
  final VoidCallback onSummary;
  final int index;

  @override
  _DashboardScreenState createState() => new _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  //PageController _pageController;
  //int _page = 0;

  @override
  void initState() {
    var user = ScopedModel.of<User>(context);
    super.initState();
    user.setPageController(new PageController(initialPage: widget.index));
  }


  @override
 /* void dispose() {
    //var user = ScopedModel.of<User>(context);
    super.dispose();
    _pageController.dispose();
  }*/


  /*void navigationTapped(int page) {
    // Animating to the page.
    // You can use whatever duration and curve you like
    _pageController.animateToPage(page,
        duration: const Duration(milliseconds: 10), curve: Curves.ease);
  }*/


  @override
 Widget build(BuildContext context) {

    /*void onPageChanged(int page) {
      var user = ScopedModel.of<User>(context);
      user.setPage(page);
    }*/

    return new Scaffold(
      body: Center(
        child: ScopedModelDescendant<User>(
            builder: (context, child, model){
          return new PageView(
            children: [
              new Home(auth: widget.auth, onSignedOut: widget.onSignedOut, onLoggedIn: widget.onSignedIn, readyToSignOut: widget.readyToSignOut, onStartWorkout: widget.onStartWorkout, onActiveWorkout: widget.onActiveWorkout, onSummary: widget.onSummary),
              new Plan(onLoggedIn: widget.onSignedIn, onStartWorkout: widget.onStartWorkout, onActiveWorkout: widget.onActiveWorkout, onSummary: widget.onSummary),
              new History("History screen"),
            ],
            onPageChanged: model.setPage,
            controller: model.pageController,
          );
        })
      ),
      bottomNavigationBar: new Theme(
        data: Theme.of(context).copyWith(
          // sets the background color of the `BottomNavigationBar`
            canvasColor: const Color(0xFF612A30),
            // sets the active color of the `BottomNavigationBar`
            primaryColor: const Color(0xFFFFFFFF),
            // sets the inactive color of the `BottomNavigationBar
            textTheme: Theme
                .of(context)
                .textTheme
                .copyWith(caption: new TextStyle(
                color: new Color.fromRGBO(255, 255, 255, 0.5)))
        ),
        child: ScopedModelDescendant<User>(builder: (context, child, model) {
          return new BottomNavigationBar(
          items: [
          new BottomNavigationBarItem(
          icon: new Icon(Icons.home, ),
          title: new Text("HOME",
          style: new TextStyle(), )),
          new BottomNavigationBarItem(
          icon: new Icon(Icons.calendar_today, ),
          title: new Text("PLAN",
          style: new TextStyle(),)),
          new BottomNavigationBarItem(icon: new Icon(Icons.history, ),
          title: new Text("HISTORY",
          style: new TextStyle
          (), ))
          ],
          onTap: model.navigationTapped,
          currentIndex: model.page,
          );
        })
      )
    );
  }
}