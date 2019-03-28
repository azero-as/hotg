import 'package:flutter/material.dart';
import 'authentication.dart';
import 'services/crud.dart';

//This is the singuplevel page

class SignupLevelPage extends StatefulWidget {
  static String tag = 'signupLevel-page';

  SignupLevelPage(
      {this.userId, this.auth, this.onSignedOut, this.title, this.onSignedIn});

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
  int _fitnessLevel = 1;
  int _rpgClassValue = 1;
  var _formKey = GlobalKey<FormState>();
  String _chooseClassDescription = "Please choose a class for your character. Your choice will determine the type of workouts that are recommended for you. You will still have access to all other available workouts. Your choice of a class should be based on your chosen training focus. If your main focus is to improve your strength, you get the choice of Barbarian, Paladin, or Fighter. With the Monk, Rogue, or Ranger class you get a mix of both strength and stamina based workouts.";

  // Adding start states for level and xp
  int _gameLevel = 1;
  int _xp = 0;
  String rpgClass = 'Barbarian';

  final charactername = TextEditingController();

  CrudMethods crudObj = new CrudMethods();

  @override
  Widget build(BuildContext context) {
    // -----------------------TEXT BOXES AND SPACING--------------------------
    Widget _headerText(String t){
      return Padding(
        padding: EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
        child: new Text(
          t,
          style: TextStyle(
            fontSize: 20.0,
          ),
          textAlign: TextAlign.left,
        ),
      );
    }

    Widget _descriptionText(String t){
      return Padding(
        padding: EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
        child: new Text(
          t,
          style: TextStyle(
            fontSize: 15.0,
          ),
          textAlign: TextAlign.left,
        ),
      );
    }

    Widget _space(double height){
      return SizedBox(
        height: height,
      );
    }

    // ----------------------------FORM FIELDS--------------------------------
    // ----RADIO BUTTONS for fitness level----
    final beginner = new RadioListTile(
        title: new Text('Beginner'),
        value: 1,
        groupValue: _fitnessLevel,
        onChanged: (int value) {
          setState(() {
            _fitnessLevel = value;
          });
        },
        activeColor: const Color(0xFF4D3262));

    final intermediate = new RadioListTile(
        title: new Text('Intermediate'),
        value: 2,
        groupValue: _fitnessLevel,
        onChanged: (int value) {
          setState(() {
            _fitnessLevel = value;
          });
        },
        activeColor: const Color(0xFF4D3262));

    final advanced = new RadioListTile(
        title: new Text('Advanced'),
        value: 3,
        groupValue: _fitnessLevel,
        onChanged: (int value) {
          setState(() {
            _fitnessLevel = value;
          });
        },
        activeColor: const Color(0xFF4D3262));

    
    // -------RADIO BUTTONS for class---------
    final barbarian = new RadioListTile(
        title: new Text('Barbarian'),
        subtitle: new Text(
            'A fierce warrior of primitive background who can enter a battle rage.'),
        value: 1,
        groupValue: _rpgClassValue,
        onChanged: (int value) {
          setState(() {
            _rpgClassValue = value;
            rpgClass = "Barbarian";
          });
        },
        activeColor: const Color(0xFF4D3262));

    final fighter = new RadioListTile(
        title: new Text('Fighter'),
        subtitle: new Text(
            'A holy warrior bound to a sacred oath.'),
        value: 2,
        groupValue: _rpgClassValue,
        onChanged: (int value) {
          setState(() {
            _rpgClassValue = value;
            rpgClass = "Fighter";
          });
        },
        activeColor: const Color(0xFF4D3262));

    final paladin = new RadioListTile(
        title: new Text('Paladin'),
        subtitle: new Text(
            'A master of martial combat, skilled with a variety of weapons and armor.'),
        value: 3,
        groupValue: _rpgClassValue,
        onChanged: (int value) {
          setState(() {
            _rpgClassValue = value;
            rpgClass = "Paladin";
          });
        },
        activeColor: const Color(0xFF4D3262));

    final monk = new RadioListTile(
        title: new Text('Monk'),
        subtitle: new Text(
            'A master of martial arts, harnessing the power of the body in pursuit of physical and spiritual perfection.'),
        value: 4,
        groupValue: _rpgClassValue,
        onChanged: (int value) {
          setState(() {
            _rpgClassValue = value;
            rpgClass = "Monk";
          });
        },
        activeColor: const Color(0xFF4D3262));

    final rogue = new RadioListTile(
        title: new Text('Rogue'),
        subtitle: new Text(
            'A scoundrel who uses stealth and trickery to overcome obstacles and enemies.'),
        value: 5,
        groupValue: _rpgClassValue,
        onChanged: (int value) {
          setState(() {
            _rpgClassValue = value;
            rpgClass = "Rogue";
          });
        },
        activeColor: const Color(0xFF4D3262));

    final ranger = new RadioListTile(
        title: new Text('Ranger'),
        subtitle: new Text(
            'A warrior who uses martial prowess and nature magic to combat threats on the edges of civilization.'),
        value: 6,
        groupValue: _rpgClassValue,
        onChanged: (int value) {
          setState(() {
            _rpgClassValue = value;
            rpgClass = "Ranger";
          });
        },
        activeColor: const Color(0xFF4D3262));

    //CharacterName input field
    final characterName = TextFormField(
        keyboardType: TextInputType.text,
        autofocus: false,
        validator: (value) => value.isEmpty
            ? 'You need to have a name for your character.'
            : null,
        controller: charactername,
        decoration: InputDecoration(
          labelText: 'Character Name',
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border: UnderlineInputBorder(),
        ));

    //LetsGo button
    final letsGoButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        onPressed: () {
          if (_formKey.currentState.validate()) {
            _formKey.currentState.save();
            print("Succeeded");
            crudObj.addFitnessLevel({
              'fitnessLevel': _fitnessLevel,
              'characterName': charactername.text,
              'gameLevel': _gameLevel,
              'xp': _xp,
              'class': rpgClass,
            }, widget.userId).catchError((e) {
              print(e);
            });
            widget.onSignedIn();
          }
        },
        padding: EdgeInsets.all(12),
        color: const Color(0xFF612A30),
        child: Text(
          'Lets Go!',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );

    //Returns all the elements to the page
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: new AppBar(
        title: Text("Heroes Of The Gym",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
        padding: EdgeInsets.only(left: 24.0, right: 24.0),
        child: SingleChildScrollView(
            child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    _space(40.0),
                    _descriptionText('Everyone starts in different places. Tell us a litte about your fitness experience in order for us to start you off at the right level and tailor the perfect workout plan for you!'),
                    _space(10.0),
                    _headerText('Select your current fitness level: '),
                    beginner,
                    intermediate,
                    advanced,
                    _descriptionText(_chooseClassDescription),
                    _headerText("Pick your class"),
                    _headerText("STRENGTH"),
                    barbarian,
                    fighter,
                    paladin,
                    _headerText("DEXTERITY"),
                    monk,
                    rogue,
                    ranger,
                    _headerText('Pick your character name: '),
                    characterName,
                    letsGoButton,
                  ],
                ))),
      )),
    );
  }
}
