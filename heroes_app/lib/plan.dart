import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Plan extends StatelessWidget {

  Plan(this.listType);
  final String listType;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('PLAN'),
          ],
        ),
      ),
    );
  }
}