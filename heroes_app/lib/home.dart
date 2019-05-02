import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'models/workout.dart';
import 'models/user.dart';

import 'workoutCard.dart';
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
        child: Text('Next recommended workout:',
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
            onSummary: onSummary,
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
          key: Key("charName"),
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
          key: Key("levelClass"),
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
          key: Key("xp"),
          textAlign: TextAlign.left),
      );
    }

// ============ Widget build for columns ============

    // Column for half bar, only image
    Widget _image() {
      var user = ScopedModel.of<User>(context);
      return Column(children: <Widget>[
        Container(
          width: imageWidth,
          height: imageHeight,
          margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
          child: user.avatar,
          decoration: BoxDecoration(
            color: Color(0xff35343A),
          ),
        ),
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

  WorkoutOverview({Key key, this.onStartWorkout, this.onActiveWorkout, this.onSummary, this.isFromHomePage, this.index}): super(key: key);

  @override
  _WorkoutOverviewState createState() => _WorkoutOverviewState();

  final VoidCallback onStartWorkout;
  final VoidCallback onActiveWorkout;
  final VoidCallback onSummary;
  final bool isFromHomePage;
  final int index;

}

// Class for workout overview
class _WorkoutOverviewState extends State<WorkoutOverview> {

  String workoutName;

  @override
  void initState() {
    super.initState();
  }


// ============ Widget assembly of information ============

  // Make the entire workout card clickable
  Widget _workout(workoutModel) {
    return new GestureDetector(
      key: Key("workoutCard"),
      onTap: (){
        workoutModel.isFromHomePage = true;
        widget.onStartWorkout();
      },
      child: WorkoutCard(
        onStartWorkout: widget.onStartWorkout,
        onActiveWorkout: widget.onActiveWorkout,
        onSummary: widget.onSummary,
        isFromHomePage: true,

      ),
    );
  }

// ============ Return Workout overview build ============
  @override
  Widget build(BuildContext context) {
    var workout = ScopedModel.of<Workout>(context);
    return LayoutBuilder(builder: (context, constraints) {
      // Check that the database has registered workouts compliant of
      if (workout.intensityRw == "" ||
        workout.workoutNameRw == "" ||
        workout.workoutClassRw == "" ||
        workout.durationRw == -1 ||
        workout.fitnessLevelRw == -1 ||
        workout.xpRw == -1 ||
        workout.exercisesRw == null ||
        workout.exercisesRw == []
      ) {
          return new Text("No workout found.");
      } else {
        return Container(
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
