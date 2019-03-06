import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'settings.dart';

class Home extends StatelessWidget {

  Home(this.listType);
  final String listType;

  //Settings icon button with navigation to settings page
  //TODO Place the button in the header on the top right corner.
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.settings),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Settings()),
        );
      }
    );
  }
}