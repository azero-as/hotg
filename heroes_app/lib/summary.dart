import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'home.dart';

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
        appBar: AppBar(
          leading: new IconButton(icon: Icon(Icons.close), onPressed: () {}),
          title: Text(
            "Summary",
            style: TextStyle(fontSize: 22),
          ),
          centerTitle: true,
        ),
        //backgroundColor: Colors.blueGrey[100],
        body: Center(
            child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(
                  right: 20.0, left: 20.0, top: 50.0, bottom: 20.0),
              child: _buildBody(),
            )
          ],
        )));
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot document) {
    return ListTile(
      title: Text(document["name"], style: TextStyle(fontSize: 20)),
      trailing: Text(document["XP"].toString() + " xp",
          style: TextStyle(fontSize: 20)),
      contentPadding: EdgeInsetsDirectional.only(start: 60.0, end: 60.0),
    );
  }

  Widget _buildListHeader(BuildContext context) {
    return ListTile(
      title: Text(
        "Warrior Gym Workout",
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
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
              return Text("");
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

  Widget _streamBuilder() {
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
              return Text("");
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

  Widget _buildBody() {
    return Card(
        elevation: 2.0,
        child: Column(children: <Widget>[
          _buildListHeader(context),
          Container(
            height: 300.0,
            child: _streamBuilder(),
          ),
          Divider(color: Colors.black),
          _getScore(context),
        ]));
  }
}
