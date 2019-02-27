import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LevelUp extends StatefulWidget{



  @override
  State<StatefulWidget> createState() => new _LevelUpState();
}

class _LevelUpState extends State<LevelUp>{

  int userXP;

  static final userID = "m11vLk2BRKSt31mRZdYDbfP1GNH3";

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            
          ],
        ),
      ),
    );
  }


  void _getXP(){
    final userDoc = Firestore.instance.collection("Users");

    final xp = userDoc.getDocuments().then((user){
      user.documents[1].data["XP"];
    });
    
    setState(() {
      userXP = 0;
    });
  }

}
