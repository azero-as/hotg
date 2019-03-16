import 'package:flutter/material.dart';
import 'authentication.dart';
import 'services/crud.dart';

//This is the singuplevel page

class SignupLevelPage extends StatefulWidget {

  static String tag = 'signupLevel-page';

  SignupLevelPage({this.userId, this.auth, this.onSignedOut, this.title, this.onSignedIn});

  final String userId;
  final BaseAuth auth;
  final VoidCallback onSignedOut;
  final String title;
  final VoidCallback onSignedIn;


  @override
  _SignupLevelPageState createState() => new _SignupLevelPageState();

}

class _SignupLevelPageState extends State<SignupLevelPage> {

  // Radio button start state
  int _fitnessLevel;
  int _rpgClassValue;

  // Adding start states for level and xp
  int _level = 1;
  int _XP = 0;
  String rpgClass = '';


  final charactername = TextEditingController();

  CrudMethods crudObj = new CrudMethods();

  @override
  Widget build(BuildContext context) {


    //Welcome text
    final infoText = new Text(
      'Everyone starts in different places. Tell us a litte about your fitness experience in order for us to start you off at the right level and tailor the perfect workout plan for you!', style: TextStyle(fontSize: 15.0,), textAlign: TextAlign.left,
    );

    //Select Level Info text
    final selectLevelText = new Text(
      'Select your current fitness level: ', style: TextStyle(fontSize: 20.0,), textAlign: TextAlign.left,
    );

    //RADIO BUTTONS
    final beginner = new RadioListTile(
        title: new Text('Beginner'),
        value: 1,
        groupValue: _fitnessLevel,
        onChanged: (int value) { setState(() { _fitnessLevel = value; }); },
        activeColor: const Color(0xFF4D3262)
    );

    final intermediate = new RadioListTile(
      title: new Text('Intermediate'),
      value: 2,
      groupValue: _fitnessLevel,
      onChanged: (int value) { setState(() { _fitnessLevel = value; }); },
      activeColor: const Color(0xFF4D3262)
    );

    final advanced = new RadioListTile(
      title: new Text('Advanced'),
      value: 3,
      groupValue: _fitnessLevel,
      onChanged: (int value) { setState(() { _fitnessLevel = value; }); },
      activeColor: const Color(0xFF4D3262)
    );



    //CharacterName Info text
    final characterNameText = new Text(
      'Pick your character name: ', style: TextStyle(fontSize: 20.0,), textAlign: TextAlign.left,
    );

    //CharacterName input field
    final characterName = TextFormField(
        keyboardType: TextInputType.text,
        autofocus: false,
        controller: charactername,
        decoration: InputDecoration(
          labelText: 'Character Name',
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border: UnderlineInputBorder(),
        )
    );

    //LetsGo button
    final letsGoButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        onPressed: () {
          crudObj.addFitnessLevel({
            'Fitness level': _fitnessLevel,
            'Username': charactername.text,
            'Level':_level,
            'XP':_XP,
            'class': rpgClass,
          }, widget.userId).catchError((e) {
            print(e);
          });
          widget.onSignedIn();
        },
        padding: EdgeInsets.all(12),
        color: const Color(0xFF612A30),
        child: Text('Lets Go!', style: TextStyle(color: Colors.white),),
      ),
    );


    //RADIO BUTTONS
    final weightloss = new RadioListTile(
        title: new Text('Tank'),
        subtitle: new Text(
            'This is the right class for you if you want to loose weight'),
        value: 1,
        groupValue: _rpgClassValue,
        onChanged: (int value) {
          setState(() {
            _rpgClassValue = value;
            rpgClass = "Tank";
          });
        },
        activeColor: const Color(0xFF4D3262)
    );

    final strength = new RadioListTile(
        title: new Text('Warrior'),
        subtitle: new Text(
            'This is the right class for you if you want to gain strength'),
        value: 2,
        groupValue: _rpgClassValue,
        onChanged: (int value) {
          setState(() {
            _rpgClassValue = value;
            rpgClass = "Warrior";
          });
        },
        activeColor: const Color(0xFF4D3262)
    );

    final fitness = new RadioListTile(
        title: new Text('Traveller'),
        subtitle: new Text(
            'This is the right class for you if you want to improve your fitness'),
        value: 3,
        groupValue: _rpgClassValue,
        onChanged: (int value) {
          setState(() {
            _rpgClassValue = value;
            rpgClass = "Traveller";
          });
        },
        activeColor: const Color(0xFF4D3262)
    );

    //Returns all the elements to the page
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: new AppBar(
        title: Text("Heroes Of The Gym", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          // No need to have this when you have to get through this point to go on, and are already signed up?
/*        leading: IconButton(icon: Icon(Icons.arrow_back_ios),
            onPressed: (){
              Navigator.of(context).pop(SignupPage.tag);
            }),*/
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
      ),
      body: Center(
          child: Container(
            margin: EdgeInsets.fromLTRB(35, 0, 35, 30),
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.only(left: 24.0, right: 24.0),
              children: <Widget>[
                SizedBox(height: 40.0,),
                characterNameText,
                characterName,
                SizedBox(height: 28.0,),
                selectLevelText,
                infoText,
                beginner,
                intermediate,
                advanced,
                SizedBox(height: 25.0,),
                new Text('Pick your class', style: TextStyle(fontSize: 20.0,), textAlign: TextAlign.left,),
                new Text('Everyone has different goals for exercising, choose a class to get exercise sets which suits your goal!', style: TextStyle(fontSize: 15.0,), textAlign: TextAlign.left,),
                weightloss,
                strength,
                fitness,
                letsGoButton,
              ],
            ),
          )
      ),
    );
  }

}