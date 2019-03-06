import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
// import 'settings.dart';

// build the home page and call on the stateful classes
class Home extends StatelessWidget {
  Home(this.listType);

  final String listType;

  //Settings icon button with navigation to settings page
  @override
  Widget build(BuildContext context) {
    return new Container(
      // general background color for the page
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        children: <Widget>[
          AvatarOverview(),
          SizedBox(height: 20.0),
          WorkoutOverview()
        ],
      ),
    );
  }
}

// create state for appbar of home page
class AvatarOverview extends StatefulWidget {
  @override
  _AvatarOverviewState createState() => _AvatarOverviewState();
}

// class for appbar of home page
class _AvatarOverviewState extends State<AvatarOverview> {
  @override
  Widget build(BuildContext context) {
    // variables for size, for best view across platforms
    var barHeight = (MediaQuery.of(context).size.height) / 3;
    var barWidth = (MediaQuery.of(context).size.width);
    var imageHeight = (barHeight - 50);
    var imageWidth = (barWidth / 2) - 20;
    var progressBar = (imageWidth - 15);

    return Stack(
      children: <Widget>[
        ClipPath(
          child: Container(
              height: barHeight,
              width: barWidth,
              color: Color(0xFF4FB88B),
              padding: EdgeInsets.fromLTRB(20, 30, 20, 10),
              child: Row(
                children: <Widget>[
                  // Column for half bar, only image
                  Column(children: <Widget>[
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: Image.asset(
                        'assets/avatar-test.png',
                        height: imageHeight,
                        width: imageWidth,
                        fit: BoxFit.fill,
                      ),
                    )
                  ]),

                  // Column for second haf bar, character information
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //Settings symbol and onPressed functionality
                      Padding(
                        padding:
                            EdgeInsets.fromLTRB((barWidth / 2) - 45, 15, 0, 0),
                        child: Icon(
                          Icons.settings,
                          color: Colors.white,
                        ),
                        /*onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Settings()),
                            );
                          }*/
                      ),

                      //Username
                      Padding(
                        padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                        child: Text(
                          'Username',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),

                      //Level
                      Padding(
                        padding: EdgeInsets.fromLTRB(20, 10, 0, 0),
                        child: Text('Level',
                            style: TextStyle(color: Colors.white),
                            textAlign: TextAlign.left),
                      ),

                      //Progress bar
                      Padding(
                        padding: EdgeInsets.fromLTRB(15, 35, 0, 0),
                        child: LinearPercentIndicator(
                          width: progressBar,
                          lineHeight: 15,
                          backgroundColor: Colors.white,
                          progressColor: Color(0xFF4D3262),
                          percent: 0.5,
                          //bar shape
                          linearStrokeCap: LinearStrokeCap.roundAll,
                          animationDuration: 2000,
                        ),
                      ),

                      // XP / XP cap
                      Padding(
                        padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                        child: Text('XP/XP cap',
                            style: TextStyle(color: Colors.white),
                            textAlign: TextAlign.left),
                      ),
                    ],
                  ),
                ],
              )),
        )
      ],
    );
  }
}

//create state for workout overview
class WorkoutOverview extends StatefulWidget {
  @override
  _WorkoutOverviewState createState() => _WorkoutOverviewState();
}

// class for workout overview
class _WorkoutOverviewState extends State<WorkoutOverview> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
          // make sure the placement is centered and a little away from appbar
          padding: EdgeInsets.fromLTRB(50, 20, 50, 0),
          child: Column(
            children: <Widget>[
              // New container for text, aligned on the left
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  child: Text('Next planned workout:\n',
                      style: TextStyle(
                        color: Colors.black,
                      )),
                ),
              ),
              // call on workout widget
              workout
            ],
          ));
    });
  }

  // general workout info
  final workout = new Container(
    // add border for the workout info box
    decoration: BoxDecoration(
      border: Border.all(color: Colors.black, width: 0.25),
      color: Colors.black45,
    ),
    child: Column(
      // Text starts on the left, instead of centered as is the default
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        // container for title box
        Container(
          padding: EdgeInsets.all(5),
          // border to distinguish between the two containers within the box
          // Colour for the entire row
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 0.15),
            color: Colors.blue,
          ),
          child: Row(
            children: <Widget>[
              // add some space between left-side border and beginning of text
              Padding(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
              ),
              // new container for title
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  child: Text(
                    'Workout title',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),

        // container for changing information
        Container(
          padding: EdgeInsets.all(5),
          // border to distinguish between the two containers within the box
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 0.15),
          ),
          child: Row(
            children: <Widget>[
              // Column for information declaration
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'XP:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    // add space between lines
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Level:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    // add space between lines
                    SizedBox(
                      height: 10,
                    ),
                    Icon(
                      Icons.alarm,
                    ),
                  ],
                ),
              ),
              // Column for changing information
              Expanded(
                flex: 3,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '56',
                      ),
                      // add space between lines
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Intermediate',
                      ),
                      // add space between lines
                      SizedBox(
                        height: 18,
                      ),
                      Text(
                        '12 min',
                      ),
                    ]),
              ),
              // Column for button
              Expanded(
                flex: 3,
                child: Column(
                  children: <Widget>[
                    // add space to make the button stay at the bottom of the box
                    SizedBox(
                      height: 50,
                    ),
                    RaisedButton(
                      padding: EdgeInsets.all(10.0),
                      onPressed: () {},
                      elevation: 5.0,
                      color: Colors.deepOrange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.67),
                      ),
                      child: Text(
                        'See workout',
                        style: TextStyle(color: Colors.white, fontSize: 13.0),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
