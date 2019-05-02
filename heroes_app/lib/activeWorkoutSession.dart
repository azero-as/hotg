import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'dart:async';
import 'models/user.dart';
import 'models/workout.dart';
import 'package:scoped_model/scoped_model.dart';
import 'logic/calculateXp.dart';

class activeWorkoutSession extends StatefulWidget {
  final List<dynamic> exercises;
  final String workoutName;
  final VoidCallback onLoggedIn;
  final VoidCallback onStartWorkout;
  final VoidCallback onSummary;

  activeWorkoutSession(
      {this.exercises,
      this.workoutName,
      this.onLoggedIn,
      this.onStartWorkout,
      this.onSummary});

  @override
  _activeWorkoutSession createState() => new _activeWorkoutSession();
}

class _activeWorkoutSession extends State<activeWorkoutSession> {
  List _selectedExercises = [];
  List _exercises = [];
  int _XpEarned = 0;
  int _BonusXP = 0;

  @override
  Widget build(BuildContext context) {
    //Information about the exercises that is apart of the workout

    //Checks to see if warm up is selected. If it is not selected, the exercises will get a grey color to make them look disabled
    Color _exerciseColor() {
      if (_selectedExercises.contains("Warm-up")) {
        return Colors.black;
      } else {
        return Colors.grey;
      }
    }

    //Finish workout button color
    Color _finishWorkoutColor() {
      if (_selectedExercises.contains("Warm-up") &&
          !(_selectedExercises.length <= 1)) {
        return Theme.of(context).primaryColor;
      } else {
        return Colors.grey;
      }
    }

    //Checks to see if warm up is selected
    void _warmUpSelected(bool selected, id, name, exercise) {
      if (selected == true) {
        setState(() {
          _selectedExercises.add(name);
        });
      } else {
        setState(() {
          _selectedExercises.remove(name);
        });
      }
    }

    //Check to see if the exercises is selected
    void _onCategorySelected(bool selected, id, name, exercise) {
      if (!_selectedExercises.contains("Warm-up")) {
        return null;
      } else if (selected == true) {
        setState(() {
          _selectedExercises.add(name);
          if (exercise["targetReps"] != null) {
            _exercises.add({
              "xp": exercise["xp"],
              "name": name,
              "repetitions": exercise["targetReps"],
              "sets": exercise["targetSets"]
            });
          } else if (exercise["targetMin"] != null) {
            _exercises.add({
              "xp": exercise["xp"],
              "name": name,
              "repetitions": exercise["targetMin"],
              "sets": exercise["targetSets"]
            });
          } else {
            _exercises.add({"xp": exercise["xp"], "name": name});
          }
          _XpEarned += exercise["xp"];
        });
      } else {
        setState(() {
          _selectedExercises.remove(name);
          _exercises.removeWhere((item) => item["name"] == name);
          _XpEarned -= exercise["xp"];
        });
      }
    }

    //Save the workout to the database using cloud functions
    void _saveWorkout() {
      DateTime date = new DateTime.now();

      if (_selectedExercises.length == widget.exercises.length + 1) {
        _BonusXP = calculateBonusXP(this._XpEarned);
      } else {
        _BonusXP = 0;
      }

      _XpEarned = _XpEarned + _BonusXP;

      CloudFunctions.instance
          .call(functionName: 'saveCompletedWorkout', parameters: {
        "bonus_xp": _BonusXP,
        "total_xp": _XpEarned,
        "workoutType": widget.workoutName,
        "exercises": _exercises
      });

      //Adds workout to state, which the summary page gets its content from.
      var workout = ScopedModel.of<Workout>(context);
      workout.setFinishedWorkout(_exercises, _XpEarned, _BonusXP);
    }

    //When clicking the finished button, this widget will come up if you have not checked of warm up + at least one exercise
    Widget _onNotCheckedOffButFinished(BuildContext context) {
      return Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
            margin: EdgeInsets.fromLTRB(30, 0, 30, 10),
            //decoration: new BoxDecoration(                  //border if we want
              //color: Colors.white,
              //border: new Border.all(color: Colors.black)
            // ),
            child: new ListView(
              shrinkWrap: true,
              children: <Widget>[
                new Container(
                  padding: EdgeInsets.fromLTRB(20, 8, 0, 8),
                  color: const Color(0xFF212838),
                  child: new Row(
                    //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'No exercises done',
                          key: Key("NoExercisesPopUp"),
                          style: TextStyle(
                            decoration: TextDecoration.none,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          )
                      ),
                      Align(
                        child: FlatButton.icon(
                          key: Key("crossOutPopUpNE"),
                          padding: EdgeInsets.fromLTRB(45, 8, 0, 8),
                          color: Theme.of(context).secondaryHeaderColor,
                          textColor: Colors.white,
                          icon: Icon(Icons.close, ),
                          label: Text(''),
                          onPressed: () => Navigator.pop(context),
                        )
                      ),
                    ],
                  )
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(20, 30, 20, 30),
                  color: Colors.white,
                  child: Column(
                    children: <Widget>[
                      RichText(
                        text: TextSpan(
                          text:
                          'Did you remember to check off the exercises you have done? '
                            'You need to warm up and do at least one exercise to finish the workout',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            )
          ),
        ],
      );
    }

    //Validates the workout when the button finished workout is clicked
    //If not at least one exercise + the warm up is checked off, a pop up will appear. Otherwise, the user will be sent to the summary page
    void _validateAndSaveWorkout() {
      if (_selectedExercises.length <= 1 ||
          !_selectedExercises.contains("Warm-up")) {
        //Display pop-up
        showDialog(
            context: context,
            builder: (context) =>
                _onNotCheckedOffButFinished(context)); // Call the Dialog.
      } else {
        _saveWorkout();
        widget.onSummary(); // Go to summary
      }
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
                      })
                  ],

                );
              }
            );
          },
        );
      } else {
        return IconButton(
          icon: Icon(Icons.info_outline,
            color: Color(0x00000000),),
          onPressed: null,
        );
      }
    }

    //Information about the warm up + checkbox for warm up
    Widget _showInfoWarmUp(int index) {
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
                      })
                  ],
                );
              });
            }, // title: new Text("Warm-up",
          ),
          key: PageStorageKey<int>(index),
          title: new CheckboxListTile(
            key: Key("warmUp"),
            value: _selectedExercises.contains("Warm-up"),
            onChanged: (bool selected) {
              _warmUpSelected(
                  selected, workout.warmUp[index], "Warm-up", workout.warmUp);
            },
            title: new Text(
              "Warm-up",
            ),
          ),
          children: <Widget>[
            ListTile(
              title: new Padding(
                padding: EdgeInsets.all(20),
                child: new Text(
                  "Minutes: " + workout.warmUp["targetMin"].toString()))),
          ]);
    }

    //Information about the exercises + checkbox for exercises
    Widget _showInfoExercises(int index) {
      String exercise = "targetReps";
      String name = "Reps: ";
      if (widget.exercises[index]["targetReps"] == null) {
        exercise = "targetMin";
        name = "Minutes: ";
      }
      return ExpansionTile(
          key: PageStorageKey<int>(index),
          leading: _showExerciseDescription(index),
          title: new CheckboxListTile(
            key: Key("exercise$index"),
            value: _selectedExercises.contains(widget.exercises[index]["name"]),
            onChanged: (bool selected) {
              _onCategorySelected(selected, widget.exercises[index],
                  widget.exercises[index]["name"], widget.exercises[index]);
            },
            title: Text(widget.exercises[index]["name"],
                style: TextStyle(color: _exerciseColor())),
          ),
          children: <Widget>[
            ListTile(
              title: new Padding(
                  padding: EdgeInsets.all(20),
                  child: new Text(
                    "Sets: " + widget.exercises[index]["targetSets"].toString(),
                  )),
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
      if (workout == null) {
        return Text("");
      }
      return new ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: widget.exercises.length + 1 ?? 0,
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) {
              return _showInfoWarmUp(index);
            } else {
              index = index - 1;
              return _showInfoExercises(index);
            }
          });
    }

    Widget _bonusInformation() {
      return new Padding(
          padding: EdgeInsets.fromLTRB(30, 0, 0, 10),
          child: Text("Remember that you get a bonus if you finish all exercises!"),
      );
    }

    Widget _returnFinishWorkoutButton() {
      return new Padding(
        key: Key("finishWorkoutButton"),
        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 15.0),
        child: ScopedModelDescendant<User>(builder: (context, child, model) {
          return RaisedButton(
            key: Key("finishButton"),
            elevation: 5.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            onPressed: () {
              _validateAndSaveWorkout();
              model.incrementXP(
                _XpEarned); // Increase use xp total in database
              },
              padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
              color: _finishWorkoutColor(),
              child: Text(
                'Finish workout',
                style: TextStyle(color: Colors.white),
              ),
            );
          }));
    }

    var workout = ScopedModel.of<Workout>(context);
    return new Scaffold(
      appBar: AppBar(
        title: new Text(workout.workoutName),
        leading: IconButton(
          key: Key("backToStartWorkout"),
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            //TODO: Check if you came from the planpage or from the homepage. Then decide whether to use onStartWorkout or onLoggedIn.
            widget.onStartWorkout();
          },
          color: Colors.white,
        ),
      ),
      body: new Container(
          color: Color(0xFFe0e4eb),
          child: Column(
            children: <Widget>[
              //_returnTimer(),
              Expanded(
                child: _showInformationWorkout(),
              ),
              _bonusInformation(),
              _returnFinishWorkoutButton(),
            ],
          )),
    );
  }
}
