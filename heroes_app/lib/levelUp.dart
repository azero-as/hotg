import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';

class LevelUp extends StatefulWidget{

  @override
  State<StatefulWidget> createState() => new _LevelUpState();
}

class _LevelUpState extends State<LevelUp>{

  int _userLevel = 0;
  int _userXP = 0;
  int _levelCap = 0;

  @override
  void initState(){
    super.initState();

    CloudFunctions.instance.call(
      functionName: 'getUserXP',
    ).then((response) {
      setState(() {
        _userXP = response['XP'];
      });
    }).catchError((error) {
      print(error);
    });

    CloudFunctions.instance.call(
      functionName: 'getUserLevel',
    ).then((response) {
      setState(() {
        _userLevel = response['Level'];
      });
    }).catchError((error) {
      print(error);
    });

    /*//Get the userID of current user
    FirebaseAuth.instance.currentUser().then((response){
      setState(() {
        _uid = response.uid;
      });
    }).catchError((error){
      print(error);
    });*/
  }

  @override
  Widget build(BuildContext context) {
    getLevelCap(_userLevel);

    return new Scaffold(
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text("Level: ${_userLevel}"),
            new Text("XP: ${_userXP}"),
            new Text("Next level cap: ${_levelCap}"),
            levelUp(),
          ],
        ),
      ),
    );
  }

//get cap to next level
  void getLevelCap(level){
    //query from database
    Firestore.instance
        .collection('Levels')
        .where("Level", isEqualTo: level)
        .snapshots()
        .listen((data) =>
        data.documents.forEach((doc) => {
          _levelCap = doc["xpCap"],
          //print("xpCap: $_levelCap"),
        }));
    //print("Cap: $_levelCap");
  }

//check if xp is bigger than level cap
  checkLevelUp(){
    //xp >= cap -> level up
    if (_userXP >= _levelCap){
      return true;
    } else {
      return false;
    }
  }

//set one level up in db
  void setLevel(){
    
  }

//reset xp in db
  void resetXP(){

  }

//Level Up
  Widget levelUp(){
    if (checkLevelUp()){
      setLevel();
      resetXP();

      return new Container(
        padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
        child:
        new RichText(
          text:
          TextSpan(
            style: DefaultTextStyle.of(context).style,
            children: <TextSpan>[
          TextSpan(
            text: 'Congratulations! You are now: \n',
            style: TextStyle(color: Colors.black, fontSize: 15),
          ),
          TextSpan(
            text: 'Level $_userLevel\n',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text: 'Novice',
             style: TextStyle(),
          ),],)),
      );} else {
      return new Container(
        child: new Text(""),
      );
    }
  }

}
