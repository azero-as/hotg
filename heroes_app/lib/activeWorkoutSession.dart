import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'dart:async';
import 'summary.dart';
import 'models/workout.dart';
import 'package:scoped_model/scoped_model.dart';

class activeWorkoutSession extends StatefulWidget {
  final List<dynamic> exercises;
  final String workoutName;
  final VoidCallback onLoggedIn;
  final VoidCallback onStartWorkout;
  final VoidCallback onSummary;

  activeWorkoutSession({this.exercises, this.workoutName, this.onLoggedIn, this.onStartWorkout, this.onSummary});

  @override
  _activeWorkoutSession createState() => new _activeWorkoutSession();
}

class _activeWorkoutSession extends State<activeWorkoutSession> {
  List _selectedExercises = [];
  List _exercises = [];
  int _XpEarned = 0;
  int _BonusXP = 0;

  //TODO: Fix timer. Not in use at the moment
  Timer _timer;
  static int _start = 300;
  double _minutes = _start / 60;
  int _seconds = _start % 60;

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
        oneSec,
        (Timer timer) => setState(() {
              if (_start < 1) {
                timer.cancel();
              } else {
                _start = _start - 1;
                _minutes = _start / 60;
                _seconds = _start % 60;
              }
            }));
  }

/*  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }*/

  @override
  Widget build(BuildContext context) {
    //Information about the exercises that is apart of the workout
    void _onCategorySelected(bool selected, t, id, xp, String name) {
      if (selected == true) {
        setState(() {
          _selectedExercises.add(id);
          _exercises.add({"xp": xp, "name": name});
          _XpEarned += xp;
        });
      } else {
        setState(() {
          _selectedExercises.remove(id);
          _exercises.removeWhere((item) => item["name"] == name);
          _XpEarned -= xp;
        });
      }
    }

    //Save the workout to the database using cloud functions
    void _saveWorkout() {
      DateTime date = new DateTime.now();

      if (_selectedExercises.length == widget.exercises.length) {
        _BonusXP = 1;
      } else {
        _BonusXP = 0;
      }

      _XpEarned = _XpEarned + _BonusXP;
      
      CloudFunctions.instance.call(functionName: 'addWorkout', parameters: {
        "bonus_xp": _BonusXP,
        "total_xp": _XpEarned,
        "workoutType": widget.workoutName,
        "exercises": _exercises
      });

      var workout = ScopedModel.of<Workout>(context);
      workout.setFinishedWorkout(_exercises, _XpEarned, _BonusXP);

    }

    Widget _showInfoExercises(int index){
      String exercise = "targetReps";
      String name = "Reps: ";
      if(widget.exercises[index]["targetReps"] == null){
        exercise = "targetMin";
        name = "Minutes: ";
      }
      return ExpansionTile(
          key: PageStorageKey<int>(index),
          title: new CheckboxListTile(
            value: _selectedExercises
                .contains(widget.exercises[index]["name"]),
            onChanged: (bool selected) {
              _onCategorySelected(
                  selected,
                  widget.exercises[index],
                  widget.exercises[index]["name"],
                  widget.exercises[index]["xp"],
                  widget.exercises[index]["name"]);
            },
            title: Text(widget.exercises[index]["name"]),
          ),
          children: <Widget>[
            ListTile(
              title: new Padding(
                  padding: EdgeInsets.all(20),
                  child: new Text(
                      "Sets: " + widget.exercises[index]["targetSets"])),
            ),
            ListTile(
              title: new Padding(
                  padding: EdgeInsets.all(20),
                  child: new Text(
                  name + widget.exercises[index][exercise])),
        ),
            ListTile(
              title: new Padding(
                  padding: EdgeInsets.all(20),
                  child: new Text("Rest between sets: " +
                      widget.exercises[index]["restBetweenSets"])),
            ),
            ListTile(
              title: new Padding(
                  padding: EdgeInsets.all(20),
                  child: new Text(
                      "XP: " + widget.exercises[index]["xp"].toString())),
            ),
          ]
        //children: root["info"]
      );
    }

    //Information about the different exercises in the workout
    Widget _showInformationWorkout() {
      return new ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: widget.exercises.length,
        itemBuilder: (BuildContext context, int index){
          return _showInfoExercises(index);
        }
      );
    }

    //Timer for warm-up
    Widget _returnTimer() {
      int _min = num.parse(_minutes.toStringAsFixed(0));
      return Container(
        padding: EdgeInsets.all(30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text("Warm-up"),
            RaisedButton(
                onPressed: () {
                  startTimer();
                },
                child: Container(
                  padding: EdgeInsets.all(1.0),
                  child: Text("$_min" + ":" + "$_seconds" + " min"),
                ))
          ],
        ),
      );
    }

    Widget _returnFinishWorkoutButton() {
      return new Padding(
        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 40.0),
        child: RaisedButton(
          elevation: 5.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          onPressed: () {
            _saveWorkout();
            widget.onSummary();
            },
          padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
          color: const Color(0xFF612A30),
          child: Text(
            'Finish workout',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }

    return new Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            //TODO: Check if you came from the planpage or from the homepage. Then decide whether to use onStartWorkout or onLoggedIn.
            widget.onStartWorkout();
          },
          color: Colors.white,
        ),
      ),
      body: new Container(
          child: Column(
        children: <Widget>[
          //_returnTimer(),
          Expanded(
            child: _showInformationWorkout(),
          ),
          _returnFinishWorkoutButton(),
        ],
      )),
    );
  }
}
