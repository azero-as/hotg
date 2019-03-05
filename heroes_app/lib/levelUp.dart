import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LevelUp extends StatefulWidget{

  @override
  State<StatefulWidget> createState() => new _LevelUpState();
}

class _LevelUpState extends State<LevelUp>{

  String _uid = "";
  int _userLevel = 0;
  int _userXP = 0;

  var _listUser = [];
  var _listXP = [];
  var _listLevel = [];

  @override
  void initState(){
    super.initState();

    //Get the userID of current user
    FirebaseAuth.instance.currentUser().then((response){
      setState(() {
        _uid = response.uid;
      });
    }).catchError((error){
      print(error);
    });
  }

  @override
  Widget build(BuildContext context) {
    _getUsersLevelXP();
    var xp = _getNextLevelCap();
    print("Cap: ${xp}");

    return new Scaffold(
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text("Level: ${_userLevel}"),
            new Text("Next level cap: ${xp}"),
          ],
        ),
      ),
    );
  }


  void _getUsersLevelXP(){

    //query from database
    Firestore.instance
        .collection('Users')
        .where("XP", isGreaterThanOrEqualTo: 0)
        .snapshots()
        .listen((data) =>
        data.documents.forEach((doc) => {
            _listUser.add(doc.documentID),
            _listXP.add(doc["XP"]),
            _listLevel.add(doc["Level"]),
    }));

    //if userId == documentID, set level and XP
    for (var i = 0; i < _listUser.length; i++){
      if (_listUser[i].toString() == _uid){
        _userXP = _listXP[i];
        _userLevel = _listLevel[i];
      }
    }

    //empty the lists
    _listUser = [];
    _listXP = [];
    _listLevel = [];
  }

  _getNextLevelCap(){

    var _xpCap = 0;

    //query from database
    Firestore.instance
        .collection('Levels')
        .where("Level", isEqualTo: _userLevel)
        .snapshots()
        .listen((data) =>
        data.documents.forEach((doc) => {
          _xpCap = doc["XP cap"],
        print("_xpCap: ${_xpCap}"),
        }));
    return _xpCap;
  }

}
