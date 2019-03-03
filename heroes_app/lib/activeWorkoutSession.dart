import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'timer_page.dart';

class activeWorkoutSession extends StatefulWidget{

    final List<dynamic> exercises;
    activeWorkoutSession({this.exercises});

    @override

    _activeWorkoutSession createState() => new _activeWorkoutSession();


}

class _activeWorkoutSession extends State<activeWorkoutSession> {

    bool _value1 = false;
    bool _value2 = false;

    void _value1Changed(bool value) => setState(() => _value1 = value);
    void _value2Changed(bool value) => setState(() => _value2 = value);



    @override
    Widget build(BuildContext context) {
        //Information about the exercises that is apart of the workout
        print(widget.exercises);
        Widget _showInformationWorkout(){
            return new ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: widget.exercises.length,
                itemBuilder: (BuildContext context, int index) =>
                    ExpansionTile(
                        key: PageStorageKey<int>(index),
                        title:  new CheckboxListTile(
                            value: _value2,
                            onChanged: _value2Changed,
                            title:  Text(widget.exercises[index]["Name"]),
                            controlAffinity: ListTileControlAffinity.leading,
                            activeColor: Colors.green,
                         ),
                            children: <Widget>[
                                ListTile(
                                    title: Text("Sets: 1"),
                                ),
                                ListTile(
                                    title: Text("Reps: 10-12"),
                                ),
                                ListTile(
                                    title: Text("Rest between sets: 1 min"),
                                ),
                                ListTile(
                                    title: Text("XP: " + widget.exercises[index]["XP"].toString()),
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
                child: _showInformationWorkout(),
        ),
        );
    }
}
