import 'package:flutter/material.dart';
import 'login.dart';
import 'signuplevel.dart';
import 'frontpage.dart';

//This is the signup page

class SignupPage extends StatefulWidget {

  static String tag = 'signup-page';

  @override
  _SignupPageState createState() => new _SignupPageState();

}

class _SignupPageState extends State<SignupPage> {

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
      'First, we need the basics', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0,), textAlign: TextAlign.center,
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

    //Password input field
    final passwordVertify = TextFormField(
      autofocus: false,
      obscureText: true,
      decoration: InputDecoration(
        icon: Icon(Icons.lock),
        labelText: 'Vertify Password',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: UnderlineInputBorder(),
      ),
    );

    //Next button
    final nextButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        onPressed: () {
          Navigator.of(context).pushNamed(SignupLevelPage.tag);
        },
        padding: EdgeInsets.all(12),
        color: const Color(0xFF4FB88B),
        child: Text('Next', style: TextStyle(color: Colors.white),),
      ),
    );

    //Join here button
    final joinButton = FlatButton(
      child: RichText(
        text: TextSpan(
          text: 'Already a hero? Log in ', style: TextStyle(color: Colors.black54),
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
        Navigator.of(context).pushNamed(LoginPage.tag);
      },
    );

    //Returns all the elements to the page
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: new AppBar(
        title: Text("Heroes Of The Gym", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        leading: IconButton(icon: Icon(Icons.arrow_back_ios),
            onPressed: (){
              //TODO Handle back button
              //() => Navigator.of(context).pop(); dont know if this is the right code
                Navigator.of(context).pushNamed(FrontPage.tag);
        }),
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
                logo,
                SizedBox(height: 40.0,),
                welcomeText,
                SizedBox(height: 48.0,),
                email,
                SizedBox(height: 18.0,),
                password,
                SizedBox(height: 15.0),
                passwordVertify,
                SizedBox(height: 15.0,),
                nextButton,
                joinButton
              ],
            ),
          )
      ),
    );
  }

}
