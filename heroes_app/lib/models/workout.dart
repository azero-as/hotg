import 'package:scoped_model/scoped_model.dart';
import '../authentication.dart';

class Workout extends Model {

  Auth auth = new Auth();

  String _intensity = '';
  String _workoutName = '';
  int _duration = -1;
  int _xp = -1;
  List<dynamic> _exercises = [];

  int get xp => _xp;
  String get intensity => _intensity;
  String get workoutName => _workoutName;
  int get duration => _duration;
  List<dynamic> get exercises => _exercises;

  void setXp(int xp) {
    this._xp = xp;
    notifyListeners();
  }

  void setIntensity(String intensity) {
    this._intensity = intensity;
    notifyListeners();
  }

  void setWorkOutName(String workoutName) {
    this._workoutName = workoutName;
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