import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:heroes_app/custom_expansion_tile.dart' as custom;
import 'models/user.dart';
import 'package:scoped_model/scoped_model.dart';

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
  bool _noWorkoutCompleted;

  @override
  void initState() {
    super.initState();
    CloudFunctions.instance
        .call(functionName: 'getAllUserWorkouts')
        .then((response) {
      if (response["workouts"].isEmpty) {
        setState(() {
          _noWorkoutCompleted = true;
        });
      } else {
        setState(() {
          _workouts = response['workouts'];
        });
      }
    }).catchError((error) {
      print(error);
    });
  }

// ============ Gui build ============

// Builds a List View of the workout history.
  @override
  Widget build(BuildContext context) {
    if (_noWorkoutCompleted == true) {
      return ScopedModelDescendant<User>(builder: (context, child, model) {
        return Scaffold(
            backgroundColor: Theme.of(context).secondaryHeaderColor,
            appBar: AppBar(
              centerTitle: true,
              title: Text("Workout History"),
            ),
            body: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                  _noTrainingMessage(model),
                  SizedBox(
                    height: 15,
                  ),
                  _motivationalQuote()
                ])));
      });
    } else if (_workouts.isEmpty) {
      return Center(child: CircularProgressIndicator());
    } else {
      return Scaffold(
          backgroundColor: Theme.of(context).secondaryHeaderColor,
          appBar: AppBar(
            centerTitle: true,
            title: Text("Workout History"),
          ),
          body: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              itemCount: _workouts.length,
              itemBuilder: (context, index) {
                return _workoutCard(context, _workouts[index]);
              }));
    }
  }

  // Conditional build of the empty workout screen

  Widget _noTrainingMessage(userModel) {
    return Column(children: [
      Container(
          child: Text(
        "You haven't done any training yet,",
        style: TextStyle(
            color: Colors.white,
          ),
      ),),
      SizedBox(
        height: 5,
      ),
      Container(
        child: Text("${userModel.characterName.toString()}.",
          style: TextStyle(
          color: Colors.white,
    ),
        ),
      )
    ]);
  }

  Widget _motivationalQuote() {
    return Column(children: [
      Container(
          child: Text(
        "Go to Home or Workouts to begin",
            style: TextStyle(
              color: Colors.white,
            ),
      )),
      SizedBox(
        height: 5,
      ),
      Container(child: Text("your adventure!", style: TextStyle(
        color: Colors.white,
      ),),)
    ]);
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

    // Renders both repetitions and duration in the sets row.
    Widget _showRepsOrDuration(exercise) {
      if (exercise["repetitions"] == null) {
        return Expanded(
            flex: 1,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Padding(
                  padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                  child: Text(exercise["sets"].toString() +
                      "x" +
                      exercise["duration"].toString()))
            ]));
      } else {
        return Expanded(
            flex: 1,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Padding(
                  padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                  child: Text(exercise["sets"].toString() +
                      "x" +
                      exercise["repetitions"].toString()))
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
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                            padding: EdgeInsets.fromLTRB(30, 5, 0, 5),
                            child: Text(
                              exercise["name"],
                            ))
                      ])),
              _showRepsOrDuration(exercise),
              Expanded(
                  flex: 1,
                  child: Column(children: [
                    Padding(
                        padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                        child: Text(
                          exercise["xp"].toString(),
                        ))
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
        padding: EdgeInsets.fromLTRB(30, 5, 30, 0),
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
                headerBackgroundColor: Theme.of(context).accentColor,
                title: Text("$_workoutDate: $_workoutType",
                    style: TextStyle(color: Colors.white)),
                children: _cardContent)));
  }
}
