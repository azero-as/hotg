import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:flutter/material.dart';

class FrontPage extends StatefulWidget {
  static String tag = 'front-page';

  @override
  _FrontPageState createState() => _FrontPageState();

  FrontPage({this.readyToLogIn, this.readyToSignUp});

  final VoidCallback readyToLogIn;
  final VoidCallback readyToSignUp;
}

class _FrontPageState extends State<FrontPage> {
  @override
  Widget build(BuildContext context) {
    // Make sure status bar colour matches the rest of the page
    FlutterStatusbarcolor.setStatusBarColor(Color(0xFF212838));

    //placeholder for logo
    final logo = new Hero(
      tag: 'hero',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 60.0,
        child: Image.asset('assets/logo2.png'),
      ),
    );

    //App name
    final appName = new Text(
      'Heroes of the Gym',
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 25.0,
      ),
      textAlign: TextAlign.center,
    );

    //Login button
    final loginButton = new Container(
      margin: const EdgeInsets.only(left: 30, right: 30),
      child: RaisedButton(
        elevation: 5.0,
        color: const Color(0xFFFFFFFF),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(60),
        ),
        child: GestureDetector(
            child: Center(
          child: Text(
            'Log In',
            style: TextStyle(
              color: const Color(0xFF212838),
              fontSize: 20.0,
            ),
          ),
        )),
        key: Key('LogIn'),
        onPressed: () {
          widget.readyToLogIn();
        },
      ),
    );

    //Signup button
    final signupButton = new Container(
      margin: const EdgeInsets.only(left: 30, right: 30),
      child: RaisedButton(
        color: const Color(0xFF212838),
        elevation: 5.0,
        shape: OutlineInputBorder(
            borderRadius: BorderRadius.circular(60),
            borderSide: BorderSide(width: 1.0, color: Colors.white)),
        child: GestureDetector(
            child: Center(
          child: Text('Sign Up',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
              )),
        )),
        key: Key('SignUp'),
        onPressed: () {
          widget.readyToSignUp();
        },
      ),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF212838),
        elevation: 0.0,
        automaticallyImplyLeading: false,
      ),
      backgroundColor: const Color(0xFF212838),
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  logo,
                ],
              ),
              SizedBox(height: 10.0),
              appName,
              SizedBox(height: 80.0),
              loginButton,
              SizedBox(height: 20.0),
              signupButton,
            ],
          )
        ],
      ),
    );
  }
}
