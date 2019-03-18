import 'package:flutter/material.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'authentication.dart';
import 'home.dart';

class Settings extends StatefulWidget {
  //For signing out

  Settings({this.auth, this.onSignedOut, this.onSignedIn});

  final BaseAuth auth;
  final VoidCallback onSignedOut;
  final VoidCallback onSignedIn;

  @override
  State createState() => new SettingsState();
}

class SettingsState extends State<Settings> {
  String _username = '';
  String _email = '';

  @override
  void initState() {
    super.initState();

    //Getting username (charactername) and email from logged in user in Firebase

    CloudFunctions.instance
        .call(
      functionName: 'getSettingsUserInfo',
    )
        .then((response) {
      setState(() {
        _username = response['username'];
        _email = response['email'];
      });
    }).catchError((error) {
      print(error);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_username == '') {
      return new Container();
    } else {
      return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                widget.onSignedIn();
              },
              color: Colors.white,
            ),
            title: Text("Settings"),
          ),
          body: Container(
            padding: EdgeInsets.only(left: 24.0, right: 24.0),
            margin: EdgeInsets.fromLTRB(35, 0, 35, 35),
            child: new ListView(
              shrinkWrap: true,
              children: <Widget>[
                SizedBox(height: 50.0),
                usernameField(),
                emailField(),
                SizedBox(height: 125.0),
                logOutButton()
              ],
            ),
          ));
    }
  }

  Widget usernameField() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 3.0),
      child: ListTile(
        leading: Icon(Icons.person),
        title: Text(_username),
      ),
    );
  }

  Widget emailField() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 2.0, 0.0, 0.0),
      child: ListTile(
        leading: Icon(Icons.email),
        title: Text(_email),
      ),
    );
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
