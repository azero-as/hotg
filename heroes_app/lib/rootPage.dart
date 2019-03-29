import 'package:flutter/material.dart';
import 'login.dart';
import 'dashboard.dart';
import 'authentication.dart';
import 'signup.dart';
import 'frontpage.dart';
import 'signuplevel.dart';
import 'settings.dart';
import 'loadingScreen.dart';
import 'models/user.dart';
import 'models/workout.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'startWorkout.dart';
import 'activeWorkoutSession.dart';
import 'summary.dart';

import './logic/recommendedWorkoutLogic.dart';

class RootPage extends StatefulWidget {
  RootPage({this.auth, this.user});

  final BaseAuth auth;
  final User user;

  @override
  State<StatefulWidget> createState() => new _RootPageState();
}

//Labels to find out if a user is signed in when launching the app
enum AuthStatus {
  NOT_DETERMINED,
  NOT_LOGGED_IN,
  LOGGED_IN,
  READY_TO_LOG_IN,
  READY_TO_SIGN_UP,
  FINISHED_SIGNED_UP,
  READY_TO_SIGN_OUT,
  START_WORKOUT,
  ACTIVE_WORKOUT_SESSION,
  SUMMARY,
  BACK_TO_WORKOUTS,
}

class _RootPageState extends State<RootPage> {
  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;
  String _userId = "";
  String _className = '';
  bool _dataLoadedFromDatabase = false; //if this is null, it is still loading data from firebase.

  @override
  void initState() {
    super.initState();
    widget.auth.getCurrentUser().then((user) {
      if (user != null) {
        new Future.delayed(Duration.zero, () {
          _setUserInfo(context);
        });

        setState(() {
          if (user != null) {
            _userId = user?.uid;
          }
          authStatus = user?.uid == null
              ? AuthStatus.NOT_LOGGED_IN
              : AuthStatus.LOGGED_IN;
        });
      } else {
        setState(() {
          authStatus = AuthStatus.NOT_LOGGED_IN;
        });
      }
    });
  }
  
