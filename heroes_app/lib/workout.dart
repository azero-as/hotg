
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'models/workout.dart';
import 'models/user.dart';

// Create state for workout overview
class WorkoutOverview2 extends StatefulWidget {

  final int index;

  const WorkoutOverview2({Key key, this.onStartWorkout, this.onActiveWorkout, this.onSummary, this.isFromHomePage, @required this.index}): super(key: key);

  @override
  _WorkoutOverviewState2 createState() => _WorkoutOverviewState2();

  final VoidCallback onStartWorkout;
  final VoidCallback onActiveWorkout;
  final VoidCallback onSummary;
  final bool isFromHomePage;

}

// Class for workout overview
class _WorkoutOverviewState2 extends State<WorkoutOverview2> {


  @override
  void initState() {
    super.initState();
  }

// ============ Widget build for information ============


  // Making a widget for sized box
  Widget _space(double height){
    return SizedBox(
      height: height,
    );
  }


  @override
  Widget build(BuildContext context) {

  // Workout title container
  Widget _workoutTitle() {
    var workoutModel = ScopedModel.of<Workout>(context);
    String workoutName = workoutModel.workoutName.toString();
    if(!widget.isFromHomePage){

      workoutName = workoutModel.listOfWorkouts[widget.index]["workoutName"];
    }
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        // Border radius to round top edges
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8.0),
            topRight: Radius.circular(8.0)
        ),
        color: Theme.of(context).accentColor,
      ),
      child: Row(
        children: <Widget>[
          Container(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                workoutName,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Column with workout information declaration
  Widget _declareInformation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Class:',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF434242)),
        ),
        _space(10),
        Text(
          'Fitness Level:',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF434242)),
        ),
        _space(10),
        Text(
          'XP:',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF434242)),
        ),
        _space(10),
        Text(
          'Intensity:',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF434242)),
        ),
        _space(10),
        Icon(
          Icons.alarm,
          color: Color(0xFF434242),
        ),
      ],
    );
  }

  // Column with workout information from database
  Widget _workoutVariables() {
    var workoutModel = ScopedModel.of<Workout>(context);
    print(workoutModel.listOfWorkouts[0]);
    if(widget.isFromHomePage){
      return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              workoutModel.workoutClass.toString(),
              style: TextStyle(color: Color(0xFF434242)),
            ),
            _space(10),
            Text(
              workoutModel.fitnessLevel.toString(),
              style: TextStyle(color: Color(0xFF434242)),
            ),
            _space(10),
            Text(
              workoutModel.xp.toString(),
              style: TextStyle(color: Color(0xFF434242)),
            ),
            // add space between lines
            _space(10),
            Text(
              workoutModel.intensity.toString(),
              style: TextStyle(color: Color(0xFF434242)),
            ),
            // add space between lines
            _space(18),
            Text(
              workoutModel.intensity.toString() + ' min',
              style: TextStyle(color: Color(0xFF434242)),
            ),
          ]
      );
   }
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            workoutModel.listOfWorkouts[widget.index]["class"].toString(),
            style: TextStyle(color: Color(0xFF434242)),
          ),
          _space(10),
          Text(
            workoutModel.listOfWorkouts[widget.index]["fitnessLevel"].toString(),
            style: TextStyle(color: Color(0xFF434242)),
          ),
          _space(10),
          Text(
            workoutModel.listOfWorkouts[widget.index]["xp"].toString(),
            style: TextStyle(color: Color(0xFF434242)),
          ),
          // add space between lines
          _space(10),
          Text(
            workoutModel.listOfWorkouts[widget.index]["intensity"].toString(),
            style: TextStyle(color: Color(0xFF434242)),
          ),
          // add space between lines
          _space(18),
          Text(
            workoutModel.listOfWorkouts[widget.index]["duration"].toString()  + ' min',
            style: TextStyle(color: Color(0xFF434242)),
          ),
        ]
    );
  }

// ============ Widget assembly of information ============

  // Assemble workout information in one container
  Widget _workoutInformation() {
    return Container(
      padding: EdgeInsets.all(15),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 6,
            child: _declareInformation(),
          ),
          Expanded(
            flex: 6,
            child: _workoutVariables(),
          ),
        ],
      ),
    );
  }

  // Build workout card
  Widget _workoutCard() {
    return new Container(
        decoration: BoxDecoration(
          // Border radius to round bottom edges
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
          color: Color(0xFFE7E9ED),
        ),
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _workoutTitle(),
            _workoutInformation()
          ],
        )
    );
  }

    return LayoutBuilder(builder: (context, constraints) {
      // Check that the database has registered workouts compliant of
        return Container(
          // Make sure the placement is centered
            padding: EdgeInsets.fromLTRB(40, 10, 40, 0),
            child: Column(
              children: <Widget>[
                // Call on workout widget
                _workoutCard(),
              ],
            )
        );

    });
  }
}