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
  // Container for every workout registered on the user in the database.
  List _workouts = [];

  @override
  void initState() {
    super.initState();
    CloudFunctions.instance
        .call(functionName: 'getAllUserWorkouts')
        .then((response) {
      setState(() {
        _workouts = response['workouts'];
      });
      
    }).catchError((error) {
      print(error);
    });
  }

// ============ Gui build ============

// Builds a List View of the workout history.
  @override
  Widget build(BuildContext context) {
    if (_workouts.isEmpty) {
      return Center(child: CircularProgressIndicator());
    } else {
      return Scaffold(
          /*appBar: AppBar(
            title: Text("Workout history"),
          ),*/
          body: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              itemCount: _workouts.length,
              itemBuilder: (context, index) {
                return _workoutCard(context, _workouts[index]);
              }));
    }
  }

  // Builds a single workout card.
  Widget _workoutCard(BuildContext context, workoutObject) {
    final String _workoutDate = Timestamp(workoutObject["date"]["_seconds"],
            workoutObject["date"]["_nanoseconds"])
        .toDate()
        .toString()
        .split(" ")[0];
    final String _workoutType = workoutObject["workoutType"];
    final String _totalXP = workoutObject["total_xp"].toString();
    final String _bonusXP = workoutObject["bonus_xp"].toString();
    final List _exercises = workoutObject["exercises"];

    // Container for every row widget in the card.
    List<Widget> _cardContent = [];

    // The top row widget
    Widget _showColumnNames() {
      return Row(
        children: <Widget>[
          Expanded(
              flex: 2,
              child: Padding(
                  padding: EdgeInsets.fromLTRB(10, 20, 0, 10),
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
      );
    }

    // Adds the top row widget as the first element.
    _cardContent.add(_showColumnNames());

    // Reneders both repeitions and duration in the sets row.
    Widget _showRepsOrDuration(exercise) {
      if (exercise["repetitions"] == null) {
        return Expanded(
            flex: 1,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(exercise["sets"].toString() +
                      "x" +
                      exercise["duration"].toString())
                ]));
      } else {
        return Expanded(
            flex: 1,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(exercise["sets"].toString() +
                      "x" +
                      exercise["repetitions"].toString())
                ]));
      }
    }

    // Creates a row widget for each exercise in the workout.
    _exercises.forEach((exercise) => {
          _cardContent.add(Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                  flex: 2,
                  child: Padding(
                      padding: EdgeInsets.fromLTRB(10, 0, 0, 10),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                                padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                                child: Text(exercise["name"]))
                          ]))),
              _showRepsOrDuration(exercise),
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

    // Widget which renders the bonusXP.
    Widget _showBonusXP() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
              padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
              child: Text("Bonus XP: $_bonusXP"))
        ],
      );
    }

    // Adds a divider between the exercises and bonus/totalXP.
    _cardContent.add(Padding(
        padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
        child: Divider(height: 10.0, color: Colors.black38)));

    // Adds the bonusXP widget if there is a bonus.
    if (_bonusXP != "0") {
      _cardContent.add(_showBonusXP());
    }

    // Adds the total xp row.
    _cardContent.add(Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
            padding: EdgeInsets.fromLTRB(0, 15, 0, 20),
            child: Text("Total XP: $_totalXP",
                style: TextStyle(fontWeight: FontWeight.bold)))
      ],
    ));

    // Renders the whole workout card.
    return Padding(
        padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
        child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            color: Color(0xFFE7E9ED),
            child: custom.ExpansionTile(
                headerBackgroundColor: Color(0xFF212838),
                title: Text("$_workoutDate: $_workoutType",
                    style: TextStyle(color: Colors.white)),
                children: _cardContent)));
  }
}
