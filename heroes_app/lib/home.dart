import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'models/workout.dart';
import 'models/user.dart';

import 'authentication.dart';

// Build the home page and call on the stateful classes
class Home extends StatelessWidget {
  Home({
    this.auth,
    this.onSignedOut,
    this.onLoggedIn,
    this.readyToSignOut,
    this.onStartWorkout,
    this.onActiveWorkout,
    this.onSummary,
  });

  final BaseAuth auth;
  final VoidCallback onSignedOut;
  final VoidCallback onLoggedIn;
  final VoidCallback readyToSignOut;
  final VoidCallback onStartWorkout;
  final VoidCallback onActiveWorkout;
  final VoidCallback onSummary;

  static String tag = 'home-page';

  // Container for text, aligned on the left
  Widget _nextWorkout() {
    return Container(
      padding: EdgeInsets.fromLTRB(40, 30, 40, 0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text('Next planned workout:',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  // Page build
  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarColor(Color(0xFF612A30));
    return new Container(
      // general background color for the page
      decoration: BoxDecoration(
        color: Theme.of(context).secondaryHeaderColor,
      ),
      child: Column(
        children: <Widget>[
          AvatarOverview(
            auth: auth,
            onSignedOut: onSignedOut,
            onLoggedIn: onLoggedIn,
            readyToSignOut: readyToSignOut
          ),
          _nextWorkout(),
          WorkoutOverview(
            onStartWorkout: onStartWorkout,
            onActiveWorkout: onActiveWorkout,
            onSummary: onSummary
          ),
        ],
      )
    );
  }
}

// Create state for appbar of home page
class AvatarOverview extends StatefulWidget {
  AvatarOverview(
      {this.auth, this.onSignedOut, this.onLoggedIn, this.readyToSignOut});

  final BaseAuth auth;
  final VoidCallback onSignedOut;
  final VoidCallback onLoggedIn;
  final VoidCallback readyToSignOut;

  @override
  State createState() => new _AvatarOverviewState();
}

// Class for appbar of home page
class _AvatarOverviewState extends State<AvatarOverview> {

  @override
  Widget build(BuildContext context) {
    // Variables for size, for best view across platforms
    var barHeight = (MediaQuery.of(context).size.height) / 3;
    var barWidth = (MediaQuery.of(context).size.width);
    var imageHeight = (barHeight - 30);
    var imageWidth = (barWidth / 2) - 20;
    var progressBar = (imageWidth - 15);

// ============ Widget build for information ============

    // Settings symbol and onPressed functionality
    Widget _settingsButton() {
      return IconButton(
        icon: Icon(Icons.settings),
        key: Key("settingsButton"),
        color: Colors.white,
        padding: EdgeInsets.fromLTRB(
          (barWidth / 2) - 44, 0, 0, 0),
        onPressed: () {
          widget.readyToSignOut();
        }
      );
    }

    // Character name
    Widget _characterName() {
      var user = ScopedModel.of<User>(context);
      return new Container(
        padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
        width: imageWidth,
        child: Text(
          user.characterName.toString(),
          softWrap: true,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
          maxLines: 1,
        ),
      );
    }

    // Level and class
    Widget _levelAndClass() {
      var user = ScopedModel.of<User>(context);
      return Container(
        padding: EdgeInsets.fromLTRB(20, 5, 0, 0),
        child: Text(
          'Level ${user.gameLevel.toString()} ${user.className.toString()}',
          style: TextStyle(color: Colors.white),
          textAlign: TextAlign.left
        ),
      );
    }

    // Progress bar
    Widget _progressBar() {
      var user = ScopedModel.of<User>(context);
      double xpPercent;
      if (user.xp >= user.xpCap) {
        xpPercent = 1.0;
      } else {
        xpPercent = user.xp / user.xpCap;
      }

      return Container(
        padding: EdgeInsets.fromLTRB(15, 35, 0, 0),
        child: LinearPercentIndicator(
          width: progressBar,
          lineHeight: 15,
          backgroundColor: Colors.white,
          progressColor: Theme.of(context).accentColor,
          percent: xpPercent,
          //bar shape
          linearStrokeCap: LinearStrokeCap.roundAll,
          animationDuration: 2000,
        ),
      );
    }

    // XP / XP cap information
    Widget _xpProgress() {
      var user = ScopedModel.of<User>(context);
      return Container (
        padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
        child: Text(
          '${user.xp.toString()}/${user.xpCap.toString()} XP',
          style: TextStyle(color: Colors.white),
          textAlign: TextAlign.left),
      );
    }

// ============ Widget build for columns ============

    // Column for half bar, only image
    Widget _image() {
      return Column(children: <Widget>[
        Container(
          margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
          height: imageHeight,
          width: imageWidth,
          child: Image.asset(
            'assets/avatar-test.png',
            fit: BoxFit.fill,
          ),
        )
      ]);
    }

    // Column for second half of bar, character information
    Widget _characterInformation() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _settingsButton(),
          _characterName(),
          _levelAndClass(),
          _progressBar(),
          _xpProgress(),
        ]
      );
    }

// ============ Return Avatar overview build ============

    return SafeArea(
      child: Container(
        height: barHeight,
        width: barWidth,
        color: Theme.of(context).primaryColor,
        padding: EdgeInsets.fromLTRB(20, 5, 10, 5),
        child: Stack(
          children: <Widget>[
            Row(
              children: <Widget>[
                _image(),
                _characterInformation(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Create state for workout overview
class WorkoutOverview extends StatefulWidget {
  @override
  _WorkoutOverviewState createState() => _WorkoutOverviewState();

  WorkoutOverview({this.onStartWorkout, this.onActiveWorkout, this.onSummary});

  final VoidCallback onStartWorkout;
  final VoidCallback onActiveWorkout;
  final VoidCallback onSummary;
}

// Class for workout overview
class _WorkoutOverviewState extends State<WorkoutOverview> {
  @override
  void initState() {
    super.initState();
  }

// ============ Widget build for information ============

  // Making a widget for sized box
  Widget _space(double height){
    return SizedBox(
      height: height,
    );
  }

  // Workout title container
  Widget _workoutTitle() {
    var workoutModel = ScopedModel.of<Workout>(context);
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        // Border radius to round top edges
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8.0),
          topRight: Radius.circular(8.0)
        ),
        color: Theme.of(context).accentColor,
      ),
      child: Row(
        children: <Widget>[
          Container(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                workoutModel.workoutName,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Column with workout information declaration
  Widget _declareInformation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Class:',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF434242)),
        ),
        _space(10),
        Text(
          'Fitness Level:',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF434242)),
        ),
        _space(10),
        Text(
          'XP:',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF434242)),
        ),
        _space(10),
        Text(
          'Intensity:',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF434242)),
        ),
        _space(10),
        Icon(
          Icons.alarm,
          color: Color(0xFF434242),
        ),
      ],
    );
  }

