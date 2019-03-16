import 'dart:async';

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
  @override
  void initState() {
    super.initState();
  }

// ============ Firestore calls ============

  // Requests all completed workouts by the user from the database
  Future _getWorkouts(String userID) async {
    var firestore = Firestore.instance;
    QuerySnapshot qn = await firestore
        .collection("Users")
        .document(userID)
        .collection("Workouts")
        .getDocuments();
    return qn.documents;
  }

  // Requests all exercises belonging to one completed workout
  Future _getExercises(String workoutID, String userID) async {
    var firestore = Firestore.instance;
    QuerySnapshot qn = await firestore
        .collection("Users")
        .document(userID)
        .collection("Workouts")
        .document(workoutID)
        .collection("Exercises")
        .getDocuments();
    return qn.documents;
  }

// ============ End Firestore calls ============

// ============ Gui build ============

// Builds complete history page

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getWorkouts("TkDkU5X55RG9rNjSb6Fn"),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        }
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Text("Should be a waiting screen");
          default:
            return ListView.builder(
                // Loops through every workout
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return _singleWorkoutItemBuilder(
                      context, snapshot.data[index]);
                });
        }
      },
    );
  }

// The Gui for one workout tile

  Widget _singleWorkoutItemBuilder(
      BuildContext context, DocumentSnapshot workoutDocument) {
    final String _workoutDocumentID =
        workoutDocument.documentID; //Current workout ID used for firestore call
    final String _workoutDate = workoutDocument["date"]
        .toDate()
        .toString()
        .split(" ")[0]; //Workout date of the current workout
    final _workoutType = workoutDocument[
        "workoutType"]; //The workout type of the current workout
    return _fetchWorkoutItemContent(
        _workoutDocumentID, _workoutDate, _workoutType);
  }

  Widget _fetchWorkoutItemContent(workoutID, workoutDate, workoutType) {
    Widget _exerciseList = FutureBuilder(
      future: _getExercises(workoutID, "TkDkU5X55RG9rNjSb6Fn"),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        }
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Text("Waiting for exercises to load");
          default:
            return _createWorkoutItemContent(
                workoutDate,
                workoutType,
                snapshot
                    .data); // Should return the whole workout tile with exercises.
        }
      },
    );
    return _exerciseList;
  }

  // Somehow need to loop through the list of exercises.
  Widget _createWorkoutItemContent(String workoutDate, String workoutType,
      List<DocumentSnapshot> exercisesSnapshotList) {
    List<Row> _widgetListExercises = [];
    for (var index = 0; index < exercisesSnapshotList.length; index++) {
      DocumentSnapshot _currentExercise = exercisesSnapshotList[index];
      Row _oneExercise = Row(
        children: <Widget>[
          Expanded(
            child: Text(_currentExercise["name"]),
          ),
          Expanded(
              child: Text(
            _currentExercise["XP"].toString() + " XP",
          ))
        ],
      );
      _widgetListExercises.add(_oneExercise);
    }
    return ExpansionTile(
      title: Text(workoutDate + ": " + workoutType),
      children: _widgetListExercises,
    );
  }
}
