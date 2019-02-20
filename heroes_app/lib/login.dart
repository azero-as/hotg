import 'package:flutter/material.dart';
import 'authentication.dart';
import 'dashboard.dart';
import 'signup.dart';
import 'frontpage.dart';

//This is the login page

class LoginPage extends StatefulWidget {

  static String tag = 'login-page';

  LoginPage({this.auth, this.onSignedIn});

  final BaseAuth auth;
  final VoidCallback onSignedIn;

  @override
  _LoginPageState createState() => new _LoginPageState();

}

enum FormMode {LOGIN}

class _LoginPageState extends State<LoginPage> {

  final _formKey = new GlobalKey<FormState>();

  FormMode _formMode = FormMode.LOGIN;

  String _email;
  String _password;
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
        title: Text("Heroes Of The Gym", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        leading: IconButton(icon: Icon(Icons.arrow_back_ios),
            onPressed: (){
              //TODO Handle back button
              //() => Navigator.of(context).pop(); dont know if this is the right code
            }),
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
      ),
      body: Stack(
        children: <Widget>[
          _returnBody(),
          _showCircularProgress(),
        ],
      )
    );
  }

  //loading circle
  Widget _showCircularProgress(){
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    } return Container(height: 0.0, width: 0.0,);

  }

  Widget _showErrorMessage() {
    if (_errorMessage.length > 0 && _errorMessage != null) {
      return new Text(
        _errorMessage  = "Wrong email or password",
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

  // Check if form is valid before perform login
  bool _validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  // Perform login
  void _validateAndSubmit() async {
    setState(() {
      _errorMessage = "";
      _isLoading = true;
    });
    if (_email == null) {
      _isLoading = false;
    }
    if (_password == null) {
      _isLoading = false;
    }
    if (_validateAndSave()) {
      String userId = "";
      try {
        if (_formMode == FormMode.LOGIN) {
        userId = await widget.auth.signIn(_email, _password);
        print('Signed in: $userId');
        }

        setState(() {
          _isLoading = false;
        });

        if (userId.length > 0 && userId != null && _formMode == FormMode.LOGIN) {
          widget.onSignedIn();
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
  }

  @override
  void initState() {
    _errorMessage = "";
    _isLoading = false;
    super.initState();
  }


//---------FORM WIDGETS------------

  Widget _returnBody(){
    return new Container(
        padding: EdgeInsets.only(left: 24.0, right: 24.0),
        margin: EdgeInsets.fromLTRB(35, 0, 35, 80),
        child: new Form(
          key: _formKey,
          child: new ListView(
            shrinkWrap: true,
            children: <Widget>[
              _logo(),
              _textHeader("Welcome back!"),
              _emailInput(),
              _passwordInput(),
              _loginButton(),
              _joinButton(),
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
  Widget _textHeader(String t){
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
      child: new Text(
        t, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0,), textAlign: TextAlign.center,
      ),
    );
  }


  //Email input field
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
  Widget _passwordInput(){
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

  Widget _loginButton(){
    return Padding(
    padding: EdgeInsets.symmetric(vertical: 16.0),
    child: RaisedButton(
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
    ),
      onPressed: _validateAndSubmit,
      padding: EdgeInsets.all(12),
      color: const Color(0xFF4FB88B),
      child: Text('Log In', style: TextStyle(color: Colors.white),),
    ),
    );
  }

  //Join here button
  Widget _joinButton(){
    return FlatButton(
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
  }

}
