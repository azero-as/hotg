import 'package:flutter/material.dart';
import "package:flutter_swiper/flutter_swiper.dart";
import 'authentication.dart';
import 'services/crud.dart';
import 'modifiedSwiperControl.dart';
import 'ensureVisibleWhenFocused.dart';

class SignupSwiperPage extends StatefulWidget {
  SignupSwiperPage(
      {Key key,
      this.userId,
      this.auth,
      this.onSignedIn,
      this.title,
      this.onSignedOut})
      : super(key: key);

  final String userId;
  final BaseAuth auth;
  final VoidCallback onSignedOut;
  final String title;
  final VoidCallback onSignedIn;
  static String tag = 'signupSwiperPage';

  @override
  _SignupSwiperState createState() => new _SignupSwiperState();
}

class _SignupSwiperState extends State<SignupSwiperPage> {
  // Radio button start state
  int _fitnessLevel = 1;
  int _rpgClassValue = 1;
  var _charNameFormKey = GlobalKey<FormState>();

  FocusNode _focusNodeCharacter = new FocusNode();

  // Descriptions for choosing a class
  String _chooseClassDescription =
      "Find your band of brothers and sisters by choosing a class for your character. Your choice will determine the type of workouts that are recommended for you.";
  String _strengthDescription =
      "Pick one of these classes if your main focus is to improve your strength";
  String _dexterityDescription =
      "If instead you want to receive a mix of strength and stamina workouts one of these might be a better choice.";

  // Adding start states for level, xp and rpgClass
  int _gameLevel = 1;
  int _xp = 0;
  String rpgClass = 'Barbarian';

  bool _isIos;
  bool _isAndroid;
  bool _charNameIsValid = false;
  final charactername = TextEditingController();
  CrudMethods crudObj = new CrudMethods();