  void _onLoggedIn() {
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        _userId = user.uid.toString();
      });
      new Future.delayed(Duration.zero, () {
        _setUserInfo(context);
      }); 
    });
    setState(() {
      authStatus = AuthStatus.LOGGED_IN;
    });
  }

  void _alreadyLoggedIn() {
    setState(() {
      authStatus = AuthStatus.LOGGED_IN;
    });
  }

  void _onSignedOut() {
    setState(() {
      authStatus = AuthStatus.NOT_LOGGED_IN;
      _userId = "";
    });
  }

  void _readyToSignOut() {
    setState(() {
      authStatus = AuthStatus.READY_TO_SIGN_OUT;
    });
  }

  void _readyToLogIn() {
    setState(() {
      authStatus = AuthStatus.READY_TO_LOG_IN;
    });
  }

  void _readyToSignUp() {
    setState(() {
      authStatus = AuthStatus.READY_TO_SIGN_UP;
    });
  }

  void _backToWorkout() {
    setState(() {
      authStatus = AuthStatus.BACK_TO_WORKOUTS;
    });
  }

  void _finishedSignedUp() {
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        _userId = user.uid.toString();
      });
    });
    setState(() {
      authStatus = AuthStatus.FINISHED_SIGNED_UP;
    });
  }

  void _startWorkout() {
    setState(() {
      authStatus = AuthStatus.START_WORKOUT;
    });
  }

  void _activeWorkout() {
    setState(() {
      authStatus = AuthStatus.ACTIVE_WORKOUT_SESSION;
    });
  }

  void _summary() {
    setState(() {
      authStatus = AuthStatus.SUMMARY;
    });
  }

  //Sets the start state of the User-model and calls _setWorkoutInfo with the user's class.
  void _setUserInfo(BuildContext context) async {
    print('setUserInfo');
    var user = ScopedModel.of<User>(context);

    try {
      final dynamic resp = await CloudFunctions.instance.call(
        functionName: 'getUserInfo',
        );
        setState(() {
          user.startState(
            resp['characterName'],
            resp['gameLevel'],
            resp['userXp'],
            resp['xpCap'],
            resp['className'],
            resp['email']);
            _className = resp['className'];
        });
        } catch(error) {
          print('getUserInfo error');
          print(error);
        }
        String _convertedClass =convertClassName(_className);
        _setWorkoutInfo(_convertedClass);
        }

  // Requests a workout from the database based on the user's rpg class and
  // creates a workout-model with the data.
  void _setWorkoutInfo(className) async {
    print('setWorkoutInfo');
    var workout = ScopedModel.of<Workout>(context);

    try {
      print(_className);
      final dynamic response = await CloudFunctions.instance.call(
        functionName: 'getRecommendedWorkout',
        parameters: <String, dynamic>{
          'className':className,
        },
      );
      setState(() {
        workout.setIntensity(response['intensity']);
        workout.setWorkOutName(response['workoutName']);
        workout.setWorkOutClass(response['class']);
        workout.setDuration(response['duration']);
        workout.setXp(response['xp']);
        workout.setExercises(response['exercises']);
        workout.setWarmUp(response['warmUp']);
        _dataLoadedFromDatabase = true;
      });  
    } catch (error) {
      print('getRecommendedWorkout error');
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    var workout = ScopedModel.of<Workout>(context);
      switch (authStatus) {
        case AuthStatus.NOT_DETERMINED:
          return new LoadingScreen();
          break;
        case AuthStatus.NOT_LOGGED_IN:
          setState(() {
            _dataLoadedFromDatabase = false;
          });
          workout.setListOfWorkouts(null);
          return FrontPage(
            readyToLogIn: _readyToLogIn,
            readyToSignUp: _readyToSignUp,
          );
        case AuthStatus.READY_TO_LOG_IN:
          return new LoginPage(
            auth: widget.auth,
            onSignedIn: _onLoggedIn,
            readyToSignUp: _readyToSignUp,
            onSignedOut: _onSignedOut,
          );
        case AuthStatus.FINISHED_SIGNED_UP:
          if (_userId.length > 0 && _userId != null) {
            return new SignupLevelPage(
              auth: widget.auth,
              onSignedIn: _onLoggedIn,
              userId: _userId,
              onSignedOut: _onSignedOut,
              title: 'Heroes of the Gym',
            );
          }
          break;
        case AuthStatus.READY_TO_SIGN_UP:
          return new SignupPage(
            auth: widget.auth,
            onSignedIn: _onLoggedIn,
            readyToLogIn: _readyToLogIn,
            onSignedOut: _onSignedOut,
            finishedSignedUp: _finishedSignedUp,
          );
          break;
        case AuthStatus.LOGGED_IN:
          if (_userId.length > 0 && _userId != null && _dataLoadedFromDatabase) {
           
              return new DashboardScreen(
                userId: _userId,
                auth: widget.auth,
                onSignedOut: _onSignedOut,
                readyToSignOut: _readyToSignOut,
                onSignedIn: _onLoggedIn,
                onStartWorkout: _startWorkout,
                onActiveWorkout: _activeWorkout,
                onSummary: _summary,
                index: 0,
              );
          } else {
            return new LoadingScreen();
          }
          break;
        case AuthStatus.READY_TO_SIGN_OUT:
          return new Settings(
            auth: widget.auth,
            onSignedOut: _onSignedOut,
            onSignedIn: _onLoggedIn,
          );
          break;
        case AuthStatus.START_WORKOUT:
          return new StartWorkout(
            exercises: workout.exercises,
            duration: workout.duration,
            intensity: workout.intensity,
            xp: workout.xp,
            workoutName: workout.workoutName,
            workoutClass: workout.workoutClass,
            onLoggedIn: _onLoggedIn,
            onStartWorkout: _startWorkout,
            onActiveWorkout: _activeWorkout,
            onSummary: _summary,
            onBackToWorkout: _backToWorkout,
            alreadyLoggedIn: _alreadyLoggedIn,
          );
          break;
        case AuthStatus.ACTIVE_WORKOUT_SESSION:
          return new activeWorkoutSession(
            exercises: workout.exercises,
            workoutName: workout.workoutName,
            onLoggedIn: _onLoggedIn,
            onStartWorkout: _startWorkout,
            onSummary: _summary,
            );
        case AuthStatus.SUMMARY:
          return new Summary(
            exercises: workout.selectedExercises,
            bonus: workout.BonusXP,
            total_xp: workout.XpEarned,
            workoutType: workout.workoutName,
            onLoggedIn: _onLoggedIn,
            alreadyLoggedIn: _alreadyLoggedIn,
          );
        case AuthStatus.BACK_TO_WORKOUTS:
          if (_userId.length > 0 && _userId != null) {
            return new DashboardScreen(
              userId: _userId,
              auth: widget.auth,
              onSignedOut: _onSignedOut,
              readyToSignOut: _readyToSignOut,
              onSignedIn: _onLoggedIn,
              onStartWorkout: _startWorkout,
              onActiveWorkout: _activeWorkout,
              onSummary: _summary,
              index: 1,
            );
          } else
            return LoadingScreen();
          break;
        default:
          return LoadingScreen();
      }
  }
}