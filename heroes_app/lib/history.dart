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
      future: Firestore.instance
          .collection("Users")
          .document("TkDkU5X55RG9rNjSb6Fn")
          .collection("Workouts")
          .getDocuments(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return ListView.builder(
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, index) {
                return _buildHistoryItem(
                    context, snapshot.data.documents[index]);
              });
        } else {
          return Text("Loading...");
        }
      },
    );
  }

  Future getExercises(exerciseID) async {
    var firestore = Firestore.instance;
    QuerySnapshot qn = await firestore
        .collection("Users")
        .document("TkDkU5X55RG9rNjSb6Fn")
        .collection("Workouts")
        .document(exerciseID)
        .collection("Exercises")
        .getDocuments();
    return qn.documents;
  }

  Widget _buildHistoryItem(
      BuildContext context, DocumentSnapshot workoutsDocument) {
    final String _exerciseDocumentID = workoutsDocument.documentID;
    final String workoutDate =
        workoutsDocument["date"].toDate().toString().split(" ")[0];
    final workoutType = workoutsDocument["workoutType"];

    return Container(
        child: FutureBuilder(
            future: getExercises(
                _exerciseDocumentID), // Fetches all exercises in the Exercise collection
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                // Liste med DocumentSnapshots
                return ExpansionTile(
                  title: Center(child: Text(workoutDate)),
                  backgroundColor: Color.fromRGBO(33, 40, 56, 0.2),
                  children: <Widget>[
                    //Må loope gjennom values i en exercise og legge hver value
                    Text("$workoutType workout"),
                    Container(
                        padding: const EdgeInsets.all(8),
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: snapshot.data
                              .map((document) => {
                                    print(document["name"]),
                                    Column(
                                      children: <Widget>[
                                        Text(document["name"])
                                      ],
                                    ),
                                    Column(children: <Widget>[
                                      Text(document["XP"].toString())
                                    ])
                                  })
                              .toList(),
                        ))
                  ],
                );
              } else {
                return Text("Loading...");
              }
            }));
  }
}
