import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'dart:async';
import 'models/user.dart';
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
    void _onCategorySelected(bool selected, t,  xp, String name) {

      if (selected == true) {
        print(true);
        setState(() {
          _selectedExercises.add(name);
          _exercises.add({"xp": xp, "name": name});
          _XpEarned += xp;
        });
      } else {
        print(false);
        setState(() {
          _selectedExercises.remove(name);
          _exercises.removeWhere((item) => item["name"] == name);
          _XpEarned -= xp;
        });
      }
    }

    //Save the workout to the database using cloud functions
    void _saveWorkout() {
      DateTime date = new DateTime.now();

      if (_selectedExercises.length == widget.exercises.length + 1) {
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

    Widget _showInfoWarmUp(int index){
      var workout = ScopedModel.of<Workout>(context);
      return ExpansionTile(
          key: PageStorageKey<int>(index),
          title: new CheckboxListTile(
            value: _selectedExercises
                .contains("Warm-up"),
            onChanged: (bool selected) {
              _onCategorySelected(
                  selected,
                  workout.warmUp[index],
                  workout.warmUp["xp"],
                  "Warm-up");
            },
            title: new Text("Warm-up",),
          ),

          children: <Widget>[
            ListTile(
                title: new Padding(
                    padding: EdgeInsets.all(20),
                    child: new Text(
                    "Minutes: " + workout.warmUp["targetMin"].toString()))),
            ListTile(
                title: new Padding(
                    padding: EdgeInsets.all(20),
                    child: new Text(
                    "Description: " +  workout.warmUp["description"].toString()))),
            ListTile(
                title: new Padding(
                    padding: EdgeInsets.all(20),
                    child: new Text("XP: " + workout.warmUp["xp"].toString()))),

            //children: root["info"]
          ]);
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
                      "Sets: " + widget.exercises[index]["targetSets"].toString())),
            ),
            ListTile(
              title: new Padding(
                  padding: EdgeInsets.all(20),
                  child: new Text(
                  name + widget.exercises[index][exercise].toString())),
        ),
            ListTile(
              title: new Padding(
                  padding: EdgeInsets.all(20),
                  child: new Text("Rest between sets: " +
                      widget.exercises[index]["restBetweenSets"].toString())),
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
      var workout = ScopedModel.of<Workout>(context);
      return new ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: widget.exercises.length + 1 ?? 0,
          itemBuilder: (BuildContext context, int index){
            if(index == 0){
              return _showInfoWarmUp(index);
            }
            else{
              index = index -1;
              return _showInfoExercises(index);
            }

          }
      );
    }


    Widget _returnFinishWorkoutButton() {
      return new Padding(
        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 40.0),
        child: ScopedModelDescendant<User>(builder: (context, child, model) {
        return RaisedButton(
          elevation: 5.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          onPressed: () {
            _saveWorkout();
            model.incrementXP(_XpEarned); // Increase use xp total in database
            widget.onSummary(); // Go to summary
            },
          padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
          color: const Color(0xFF612A30),
          child: Text(
            'Finish workout',
            style: TextStyle(color: Colors.white),
          ),
        );
        })
      );
    }

    var workout = ScopedModel.of<Workout>(context);
    return new Scaffold(
      appBar: AppBar(
        title: new Text(workout.workoutName),
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