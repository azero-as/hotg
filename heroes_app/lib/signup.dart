import 'package:flutter/material.dart';
import 'login.dart';
import 'authentication.dart';
import 'rootpage.dart';

//This is the signup page

class SignupPage extends StatefulWidget {

  static String tag = 'signup-page';

  SignupPage({this.auth, this.onSignedIn, this.readyToLogIn, this.onSignedOut, this.finishedSignedUp});

  final BaseAuth auth;
  final VoidCallback onSignedIn;
  final VoidCallback readyToLogIn;
  final VoidCallback onSignedOut;
  final VoidCallback finishedSignedUp;

  @override
  _SignupPageState createState() => new _SignupPageState();

}

enum FormMode {SIGNUP}

class _SignupPageState extends State<SignupPage> {

  final _formKey = new GlobalKey<FormState>();

  FormMode _formMode = FormMode.SIGNUP;

  String _email;
  String _password;
  String _passwordVerification;
  String _errorMessage;

  bool _isIos;
  bool _isLoading;

  @override
  Widget build(BuildContext context) {

    _isIos = Theme.of(context).platform == TargetPlatform.iOS;

    //Returns all the elements to the page
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: new AppBar(
        title: Text("Heroes of the Gym", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        leading: IconButton(icon: Icon(Icons.arrow_back_ios),
            onPressed: (){
                widget.onSignedOut();
        }),
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
      ),
      body: Stack(
        children: <Widget>[
          _returnForm(),
          _showCircularProgress(),
          ],
            ),
    );

  }

  // ------ FORM WIDGETS ------
  Widget _returnForm(){
    return new Container(
        padding: EdgeInsets.only(left: 24.0, right: 24.0),
        margin: EdgeInsets.fromLTRB(35, 0, 35, 35),
        child: new Form(
          key: _formKey,
          child: new ListView(
            shrinkWrap: true,
            children: <Widget>[
              _logo(),
              _welcomeText('First, we need the basics'),
              _emailInput(),
              _passwordInput1(),
              _passwordInput2(),
              _nextButton(),
              _loginButton(),
              _showErrorMessage(),
            ],
          ),
        ));
  }

  //placeholder for logo
  Widget _logo(){
    return new Hero(
      tag: 'hero',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 60.0,
        child: Image.asset('assets/logo.png'),
      ),
    );
  }

  //Welcome text
  Widget _welcomeText(String t){
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
      child: new Text(
        t, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0,), textAlign: TextAlign.center,
      ),
    );
  }

  Widget _emailInput(){
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 50.0, 0.0, 0.0),
      child: TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        decoration: InputDecoration(
          icon: Icon(Icons.email),
          labelText: 'Email',
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border: UnderlineInputBorder(),
        ),
        validator: (value) => value.isEmpty ? 'Email can\'t be empty' : null,
        onSaved: (value) => _email = value,
      ),
    );
  }

  //Password input field
  Widget _passwordInput1(){
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 15.00, 0.0, 0.0),
      child: TextFormField(
        autofocus: false,
        maxLines: 1,
        obscureText: true,
        decoration: InputDecoration(
          icon: Icon(Icons.lock),
          labelText: 'Password',
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border: UnderlineInputBorder(),
        ),
        validator: (value) => value.isEmpty ? 'Password can\'t be empty' : null,
        onSaved: (value) => _password = value,
      ),
    );
  }

  //Password confirmation input field
  Widget _passwordInput2(){
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 15.00, 0.0, 0.0),
      child: TextFormField(
        autofocus: false,
        maxLines: 1,
        obscureText: true,
        decoration: InputDecoration(
          icon: Icon(Icons.lock),
          labelText: 'Verify password',
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border: UnderlineInputBorder(),
        ),
        validator: (value) => value.isEmpty ? 'You need to verify your password' : null,
        onSaved: (value) => _passwordVerification = value,
      ),
    );
  }

  Widget _nextButton(){
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        onPressed: _validateAndSubmit,
            //TODO: Navigate to signuplevel, then sign up.
            //Navigator.of(context).pushNamed(SignupLevelPage.tag);
        padding: EdgeInsets.all(12),
        color: const Color(0xFF4FB88B),
        child: Text('Sign up and continue', style: TextStyle(color: Colors.white),),
      ),
    );
  }

  //Login here button
  Widget _loginButton(){
    return FlatButton(
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
        widget.readyToLogIn();
      },
    );
  }

  Widget _showErrorMessage() {
    if (_errorMessage.length > 0 && _errorMessage != null) {
      return new Text(
        _errorMessage,
        style: TextStyle(
            fontSize: 13.0,
            color: Colors.red,
            height: 1.0,
            fontWeight: FontWeight.w300),
      );
    } else {
      return new Container(
        height: 0.0,
      );
    }
  }

  @override
  void initState() {
    _errorMessage = "";
    _isLoading = false;
    super.initState();
  }

  // Check if form is valid before perform signup
  bool _validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      // Check if passwords are equal
      if (_passwordVerification==_password) {
        return true;
      }
      else {
        setState(() {
          _errorMessage = "Passwords are different";
        });
      }
    }
    return false;
  }

  // Perform signup
  void _validateAndSubmit() async {
    setState(() {
      _errorMessage = "";
      _isLoading = true;
    });

    if (_validateAndSave()) {
      String userId = "";
      try {
        if (_formMode == FormMode.SIGNUP) {
          userId = await widget.auth.signUp(_email, _password);
          print('Signed up: $userId');
        }

        setState(() {
          _isLoading = false;
        });

        if (userId.length > 0 && userId != null &&
            _formMode == FormMode.SIGNUP) {
          widget.finishedSignedUp();
        }
      } catch (e) {
        print('Error: $e');
        setState(() {
          _isLoading = false;
          if (_isIos) {
            _errorMessage = e.message;
          } else
            _errorMessage = e.message;
        });
      }
    }
    // To prevent loading circle to continue if you've clicked the next button twice with no passwords set.
    else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  //loading circle
  Widget _showCircularProgress(){
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    } return Container(height: 0.0, width: 0.0,);

  }

}
