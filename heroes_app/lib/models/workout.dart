import 'package:scoped_model/scoped_model.dart';
import '../authentication.dart';

class Workout extends Model {
  Auth auth = new Auth();

  // Belongs to Home
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

  // Belongs to activeWorkoutSession
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

  void setXp(int xp) {
    this._xp = xp;
    notifyListeners();
  }

  void setIntensity(String intensity) {
    this._intensity = intensity;
    notifyListeners();
  }

  void setFitnessLevel(int fitnessLevel) {
    this._fitnessLevel = fitnessLevel;
    notifyListeners();
  }

  void setWorkOutName(String workoutName) {
    this._workoutName = workoutName;
    notifyListeners();
  }

  void setWarmUp(Map warmUp) {
    this._warmUp = warmUp;
    notifyListeners();
  }

  void setWorkOutClass(String workoutClass) {
    this._workoutClass = workoutClass;
    notifyListeners();
  }

  void setDuration(int duration) {
    this._duration = duration;
    notifyListeners();
  }

  void setExercises(List<dynamic> exercises) {
    this._exercises = exercises;
    notifyListeners();
  }
}
