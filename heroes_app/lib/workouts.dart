import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:scoped_model/scoped_model.dart';
import 'models/workout.dart';
import 'models/user.dart';
import 'workout.dart';

class Workouts extends StatefulWidget {
  @override
  _WorkoutsPageState createState() => new _WorkoutsPageState();

  Workouts(
    {this.onLoggedIn,
      this.onStartWorkout,
      this.onActiveWorkout,
      this.onSummary});

  final VoidCallback onLoggedIn;
  final VoidCallback onStartWorkout;
  final VoidCallback onActiveWorkout;
  final VoidCallback onSummary;
}

class _WorkoutsPageState extends State<Workouts> {
  bool _dataLoadedFromFireBase = false; //if this is null, it is still loading data from firebase.

  @override
  void initState() {
    super.initState();

    var workout = ScopedModel.of<Workout>(context);

    if (workout.listOfWorkouts != null) {
      _dataLoadedFromFireBase = true;
    }
    CloudFunctions.instance.call(
      functionName: 'getAllWorkouts',
    )
      .then((response) {
      if (this.mounted) {
        workout.setListOfWorkouts(response['workoutList']);
        setState(() {
          _dataLoadedFromFireBase = true;
        });
      }
    }).catchError((error) {
      print(error);
    });
  }


  @override
  Widget build(BuildContext context) {
    Widget _buildWaitingScreen() {
      return Scaffold(
        body: Container(
          alignment: Alignment.center,
          child: CircularProgressIndicator(),
        ),
      );
    }


    // Make the entire workout card clickable
    Widget _workout(int index) {
      var workoutModel = ScopedModel.of<Workout>(context);
      return new GestureDetector(
        onTap: (){
          workoutModel.isFromHomePage = false;
          workoutModel.changeActiveWorkout(workoutModel.listOfWorkouts, index);
          widget.onStartWorkout();
        },
        child: WorkoutOverview2(
          onStartWorkout: widget.onStartWorkout,
          onActiveWorkout: widget.onActiveWorkout,
          onSummary: widget.onSummary,
          isFromHomePage: false,
          index: index,
        ),
      );
    }

    Widget _listOfWorkouts() {
      var workout = ScopedModel.of<Workout>(context);
      if (workout.listOfWorkouts.isEmpty) {
        return Text("");
      } else {
        return new ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: workout.listOfWorkouts.length,
          itemBuilder: (BuildContext context, int index){
            return _workout(index);
          },
        );
      }
    }

    if (!_dataLoadedFromFireBase) {
      return Scaffold(
        appBar: new AppBar(
          centerTitle: true,
          title: new Text("Workouts"),
        ),
        backgroundColor: Theme.of(context).secondaryHeaderColor,
        body: _buildWaitingScreen(),
      );
    } else {
      return Scaffold(
        appBar: new AppBar(
          centerTitle: true,
          title: new Text("Workouts"),
        ),
        backgroundColor: Theme.of(context).secondaryHeaderColor,
        body: _listOfWorkouts(),
      );
    }
  }
}