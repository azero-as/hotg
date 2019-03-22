import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'dart:async';

class activeWorkoutSession extends StatefulWidget {
  final List<dynamic> exercises;
  final String workoutName;

  activeWorkoutSession({this.exercises, this.workoutName});

  @override
  _activeWorkoutSession createState() => new _activeWorkoutSession();
}

class _activeWorkoutSession extends State<activeWorkoutSession> {
  List _selectedExercises = [];
  List _exercises = [];
  int _XpEarned = 0;
  int _BonusXP = 1;

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

  //Save the workout to the database using cloud functions
  void _saveWorkout() {
    DateTime date = new DateTime.now();

    //Check if you have gotten bonus
    for (var i = 0; i < widget.exercises.length; i++) {
      if (!_selectedExercises.contains(widget.exercises[i]["name"])) {
        _BonusXP = 0;
        break;
      } else if (_BonusXP == 0) {
        _BonusXP = 1;
      }
    }

    CloudFunctions.instance.call(functionName: 'addWorkout', parameters: {
      "bonus_xp": _BonusXP,
      "total_xp": _XpEarned,
      "workoutType": widget.workoutName,
      "exercises": _exercises
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //Information about the exercises that is apart of the workout
    void _onCategorySelected(bool selected, t, id, xp, String name) {
      if (selected == true) {
        setState(() {
          _selectedExercises.add(id);
          _exercises.add({"XP": xp, "name": name});
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

    //Information about the different exercises in the workout
    Widget _showInformationWorkout() {
      return new ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: widget.exercises.length,
        itemBuilder: (BuildContext context, int index) => ExpansionTile(
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
                            "Reps: " + widget.exercises[index]["targetReps"])),
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
                ),
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
        actions: <Widget>[
          new Center(
            child: new Text('',
                style: new TextStyle(fontSize: 17.0, color: Colors.white)),
          )
        ],
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
