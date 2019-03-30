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
    void _onCategorySelected(bool selected, id, name, exercise) {

      if (selected == true) {
        setState(() {
          _selectedExercises.add(name);
          if(exercise["targetReps"] != null){
            _exercises.add({"xp": exercise["xp"], "name": name, "repetitions": exercise["targetReps"], "sets": exercise["targetSets"] });
          }else if(exercise["targetMin"] != null){
            _exercises.add({"xp": exercise["xp"], "name": name, "repetitions": exercise["targetMin"], "sets": exercise["targetSets"] });
          }else{
            _exercises.add({"xp": exercise["xp"], "name": name});
          }
          _XpEarned += exercise["xp"];
        });
      } else {
        print(false);
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
        _BonusXP = 1;
      } else {
        _BonusXP = 0;
      }

      _XpEarned = _XpEarned + _BonusXP;
      
      CloudFunctions.instance.call(functionName: 'saveCompletedWorkout', parameters: {
        "bonus_xp": _BonusXP,
        "total_xp": _XpEarned,
        "workoutType": widget.workoutName,
        "exercises": _exercises
      });

      //Adds workout to state, which the summary page gets its content from.
      var workout = ScopedModel.of<Workout>(context);
      workout.setFinishedWorkout(_exercises, _XpEarned, _BonusXP);
    }

    Widget _onNotCheckedOffButFinished(BuildContext context) {
      return Stack(
        alignment: Alignment.center,
        children: <Widget>[
          new Container(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              margin: EdgeInsets.fromLTRB(35, 0, 35, 35),
              //decoration: new BoxDecoration(                  //border if we want
              //color: Colors.white,
              //border: new Border.all(color: Colors.black)),
              child: new ListView(
                shrinkWrap: true,
                children: <Widget>[
                  new Container(
                      padding: EdgeInsets.fromLTRB(25, 8, 0, 8),
                      color: const Color(0xFF212838),
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          RichText(
                            text: TextSpan(
                              text: 'No exercises done',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          Align(
                            //alignment: Alignment.topRight,
                            child: RaisedButton(
                              color: Theme.of(context).secondaryHeaderColor,
                              textColor: Colors.white,
                              onPressed: () => Navigator.pop(context),
                              child: Icon(
                                Icons.close,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      )),
                  new Container(
                    padding: EdgeInsets.fromLTRB(25, 40, 25, 40),
                    color: Colors.white,
                    child: Column(
                      children: <Widget>[
                        RichText(
                          text: TextSpan(
                            text:
                                'Did you remember to check off the exercises you have done?',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                    //SizedBox(height: 100.0),
                  )
                ],
              )),
        ],
      );
    }

    void _validateAndSaveWorkout() {
      if (_selectedExercises.isEmpty) {
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


    Widget _showInfoWarmUp(int index){
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
                      content: Text( workout.warmUp["description"].toString()),
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
            value: _selectedExercises
                .contains("Warm-up"),
            onChanged: (bool selected) {
              _onCategorySelected(
                  selected,
                  workout.warmUp[index],
                  "Warm-up",
                  workout.warmUp);
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


    Widget _showInfoExercises(int index) {
      String exercise = "targetReps";
      String name = "Reps: ";
      if (widget.exercises[index]["targetReps"] == null) {
        exercise = "targetMin";
        name = "Minutes: ";
      }
      return ExpansionTile(
          key: PageStorageKey<int>(index),
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
          title: new CheckboxListTile(
            value: _selectedExercises.contains(widget.exercises[index]["name"]),
            onChanged: (bool selected) {
              _onCategorySelected(
                  selected,
                  widget.exercises[index],
                  widget.exercises[index]["name"],
                  widget.exercises[index]);
            },
            title: Text(widget.exercises[index]["name"]),
          ),
          children: <Widget>[
            ListTile(
              title: new Padding(
                  padding: EdgeInsets.all(20),
                  child: new Text("Sets: " +
                      widget.exercises[index]["targetSets"].toString())),
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
      if(workout == null){
        return Text("");
      }
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
                _validateAndSaveWorkout();
                model.incrementXP(
                    _XpEarned); // Increase use xp total in database
              },
              padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
              color: const Color(0xFF612A30),
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
          _returnFinishWorkoutButton(),
        ],
      )),
    );
  }
}
