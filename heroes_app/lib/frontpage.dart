import 'package:flutter/material.dart';
import 'login.dart';
import 'signup.dart';

class FrontPage extends StatefulWidget {
    static String tag = 'front-page';
    @override
    _FrontPageState createState() => _FrontPageState();
}

class _FrontPageState extends State<FrontPage> {

    @override
    Widget build(BuildContext context) {

    //placeholder for logo
    final logo = Hero(
        tag: 'hero',
        child: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: 60.0,
            child: Image.asset('assets/logo.png'),
        ),
    );
    //App name
    final appName = new Text(
        'Heroes of the gym', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0,), textAlign: TextAlign.center,
    );

    //Login button
    final loginButton = Padding(
        padding: EdgeInsets.symmetric(vertical: 0.0),
        child: RaisedButton(
            elevation: 5.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
            ),
            child: Text('Log In', style: TextStyle(color: const Color(0xFF4FB88B), fontSize: 20), ), color: Colors.white,
            onPressed: () {
                Navigator.of(context).pushNamed(LoginPage.tag);
            },
        ),
    );


    //Signup button
    final signupButton = Padding(
        padding: EdgeInsets.symmetric(vertical: 0.0),
        child: RaisedButton(
            color: const Color(0xFF4FB88B),
            shape: OutlineInputBorder(
                borderRadius: BorderRadius.circular(60),
                borderSide: BorderSide(
                    width: 1.0,
                    color: Colors.white
                )
            ),
            child: GestureDetector(
                child: Center(
                    child: Text('Sign up',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                        )
                    ),
                )
            ),
            onPressed: () {
                Navigator.of(context).pushNamed(SignupPage.tag);
            },
        ),
    );


        return Scaffold(
            appBar: AppBar(
                backgroundColor: const Color(0xFF4FB88B),
                elevation: 0.0,
                automaticallyImplyLeading: false,
            ),
            backgroundColor: const Color(0xFF4FB88B),
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
                        SizedBox(height: 120.0),
                        Container(
                            height: 40.0,
                            width: 250.0,
                            child: loginButton,
                        ),
                        SizedBox(height: 20.0),
                        Container(
                            height: 40.0,
                            width: 250.0,
                            child: signupButton,
                            )
                        ],
                    )
                ],
            ),
        );
    }
}
