import 'package:scoped_model/scoped_model.dart';
import 'package:cloud_functions/cloud_functions.dart';
import '../authentication.dart';

class User extends Model {

  Auth auth = new Auth();

  int _xpCap = 1;
  int _xp = 0;
  int _level;
  String _characterName;
  String _className;
  bool _levelUp = false;
  String _email;

  int get xpCap => _xpCap;
  int get xp => _xp;
  int get level => _level;
  String get characterName => _characterName;
  String get className => _className;
  bool get levelUp => _levelUp;
  String get email => _email;

  void startState(String username, int userLevel, int userXp, int xpCap, String className, String email) {
    _characterName = username;
    _level = userLevel;
    _xp = userXp;
    _xpCap = xpCap;
    _className =className;
    _email = email;
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

  void setClassName(String className) {
    this._className =_className;
    notifyListeners();
  }

  // Methods used by other widgets:
  void incrementXP(int xpEarned) async {
      await CloudFunctions.instance.
          call(
          functionName: 'updateUserXpWorkout',
          parameters: {
            "xpEarned": xpEarned,
          }
      )
      .then((response){
        setXP(response['updatedXp']);
      }).catchError((error) {
        print(error);
      });
      await checkLevelUp();

      notifyListeners();
  }

  void incrementLevelByOne() async {
    await CloudFunctions.instance.
      call(
        functionName: 'updateUserLevelInfo',
        parameters: {
          "xp": xp,
          "xpCap": xpCap,
          "level": level,
        }
    )
    .then((response){
      setLevel(response['userLevel']);
      setXP(response['userXp']);
      setXpCap(response['xpCap']);

    }).catchError((error) {
      print(error);
    });

    notifyListeners();
  }
  checkLevelUp(){
    if(xp >= xpCap){
      incrementLevelByOne();
      setLevelUpTrue();
    }
  }

    void setEmail(String email) {
    this._email = this._email;
    notifyListeners();
  }

  void setLevelUpTrue() {
    this._levelUp = true;
  }

  void setLevelUpFalse() {
    this._levelUp = false;
  }
}
