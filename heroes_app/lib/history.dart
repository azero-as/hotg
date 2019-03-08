import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class History extends StatelessWidget {
  History(this.listType);
  final String listType;

  @override
  Widget build(BuildContext context) {
    return ListOfTrainingSessions(); // TODO: Should return the content of the history page
  }
}

class ListOfTrainingSessions extends StatefulWidget {
  ListOfTrainingSessions();

  @override
  State<StatefulWidget> createState() {
    return _ListOfTrainingSessionsState();
  }
}

class _ListOfTrainingSessionsState extends State<ListOfTrainingSessions> {
  final List<String> _listOfSessions = [
    "Bla1",
    "Bla2",
    "Bla3",
    "Bla4",
    "Bla5",
    "Bla6",
    "Bla7",
    "Bla8",
    "bla9",
    "bla10",
    "Bla11",
    "Bla12"
  ];

  @override
  Widget build(BuildContext context) {
    //TODO: Should return a ListView with training sessions

    return ListView.builder(
      itemBuilder: _buildHistoryItem,
      itemCount: _listOfSessions.length,
    );
  }

  Widget _buildHistoryItem(BuildContext context, int index) {
    return ExpansionTile(
      title: Center(child: Text("Date of session")),
      backgroundColor: Color.fromRGBO(33, 40, 56, 0.2),
      children: <Widget>[Text(_listOfSessions[index]), Text('Second text')],
    ); // Should return a single history item widget
  }
}

// TODO: Trenger en listview for å lage en scrollbar liste med økter
// TODO: Hver økt skal kunne trykkes på for å vise detaljer (eks ExpansionTile)
// TODO: Designet skal stemme overens med figma
// TODO: Dataen som vises skal hentes fra databasen (Stream, Cloud?)
