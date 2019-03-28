import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:scoped_model/scoped_model.dart';
import 'models/workout.dart';


class Plan extends StatefulWidget {
  @override
  _PlanPageState createState() => new _PlanPageState();

  Plan(
      {this.onLoggedIn,
      this.onStartWorkout,
      this.onActiveWorkout,
      this.onSummary});

  final VoidCallback onLoggedIn;
  final VoidCallback onStartWorkout;
  final VoidCallback onActiveWorkout;
  final VoidCallback onSummary;
}

class _PlanPageState extends State<Plan> {
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
      workout.setListOfWorkouts(response['workoutList']);
      setState(() {
        _dataLoadedFromFireBase = true;
      });
    }).catchError((error) {
      print(error);
    });
  }

  Color chooseHeaderColor(int index){
    var workout = ScopedModel.of<Workout>(context);
    var color = '';
    if(workout.listOfWorkouts[index]["class"] == "Ranger"){
      return Color(0xFFAA6464);
    }

    if(workout.listOfWorkouts[index]["class"] == ""){
      return Color(0xFFAA6464);

    }
    else{
      return Color(0xFFB2826A);
    }
  }
  //Checks to see if all the necessary fields in the database are set and correct
  bool _validateWorkout(int index) {
    var workout = ScopedModel.of<Workout>(context);
    //if the workout does not have a list of exercises, do not display it as an option
    var wo = workout.listOfWorkouts[index];

    if (wo["exercises"] == null || wo["exercises"].length == 0) {
      return false;
    }

    if (wo["workoutName"] == null ||
        wo["duration"] == null ||
        wo["intensity"] == null ||
        wo["xp"] == null) {
      return false;
    }
    if (!(wo["duration"] is int || wo["xp g"] is int)) {
      return false;

    }

    if(wo["warmUp"] == null || wo["warmUp"].length == 0){
      return false;
    }

    if(wo["warmUp"]["description"] == null ||
       wo["warmUp"]["xp"] == null ||
       wo["warmUp"]["targetMin"] == null ){

      return false;
    }

    if(!(wo["warmUp"]["xp"] is int)){
      return false;
    }


    else {
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

    Widget _workout(int index) {
      if (_validateWorkout(index) == false) {
        return Text("");
      } else {
        var color = chooseHeaderColor(index);
        return new Container(
          // add border for the workout info box
          margin: new EdgeInsets.symmetric(horizontal: 50.0, vertical: 12.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 0.25),
            color: Color(0xFFE7E9ED),
            borderRadius: BorderRadius.all(Radius.circular(8.0)),

          ),
          child: ScopedModelDescendant<Workout>(builder: (context, child, model) {
            return Column(
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
                    color: color,
                    //Border radius for workout title
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(8.0), topRight: Radius.circular(8.0)),
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
                            model.listOfWorkouts[index]["workoutName"] ?? '',
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
                        flex: 2,
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
                                model.listOfWorkouts[index]["class"].toString(),
                                style: TextStyle(color: Color(0xFF434242)),
                              ),
                              // add space between lines
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                model.listOfWorkouts[index]["xp"].toString() ??
                                    '',
                                style: TextStyle(color: Color(0xFF434242)),
                              ),
                              // add space between lines
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                model.listOfWorkouts[index]["intensity"]
                                        .toString() ??
                                    '',
                                style: TextStyle(color: Color(0xFF434242)),
                              ),
                              // add space between lines
                              SizedBox(
                                height: 18,
                              ),
                              Text(
                                model.listOfWorkouts[index]["duration"]
                                            .toString() +
                                        " min" ??
                                    '',
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
                              height: 70,
                            ),
                            RaisedButton(
                              padding: EdgeInsets.all(10.0),
                              onPressed: () {
                                model.isFromHomePage = false;
                                model.changeActiveWorkout(
                                    model.listOfWorkouts, index);
                                widget.onStartWorkout();
                              },
                              elevation: 5.0,
                              color: Color(0xFF612A30),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.67),
                              ),
                              child: Text(
                                'See workout',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 13.0),
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
          }),
        );
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
          itemBuilder: (BuildContext context, int index){
            return _workout(index);
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
