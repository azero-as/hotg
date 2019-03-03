import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'timer_page.dart';

class activeWorkoutSession extends StatelessWidget {


    final List<dynamic> exercises;
    activeWorkoutSession({this.exercises});

    @override
    Widget build(BuildContext context) {
        //Information about the exercises that is apart of the workout
        Widget _showInformationWorkout(List<dynamic> exercises){
            return new ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: exercises.length,
                itemBuilder: (BuildContext context, int index) =>
                    ExpansionTile(
                        key: PageStorageKey<int>(index),
                        title: Text(exercises[index]["Name"]),
                            children: <Widget>[
                                ListTile(
                                    title: Text("Sets: 1"),
                                ),
                                ListTile(
                                    title: Text("Reps: 10-12"),
                                ),
                                ListTile(
                                    title: Text("XP: " + exercises[index]["XP"].toString()),
                                ),
                            ]
                            //children: root["info"]
                            ),

                        );
             }

        return new Scaffold(
            appBar: AppBar(actions: <Widget>[
                new Center(
                    child: new Text('Workout',
                        style: new TextStyle(fontSize: 17.0, color: Colors.white)),
                )],),
            body: new Container(
                child: _showInformationWorkout(exercises),
        ),
        );
    }
}
