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
  final String _workoutID = "";

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

  Widget _buildHistoryItem(BuildContext context, DocumentSnapshot document) {
    return ExpansionTile(
      title: Center(
          child: Text(document["date"].toDate().toString().split(" ")[0])),
      backgroundColor: Color.fromRGBO(33, 40, 56, 0.2),
      children: <Widget>[
        Text(document["workoutType"] + " workout"),
        Container(
            padding: const EdgeInsets.all(8),
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Column(children: <Widget>[
                  Text("Warm Up"),
                  Text("Push ups"),
                  Text("Total XP")
                ]),
                Column(
                  children: <Widget>[
                    Text("5 XP"),
                    Text("10 XP"),
                    Text(document["total_xp"].toString())
                  ],
                )
              ],
            ))
      ],
    ); // Should return a single history item widget
  }
}

// TODO: Trenger en listview for å lage en scrollbar liste med økter
// TODO: Hver økt skal kunne trykkes på for å vise detaljer (eks ExpansionTile)
// TODO: Designet skal stemme overens med figma
// TODO: Dataen som vises skal hentes fra databasen (Stream, Cloud?)
