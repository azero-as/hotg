import 'package:flutter/material.dart';
import 'login.dart';
import 'signup.dart';

class FrontPage extends StatefulWidget {
    static String tag = 'front-page';
    @override
    _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<FrontPage> {
    int counter = 0;
    List<String> strings = ['Flutter', 'is', 'cool', "and","awesome!"];
    String displayedString = "Heroes of the gym!";

    @override
    Widget build(BuildContext context) {
    //Welcome text
    final appName = new Text(
        'Heroes of the gym', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0,), textAlign: TextAlign.center,
    );

    //Login button
    final loginButton = Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        child: RaisedButton(
            elevation: 5.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
            ),
            onPressed: () {
                //TODO: eventhandler on log in button
                Navigator.of(context).pushNamed(LoginPage.tag);

            },
            padding: EdgeInsets.all(12),
            color: const Color(0xFF4FB88B),
            child: Text('Log In', style: TextStyle(color: Colors.white),),
        ),
    );

    //Login button
    final signupButton = Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        child: RaisedButton(
            elevation: 5.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
            ),
            onPressed: () {
                //TODO: eventhandler on log in button
                Navigator.of(context).pushNamed(SignupPage.tag);

            },
            padding: EdgeInsets.all(12),
            color: const Color(0xFF4FB88B),
            child: Text('Sign up', style: TextStyle(color: Colors.white),),
        ),
    );


        return Scaffold(
            appBar: AppBar(
                // Here we take the value from the MyHomePage object that was created by
                // the App.build method, and use it to set our appbar title.
                title: Text("test"),
                backgroundColor: Colors.green,
            ),
            body: Center(
                child: Container(
                    margin: EdgeInsets.fromLTRB(35, 0, 35, 50),
                    child: ListView(
                        shrinkWrap: true,
                        padding: EdgeInsets.only(left: 24.0, right: 24.0),
                        children: <Widget>[
                            appName,
                            SizedBox(height: 80.0,),
                            loginButton,
                            signupButton,
                        ],
                    ),
                )
            ),
        );
    }
}
