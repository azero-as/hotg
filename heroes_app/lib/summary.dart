import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';

class Summary extends StatefulWidget {
  @override
  State createState() => new _SummaryState();
}

class _SummaryState extends State<Summary> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          leading: new IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                // TO-DO: Add navigation back to home page
              }),
          title: Text(
            "Summary",
            style: TextStyle(fontSize: 22),
          ),
          centerTitle: true,
        ),
        body: Center(
            child: Column(
          children: <Widget>[
            Container(
              // set heigth of container to be 80% of screen height
              height: MediaQuery.of(context).size.height * 0.85,
              padding: EdgeInsets.only(
                  right: 20.0, left: 20.0, top: 30.0, bottom: 30.0),
              child: _buildWorkoutCard(),
            )
          ],
        )));
  }

  Widget _buildExerciseListItem(BuildContext context, exercise) {
    return ListTile(
      title: Text(exercise["name"], style: TextStyle(fontSize: 18)),
      trailing: Text(exercise["xp"].toString() + " xp",
          style: TextStyle(fontSize: 18)),
      contentPadding: EdgeInsetsDirectional.only(start: 40.0, end: 40.0),
    );
  }

  Widget _buildListHeader(BuildContext context, workouts) {
    return Container(
        child: ListTile(
      title: Text(
        workouts[0]['workoutType'] + " Workout",
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    ));
  }

  Widget _buildScore(BuildContext context, workout) {
    return Column(
      children: <Widget>[
        ListTile(
          title: Text("Bonus: ", style: TextStyle(fontSize: 22)),
          trailing: Text(workout[0]["bonus_xp"].toString() + " xp",
              style: TextStyle(fontSize: 22)),
          contentPadding:
              EdgeInsetsDirectional.only(top: 10.0, start: 70.0, end: 70.0),
        ),
        ListTile(
          title: Text("Total: ",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          trailing: Text(workout[0]["total_xp"].toString() + " xp",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          contentPadding: EdgeInsetsDirectional.only(start: 70.0, end: 70.0),
        ),
      ],
    );
  }

  Widget _buildExerciseList() {
    return new Scrollbar(
        child: ListView.builder(
            //spacing between items
            itemExtent: 45.0,
            itemCount: _workouts[0]['exercises'].length,
            itemBuilder: (context, index) {
              return _buildExerciseListItem(
                  context, _workouts[0]['exercises'][index]);
            }));
  }

  Widget _buildWorkoutCard() {
    var appScreenHeight = MediaQuery.of(context).size.height;
    if (_workouts.length == 0) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return Card(
          elevation: 2.0,
          child: Column(children: <Widget>[
            _buildListHeader(context, _workouts),
            Container(
              height: appScreenHeight * 0.45,
              child: _buildExerciseList(),
            ),
            Divider(color: Colors.black),
            _buildScore(context, _workouts),
          ]));
    }
  }
}
