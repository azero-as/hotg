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

  @override
  void initState(){
    super.initState();

    CloudFunctions.instance.call(
      functionName: 'updateUserLevelInfo',
    ).then((response) {
      setState(() {
        //_userXp = response['userXp'];
        _userLevel = response['userLevel'];
        //_xpCap = response['xpCap'];
     //   _updateLevel = response['updateLevel'];
      });
    }).catchError((error) {
      print(error);
    });
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
                showDialog(context: context,builder: (context) => _onLevelUp(context)); // Call the Dialog.
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


  //Pop-up window when a user level up
  Widget _onLevelUp(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        new Container(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
          margin: EdgeInsets.fromLTRB(35, 0, 35, 35),
          //decoration: new BoxDecoration(                  //border if we want
            //color: Colors.white,
            //border: new Border.all(color: Colors.black)),
          child:
            new ListView(
            shrinkWrap: true,
            children: <Widget>[
              new Container(
                padding: EdgeInsets.fromLTRB(30, 8, 0, 8),
                color: const Color(0xFF212838),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    RichText(
                      text: TextSpan(
                        text: 'Level up!',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    Align(
                      //alignment: Alignment.topRight,
                      child: RaisedButton(
                          color: Theme.of(context).primaryColor,
                          textColor: Colors.white,
                          onPressed: () => Navigator.pop(context),
                          child: Icon(
                            Icons.close,
                            color: Colors.white,
                            ),
                      ),
                    ),
                  ],
                )
              ),
              new Container(
                padding: EdgeInsets.fromLTRB(10, 40, 10, 40),
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    RichText(
                      text: TextSpan(
                        text: 'Congratulations! You are now: ',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    RichText(
                      text: TextSpan(
                        text: 'Level $_userLevel',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              //SizedBox(height: 100.0),
            ],
          )),

      ],
    );
  }

}
