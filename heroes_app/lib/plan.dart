import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class Plan extends StatelessWidget {
    Plan(this.listType);
    final String listType;

    @override
    Widget build(BuildContext context) {
        return MaterialApp(
            home: Scaffold(
                appBar: AppBar(
                    backgroundColor: const Color(0xFF4FB88B),
                ),
                body: ListView.builder(
                    itemBuilder: (BuildContext context, int index) =>
                        EntryItem(data[index]),
                    itemCount: data.length,
                ),
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
            Entry('Minutes: 5-20'),
            Entry('Rest after set: 3 min'),
            Entry('XP: 5'),
        ],
    ),
    Entry(
        'Push ups',
        <Entry>[
            Entry('Sets: 3'),
            Entry('Reps: 10-12'),
            Entry('XP: 12'),
        ],
    ),
    Entry(
        'Squats',
        <Entry>[
            Entry('Sets: 3'),
            Entry('Reps: 10-12'),
            Entry('XP: 12'),
        ],
    ),
];

// Displays one Entry. If the entry has children then it's displayed
// with an ExpansionTile.
class EntryItem extends StatelessWidget {
    const EntryItem(this.entry);

    final Entry entry;

    Widget _buildTiles(Entry root) {
        if (root.children.isEmpty) return ListTile(title: Text(root.title));
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
