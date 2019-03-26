import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';

class Summary extends StatefulWidget {

  final List<dynamic> exercises;
  final int bonus;
  final int total_xp;
  final String workoutType;

  Summary({this.exercises, this.bonus, this.total_xp, this.workoutType});

  @override
  State createState() => new _SummaryState();
}

class _SummaryState extends State<Summary> {

  @override
  Widget build(BuildContext context) {
    print(widget.exercises);

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

  Widget _buildListHeader() {
    return Container(
        child: ListTile(
      title: Text(
        widget.workoutType,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    ));
  }

  Widget _buildScore() {
    return Column(
      children: <Widget>[
        ListTile(
          title: Text("Bonus: ", style: TextStyle(fontSize: 22)),
          trailing: Text(widget.bonus.toString() + " xp",
              style: TextStyle(fontSize: 22)),
          contentPadding:
              EdgeInsetsDirectional.only(top: 10.0, start: 70.0, end: 70.0),
        ),
        ListTile(
          title: Text("Total: ",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          trailing: Text(widget.total_xp.toString() + " xp",
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
            itemCount: widget.exercises.length,
            itemBuilder: (context, index) {
              return _buildExerciseListItem(
                  context, widget.exercises[index]);
            }));
  }

  Widget _buildWorkoutCard() {
    var appScreenHeight = MediaQuery.of(context).size.height;
      return Card(
          elevation: 2.0,
          child: Column(children: <Widget>[
            _buildListHeader(),
            Container(
              height: appScreenHeight * 0.45,
              child: _buildExerciseList(),
            ),
            Divider(color: Colors.black),
            _buildScore(),
          ]));
    }
  }