  void _saveInfo() async {
    try {
      crudObj.addFitnessLevel({
        'fitnessLevel': _fitnessLevel,
        'characterName': charactername.text,
        'gameLevel': _gameLevel,
        'xp': _xp,
        'class': rpgClass,
      }, widget.userId).then((_) => {widget.onSignedIn()});
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    _isIos = Theme.of(context).platform == TargetPlatform.iOS;
    _isAndroid = Theme.of(context).platform == TargetPlatform.android;

    //CharacterName input field
    final characterName = EnsureVisibleWhenFocused(
      focusNode: _focusNodeCharacter,
      child: TextFormField(
        maxLength: 27,
        keyboardType: TextInputType.text,
        autofocus: false,
        focusNode: _focusNodeCharacter,
        validator: (value) =>
            value.length == 0 ? 'Every hero needs a name' : null,
        controller: charactername,
        decoration: InputDecoration(
          errorStyle: TextStyle(fontSize: 14),
          labelText: 'Character Name',
          contentPadding: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
          border: UnderlineInputBorder(),
        ),
      ),
    );

    // -------RADIO BUTTONS for class---------
    final barbarian = new RadioListTile(
        title: new Text('Barbarian'),
        subtitle: new Text(
            'A fierce warrior of primitive background who can enter a battle rage.'),
        value: 1,
        groupValue: _rpgClassValue,
        onChanged: (int value) {
          FocusScope.of(context).requestFocus(new FocusNode());
          setState(() {
            _rpgClassValue = value;
            rpgClass = "Barbarian";
          });
        },
        activeColor: Colors.white);

    final fighter = new RadioListTile(
        title: new Text('Fighter'),
        subtitle: new Text(
            'A master of martial combat, skilled with a variety of weapons and armour.'),
        value: 2,
        groupValue: _rpgClassValue,
        onChanged: (int value) {
          FocusScope.of(context).requestFocus(new FocusNode());
          setState(() {
            _rpgClassValue = value;
            rpgClass = "Fighter";
          });
        },
        activeColor: Colors.white);

    final paladin = new RadioListTile(
        title: new Text('Paladin'),
        subtitle: new Text('A holy warrior bound to a sacred oath.'),
        value: 3,
        groupValue: _rpgClassValue,
        onChanged: (int value) {
          FocusScope.of(context).requestFocus(new FocusNode());
          setState(() {
            _rpgClassValue = value;
            rpgClass = "Paladin";
          });
        },
        activeColor: Colors.white);

    final monk = new RadioListTile(
        title: new Text('Monk'),
        subtitle: new Text(
            'A master of martial arts, harnessing the power of the body in pursuit of physical and spiritual perfection.'),
        value: 4,
        groupValue: _rpgClassValue,
        onChanged: (int value) {
          FocusScope.of(context).requestFocus(new FocusNode());
          setState(() {
            _rpgClassValue = value;
            rpgClass = "Monk";
          });
        },
        activeColor: Colors.white);

    final rogue = new RadioListTile(
        title: new Text('Rogue'),
        subtitle: new Text(
            'A scoundrel who uses stealth and trickery to overcome obstacles and enemies.'),
        value: 5,
        groupValue: _rpgClassValue,
        onChanged: (int value) {
          FocusScope.of(context).requestFocus(new FocusNode());
          setState(() {
            _rpgClassValue = value;
            rpgClass = "Rogue";
          });
        },
        activeColor: Colors.white);

    final ranger = new RadioListTile(
        title: new Text('Ranger'),
        subtitle: new Text(
            'A warrior who uses martial prowess and nature magic to combat threats on the edges of civilization.'),
        value: 6,
        groupValue: _rpgClassValue,
        onChanged: (int value) {
          FocusScope.of(context).requestFocus(new FocusNode());
          setState(() {
            _rpgClassValue = value;
            rpgClass = "Ranger";
          });
        },
        activeColor: Colors.white);

    // ----RADIO BUTTONS for fitness level----
    final beginner = new RadioListTile(
        title: new Text('Beginner'),
        subtitle: new Text(
            "Little or no previous experience with working out. Works out 0-1 time a week."),
        value: 1,
        groupValue: _fitnessLevel,
        onChanged: (int value) {
          FocusScope.of(context).requestFocus(new FocusNode());
          setState(() {
            _fitnessLevel = value;
          });
        },
        activeColor: Colors.white);

    final intermediate = new RadioListTile(
        title: new Text('Intermediate'),
        subtitle: new Text(
            "Some previous experience with working out and works out 2-3 times a week."),
        value: 2,
        groupValue: _fitnessLevel,
        onChanged: (int value) {
          FocusScope.of(context).requestFocus(new FocusNode());
          setState(() {
            _fitnessLevel = value;
          });
        },
        activeColor: Colors.white);

    final advanced = new RadioListTile(
        title: new Text('Advanced'),
        subtitle: new Text(
            "Extensive experience and knowledge about exercise. Has worked out for 4+ times a week for an extended period of time."),
        value: 3,
        groupValue: _fitnessLevel,
        onChanged: (int value) {
          FocusScope.of(context).requestFocus(new FocusNode());
          setState(() {
            _fitnessLevel = value;
          });
        },
        activeColor: Colors.white);

    //LetsGo button
    final letsGoButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        // disables button if character name is not valid
        onPressed: !_charNameIsValid ? null : _saveInfo,
        padding: EdgeInsets.all(12),
        color: const Color(0xFF612A30),
        child: Text(
          'Let\'s go!',
          style: TextStyle(color: Colors.white, fontSize: 18.0),
        ),
      ),
    );

