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
        return Scaffold(
            appBar: AppBar(
                // Here we take the value from the MyHomePage object that was created by
                // the App.build method, and use it to set our appbar title.
                title: Text("test"),
                backgroundColor: Colors.green,
            ),
            body: Container(
                // Center is a layout widget. It takes a single child and positions it
                // in the middle of the parent.

                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                        new Text(displayedString, style: new TextStyle(fontSize: 40.0)),
                        new Padding(padding: new EdgeInsets.all(10.0)),
                        new SizedBox(
                            width: 200.0,
                            height: 50.0,
                            child: new RaisedButton(
                                child: new Text(
                                    "Login",
                                    style: new TextStyle(color: Colors.white)
                                ),
                                color: Color(0xFF4AB98A),
                                onPressed: () {
                                    //TODO: eventhandler on log in button
                                    Navigator.of(context).pushNamed(LoginPage.tag);
                                },
                                shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),

                            ),

                        ),
                        new Container(
                            width: 200.0,
                            height: 50.0,
                            margin: const EdgeInsets.only(top: 10.0),
                            child: new RaisedButton(
                                child: new Text(
                                    "Sign up",
                                    style: new TextStyle(color: Colors.white)
                                ),
                                color: Colors.green,
                                onPressed: () {
                                    Navigator.of(context).pushNamed(SignupPage.tag);
                                },
                                shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                            ),

                        ),
                    ],
                ),
            ),
        );
    }
}
