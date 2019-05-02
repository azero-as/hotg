import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/material.dart';

import 'models/user.dart';

class Summary extends StatefulWidget {
  final List<dynamic> exercises;
  final int bonus;
  final int total_xp;
  final String workoutName;
  final VoidCallback onLoggedIn;
  final VoidCallback alreadyLoggedIn;

  Summary(
      {this.exercises,
      this.bonus,
      this.total_xp,
      this.workoutName,
      this.onLoggedIn,
      this.alreadyLoggedIn});

  @override
  State createState() => new _SummaryState();
}

class _SummaryState extends State<Summary> {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<User>(builder: (context, child, model) {
      return Scaffold(
          backgroundColor: Theme.of(context).secondaryHeaderColor,
          appBar: AppBar(
            leading: new IconButton(
                key: Key("summaryExit"),
                icon: Icon(Icons.close),
                onPressed: () {
                  // Check if levelUp pop-up should appear
                  if (model.levelUp) {
                    // Display pop-up
                    showDialog(
                        context: context,
                        builder: (context) =>
                            _onLevelUp(context)); // Call the Dialog.
                    // Set levelUp back to fase
                    model.setLevelUpFalse();
                  }
                  // Navigate to homepage
                  widget.alreadyLoggedIn();
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
                // set height of container to be 85% of screen height
                height: MediaQuery.of(context).size.height * 0.85,
                padding: EdgeInsets.only(
                    right: 15.0, left: 15.0, top: 15.0, bottom: 15.0),
                child: _buildWorkoutCard(),
              )
            ],
          )));
    });
  }

  Widget _buildExerciseListItem(BuildContext context, exercise) {
    return ListTile(
      title: Text(exercise["name"]),
      trailing: Text(exercise["xp"].toString() + " xp"),
      contentPadding: EdgeInsetsDirectional.only(start: 40.0, end: 40.0),
    );
  }

  Widget _buildListHeader() {
    return Container(
        child: ListTile(
      title: Text(
        widget.workoutName,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    ));
  }

  Widget _buildScore() {
    if (widget.bonus == 0) {
      return Column(
        children: <Widget>[
          ListTile(
            title:
                Text("Total: ", style: TextStyle(fontWeight: FontWeight.bold)),
            trailing: Text(widget.total_xp.toString() + " xp",
                style: TextStyle(fontWeight: FontWeight.bold)),
            contentPadding: EdgeInsetsDirectional.only(start: 70.0, end: 70.0),
          ),
        ],
      );
    } else {
      return Column(
        children: <Widget>[
          ListTile(
            title: Text("Bonus: "),
            trailing: Text(widget.bonus.toString() + " xp"),
            contentPadding: EdgeInsetsDirectional.only(start: 70.0, end: 70.0),
          ),
          ListTile(
            title:
                Text("Total: ", style: TextStyle(fontWeight: FontWeight.bold)),
            trailing: Text(widget.total_xp.toString() + " xp",
                style: TextStyle(fontWeight: FontWeight.bold)),
            contentPadding: EdgeInsetsDirectional.only(start: 70.0, end: 70.0),
          ),
        ],
      );
    }
  }

  Widget _buildExerciseList() {
    return new Scrollbar(
        child: ListView.builder(
            //spacing between items
            itemExtent: 45.0,
            itemCount: widget.exercises.length,
            itemBuilder: (context, index) {
              return _buildExerciseListItem(context, widget.exercises[index]);
            }));
  }

  Widget _buildWorkoutCard() {
    var appScreenHeight = MediaQuery.of(context).size.height;
    return Card(
        elevation: 2.0,
        child: Column(children: <Widget>[
          _buildListHeader(),
          Container(
            height: appScreenHeight * 0.45,
            child: _buildExerciseList(),
          ),
          Divider(color: Colors.black),
          _buildScore(),
        ]));
  }

  //Pop-up window when a user level up
  Widget _onLevelUp(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        new Container(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
            margin: EdgeInsets.fromLTRB(35, 0, 35, 35),
            //decoration: new BoxDecoration(                  //border if we want
            //color: Colors.white,
            //border: new Border.all(color: Colors.black)
            // ),
            child: new ListView(
              shrinkWrap: true,
              children: <Widget>[
                new Container(
                    padding: EdgeInsets.fromLTRB(25, 8, 0, 8),
                    color: const Color(0xFF212838),
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        RichText(
                          text: TextSpan(
                            text: 'Level up!',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        Align(
                          child: RaisedButton(
                            color: Theme.of(context).secondaryHeaderColor,
                            textColor: Colors.white,
                            onPressed: () => Navigator.pop(context),
                            child: Icon(
                              Icons.close,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    )),
                new Container(
                    padding: EdgeInsets.fromLTRB(25, 40, 25, 40),
                    color: Colors.white,
                    child: ScopedModelDescendant<User>(
                        builder: (context, child, model) {
                      return Column(children: <Widget>[
                        RichText(
                          text: TextSpan(
                            text: 'Congratulations! You are now: ',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        RichText(
                          text: TextSpan(
                            text: 'Level ${model.gameLevel}',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ]);
                    }))
              ],
            )),
      ],
    );
  }
}
