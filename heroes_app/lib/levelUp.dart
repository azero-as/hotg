import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LevelUp extends StatefulWidget{

  @override
  State<StatefulWidget> createState() => new _LevelUpState();
}

class _LevelUpState extends State<LevelUp>{

  int _userXP = 0;
  String _uid = "";

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
    _getXP();
    print("Current user ID: ${_uid}");
    print("XP: ${_userXP}");
    return new Scaffold(
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text("LevelUp"),
          ],
        ),
      ),
    );
  }


  void _getXP(){
    final userDoc = Firestore.instance.document("Users/${_uid}");

    print("Print: ${userDoc}");


  }

}
