import 'package:flutter/material.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'authentication.dart';

// Stateful async guide: https://flutter.institute/run-async-operation-on-widget-creation/

class Settings extends StatefulWidget {
  Settings({this.auth, this.onSignedOut});

  final BaseAuth auth;
  final VoidCallback onSignedOut;
  @override 
  State createState() => new SettingsState();
}

class SettingsState extends State<Settings> {

  String _username = '';
  String _email = '';

  @override
  void initState() {
    super.initState();

    CloudFunctions.instance.call(
      functionName: 'getUserInfo',
    ).then((response) {
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
          title: Text("Settings"),
        ),
        body: Container(
        padding: EdgeInsets.only(left: 24.0, right: 24.0),
        margin: EdgeInsets.fromLTRB(35, 0, 35, 35),
          child: new ListView(
            shrinkWrap: true,
            children: <Widget>[
              SizedBox(height: 25.0),
              usernameField(),
              emailField(),
              resetPasswordButton(),
              SizedBox(height: 100.0),
              logOutButton()
              
            ],
          ),
        ));
    }
  }

   Widget usernameField(){
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 3.0),
      child:
        ListTile(
          leading: Icon(Icons.person),
          title: Text(_username),
        ),
    );
  
  }

  Widget emailField(){
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 2.0, 0.0, 0.0),
      child:
        ListTile(
          leading: Icon(Icons.email),
          title: Text(_email),
        ),
    );
  }
 

  Widget resetPasswordButton() {
    return Padding(
      padding: EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 0.0),
      child: 
        OutlineButton.icon(
          icon: Icon(Icons.lock),
          label: Text('Change password'),
          color: Colors.white,
          borderSide: BorderSide(color: Colors.grey),

          //TODO: Navigate to change password screen
          onPressed: () {}
      )
     );
  }

  Widget logOutButton() {
    return Padding(
      padding: EdgeInsets.all(5.0),
      child: RaisedButton(
        elevation: 5.0,
        shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
    ),
          onPressed: () {
            widget.onSignedOut();
          },
          color: const Color(0xFF612A30),
        child: Text('Log out', style: TextStyle(color: Colors.white),),
      )
    );
  }


  
}