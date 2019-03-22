import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'activeWorkoutSession.dart';

class Plan extends StatefulWidget {

    @override
    _PlanPageState createState() => new _PlanPageState();

}


class _PlanPageState extends State<Plan> {


  @override
    Widget build(BuildContext context) {
        return Scaffold(

              body: Container(
                child: new Text("Plan"),
              ),
        );}}
