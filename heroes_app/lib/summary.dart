import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'main.dart';

class Summary extends StatefulWidget {
  Summary({this.workoutID});
  final String workoutID;

  @override
  State createState() => new _SummaryState();
}

class _SummaryState extends State<Summary> {
  String _workoutID = '';

  @override
  void initState() {
    super.initState();

    Firestore.instance
        .collection("Users")
        .document("TkDkU5X55RG9rNjSb6Fn")
        .collection("Workouts")
        .orderBy("date", descending: true)
        .limit(1)
        .getDocuments()
        .then((data) {
      setState(() {
        _workoutID = data.documents[0].documentID.toString();
      });
    }).catchError((error) {
      return error;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          backgroundColor: const Color(0xFF612A30),
          leading: new IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                Navigator.popUntil(context, ModalRoute.withName('dashboard'));
              }),
          title: Text(
            "Summary",
            style: TextStyle(fontSize: 22),
          ),
          centerTitle: true,
        ),
        body: Center(
            child: Column(
          children: <Widget>[
            Container(
              // set heigth of container to be 85% of screen height
              height: MediaQuery.of(context).size.height * 0.80,
              padding: EdgeInsets.only(
                  right: 20.0, left: 20.0, top: 30.0, bottom: 30.0),
              child: _buildCard(),
            )
          ],
        )));
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot document) {
    return ListTile(
      title: Text(document["name"], style: TextStyle(fontSize: 20)),
      trailing: Text(document["XP"].toString() + " xp",
          style: TextStyle(fontSize: 20)),
      contentPadding: EdgeInsetsDirectional.only(start: 40.0, end: 40.0),
    );
  }

  Widget _buildListHeader(BuildContext context) {
    return Container(
        child: ListTile(
      title: Text(
        "Workout Summary",
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    ));
  }

  Widget _getScore(BuildContext context) {
    if (_workoutID == '') {
      return Container(height: 0.0, width: 0.0);
    } else {
      return FutureBuilder(
          future: Firestore.instance
              .collection("Users")
              .document("TkDkU5X55RG9rNjSb6Fn")
              .collection("Workouts")
              .document(_workoutID)
              .get(),
          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Container(height: 0.0, width: 0.0);
            }
            if (snapshot.hasData) {
              return _buildScore(context, snapshot.data);
            }
          });
    }
  }

  Widget _buildScore(BuildContext context, DocumentSnapshot snapshot) {
    return Column(
      children: <Widget>[
        ListTile(
          title: Text("Bonus ", style: TextStyle(fontSize: 22)),
          trailing: Text(snapshot["bonus_xp"].toString() + " xp",
              style: TextStyle(fontSize: 22)),
          contentPadding: EdgeInsetsDirectional.only(start: 50.0, end: 50.0),
        ),
        ListTile(
          title: Text("Total: ",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          trailing: Text(snapshot["total_xp"].toString() + " xp",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          contentPadding: EdgeInsetsDirectional.only(start: 50.0, end: 50.0),
        ),
      ],
    );
  }

  Widget _getWorkoutInfo() {
    if (_workoutID == '') {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return StreamBuilder(
          stream: Firestore.instance
              .collection("Users")
              // this reference should be replaced by state.user.id
              .document("TkDkU5X55RG9rNjSb6Fn")
              .collection("Workouts")
              .document(_workoutID)
              .collection("Exercises")
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            if (snapshot.hasData) {
              return new ListView.builder(

                  //spacing between items
                  itemExtent: 50.0,
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) {
                    return _buildListItem(
                        context, snapshot.data.documents[index]);
                  });
            }
          });
    }
  }

  Widget _buildCard() {
    return Card(
        elevation: 2.0,
        child: Column(children: <Widget>[
          _buildListHeader(context),
          Container(
            height: MediaQuery.of(context).size.height * 0.45,
            child: _getWorkoutInfo(),
          ),
          Divider(color: Colors.black),
          Container(
              height: MediaQuery.of(context).size.height * 0.15,
              child: _getScore(context)),
        ]));
  }
}
