import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:scoped_model/scoped_model.dart';
import 'models/user.dart';
import 'models/workout.dart';
import 'authentication.dart';
import 'startWorkout.dart';
import 'package:cloud_functions/cloud_functions.dart';

// build the home page and call on the stateful classes
class Home extends StatelessWidget {

  Home({this.auth, this.onSignedOut, this.onLoggedIn, this.readyToSignOut, this.onStartWorkout, this.onActiveWorkout, this.onSummary});

  final BaseAuth auth;
  final VoidCallback onSignedOut;
  final VoidCallback onLoggedIn;
  final VoidCallback readyToSignOut;
  final VoidCallback onStartWorkout;
  final VoidCallback onActiveWorkout;
  final VoidCallback onSummary;

  static String tag = 'home-page';

  //Settings icon button with navigation to settings page
  @override
  Widget build(BuildContext context) {
    return new Container(
        // general background color for the page
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Column(
          children: <Widget>[
            AvatarOverview(auth: auth, onSignedOut: onSignedOut, onLoggedIn: onLoggedIn, readyToSignOut: readyToSignOut),
            SizedBox(height: 20.0),
            WorkoutOverview(onStartWorkout: onStartWorkout, onActiveWorkout: onActiveWorkout, onSummary: onSummary),
          ],
        ));
  }
}

// create state for appbar of home page
class AvatarOverview extends StatefulWidget {
  AvatarOverview({this.auth, this.onSignedOut, this.onLoggedIn, this.readyToSignOut});

  final BaseAuth auth;
  final VoidCallback onSignedOut;
  final VoidCallback onLoggedIn;
  final VoidCallback readyToSignOut;

  @override
  State createState() => new _AvatarOverviewState();
}

// class for appbar of home page
class _AvatarOverviewState extends State<AvatarOverview> {
  Widget build(BuildContext context) {
    // variables for size, for best view across platforms
    var barHeight = (MediaQuery.of(context).size.height) / 3;
    var barWidth = (MediaQuery.of(context).size.width);
    var imageHeight = (barHeight - 55);
    var imageWidth = (barWidth / 2) - 20;
    var progressBar = (imageWidth - 15);
    return Stack(
      children: <Widget>[
        ClipPath(
          child: Container(
              height: barHeight,
              width: barWidth,
              color: Color(0xFF212838),
              padding: EdgeInsets.fromLTRB(20, 30, 20, 15),
              child: ScopedModelDescendant<User>(builder: (context, child, model) {
                // Percent should not exceed 1.0: 
                double xpPercent; 
                 if (model.xp >= model.xpCap) {
                   xpPercent = 1.0;
                   }
                else {
                  xpPercent = model.xp / model.xpCap;
                }
                return Row(
                  children: <Widget>[
                    // Column for half bar, only image
                    Column(children: <Widget>[
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                        child: Image.asset(
                          'assets/avatar-test.png',
                          height: imageHeight,
                          width: imageWidth,
                          fit: BoxFit.fill,
                        ),
                      )
                    ]),

                    // Column for second haf bar, character information
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        //Settings symbol and onPressed functionality
                        IconButton(
                          icon: Icon(Icons.settings),
                          key: Key("settingsButton"),
                          color: Colors.white,
                          padding: EdgeInsets.fromLTRB((barWidth / 2) - 44, 0, 0, 0),
                          onPressed: () {
                            widget.readyToSignOut();
                          }),

                        //Username
                        Padding(
                          padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                          child: Text(
                            model.characterName.toString(),
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                            //textAlign: TextAlign.left,
                          ),
                        ),

                        //Level and class
                        Padding(
                          padding: EdgeInsets.fromLTRB(20, 10, 0, 0),
                          child: Text(
                              'Level ${model.level.toString()} ${model.className.toString()}',
                              // 'Level' /* + _userLevel  + ' Intermediate thing?'*/,
                              style: TextStyle(color: Colors.white),
                              textAlign: TextAlign.left),
                        ),

                        //Progress bar
                        Padding(
                          padding: EdgeInsets.fromLTRB(15, 35, 0, 0),
                          child: LinearPercentIndicator(
                            width: progressBar,
                            lineHeight: 15,
                            backgroundColor: Colors.white,
                            progressColor: Color(0xFF4D3262),
                            percent: xpPercent,
                            //bar shape
                            linearStrokeCap: LinearStrokeCap.roundAll,
                            animationDuration: 2000,
                          ),
                        ),

                        // XP / XP cap
                        Padding(
                          padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                          child: Text(
                              '${model.xp.toString()}/${model.xpCap.toString()}',
                              style: TextStyle(color: Colors.white),
                              textAlign: TextAlign.left),
                        ),
                      ],
                    ),
                  ],
                );
              })),
        )
      ],
    );
  }
}

