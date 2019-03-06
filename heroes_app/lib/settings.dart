import 'package:flutter/material.dart';
import 'package:cloud_functions/cloud_functions.dart';

// Stateful async guide: https://flutter.institute/run-async-operation-on-widget-creation/

class Settings extends StatefulWidget {
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
        body: ListView(
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.person),
              title: Text(_username),
            ),
            ListTile(
              leading: Icon(Icons.email),
              title: Text(_email),
            )
          ],
        ),
        
      );
    }
  }

  Widget resetPasswordButton() {
    return OutlineButton.icon(
        icon: Icon(Icons.lock),
        label: Text('Change password'),
        color: Colors.white,
        borderSide: BorderSide(color: Colors.black),

        //TODO: Navigate to change password screen
        onPressed: () {}
    );
  }
}