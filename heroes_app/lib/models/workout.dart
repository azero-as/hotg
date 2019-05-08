import 'package:scoped_model/scoped_model.dart';
import '../authentication.dart';

class Workout extends Model {
  Auth auth = new Auth();

  // Recommended workout
  String _intensityRw = '';
  String _workoutNameRw = '';
  String _workoutClassRw = '';
  int _fitnessLevelRw = -1;
  int _durationRw = -1;
  int _xpRw = -1;
  List<dynamic> _exercisesRw = [];
  Map _warmUpRw = {};

  int get xpRw => _xpRw;
  String get intensityRw => _intensityRw;
  String get workoutNameRw => _workoutNameRw;
  String get workoutClassRw => _workoutClassRw;
  int get durationRw => _durationRw;
  int get fitnessLevelRw => _fitnessLevelRw;
  List<dynamic> get exercisesRw => _exercisesRw;
  Map get warmUpRw => _warmUpRw;

  // ActiveWorkout
  String _intensity = '';
  String _workoutName = '';
  String _workoutClass = '';
  int _fitnessLevel = -1;
  int _duration = -1;
  int _xp = -1;
  List<dynamic> _exercises = [];
  Map _warmUp = {};

  int get xp => _xp;
  String get intensity => _intensity;
  String get workoutName => _workoutName;
  String get workoutClass => _workoutClass;
  int get duration => _duration;
  int get fitnessLevel => _fitnessLevel;
  List<dynamic> get exercises => _exercises;
  Map get warmUp => _warmUp;

  //Active workout session
  List<dynamic> _selectedExercises =
      []; //Same as exercises in activeWorkoutSession.
  int _XpEarned = 0;
  int _BonusXP = 0;

  List<dynamic> get selectedExercises => _selectedExercises;
  int get XpEarned => _XpEarned;
  int get BonusXP => _BonusXP;

  // Belongs to plan
  List<dynamic> _listOfWorkouts;

  List<dynamic> get listOfWorkouts => _listOfWorkouts;

  //To check whether to go back to home or to plan
  bool isFromHomePage;

  void setListOfWorkouts(List<dynamic> workouts) {
    this._listOfWorkouts = workouts;
    notifyListeners();
  }

  void changeActiveWorkout(List<dynamic> workout, int index) {
    this._xp = workout[index]["xp"];
    this._duration = workout[index]["duration"];
    this._intensity = workout[index]["intensity"];
    this._workoutName = workout[index]["workoutName"];
    this._workoutClass = workout[index]["class"];
    this._exercises = workout[index]["exercises"];
    this._warmUp = workout[index]["warmUp"];
    this._fitnessLevel = workout[index]["fitnessLevel"];
  }

  void setFinishedWorkout(
      List<dynamic> selectedExercises, int XpEarned, int BonusXP) {
    this._selectedExercises = selectedExercises;
    this._XpEarned = XpEarned;
    this._BonusXP = BonusXP;
    notifyListeners();
  }

  void setXpRw(int xp) {
    this._xpRw = xp;
    notifyListeners();
  }

  void setIntensityRw(String intensity) {
    this._intensityRw = intensity;
    notifyListeners();
  }

  void setFitnessLevelRw(int fitnessLevel) {
    this._fitnessLevelRw = fitnessLevel;
    notifyListeners();
  }

  void setWorkOutNameRw(String workoutName) {
    this._workoutNameRw = workoutName;
    notifyListeners();
  }

  void setWarmUpRw(Map warmUp) {
    this._warmUpRw = warmUp;
    notifyListeners();
  }

  void setWorkOutClassRw(String workoutClass) {
    this._workoutClassRw = workoutClass;
    notifyListeners();
  }

  void setDurationRw(int duration) {
    this._durationRw = duration;
    notifyListeners();
  }

  void setExercisesRw(List<dynamic> exercises) {
    this._exercisesRw = exercises;
    notifyListeners();
  }
}
