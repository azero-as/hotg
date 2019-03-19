import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'authentication.dart';
import 'settings.dart';

// build the home page and call on the stateful classes
import 'models/user.dart';
import 'package:scoped_model/scoped_model.dart';

class Home extends StatelessWidget {
  static String tag = 'home-page';

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
            WorkoutOverview(),
            SizedBox(height: 20.0),
            Container(child:
            ScopedModelDescendant<User>(builder: (context, child, model) {
                return Container(
                    child: Column(children: [
                      new Text(model.level.toString()),
                      new RaisedButton(onPressed: () => model.incrementLevelByOne()),
                    ]));
            }))
          ],
        ));
  }
}

// create state for appbar of home page
class AvatarOverview extends StatefulWidget {
  AvatarOverview(
      {Key key,
      this.auth,
      this.userId,
      this.onSignedOut,
      this.title,
      this.signOut})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback signOut;
  final VoidCallback onSignedOut;
  final String userId;
  final String title;

  @override
  State createState() => new _AvatarOverviewState();
}

// class for appbar of home page
class _AvatarOverviewState extends State<AvatarOverview> {
  String _username = '';
    // Can it be int?
  int _userLevel;
    // Any way to make the next two int? Needs to be able to divide them
  int _userXp;
  int _xpCap;

    //Get levelcap of users level

    //calculate the progression to get the correct percentage in the progress bar
//    var progress = _userXP/_levelCap;

    @override
    void initState() {
      super.initState();

      CloudFunctions.instance
          .call(
        functionName: 'getUserInfo',
      )
          .then((response) {
        setState(() {
          _username = response['username'];
          _userLevel = response['userLevel'];
          _userXp = response['userXp'];
          _xpCap = response['xpCap'];
        });
      }).catchError((error) {
        print(error);
      });
    }
    @override
  Widget build(BuildContext context) {
    // variables for size, for best view across platforms
    var barHeight = (MediaQuery.of(context).size.height) / 3;
    var barWidth = (MediaQuery.of(context).size.width);
    var imageHeight = (barHeight - 55);
    var imageWidth = (barWidth / 2) - 20;
    var progressBar = (imageWidth - 15);

    return Stack(
      children: <Widget>[
        ClipPath(
          child: Container(
              height: barHeight,
              width: barWidth,
              color: Color(0xFF212838),
              padding: EdgeInsets.fromLTRB(20, 30, 20, 15),
              child: ScopedModelDescendant<User>(builder: (context, child, model) {
                return Row(
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
                      children: <Widget>[
                        //Settings symbol and onPressed functionality
                        /*IconButton(
                          icon: Icon(Icons.settings),
                          color: Colors.white,
                          padding: EdgeInsets.fromLTRB((barWidth / 2) - 44, 0, 0, 0),
                          onPressed: () {
                            widget.signOut();
                          }),*/

                        //Username
                        Padding(
                          padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                          child: Text(
                            model.characterName.toString(),
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            //textAlign: TextAlign.left,
                          ),
                        ),

                        //Level
                        Padding(
                          padding: EdgeInsets.fromLTRB(20, 10, 0, 0),
                          child: Text(
                              'Level: ${model.level.toString()}',
                              // 'Level' /* + _userLevel  + ' Intermediate thing?'*/,
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
                            percent: 0.2,
                            //bar shape
                            linearStrokeCap: LinearStrokeCap.roundAll,
                            animationDuration: 2000,
                          ),
                        ),

                        // XP / XP cap
                        Padding(
                          padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                          child: Text(/*_userXP +*/
                              '${model.xp.toString()}/${model.xpCap.toString()}' /* + _levelCap*/,
                              style: TextStyle(color: Colors.white),
                              textAlign: TextAlign.left),
                        ),
                      ],
                    ),
                  ],
                );
              })),
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
                        color: Color(0xFF525050),
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
      color: Color(0xFFE7E9ED),
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
            border: Border.all(color: Color(0xFF212838), width: 0.15),
            color: Color(0xFF212838),
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
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF434242)),
                    ),
                    // add space between lines
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Intensity:',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF434242)),
                    ),
                    // add space between lines
                    SizedBox(
                      height: 10,
                    ),
                    Icon(
                      Icons.alarm,
                      color: Color(0xFF434242),
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
                        style: TextStyle(color: Color(0xFF434242)),
                      ),
                      // add space between lines
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Medium',
                        style: TextStyle(color: Color(0xFF434242)),
                      ),
                      // add space between lines
                      SizedBox(
                        height: 18,
                      ),
                      Text(
                        '12 min',
                        style: TextStyle(color: Color(0xFF434242)),
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
                      color: Color(0xFF612A30),
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
