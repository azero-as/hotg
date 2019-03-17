import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'timer_page.dart';
import 'package:cloud_functions/cloud_functions.dart';

class activeWorkoutSession extends StatefulWidget{

    final List<dynamic> exercises;
    activeWorkoutSession({this.exercises});

    @override
    _activeWorkoutSession createState() => new _activeWorkoutSession();
}

class _activeWorkoutSession extends State<activeWorkoutSession> {

    List _selectedExercises = [];
    int _XpEarned = 0;
    int _BonusXP = 1;
    var _test;

    @override
    Widget build(BuildContext context) {
        //Information about the exercises that is apart of the workout
        void _onCategorySelected(bool selected, id, xp) {
            print(xp);
            print(widget.exercises[0]);

            if (selected == true) {
                setState(() {
                    _selectedExercises.add(id);
                    _XpEarned += xp;
                });
            } else {
                setState(() {
                    _selectedExercises.remove(id);
                    _XpEarned -= xp;
                    _BonusXP = 0;
                });
            }
        }

        Widget _showInformationWorkout(){
            return new ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: widget.exercises.length,
                itemBuilder: (BuildContext context, int index) =>
                    ExpansionTile(
                        key: PageStorageKey<int>(index),
                        title:  new CheckboxListTile(
                                value: _selectedExercises
                                    .contains(widget.exercises[index].documentID),
                                onChanged: (bool selected) {
                                _onCategorySelected(selected,
                                    widget.exercises[index].documentID, widget.exercises[index]["XP"]);
                                },
                                title: Text(widget.exercises[index]["name"]),
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
        void _calculateXp(){
                var date = new DateTime.now().millisecondsSinceEpoch;
                print("date:$date");
                print(date);
               // CloudFunctions.instance.call(
                 // functionName: 'getExercises',

                //).then((response) {
                //  print(response);
                //     print(response["exercises"]);
                /**  print(response["exercises"][0]);
                  print(response["exercises"][0]["name"]);

                }).catchError((error) {
                  print(error);
                  print("error");
                });**/
                CloudFunctions.instance.call(
                    functionName: 'addWorkout',
                    parameters: {
                        //TODO: add correct bonus xp
                        "bonus_xp": _BonusXP,
                        "total_xp": _XpEarned,
                        "date": date,
                        "workoutType": "Full-body workout"
                    }
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
                        _calculateXp();
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