//create state for workout overview
class WorkoutOverview extends StatefulWidget {
  @override
  _WorkoutOverviewState createState() => _WorkoutOverviewState();

  WorkoutOverview({this.onStartWorkout, this.onActiveWorkout, this.onSummary});

  final VoidCallback onStartWorkout;
  final VoidCallback onActiveWorkout;
  final VoidCallback onSummary;

}

// class for workout overview
class _WorkoutOverviewState extends State<WorkoutOverview> {
  @override
  Widget build(BuildContext context) {
  var workout = ScopedModel.of<Workout>(context);
    return LayoutBuilder(builder: (context, constraints) {
      if (workout.intensity == "" ||
          workout.workoutName == "" ||
          workout.duration == -1 ||
          workout.xp == -1 ||
          workout.exercises == []) {
        return new Text("");
      } else {
        return Container(
            // make sure the placement is centered and a little away from appbar
            padding: EdgeInsets.fromLTRB(50, 20, 50, 0),
            child: Column(
              children: <Widget>[
                // New container for text, aligned on the left
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    child: Text('Next planned workout:\n',
                        style: TextStyle(
                          color: Color(0xFF525050),
                        )),
                  ),
                ),
                // call on workout widget
                _workout(),
              ],
            ));
      }
    });
  }

  Widget _workout() {
    return new Container(
      // add border for the workout info box
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 0.25),
        color: Color(0xFFE7E9ED),
      ),
      child: ScopedModelDescendant<Workout>(builder: (context, child, model) {
      return Column(
        // Text starts on the left, instead of centered as is the default
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          // container for title box
          Container(
            padding: EdgeInsets.all(5),
            // border to distinguish between the two containers within the box
            // Colour for the entire row
            decoration: BoxDecoration(
              border: Border.all(color: Color(0xFF212838), width: 0.15),
              color: Color(0xFF212838),
            ),
            child: Row(
              children: <Widget>[
                // add some space between left-side border and beginning of text
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                ),
                // new container for title
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    child: Text(
                      model.workoutName,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // container for changing information
          Container(
            padding: EdgeInsets.all(5),
            // border to distinguish between the two containers within the box
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 0.15),
            ),
            child: Row(
              children: <Widget>[
                // Column for information declaration
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'XP:',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF434242)),
                      ),
                      // add space between lines
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Intensity:',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF434242)),
                      ),
                      // add space between lines
                      SizedBox(
                        height: 10,
                      ),
                      Icon(
                        Icons.alarm,
                        color: Color(0xFF434242),
                      ),
                    ],
                  ),
                ),
                // Column for changing information
                Expanded(
                  flex: 3,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          model.xp.toString(),
                          style: TextStyle(color: Color(0xFF434242)),
                        ),
                        // add space between lines
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          model.intensity,
                          style: TextStyle(color: Color(0xFF434242)),
                        ),
                        // add space between lines
                        SizedBox(
                          height: 18,
                        ),
                        Text(
                          model.duration.toString(),
                          style: TextStyle(color: Color(0xFF434242)),
                        ),
                      ]),
                ),
                // Column for button
                Expanded(
                  flex: 3,
                  child: Column(
                    children: <Widget>[
                      // add space to make the button stay at the bottom of the box
                      SizedBox(
                        height: 50,
                      ),
                      RaisedButton(
                        padding: EdgeInsets.all(10.0),
                        onPressed: () {
                          model.isFromHomePage = true;
                          widget.onStartWorkout();
                        },
                        elevation: 5.0,
                        color: Color(0xFF612A30),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.67),
                        ),
                        child: Text(
                          'See workout',
                          style: TextStyle(color: Colors.white, fontSize: 13.0),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      );
      })
    );
  }
}
