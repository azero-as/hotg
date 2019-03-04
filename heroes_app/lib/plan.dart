import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'activeWorkoutSession.dart';

class Plan extends StatefulWidget {

    static String tag = 'plan-page';
    @override
    _PlanPageState createState() => new _PlanPageState();

}


class _PlanPageState extends State<Plan> {
    @override
    Widget build(BuildContext context) {

        Widget _returnNewWorkoutButton(){
            return Padding(
                padding: EdgeInsets.symmetric(horizontal: 0),
                child: RaisedButton(
                    elevation: 5.0,
                    shape: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide(
                            width: 2.0,
                            color: const Color(0xFF58C6DA),
                        )
                    ),
                    onPressed: () {
                        //TODO: eventhandler on start workout button
                    },
                    padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                    color: const Color(0xFFFFFFFF),
                    child: Text('Generate new workout', style: TextStyle(color: Colors.black54),),
                ),
            );
        }

        Widget _returnStartWorkoutButton(List<dynamic> exercises){
            return new Padding(
                padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0.0),

                child: RaisedButton(
                    elevation: 5.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                    ),
                    onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => activeWorkoutSession(exercises: exercises)));

                    },
                    padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
                    color: const Color(0xFF58C6DA),
                    child: Text('Start workout', style: TextStyle(color: Colors.white),),
                ),
            );}

        //Information about workout
        Widget _showInfo(){
            return  Container(
                margin: EdgeInsets.fromLTRB(100, 0, 100, 40),
                child: RichText(
                    text: new TextSpan(
                        style: new TextStyle(
                            fontSize: 14.0,
                            color: Colors.black,
                        ),
                        children: <TextSpan>[
                            //TODO: Add icon
                            new TextSpan(text: 'Time: ', style: new TextStyle(fontWeight: FontWeight.bold)),
                            //TODO: Add the correct time here
                            new TextSpan(text: '1  '),
                            new TextSpan(text: ' XP: ', style: new TextStyle(fontWeight: FontWeight.bold)),
                            //TODO: Add the correct XP one gets from completing the workout
                            new TextSpan(text: '100 \n\n'),
                            new TextSpan(text: 'Difficulty: ', style: new TextStyle(fontWeight: FontWeight.bold)),
                            //TODO: Add the correct difficulty
                            new TextSpan(text: 'Beginner'),
                        ]
                    ))
                );
        }

        //Information about the exercises that is apart of the workout
        Widget _showInformationWorkout(List<dynamic> exercises){
            return new ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: exercises.length,
                itemBuilder: (BuildContext context, int index) =>
                    EntryItem(exercises[index]),

            );

        }

        Widget _returnBody(List<dynamic> exercises){
            return new Container(
                padding: EdgeInsets.only(left: 24.0, right: 24.0),
                margin: EdgeInsets.fromLTRB(0, 50, 0, 15),
                child: Column(
                    children: <Widget>[
                        Container(
                            child: _showInfo(),

                        ),
                        Expanded(
                            child: _showInformationWorkout(exercises),
                        ),
                        _returnStartWorkoutButton(exercises),
                        _returnNewWorkoutButton(),
                    ],

                )
            );}


        return Scaffold(
                body: StreamBuilder<QuerySnapshot>(
                    stream:  Firestore.instance.collection("Exercises").document("LowerBody").collection("Lvl1").snapshots(),
                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                        if (!snapshot.hasData) return new Text('Loading...');
                        if(snapshot.hasData && snapshot.data !=null){
                            var exercises = [];
                           for(var i = 0; i < snapshot.data.documents.length; i++){
                                exercises.add(snapshot.data.documents[i]);


                           }


                            return _returnBody(exercises);
                        }
                    }
                ),
             );
        }}










// One entry in the multilevel list displayed by this app.
class Entry {
    Entry(this.name, [this.info = const <Text>[]]);

    final String name;
    final List<Text> info;

}

// The entire multilevel list displayed by this app.


// Displays one Entry. If the entry has children then it's displayed
// with an ExpansionTile.
class EntryItem extends StatelessWidget {
    const EntryItem(this.entry);

    final DocumentSnapshot entry;
    Widget _buildTiles(DocumentSnapshot root) {
        return ExpansionTile(
            key: PageStorageKey<DocumentSnapshot>(root),
            title: Text(root["Name"]),
            children: <Widget>[
                ListTile(
                    title: Text("Sets: 1"),
                ),
                ListTile(
                    title: Text("Reps: 10-12"),
                ),
                ListTile(
                    title: Text("XP: " + root["XP"].toString()),
                ),
            ]
            //children: root["info"]
        );
    }

    @override
    Widget build(BuildContext context) {
        return _buildTiles(entry);
    }
}
