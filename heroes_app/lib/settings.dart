import 'package:flutter/material.dart';
import 'authentication.dart';
import 'package:scoped_model/scoped_model.dart';
import 'models/user.dart';
import 'logic/fitnessLevelName.dart';

class Settings extends StatefulWidget {
  //For signing out

  Settings({this.auth, this.onSignedOut, this.alreadyLoggedIn});

  final BaseAuth auth;
  final VoidCallback onSignedOut;
  final VoidCallback alreadyLoggedIn;

  @override
  State createState() => new SettingsState();
}

class SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).secondaryHeaderColor,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              widget.alreadyLoggedIn();
            },
            color: Colors.white,
          ),
          title: Text("Settings"),
        ),
        body: Container(
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          margin: EdgeInsets.fromLTRB(20, 0, 20, 35),
          child: new ListView(
            shrinkWrap: true,
            children: <Widget>[
              SizedBox(height: 50.0),
              characterNameField(),
              emailField(),
              fitnessLevelField(),
              SizedBox(height: 125.0),
              logOutButton()
            ],
          ),
        ));
  }

  // Displays characterName
  Widget characterNameField() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 3.0),
      child: ScopedModelDescendant<User>(builder: (context, child, model) {
        if (model.characterName.isEmpty) {
          return new Container();
        }
        return ListTile(
          leading: Icon(
            Icons.person,
            color: Colors.white,
          ),
          title: Text(
            model.characterName,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        );
      }),
    );
  }

  // Displays email address
  Widget emailField() {
    return Padding(
        padding: EdgeInsets.fromLTRB(0.0, 2.0, 0.0, 0.0),
        child: ScopedModelDescendant<User>(builder: (context, child, model) {
          if (model.email.isEmpty) {
            return new Container();
          }
          return ListTile(
            leading: Icon(
              Icons.email,
              color: Colors.white,
            ),
            title: Text(
              model.email,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          );
        }));
  }

  // Displays fitness level
  Widget fitnessLevelField() {
    return Padding(
        padding: EdgeInsets.fromLTRB(0.0, 2.0, 0.0, 0.0),
        child: ScopedModelDescendant<User>(builder: (context, child, model) {
          if (model.fitnessLevel == null) {
            return new Container();
          }
          return ListTile(
            leading: Icon(
              Icons.fitness_center,
              color: Colors.white,
            ),
            title: Text(
              'Fitness level: ${convertFitnessLevelName(model.fitnessLevel)}',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          );
        }));
  }

  _signOut() async {
    try {
      await widget.auth.signOut();
      widget.onSignedOut();
    } catch (e) {
      print(e);
    }
  }

  Widget logOutButton() {
    return Padding(
        padding: EdgeInsets.all(20.0),
        child: RaisedButton(
          elevation: 5.0,
          key: Key("signOutButton"),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          onPressed: () {
            _signOut();
          },
          color: const Color(0xFF612A30),
          child: Text(
            'Log out',
            style: TextStyle(color: Colors.white),
          ),
        ));
  }
}
