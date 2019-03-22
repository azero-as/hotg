import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:heroes_app/custom_expansion_tile.dart' as custom;

class History extends StatelessWidget {
  History(this.listType);
  final String listType;

  @override
  Widget build(BuildContext context) {
    return ListOfTrainingSessions();
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
      return Center(child: CircularProgressIndicator());
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

    final List _exercises = workoutObject["exercises"];

    List<Widget> exercises = [
      Row(
        children: <Widget>[
          Expanded(
              flex: 2,
              child: Padding(
                  padding: EdgeInsets.fromLTRB(0, 20, 0, 10),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                            padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                            child: Text(
                              "Exercise",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ))
                      ]))),
          Expanded(
            flex: 1,
            child: Padding(
                padding: EdgeInsets.fromLTRB(0, 20, 0, 10),
                child: Column(children: [
                  Text("Sets", style: TextStyle(fontWeight: FontWeight.bold))
                ])),
          ),
          Expanded(
              flex: 1,
              child: Padding(
                  padding: EdgeInsets.fromLTRB(0, 20, 0, 10),
                  child: Column(children: [
                    Text("XP", style: TextStyle(fontWeight: FontWeight.bold))
                  ])))
        ],
      )
    ];

    Widget _setsRepetitions(exercise) {
      if (exercise["repetitions"] == null) {
        return Expanded(
            flex: 1,
            child: Column(children: [
              Text(exercise["sets"].toString() +
                  "x" +
                  exercise["duration"].toString())
            ]));
      } else {
        return Expanded(
            flex: 1,
            child: Column(children: [
              Text(exercise["sets"].toString() +
                  "x" +
                  exercise["repetitions"].toString())
            ]));
      }
    }

    _exercises.forEach((exercise) => {
          exercises.add(Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                  flex: 2,
                  child: Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                                padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                                child: Text(exercise["name"]))
                          ]))),
              _setsRepetitions(exercise),
              Expanded(
                  flex: 1,
                  child: Column(children: [
                    Text(
                      exercise["xp"].toString(),
                    )
                  ]))
            ],
          ))
        });
    exercises.add(Divider(height: 10.0, color: Colors.black38));
    exercises.add(Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
            padding: EdgeInsets.fromLTRB(0, 15, 0, 20),
            child: Text("Total XP: $_totalXP",
                style: TextStyle(fontWeight: FontWeight.bold)))
      ],
    ));

    return Padding(
        padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
        child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            color: Color(0xFFE7E9ED),
            child: custom.ExpansionTile(
                headerBackgroundColor: Color(0xFF212838),
                title: Text("$_workoutDate: $_workoutType workout",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
                children: exercises)));
  }
}
