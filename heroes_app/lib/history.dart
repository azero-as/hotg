import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class History extends StatelessWidget {
  History(this.listType);
  final String listType;

  @override
  Widget build(BuildContext context) {
    return ListOfTrainingSessions(); // TODO: Should return the content of the history page
  }
}

class ListOfTrainingSessions extends StatefulWidget {
  ListOfTrainingSessions();

  @override
  State<StatefulWidget> createState() {
    return _ListOfTrainingSessionsState();
  }
}

class _ListOfTrainingSessionsState extends State<ListOfTrainingSessions> {
  List _workouts = [];

  @override
  void initState() {
    super.initState();

    CloudFunctions.instance
        .call(functionName: 'getAllUserWorkouts')
        .then((response) {
      setState(() {
        _workouts = response;
      });
    }).catchError((error) {
      print(error);
    });
  }

// ============ Gui build ============

// Builds complete history page

  @override
  Widget build(BuildContext context) {
    if (_workouts.isEmpty) {
      return Container(
          width: 50, height: 50, child: CircularProgressIndicator());
    } else {
      return ListView.builder(
          // Loops through every workout
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
          itemCount: _workouts.length,
          itemBuilder: (context, index) {
            return _workoutCard(
                context, _workouts[index]); //Sending one workout
          });
    }
  }

  Widget _workoutCard(BuildContext context, workoutObject) {
    final String _workoutDate = Timestamp(workoutObject["date"]["_seconds"],
            workoutObject["date"]["_nanoseconds"])
        .toDate()
        .toString()
        .split(" ")[0];
    final String _workoutType = workoutObject["workoutType"];
    final String _totalXP = workoutObject["total_xp"].toString();

    List _exercises = workoutObject["exercises"];

    List<Widget> exercises = [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Expanded(
              flex: 2,
              child: Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                  child: Text(
                    "Exercise",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ))),
          Expanded(
            flex: 1,
            child: Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                child: Text("Sets",
                    style: TextStyle(fontWeight: FontWeight.bold))),
          ),
          Expanded(
              flex: 1,
              child: Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                  child: Text("XP",
                      style: TextStyle(fontWeight: FontWeight.bold))))
        ],
      )
    ];
    _exercises.forEach((exercise) => {
          exercises.add(Row(
            children: <Widget>[
              Expanded(
                  flex: 2,
                  child: Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                      child: Column(children: [Text(exercise["name"])]))),
              Expanded(
                  flex: 1,
                  child: Column(children: [
                    Text(exercise["sets"].toString() +
                        "x" +
                        exercise["repetitions"].toString())
                  ])),
              Expanded(
                  flex: 1,
                  child: Column(children: [Text(exercise["XP"].toString())]))
            ],
          ))
        });
    exercises.add(Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
            child: Text("Total XP: $_totalXP"))
      ],
    ));

    return Card(
        child: ExpansionTile(
            title: Text("$_workoutDate: $_workoutType workout"),
            children: exercises));
  }
}

//Text(_workouts[0]["exercises"][0]["XP"].toString());
