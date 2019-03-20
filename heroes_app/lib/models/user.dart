import 'package:scoped_model/scoped_model.dart';
import 'package:cloud_functions/cloud_functions.dart';
import '../authentication.dart';

class User extends Model {

  Auth auth = new Auth();

  int _xpCap;
  int _xp;
  int _level;
  String _characterName;

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
    notifyListeners();
  }

  setXP(int number) {
    this._xp = number;
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

  // Methods used by other widgets:
  void incrementXP(int bonus_xp, int total_xp) {
    print("incrementXP");

    CloudFunctions.instance.
        call(
        functionName: 'updateUserXpWorkout',
        parameters: {
          "bonus_xp": bonus_xp,
          "total_xp": total_xp
        }
    )
    .then((response){
      print("Her");
      print(response['updatedXp']);

      setXP(response['updatedXp']);
    }).catchError((error) {
      print(error);
    });

    checkLevelUp();
    notifyListeners();
    //TODO: Also change value in database
  }

  void incrementLevelByOne() {
    print("incrementLevel");
    CloudFunctions.instance.
      call(
        functionName: 'updateUserLevelInfo',
    )
    .then((response){
      setLevel(response['userLevel']);
      setXP(response['userXP']);
      setXpCap(response['xpCap']);

    }).catchError((error) {
      print(error);
    });

    notifyListeners();
    //TODO: Make the pop up appear?
  }

  checkLevelUp(){
    print("checkLevelUp");
    if(this._xp >= this._xpCap){
      incrementLevelByOne();
    }
  }
}