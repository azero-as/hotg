import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class Plan extends StatelessWidget {
    Plan(this.listType);
    final String listType;

    @override
    Widget build(BuildContext context) {

        var description = new RichText(
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
            ));

        final startWorkoutButton = Padding(
            padding: EdgeInsets.symmetric(vertical: 0.0),
            child: RaisedButton(
                elevation: 5.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                ),
                onPressed: () {
                    //TODO: eventhandler on start workout button
                },
                padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
                color: const Color(0xFF58C6DA),
                child: Text('Start workout', style: TextStyle(color: Colors.white),),
            ),
        );


        final newWorkoutButton = Padding(
            padding: EdgeInsets.symmetric(vertical: 0.0),
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


        return Scaffold(
                appBar: AppBar(
                    backgroundColor: const Color(0xFF4FB88B),
                    title: Text("Fullkroppsstyrke", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),

                body: new Column(
                children: <Widget>[
                        Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                                SizedBox(height: 120),
                                description,
                            ],
                        ),


                    new Expanded(
                        child: Container(
                            child: ListView.builder(
                                itemBuilder: (BuildContext context, int index) =>
                                    EntryItem(data[index]),
                                itemCount: data.length,
                            ),
                        )
                    ),
                    startWorkoutButton,
                    newWorkoutButton,

                ],
            ),
        );
    }
}

// One entry in the multilevel list displayed by this app.
class Entry {
    Entry(this.title, [this.children = const <Entry>[]]);

    final String title;
    final List<Entry> children;
}

// The entire multilevel list displayed by this app.
final List<Entry> data = <Entry>[

    Entry(
        'Warm up',
        <Entry>[
            Entry('Minutes: '),
            Entry('Rest after set: '),
            Entry('XP: 5'),
        ],
    ),
    Entry(
        'Push ups',
        <Entry>[
            Entry('Sets: '),
            Entry('Reps: '),
            Entry('XP: '),
        ],
    ),
    Entry(
        'Squats',
        <Entry>[
            Entry('Sets: '),
            Entry('Reps: '),
            Entry('XP: '),
        ],
    ),
];

// Displays one Entry. If the entry has children then it's displayed
// with an ExpansionTile.
class EntryItem extends StatelessWidget {
    const EntryItem(this.entry);

    final Entry entry;

    Widget _buildTiles(Entry root) {
        if (root.children.isEmpty) return ListTile(title: Text(root.title,style: TextStyle(fontWeight: FontWeight.bold)));
        return ExpansionTile(
            key: PageStorageKey<Entry>(root),
            title: Text(root.title),
            children: root.children.map(_buildTiles).toList(),
        );
    }

    @override
    Widget build(BuildContext context) {
        return _buildTiles(entry);
    }
}
