import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'startWorkout.dart';
import 'package:scoped_model/scoped_model.dart';
import 'models/workout.dart';

class Plan extends StatefulWidget {

    @override
    _PlanPageState createState() => new _PlanPageState();

    Plan({this.onLoggedIn, this.onStartWorkout, this.onActiveWorkout, this.onSummary});

    final VoidCallback onLoggedIn;
    final VoidCallback onStartWorkout;
    final VoidCallback onActiveWorkout;
    final VoidCallback onSummary;

}


class _PlanPageState extends State<Plan> {

  List _workouts = [];

  @override
  void initState(){
    super.initState();

    var workout = ScopedModel.of<Workout>(context);

    CloudFunctions.instance
        .call(
      functionName: 'getAllWorkouts',
    ).then((response) {
      setState(() {
        workout.setListOfWorkouts(response['workoutList']);
      });
    }).catchError((error) {
      print(error);
    });
  }

  @override
    Widget build(BuildContext context) {

    Widget _workout(int index) {
      return new Container(
        // add border for the workout info box
        margin: new EdgeInsets.symmetric(horizontal: 55.0, vertical: 12.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 0.25),
          color: Color(0xFFE7E9ED),
        ),
        child: ScopedModelDescendant<Workout>(builder: (context, child, model) {
          return Column(
          // Text starts on the left, instead of centered as is the default
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            // container for title box
            Container(
              padding: EdgeInsets.all(5),
              // border to distinguish between the two containers within the box
              // Colour for the entire row
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xFF212838), width: 0.15),
                color: Color(0xFF212838),
              ),
              child: Row(
                children: <Widget>[
                  // add some space between left-side border and beginning of text
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                  ),
                  // new container for title
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      child: Text(
                        model.listOfWorkouts[index]["workoutName"],
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // container for changing information
            Container(
              padding: EdgeInsets.all(5),
              // border to distinguish between the two containers within the box
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 0.15),
              ),
              child: Row(
                children: <Widget>[
                  // Column for information declaration
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'XP:',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF434242)),
                        ),
                        // add space between lines
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Intensity:',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF434242)),
                        ),
                        // add space between lines
                        SizedBox(
                          height: 10,
                        ),
                        Icon(
                          Icons.alarm,
                          color: Color(0xFF434242),
                        ),
                      ],
                    ),
                  ),
                  // Column for changing information
                  Expanded(
                    flex: 3,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            model.listOfWorkouts[index]["xp"].toString(),
                            style: TextStyle(color: Color(0xFF434242)),
                          ),
                          // add space between lines
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                              model.listOfWorkouts[index]["intensity"].toString(),
                            style: TextStyle(color: Color(0xFF434242)),
                          ),
                          // add space between lines
                          SizedBox(
                            height: 18,
                          ),
                          Text(
                            model.listOfWorkouts[index]["duration"].toString() + " min",
                            style: TextStyle(color: Color(0xFF434242)),
                          ),
                        ]),
                  ),
                  // Column for button
                  Expanded(
                    flex: 3,
                    child: Column(
                        children: <Widget>[
                          // add space to make the button stay at the bottom of the box
                          SizedBox(
                            height: 50,
                          ),
                          RaisedButton(
                            padding: EdgeInsets.all(10.0),
                            onPressed: () {
                              //TODO: change state in workout to the chosen workout.
                              widget.onStartWorkout();
                            },
                            elevation: 5.0,
                            color: Color(0xFF612A30),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.67),
                            ),
                            child: Text(
                              'See workout',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 13.0),
                            ),
                          ),
                        ],
                      ),
                  ),
                ],
              ),
            ),
          ],
        );
          }),
      );
    }

    Widget _listOfWorkouts() {
      var workout = ScopedModel.of<Workout>(context);
      if(workout.listOfWorkouts.isEmpty){
        return Text("");
      }
      else {
        return new ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: workout.listOfWorkouts.length,
          itemBuilder: (BuildContext context, int index){
            return _workout(index);
            //children: root["info"]
          },
        );
      }
    }

    return Scaffold(
      appBar: new AppBar(
        centerTitle: true ,
        title: new Text("Workouts"),
      ),
      body: _listOfWorkouts(),
    );
  }}
