import 'package:scoped_model/scoped_model.dart';
import 'package:cloud_functions/cloud_functions.dart';
import '../authentication.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_storage/firebase_storage.dart';

class User extends Model {
  Auth auth = new Auth();

  int _xpCap = 1;
  int _xp = 0;
  int _gameLevel;
  int _fitnessLevel;
  String _characterName;
  String _className;
  bool _levelUp = false;
  String _email;
  String _imageUrl = '';

  // History page
  List _workouts = [];
  bool _noWorkoutCompleted;

  int get xpCap => _xpCap;
  int get xp => _xp;
  int get gameLevel => _gameLevel;
  int get fitnessLevel => _fitnessLevel;
  String get characterName => _characterName;
  String get className => _className;
  bool get levelUp => _levelUp;
  String get email => _email;
  String get imageUrl => _imageUrl;

  //History page
  List get workouts => _workouts;
  bool get noWorkoutCompleted => _noWorkoutCompleted;

  void startState(String characterName, int gameLevel, int userXp, int xpCap,
      String className, String email, int fitnessLevel) {
    _characterName = characterName;
    _gameLevel = gameLevel;
    _xp = userXp;
    _xpCap = xpCap;
    _className = className;
    _email = email;
    _fitnessLevel = fitnessLevel;
    notifyListeners();
  }

  //Methods just for setting in the beginning
  setLevel(int number) {
    this._gameLevel = number;
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
    this._className = _className;
    notifyListeners();
  }

  void setWorkouts(List workouts) {
    this._workouts = workouts;
    notifyListeners();
  }

  void setNoWorkoutCompleted(bool status) {
    this._noWorkoutCompleted = status;
    notifyListeners();
  }

  // Methods used by other widgets:
  void incrementXP(int xpEarned) async {
    await CloudFunctions.instance
        .call(functionName: 'updateUserXp', parameters: {
      "xpEarned": xpEarned,
    }).then((response) {
      setXP(response['updatedXp']);
    }).catchError((error) {
      print(error);
    });
    await checkLevelUp();

    notifyListeners();
  }

  void incrementLevelByOne() async {
    await CloudFunctions.instance
        .call(functionName: 'updateUserLevelInfo', parameters: {
      "xp": xp,
      "xpCap": xpCap,
      "level": gameLevel,
    }).then((response) {
      setLevel(response['gameLevel']);
      setXP(response['userXp']);
      setXpCap(response['xpCap']);
    }).catchError((error) {
      print(error);
    });

    notifyListeners();
  }

  checkLevelUp() {
    if (xp >= xpCap) {
      incrementLevelByOne();
      setLevelUpTrue();
    }
  }

//page controller for navigation bar
  PageController _pageController;
  int _page = 0;

  PageController get pageController => _pageController;
  int get page => _page;

  setPageController(PageController pageController) {
    this._pageController = pageController;
    notifyListeners();
  }

  void navigationTapped(int page) {
    pageController.jumpToPage(page);
    notifyListeners();
  }

  void dispose() {
    //var user = ScopedModel.of<User>(context);
    //super.dispose();
    this._pageController.dispose();
    notifyListeners();
  }

  setPage(int page) {
    this._page = page;
    notifyListeners();
  }

  void setLevelUpTrue() {
    this._levelUp = true;
    notifyListeners();
  }

  void setEmail(String email) {
    this._email = this._email;
    notifyListeners();
  }

  void setLevelUpFalse() {
    this._levelUp = false;
    notifyListeners();
  }

    // Get ImageUrl based on className.
  void setImageUrl() async {
    String imageUrl = _className + '.png'; 

    StorageReference ref = FirebaseStorage.instance.ref().child(imageUrl);
    String location = await ref.getDownloadURL();
    this._imageUrl = location;
    //TODO: remove print
    print('ImageUrl: '+imageUrl);
    notifyListeners();
  }

  void setFitnessLevel(int fitnessLevel) {
    this._fitnessLevel = fitnessLevel;
    notifyListeners();
  }
}
