import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:scoped_model/scoped_model.dart';
import 'models/workout.dart';

class Workouts extends StatefulWidget {
  @override
  _WorkoutsPageState createState() => new _WorkoutsPageState();

  Workouts(
      {this.onLoggedIn,
      this.onStartWorkout,
      this.onActiveWorkout,
      this.onSummary});

  final VoidCallback onLoggedIn;
  final VoidCallback onStartWorkout;
  final VoidCallback onActiveWorkout;
  final VoidCallback onSummary;
}

class _WorkoutsPageState extends State<Workouts> {
  bool _dataLoadedFromFireBase =
      false; //if this is null, it is still loading data from firebase.

  @override
  void initState() {
    super.initState();

    var workout = ScopedModel.of<Workout>(context);

    if (workout.listOfWorkouts != null) {
      _dataLoadedFromFireBase = true;
    }

    CloudFunctions.instance
        .call(
      functionName: 'getAllWorkouts',
    )
        .then((response) {
      if (this.mounted) {
        workout.setListOfWorkouts(response['workoutList']);
        setState(() {
          _dataLoadedFromFireBase = true;
        });
      }
    }).catchError((error) {
      print(error);
    });
  }

  //Checks to see if all the necessary fields in the database are set and correct
  bool _validateWorkout(int index) {
    var workout = ScopedModel.of<Workout>(context);

    int fitnessLevel = 1;
    //if the workout does not have a list of exercises, do not display it as an option
    var wo = workout.listOfWorkouts[index];

    //checks whether the workout has a fitnessLvl and whether the workouts fitnessLvl is higher than the user's
    if (wo["fitnessLevel"] == null || wo["fitnessLevel"] > fitnessLevel) {
      return false;
    }
    if (wo["exercises"] == null || wo["exercises"].length == 0) {
      return false;
    }

    if (wo["workoutName"] == null ||
        wo["duration"] == null ||
        wo["intensity"] == null ||
        wo["xp"] == null) {
      return false;
    }
    if (!(wo["duration"] is int || wo["xp"] is int)) {
      return false;
    }

    if (wo["warmUp"] == null || wo["warmUp"].length == 0) {
      return false;
    }

    if (wo["warmUp"]["description"] == null ||
        wo["warmUp"]["xp"] == null ||
        wo["warmUp"]["targetMin"] == null) {
      return false;
    }

    if (!(wo["warmUp"]["xp"] is int)) {
      return false;
    } else {
      for (var exercise in wo["exercises"]) {
        if (exercise["name"] == null ||
            exercise["targetSets"] == null ||
            exercise["restBetweenSets"] == null ||
            exercise["xp"] == null) {
          return false;
        }
        if (!(exercise["xp"] is int)) {
          return false;
        }
        if (exercise["targetReps"] == null && exercise["targetMin"] == null) {
          return false;
        }
      }
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget _buildWaitingScreen() {
      return Scaffold(
        body: Container(
          alignment: Alignment.center,
          child: CircularProgressIndicator(),
        ),
      );
    }

    Widget _workout(workoutModel, int index) {
      if (_validateWorkout(index) == false) {
        return Text("");
      } else {
        return new GestureDetector(
            onTap: () {
              workoutModel.isFromHomePage = false;
              workoutModel.changeActiveWorkout(
                  workoutModel.listOfWorkouts, index);
              widget.onStartWorkout();
            },
            child: new Container(
              // add border for the workout info box
              margin:
                  new EdgeInsets.symmetric(horizontal: 40.0, vertical: 12.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 0.25),
                color: Color(0xFFE7E9ED),
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              child: Column(
                // Text starts on the left, instead of centered as is the default
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  // container for title box
                  Container(
                    padding: EdgeInsets.all(15),
                    // border to distinguish between the two containers within the box
                    // Colour for the entire row
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xFF212838), width: 0.15),
                      color: Theme.of(context).accentColor,
                      //Border radius for workout title
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8.0),
                          topRight: Radius.circular(8.0)),
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
                              workoutModel.listOfWorkouts[index]
                                      ["workoutName"] ??
                                  '',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // container for changing information
                  Container(
                    padding: EdgeInsets.all(15),
                    // border to distinguish between the two containers within the box
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 0.15),
                    ),
                    child: Row(
                      children: <Widget>[
                        // Column for information declaration
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Class:',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF434242)),
                              ),
                              // add space between lines
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                'Fitness Level:',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF434242)),
                              ),
                              // add space between lines
                              SizedBox(
                                height: 10,
                              ),
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
                          flex: 6,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  workoutModel.listOfWorkouts[index]["class"]
                                      .toString(),
                                  style: TextStyle(color: Color(0xFF434242)),
                                ),
                                // add space between lines
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  workoutModel.listOfWorkouts[index]
                                          ["fitnessLevel"]
                                      .toString(),
                                  style: TextStyle(color: Color(0xFF434242)),
                                ),
                                // add space between lines
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  workoutModel.listOfWorkouts[index]["xp"]
                                          .toString() ??
                                      '',
                                  style: TextStyle(color: Color(0xFF434242)),
                                ),
                                // add space between lines
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  workoutModel.listOfWorkouts[index]
                                              ["intensity"]
                                          .toString() ??
                                      '',
                                  style: TextStyle(color: Color(0xFF434242)),
                                ),
                                // add space between lines
                                SizedBox(
                                  height: 18,
                                ),
                                Text(
                                  workoutModel.listOfWorkouts[index]["duration"]
                                              .toString() +
                                          " min" ??
                                      '',
                                  style: TextStyle(color: Color(0xFF434242)),
                                ),
                              ]),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ));
      }
    }

    Widget _listOfWorkouts() {
      var workout = ScopedModel.of<Workout>(context);
      if (workout.listOfWorkouts.isEmpty) {
        return Text("");
      } else {
        return new ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: workout.listOfWorkouts.length,
          itemBuilder: (BuildContext context, int index) {
            return _workout(workout, index);
            //children: root["info"]
          },
        );
      }
    }

    if (!_dataLoadedFromFireBase) {
      return Scaffold(
        appBar: new AppBar(
          centerTitle: true,
          title: new Text("Workouts"),
        ),
        backgroundColor: Theme.of(context).secondaryHeaderColor,
        body: _buildWaitingScreen(),
      );
    } else {
      return Scaffold(
        appBar: new AppBar(
          centerTitle: true,
          title: new Text("Workouts"),
        ),
        backgroundColor: Theme.of(context).secondaryHeaderColor,
        body: _listOfWorkouts(),
      );
    }
  }
}
