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

    List _selectedEcercises = List();

    @override
    Widget build(BuildContext context) {
        //Information about the exercises that is apart of the workout
        void _onCategorySelected(bool selected, id) {
            if (selected == true) {
                setState(() {
                    _selectedEcercises.add(id);
                });
            } else {
                setState(() {
                    _selectedEcercises.remove(id);
                });
            }
        }

        print(widget.exercises);
        Widget _showInformationWorkout(){
            print(widget.exercises[1].documentID);
            return new ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: widget.exercises.length,
                itemBuilder: (BuildContext context, int index) =>
                    ExpansionTile(
                        key: PageStorageKey<int>(index),
                        title:  new CheckboxListTile(
                                value: _selectedEcercises
                                    .contains(widget.exercises[index].documentID),
                                onChanged: (bool selected) {
                                _onCategorySelected(selected,
                                    widget.exercises[index].documentID);
                                },
                                title: Text(widget.exercises[index]["Name"]),
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

        Widget _returnFinishWorkoutButton(){
            return new Padding(
                padding: EdgeInsets.symmetric(horizontal: 0, vertical: 40.0),
                child: RaisedButton(
                    elevation: 5.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                    ),
                    onPressed: () {
                        //Todo: add event handler
                    },
                    padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
                    color: const Color(0xFF58C6DA),
                    child: Text('Finish workout', style: TextStyle(color: Colors.white),),
                ),
            );}

        return new Scaffold(
            appBar: AppBar(actions: <Widget>[
                new Center(
                    child: new Text('Workout',
                        style: new TextStyle(fontSize: 17.0, color: Colors.white)),
                )],),
            body: new Container(
                child: Column(
                    children: <Widget>[
                    Expanded(
                        child: _showInformationWorkout(),
                    ),
                        _returnFinishWorkoutButton(),
                    ],
                )
        ),
        );
    }
}
