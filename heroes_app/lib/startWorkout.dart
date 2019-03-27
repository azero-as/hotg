import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'activeWorkoutSession.dart';
import 'package:scoped_model/scoped_model.dart';
import 'models/workout.dart';
import 'plan.dart';

class StartWorkout extends StatefulWidget {
  final List exercises;
  final int duration;
  final String intensity;
  final int xp;
  final String workoutName;
  final String workoutClass;
  final VoidCallback onLoggedIn;
  final VoidCallback onStartWorkout;
  final VoidCallback onActiveWorkout;
  final VoidCallback onSummary;

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
      this.workoutClass});

  @override
  _StartWorkoutPage createState() => new _StartWorkoutPage();
}

class _StartWorkoutPage extends State<StartWorkout> {
  @override
  Widget build(BuildContext context) {
    Widget _returnStartWorkoutButton() {
      return new Padding(
        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0.0),
        child: RaisedButton(
          elevation: 5.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          onPressed: () {
            widget.onActiveWorkout();
          },
          padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
          color: const Color(0xFF212838),
          child: Text(
            'Start workout',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }

    //General information about the workout
    Widget _showInfo() {
      return Container(
          margin: EdgeInsets.fromLTRB(100, 0, 100, 40),
          child: RichText(
              text: TextSpan(
                  style:  TextStyle(
                    fontSize: 14.0,
                    color: Colors.black,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: ' Class: ',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: widget.workoutClass.toString() + ' \n\n'),
                    TextSpan(
                      text: ' XP: ',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: widget.xp.toString() + ' \n\n'),
                    TextSpan(
                      text: ' Intensity: ',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: widget.intensity.toString() + ' \n\n'),
                    TextSpan(
                      text: ' Time: ',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: widget.duration.toString() + " min"),
              ])));
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
          leading: IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text(widget.exercises[index]["name"]),
                      content: Text(widget.exercises[index]["description"]),
                      actions: <Widget>[
                        FlatButton(
                            child: Text('Close'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            })
                      ],
                    );
                  });
            },
          ),
          title: new Text(
            (widget.exercises[index]["name"]),
          ),
          children: <Widget>[
            ListTile(
                title:
                    new Text("Sets: " + widget.exercises[index]["targetSets"])),
            ListTile(title: new Text(name + widget.exercises[index][exercise])),
            ListTile(
                title: new Text("Rest between sets: " +
                    widget.exercises[index]["restBetweenSets"])),
            ListTile(
                title: new Text(
                    "XP: " + widget.exercises[index]["xp"].toString())),
          ]
          //children: root["info"]
          );
    }

    //Display list of all the exercises in the workout
    Widget _showInformationWorkout() {
      return new ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: widget.exercises.length,
          itemBuilder: (BuildContext context, int index) {
            return _showInfoExercises(index);
          });
    }

    Widget _returnBody() {
      return new Container(
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          margin: EdgeInsets.fromLTRB(0, 50, 0, 35),
          child: Column(
            children: <Widget>[
              Container(
                child: _showInfo(),
              ),
              Expanded(
                child: _showInformationWorkout(),
              ),
              _returnStartWorkoutButton(),
            ],
          ));
    }

    var workout = ScopedModel.of<Workout>(context);
    return Scaffold(
      appBar: AppBar(
        title: new Text(workout.workoutName),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            if (workout.isFromHomePage == true) {
              widget.onLoggedIn();
            } else {
              // TODO: Make it go to pla page instead of widget.onLoggedIn();
              widget.onLoggedIn();
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
