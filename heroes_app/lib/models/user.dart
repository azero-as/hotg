import 'package:scoped_model/scoped_model.dart';
import '../authentication.dart';

import 'package:cloud_functions/cloud_functions.dart';

class User extends Model {

  Auth auth = new Auth();

  int _xpCap = 0;
  int _xp = 0;
  int _level = 1;
  String _characterName = '';

  int get xpCap => _xpCap;
  int get xp => _xp;
  int get level => _level;
  String get characterName => _characterName;

  void startState(String username, int userLevel, int userXp, int xpCap) {
    _characterName = username;
    _level = userLevel;
    _xp = userXp;
    _xpCap = xpCap;
    notifyListeners();
  }
  //Methods just for setting in the beginning
  setLevel(int number) {
    this._level = number;
  }

  setXpCap(int number) {
    this._xpCap = number;
  }

  void setXP(int number) {
    this._xp = number;
  }

  void setCharacterName(String name) {
    this._characterName = name;
  }

  // Methods used by other widgets:
  void incrementXP(int number) {
    this._xp = this.xp + number;
    notifyListeners();
    //TODO: Also change value in database
  }

  void changeXPtoZeroPlusNumber(int number) {
    this._xp = number;
    notifyListeners();
    //TODO: Also change value in database
  }

  void incrementLevelByOne() {
    this._level = this._level + 1;
    notifyListeners();
    //TODO: Also change value in database
  }


}