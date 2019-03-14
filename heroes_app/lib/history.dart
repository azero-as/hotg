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
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //TODO: Should return a ListView with training sessions

    return FutureBuilder(
      future: _getWorkouts("TkDkU5X55RG9rNjSb6Fn"),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                return _buildHistoryItem(context, snapshot.data[index]);
              });
        } else {
          return Text("Loading...");
        }
      },
    );
  }

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

  Widget _buildHistoryItem(
      BuildContext context, DocumentSnapshot workoutDocument) {
    final String _workoutDocumentID = workoutDocument.documentID;
    final String workoutDate =
        workoutDocument["date"].toDate().toString().split(" ")[0];
    final workoutType = workoutDocument["workoutType"];

    return Container(
        child: FutureBuilder(
            future: _getExercises(_workoutDocumentID,
                "TkDkU5X55RG9rNjSb6Fn"), // Fetches all exercises in the Exercise collection
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                // Liste med DocumentSnapshots
                return _buildSingleWorkoutTile(
                    workoutDate, workoutType, snapshot.data[0]);
              } else {
                return Text("Loading...");
              }
            }));
  }

  Widget _buildSingleWorkoutTile(
      String workoutDate, String workoutType, DocumentSnapshot exerciseData) {
    return ExpansionTile(
        title: Center(
          child: Text(workoutDate),
        ),
        backgroundColor: Color.fromRGBO(33, 40, 56, 0.2),
        children: <Widget>[
          Text("$workoutType workout"),
          Container(
              padding: const EdgeInsets.all(8),
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[Text(exerciseData["name"])],
              ))
        ]);
  }
}

/*
snapshot.data.map((document) => {
                                    print(document["name"]),
                                    Column(
                                      children: <Widget>[
                                        Text(document["name"])
                                      ],
                                    ),
                                    Column(children: <Widget>[
                                      Text(document["XP"].toString())
                                    ])
                                  })*/
