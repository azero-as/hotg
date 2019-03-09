import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
    print("build summary called!");
    return Scaffold(
        backgroundColor: Colors.blueGrey[100],
        body: Column(
          children: <Widget>[
            _buildListHeader(context),
            _exercisesListContainer(context),
            Divider(),
            _scoreContainer(context),
            //_getScore(),
          ],
        ));
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot document) {
    return ListTile(
      title: Text(document["name"], style: TextStyle(fontSize: 20)),
      trailing: Text(document["XP"].toString() + " xp",
          style: TextStyle(fontSize: 20)),
      contentPadding: EdgeInsetsDirectional.only(start: 70.0, end: 70.0),
    );
  }

  Widget _buildListHeader(BuildContext context) {
    return ListTile(
      title: Text(
        "Summary",
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
      contentPadding: EdgeInsets.only(top: 30.0),
    );
  }

  Widget _getScore(BuildContext context) {
    if (_workoutID == '') {
      return Text("Loaading..");
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
    return ListView(
      children: <Widget>[
        ListTile(
          title: Text("Bonus "),
          trailing: Text(snapshot["bonus_xp"].toString() + " xp"),
          contentPadding: EdgeInsetsDirectional.only(start: 50.0, end: 50.0),
        ),
        ListTile(
          title: Text("Total: ",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          trailing: Text(
            snapshot["total_xp"].toString() + " xp",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          contentPadding:
              EdgeInsetsDirectional.only(start: 50.0, end: 50.0, bottom: 50),
        )
      ],
    );
  }

  Widget _streamBuilder() {
    print("Streambuilder called");
    if (_workoutID == '') {
      return Text("Loaading..");
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
              return Text("Loading...");
            }
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            if (snapshot.hasData) {
              print(snapshot.data);
              return new ListView.builder(
                  //spacing between items
                  itemExtent: 60.0,
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) {
                    return _buildListItem(
                        context, snapshot.data.documents[index]);
                  });
            }
          });
    }
  }

  Widget _exercisesListContainer(BuildContext context) {
    return Container(height: 5 * 60.0, child: _streamBuilder());
  }

  Widget _scoreContainer(BuildContext context) {
    return Container(
        height: 100.0,
        margin: const EdgeInsets.only(left: 30, right: 30, bottom: 10),
        child: _getScore(context));
  }
}
