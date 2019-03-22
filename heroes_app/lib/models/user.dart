import 'package:scoped_model/scoped_model.dart';
import '../authentication.dart';

class User extends Model {

  Auth auth = new Auth();

  int _xpCap = 1;
  int _xp = 0;
  int _level;
  String _characterName;
  String _className;

  int get xpCap => _xpCap;
  int get xp => _xp;
  int get level => _level;
  String get characterName => _characterName;
  String get className => _className;

  void startState(String username, int userLevel, int userXp, int xpCap, String className) {
    _characterName = username;
    _level = userLevel;
    _xp = userXp;
    _xpCap = xpCap;
    _className =className;
    notifyListeners();
  }
  //Methods just for setting in the beginning
  setLevel(int number) {
    this._level = number;
    notifyListeners();
  }

  setXpCap(int number) {
    this._xpCap = number;
    notifyListeners();
  }

  void setCharacterName(String name) {
    this._characterName = name;
    notifyListeners();
  }

  void setClassName(String className) {
    this._className =_className;
    notifyListeners();
  }

  // Methods used by other widgets:
  void incrementXP(int number) {
    this._xp = this.xp + number;
    notifyListeners();
    //TODO: Also change value in database
  }

  void incrementLevelByOne() {
    this._level = this._level + 1;
    notifyListeners();
    //TODO: Also change value in database
    //TODO: Make the pop up appear?
  }



}