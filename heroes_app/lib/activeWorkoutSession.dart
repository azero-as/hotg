import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'timer_page.dart';

class activeWorkoutSession extends StatelessWidget {


    final String workouts;
    activeWorkoutSession({this.workouts});

    @override
    Widget build(BuildContext context) {
        print("testttgfg");
        return new Scaffold(
            appBar: AppBar(actions: <Widget>[
                new Center(
                    child: new Text('Workout',
                        style: new TextStyle(fontSize: 17.0, color: Colors.white)),
                )],),
            body: new Container(
                child: Text(
                'Workout',
                style: TextStyle(fontSize: 32.0, color: Colors.black),
            )
        ),
        );
    }
}