  // Column with workout information from database
  Widget _workoutVariables() {
    var workoutModel = ScopedModel.of<Workout>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          workoutModel.workoutClass,
          style: TextStyle(color: Color(0xFF434242)),
        ),
        _space(10),
        Text(
          workoutModel.fitnessLevel.toString(),
          style: TextStyle(color: Color(0xFF434242)),
        ),
        _space(10),
        Text(
          workoutModel.xp.toString(),
          style: TextStyle(color: Color(0xFF434242)),
        ),
        // add space between lines
        _space(10),
        Text(
          workoutModel.intensity,
          style: TextStyle(color: Color(0xFF434242)),
        ),
        // add space between lines
        _space(18),
        Text(
          workoutModel.duration.toString() + ' min',
          style: TextStyle(color: Color(0xFF434242)),
        ),
      ]
    );
  }

// ============ Widget assembly of information ============

  // Assemble workout information in one container
  Widget _workoutInformation() {
    return Container(
      padding: EdgeInsets.all(15),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 6,
            child: _declareInformation(),
          ),
          Expanded(
            flex: 6,
            child: _workoutVariables(),
          ),
        ],
      ),
    );
  }

  // Build workout card
  Widget _workoutCard() {
    return new Container(
      decoration: BoxDecoration(
        // Border radius to round bottom edges
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
        color: Color(0xFFE7E9ED),
      ),
      child: Column(
        //mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          _workoutTitle(),
          _workoutInformation()
        ],
      )
    );
  }

  // Make the entire workout card clickable
  Widget _workout(workoutModel) {
    return new GestureDetector(
      onTap: (){
        workoutModel.isFromHomePage = true;
        widget.onStartWorkout();
      },
      child: _workoutCard(),
    );
  }

// ============ Return Workout overview build ============

  @override
  Widget build(BuildContext context) {
    var workout = ScopedModel.of<Workout>(context);
    return LayoutBuilder(builder: (context, constraints) {
      // Check that the database has registered workouts compliant of
      if (workout.intensity == "" ||
        workout.workoutName == "" ||
        workout.workoutClass == "" ||
        workout.duration == -1 ||
        workout.fitnessLevel == -1 ||
        workout.xp == -1 ||
        workout.exercises == []) {
          return new Text("No workout found.");
      } else {
        return Container(
          // Make sure the placement is centered
          padding: EdgeInsets.fromLTRB(40, 10, 40, 0),
          child: Column(
            children: <Widget>[
              // Call on workout widget
              _workout(workout),
            ],
          )
        );
      }
    });
  }
}
