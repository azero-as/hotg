import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'models/workout.dart';

class StartWorkout extends StatefulWidget {
  final List exercises;
  final int duration;
  final String intensity;
  final int xp;
  final Map warmUp;
  final String workoutName;
  final String workoutClass;
  final VoidCallback onLoggedIn;
  final VoidCallback onStartWorkout;
  final VoidCallback onActiveWorkout;
  final VoidCallback onSummary;
  final VoidCallback onBackToWorkout;
  final VoidCallback alreadyLoggedIn;

  StartWorkout(
      {this.exercises,
      this.duration,
      this.intensity,
      this.xp,
      this.workoutName,
      this.onLoggedIn,
      this.onStartWorkout,
      this.onActiveWorkout,
      this.onSummary,
      this.workoutClass,
      this.onBackToWorkout,
      this.warmUp,
      this.alreadyLoggedIn});

  @override
  _StartWorkoutPage createState() => new _StartWorkoutPage();
}

class _StartWorkoutPage extends State<StartWorkout> {
  @override
  Widget build(BuildContext context) {
    var workout = ScopedModel.of<Workout>(context);

    Widget _returnStartWorkoutButton() {
      if (widget.exercises == null) {
        return Text("");
      }
      return new Padding(
        key: Key("startWorkoutButton"),
        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0.0),
        child: RaisedButton(
          key: Key("startWorkout"),
          elevation: 5.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          onPressed: () {
            widget.onActiveWorkout();
          },
          padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
          color: Theme.of(context).primaryColor,
          child: Text(
            'Start workout',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }

    // Column with Class and xp information
    Widget _infoColumnOne() {
      return Container(
        padding: EdgeInsets.only(right: 5, bottom: 5),
        child: Column(
          children: <Widget>[
            RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.black,
                ),
                children:<TextSpan>[
                  TextSpan(
                    text: ' Class: ',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: widget.workoutClass.toString() + ' \n\n'),
                  TextSpan(
                    text: ' XP: ',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: widget.xp.toString()),
                ]
              ),
            )
          ],
        ),
      );
    }

    // Column with Intensity and Time information
    Widget _infoColumnTwo() {
      return Container(
        padding: EdgeInsets.only(left: 5, bottom: 5),
        child: Column(
          children: <Widget>[
            RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.black,
                ),
                children:<TextSpan>[
                  TextSpan(
                    text: ' Intensity: ',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: widget.intensity.toString() + ' \n\n'),
                  TextSpan(
                    text: ' Time: ',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: widget.duration.toString() + " min"),
                ]
              ),
            )
          ],
        ),
      );
    }

    //General information about the workout, row placement
    Widget _showInfo() {
      return Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _infoColumnOne(),
            _infoColumnTwo(),
          ],
        ),
      );
    }

    // Alert dialog to exercise description, only shown if description is in database
    Widget _showExerciseDescription(int index) {
      if ((widget.exercises[index]["description"]) != null) {
        return IconButton(
          icon: Icon(Icons.info_outline),
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text(widget.exercises[index]["name"]),
                  content: SingleChildScrollView(
                    child:Text(widget.exercises[index]["description"]),
                  ),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('Close'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      }
                    )
                  ],
                );
              },
            );
          },
        );
      } else {
        return IconButton(
          icon: Icon(Icons.info_outline,
            color: Color(0x00000000),
          ),
        );
      }
    }

    Widget _showInfoWarmUp() {
      var workout = ScopedModel.of<Workout>(context);
      return ExpansionTile(
        leading: IconButton(
          icon: Icon(Icons.info_outline),
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Warm-up"),
                  content: SingleChildScrollView(
                    child: Text(workout.warmUp["description"].toString()),
                  ),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('Close'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      }
                    )
                  ],
                );
              }
            );
          }, // title: new Text("Warm-up",
        ),
        title: new Text(
          "Warm-up",
        ),
        children: <Widget>[
          ListTile(
            title: new Text(
              "Minutes: " + workout.warmUp["targetMin"].toString()
            )
          ),
        ]
      );
    }

    //Show information about a workout using minutes
    Widget _showInfoExercises(int index) {
      String exercise = "targetReps";
      String name = "Reps: ";
      if (widget.exercises[index]["targetReps"] == null) {
        exercise = "targetMin";
        name = "Minutes: ";
      }

      return ExpansionTile(
        leading: _showExerciseDescription(index),
        title: new Text(
          (widget.exercises[index]["name"]),
        ),
        children: <Widget>[
          ListTile(
            title: new Text("Sets: " +
              widget.exercises[index]["targetSets"].toString())),
          ListTile(
            title: new Text(
              name + widget.exercises[index][exercise].toString())),
          ListTile(
            title: new Text("Rest between sets: " +
              widget.exercises[index]["restBetweenSets"].toString())),
          ListTile(
            title: new Text(
              "XP: " + widget.exercises[index]["xp"].toString())),
        ]
      );
    }

    //Display list of all the exercises in the workout
    Widget _showInformationWorkout() {
      return new ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: widget.exercises.length + 1 ?? 0,
        itemBuilder: (BuildContext context, int index) {
          if (index == 0) {
            return _showInfoWarmUp();
          } else {
            index = index - 1;
            return _showInfoExercises(index);
          }
        }
      );
    }

    Widget _returnBody() {
      return new Container(
        color: Color(0xFFe0e4eb),
        padding:
          EdgeInsets.only(left: 24.0, bottom: 25.0, top: 25.0, right: 24.0),
        child: Column(
          children: <Widget>[
            _showInfo(),
            Expanded(
              child: _showInformationWorkout(),
            ),
            _returnStartWorkoutButton(),
          ],
        )
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: new Text(workout.workoutName),
        leading: IconButton(
          key: Key("backToHome"),
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            if (workout.isFromHomePage == true) {
              widget.alreadyLoggedIn();
            } else {
              widget.onBackToWorkout();
            }
          },
          color: Colors.white,
        ),
      ),
      body: Container(
        child: _returnBody(),
      ),
    );
  }
}
