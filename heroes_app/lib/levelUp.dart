import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';

class LevelUp extends StatefulWidget{

  @override
  State<StatefulWidget> createState() => new _LevelUpState();
}

class _LevelUpState extends State<LevelUp>{

  int _userLevel;
  int _userXp;
  int _xpCap;
 // bool _updateLevel;

  @override
  void initState(){
    super.initState();

    CloudFunctions.instance.call(
      functionName: 'updateUserLevelInfo',
    ).then((response) {
      setState(() {
        _userXp = response['userXp'];
        _userLevel = response['userLevel'];
        _xpCap = response['xpCap'];
     //   _updateLevel = response['updateLevel'];
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


    print(_xpCap);
    return new Scaffold(
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text("Level: $_userLevel"),
            new Text("XP: $_userXp"),
            new Text("Next level cap: $_xpCap"),
         //   new Text("Level up?: $_updateLevel"),
            //levelUp(),
          ],
        ),
      ),
    );
  }

/*//get cap to next level
  void getLevelCap(level){
    var cap;

    //query from database
    Firestore.instance
        .collection('Levels')
        .where("Level", isEqualTo: level)
        .snapshots()
        .listen((data) => data.documents.forEach((doc) => {

          cap += doc["xpCap"]
          //print("xpCap: $_levelCap")
        }));

    _levelCap = cap;
  }*/



/*
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
*/
}
