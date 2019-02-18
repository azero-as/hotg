import 'package:flutter/material.dart';
import 'dashboard.dart';
import 'signup.dart';
import 'frontpage.dart';
//This is the login page

class LoginPage extends StatefulWidget {

  static String tag = 'login-page';

  @override
  _LoginPageState createState() => new _LoginPageState();

}

class _LoginPageState extends State<LoginPage> {

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

    //Welcome text
    final welcomeText = new Text(
      'Welcome back!', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0,), textAlign: TextAlign.center,
    );

    //Email input field
    final email = TextFormField(
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        decoration: InputDecoration(
          icon: Icon(Icons.email),
          labelText: 'Email',
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border: UnderlineInputBorder(),
        )
    );

    //Password input field
    final password = TextFormField(
      autofocus: false,
      obscureText: true,
      decoration: InputDecoration(
        icon: Icon(Icons.lock),
        labelText: 'Password',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: UnderlineInputBorder(),
      ),
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
          Navigator.of(context).pushNamed(Dashboard.tag);
        },
        padding: EdgeInsets.all(12),
        color: const Color(0xFF4FB88B),
        child: Text('Log In', style: TextStyle(color: Colors.white),),
      ),
    );

    //Join here button
    final joinButton = FlatButton(
      child: RichText(
        text: TextSpan(
          text: 'Not already a hero? Join us ', style: TextStyle(color: Colors.black54),
          children: <TextSpan>[
            TextSpan(
              text: 'here!',
              style: TextStyle(
                color: Colors.black54,
                decoration: TextDecoration.underline,
                decorationColor: Colors.black54,
                decorationStyle: TextDecorationStyle.solid,
              ),
            ),
          ],
        ),
      ),
      onPressed: (){
        Navigator.of(context).pushNamed(SignupPage.tag);
      },
    );

    //Returns all the elements to the page
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: new AppBar(
        title: Text("Heroes Of The Gym", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        leading: IconButton(icon: Icon(Icons.arrow_back_ios),
            onPressed: (){
                Navigator.of(context).pop();
            }),
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
      ),
      body: Center(
          child: Container(
            margin: EdgeInsets.fromLTRB(35, 0, 35, 80),
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.only(left: 24.0, right: 24.0),
              children: <Widget>[
                logo,
                SizedBox(height: 40.0,),
                welcomeText,
                SizedBox(height: 48.0,),
                email,
                SizedBox(height: 18.0,),
                password,
                SizedBox(height: 15.0,),
                loginButton,
                joinButton
              ],
            ),
          )
      ),
    );
  }

}
