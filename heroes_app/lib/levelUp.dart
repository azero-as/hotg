import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'dashboard.dart';
import 'home.dart';

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

    return new Scaffold(
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new RaisedButton(
              onPressed: () {
                _levelUpAlert(context);
              },
              child: const Text("Pop-up"),
            ),
         //   new Text("Level up?: $_updateLevel"),
            //levelUp(),
          ],
        ),
      ),
    );
  }


  Future<void> _levelUpAlert(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Level up!'),
          content: new Text('Congratulations! You are now: Level ${_userLevel}'),
          actions: <Widget>[
            FlatButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

}
