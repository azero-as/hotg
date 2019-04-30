import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:scoped_model/scoped_model.dart';
import 'models/workout.dart';
import 'workoutCard.dart';
import 'models/user.dart';

class WorkoutList extends StatefulWidget {
  @override
  _WorkoutListState createState() => new _WorkoutListState();

  WorkoutList(
    {this.onLoggedIn,
      this.onStartWorkout,
      this.onActiveWorkout,
      this.onSummary});

  final VoidCallback onLoggedIn;
  final VoidCallback onStartWorkout;
  final VoidCallback onActiveWorkout;
  final VoidCallback onSummary;
}

class _WorkoutListState extends State<WorkoutList> {
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



    //Builds a waiting screen when the data is not yet loaded
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
      var workout = ScopedModel.of<Workout>(context);
      var user = ScopedModel.of<User>(context);

      if(workout.listOfWorkouts[index]["intensity"] == "" ||
          workout.listOfWorkouts[index]["workoutName"] == "" ||
          workout.listOfWorkouts[index]["workoutClass"] == "" ||
          workout.listOfWorkouts[index]["duration"] == -1 ||
          workout.listOfWorkouts[index]["fitnessLevel"] == -1 ||
          workout.listOfWorkouts[index]["xp"] == -1 ||
          workout.listOfWorkouts[index]["exercises"] == null ||
          workout.listOfWorkouts[index]["exercises"] == [] ||
          workout.listOfWorkouts[index]["fitnessLevel"] > user.fitnessLevel) {
          return new Text("");
        };
      return new GestureDetector(
        onTap: (){
          workout.isFromHomePage = false;
          workout.changeActiveWorkout(workout.listOfWorkouts, index);
          widget.onStartWorkout();
        },
        child: WorkoutCard(
          onStartWorkout: widget.onStartWorkout,
          onActiveWorkout: widget.onActiveWorkout,
          onSummary: widget.onSummary,
          isFromHomePage: false,
          index: index,
        ),
      );
    }

    // Creates a list of workout cards
    Widget _listOfWorkouts() {
      var workout = ScopedModel.of<Workout>(context);
      if (workout.listOfWorkouts.isEmpty) {
        return Text("no workouts");
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

  // ============ Return WorkoutList build ============
  @override
  Widget build(BuildContext context) {
    //If the data is not yet loaded from firebase, a waiting screen will appear
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