import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'activeWorkoutSession.dart';

class StartWorkout extends StatefulWidget {
  final List exercises;
  final int duration;
  final String intensity;
  final int xp;
  final String workoutName;
  final VoidCallback onLoggedIn;

  StartWorkout({this.exercises, this.duration, this.intensity, this.xp, this.workoutName, this.onLoggedIn});

  @override
  _StartWorkoutPage createState() => new _StartWorkoutPage();
}

class _StartWorkoutPage extends State<StartWorkout> {
  @override
  Widget build(BuildContext context) {
    Widget _returnStartWorkoutButton() {
      return new Padding(
        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0.0),
        child: RaisedButton(
          elevation: 5.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) =>
                        activeWorkoutSession(exercises: widget.exercises, workoutName: widget.workoutName)));
          },
          padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
          color: const Color(0xFF212838),
          child: Text(
            'Start workout',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }

    //Information about workout
    Widget _showInfo() {
      return Container(
          margin: EdgeInsets.fromLTRB(100, 0, 100, 40),
          child: RichText(
              text: new TextSpan(
                  style: new TextStyle(
                    fontSize: 14.0,
                    color: Colors.black,
                  ),
                  children: <TextSpan>[
                new TextSpan(
                    text: 'Duration: ',
                    style: new TextStyle(fontWeight: FontWeight.bold)),
                new TextSpan(text: widget.duration.toString() + " min"),
                new TextSpan(
                    text: ' XP: ',
                    style: new TextStyle(fontWeight: FontWeight.bold)),
                new TextSpan(text: widget.xp.toString() + ' \n\n'),
                new TextSpan(
                    text: 'Intensity: ',
                    style: new TextStyle(fontWeight: FontWeight.bold)),
                new TextSpan(text: widget.intensity.toString()),
              ])));
    }

    Widget _showInformationWorkout() {
      return new ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: widget.exercises.length,
        itemBuilder: (BuildContext context, int index) => ExpansionTile(
                key: PageStorageKey<int>(index),
                title: new Text(
                  (widget.exercises[index]["name"]),
                ),
                children: <Widget>[
                  ListTile(
                      title: new Text(
                          "Sets: " + widget.exercises[index]["targetSets"])),
                  ListTile(
                      title: new Text(
                          "Reps: " + widget.exercises[index]["targetReps"])),
                  ListTile(
                      title: new Text("Rest between sets: " +
                          widget.exercises[index]["restBetweenSets"])),
                  ListTile(
                      title: new Text(
                          "XP: " + widget.exercises[index]["xp"].toString())),
                ]
                //children: root["info"]
                ),
      );
    }

    Widget _returnBody() {
      return new Container(
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          margin: EdgeInsets.fromLTRB(0, 50, 0, 35),
          child: Column(
            children: <Widget>[
              Container(
                child: _showInfo(),
              ),
              Expanded(
                child: _showInformationWorkout(),
              ),
              _returnStartWorkoutButton(),
            ],
          ));
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            widget.onLoggedIn();
          },
          color: Colors.white,
        ),
      ),
      body: Container(
        child: _returnBody(),
      ),
    );
  }
}