    // Different build for character name page based on device
    Widget _characterNameContainer() {
      if (_isIos) {
        return Container(
          margin: EdgeInsets.fromLTRB(35, 0, 35, 30),
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Form(
                  key: _charNameFormKey,
                  child: Column(
                    children: <Widget>[
                      _space(60.0),
                      _logo(),
                      _headerText('Pick your character name'),
                      _descriptionText(
                          'Every hero needs a suitable name! Start your journey by picking a character name.'),
                      _space(40),
                      Container(width: 250, child: characterName),
                    ],
                  ),
                  onChanged: () {
                    setState(() {});
                    if (_charNameFormKey.currentState.validate()) {
                      _charNameIsValid = true;
                      _charNameFormKey.currentState.save();
                    } else {
                      _charNameIsValid = false;
                    }
                  },
                )
              ],
            ),
          ),
        );
      } else if (_isAndroid) {
        return Container(
          margin: EdgeInsets.fromLTRB(35, 0, 35, 30),
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Form(
                  key: _charNameFormKey,
                  child: Column(
                    children: <Widget>[
                      _space(60.0),
                      _logo(),
                      _headerText('Pick your character name'),
                      _descriptionText(
                          'Every hero needs a suitable name! Start your journey by picking a character name.'),
                      _space(40),
                      Container(width: 250, child: characterName),
                      _space(300),
                    ],
                  ),
                  onChanged: () {
                    setState(() {});
                    if (_charNameFormKey.currentState.validate()) {
                      _charNameIsValid = true;
                      _charNameFormKey.currentState.save();
                    } else {
                      _charNameIsValid = false;
                    }
                  },
                )
              ],
            ),
          ),
        );
      }
    }

    return new Theme(
        // set theme data for this class to dark
        data: ThemeData.dark(),
        child: Scaffold(
          backgroundColor: const Color(0xFF212838),
          body: new Swiper.children(
            loop: false,
            autoplay: false,
            pagination: new SwiperPagination(
                builder: new DotSwiperPaginationBuilder(
                    color: Colors.grey,
                    activeColor: Colors.white,
                    size: 8.5,
                    activeSize: 10.0)),
            control: new ModifiedSwiperControl(color: Colors.white),
            children: <Widget>[
              Center(child: _characterNameContainer()),
              Center(
                child: Container(
                  margin: EdgeInsets.fromLTRB(35, 20, 35, 30),
                  padding: EdgeInsets.only(left: 24.0, right: 24.0),
                  child: SingleChildScrollView(
                      child: Column(
                    children: <Widget>[
                      _headerText("Pick your class"),
                      _descriptionText(_chooseClassDescription),
                      _subHeaderText("STRENGTH"),
                      _descriptionText(_strengthDescription),
                      barbarian,
                      fighter,
                      paladin,
                      _subHeaderText("DEXTERITY"),
                      _descriptionText(_dexterityDescription),
                      monk,
                      rogue,
                      ranger
                    ],
                  )),
                ),
              ),
              Container(
                  margin: EdgeInsets.fromLTRB(35, 20, 35, 30),
                  padding: EdgeInsets.only(left: 24.0, right: 24.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        _space(20),
                        _headerText("Select your current fitness level"),
                        _descriptionText(
                            "Everyone starts in different places. Select your current fitness level in order to receive workouts tailored to your current level."),
                        _space(10.0),
                        beginner,
                        intermediate,
                        advanced,
                        _space(20.0),
                        _errorMessage(),
                        letsGoButton,
                        _space(150),
                      ],
                    ),
                  ))
            ],
          ),
        ));
  }

// -----------------------TEXT BOXES AND SPACING--------------------------
  Widget _headerText(String text) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 40.0, 0.0, 10.0),
      child: new Text(
        text,
        style: TextStyle(
          fontSize: 22.0,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _subHeaderText(String text) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 10.0),
      child: new Text(
        text,
        style: TextStyle(
          fontSize: 20.0,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _descriptionText(String text) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
      child: new Text(
        text,
        style: TextStyle(
          fontSize: 16.0,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _errorMessage() {
    if (!_charNameIsValid) {
      return Text(
          "You shall not pass.. without a character name. Please go back and create one!",
          style: TextStyle(color: Colors.red),
          textAlign: TextAlign.center);
    }
    return Container(height: 0.0, width: 0.0);
  }

  Widget _space(double height) {
    return SizedBox(
      height: height,
    );
  }

  //placeholder for logo
  Widget _logo() {
    return new Hero(
      tag: 'hero',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 60.0,
        child: Image.asset('assets/logo1.png'),
      ),
    );
  }
}
