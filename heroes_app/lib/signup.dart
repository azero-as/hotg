import 'package:flutter/material.dart';
import 'authentication.dart';
import 'ensureVisibleWhenFocused.dart';

//This is the signup page

class SignupPage extends StatefulWidget {
  static String tag = 'signup-page';

  SignupPage(
      {this.auth,
      this.onSignedIn,
      this.readyToLogIn,
      this.onSignedOut,
      this.finishedSignedUp});

  final BaseAuth auth;
  final VoidCallback onSignedIn;
  final VoidCallback readyToLogIn;
  final VoidCallback onSignedOut;
  final VoidCallback finishedSignedUp;

  @override
  _SignupPageState createState() => new _SignupPageState();
}

enum FormMode { SIGNUP }

class _SignupPageState extends State<SignupPage> {
  static final _formKey = new GlobalKey<FormState>();

  FocusNode _focusNodeEmail = new FocusNode();
  FocusNode _focusNodePassword = new FocusNode();
  FocusNode _focusNodePassword2 = new FocusNode();

  FormMode _formMode = FormMode.SIGNUP;

  String _email;
  String _password;
  String _passwordVerification;
  String _errorMessage;

  bool _isIos;
  bool _isAndroid;
  bool _isLoading;

  @override
  Widget build(BuildContext context) {
    _isIos = Theme.of(context).platform == TargetPlatform.iOS;
    _isAndroid = Theme.of(context).platform == TargetPlatform.android;

    //Returns all the elements to the page
    return new Theme(
        // set theme data for this class to dark
        data: ThemeData.dark(),
        child: Scaffold(
          backgroundColor: const Color(0xFF212838),
          appBar: new AppBar(
            backgroundColor: const Color(0xFF212838),
            leading: IconButton(
                icon: Icon(Icons.arrow_back_ios),
                key: Key("signupBackButton"),
                onPressed: () {
                  widget.onSignedOut();
                }),
          ),
          body: Stack(
            children: <Widget>[
              _returnForm(),
              _showCircularProgress(),
            ],
          ),
        ));
  }

  // ------ FORM WIDGETS ------
  _returnForm() {
    if (_isIos) {
      return new Container(
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          margin: EdgeInsets.fromLTRB(35, 0, 35, 35),
          child: new Form(
            key: _formKey,
            child: new ListView(
              shrinkWrap: true,
              children: <Widget>[
                SizedBox(height: 25.0),
                _logo(),
                _welcomeText('First we need the basics'),
                _emailInput(),
                _passwordInput1(),
                _passwordInput2(),
                _nextButton(),
                _loginButton(),
                _showErrorMessage(),
              ],
            ),
          ));
    } else if (_isAndroid) {
      return new Container(
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          margin: EdgeInsets.fromLTRB(35, 0, 35, 35),
          child: new Form(
            key: _formKey,
            child: new ListView(
              shrinkWrap: true,
              children: <Widget>[
                SizedBox(height: 25.0),
                _logo(),
                _welcomeText('First we need the basics'),
                _emailInput(),
                _passwordInput1(),
                _passwordInput2(),
                _nextButton(),
                _loginButton(),
                _showErrorMessage(),
                SizedBox(height: 250),
              ],
            ),
          ));
    }
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

  //Welcome text
  Widget _welcomeText(String t) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
      child: new Text(
        t,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 25.0,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _emailInput() {
    return EnsureVisibleWhenFocused(
        focusNode: _focusNodeEmail,
        child: Padding(
          padding: EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
          child: TextFormField(
            maxLines: 1,
            keyboardType: TextInputType.emailAddress,
            autofocus: false,
            focusNode: _focusNodeEmail,
            key: Key("signupEmail"),
            decoration: InputDecoration(
              icon: Icon(Icons.email),
              labelText: 'Email',
              contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              border: UnderlineInputBorder(),
            ),
            validator: (value) =>
                value.isEmpty ? 'Email can\'t be empty' : null,
            onSaved: (value) => _email = value,
          ),
        ));
  }

  //Password input field
  Widget _passwordInput1() {
    return EnsureVisibleWhenFocused(
        focusNode: _focusNodePassword,
        child: Padding(
          padding: EdgeInsets.fromLTRB(0.0, 15.00, 0.0, 0.0),
          child: TextFormField(
            autofocus: false,
            focusNode: _focusNodePassword,
            key: Key("signupPassword"),
            maxLines: 1,
            obscureText: true,
            decoration: InputDecoration(
              icon: Icon(Icons.lock),
              labelText: 'Password',
              contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              border: UnderlineInputBorder(),
            ),
            validator: (value) =>
                value.isEmpty ? 'Password can\'t be empty' : null,
            onSaved: (value) => _password = value,
          ),
        ));
  }

  //Password confirmation input field
  Widget _passwordInput2() {
    return EnsureVisibleWhenFocused(
        focusNode: _focusNodePassword2,
        child: Padding(
          padding: EdgeInsets.fromLTRB(0.0, 15.00, 0.0, 0.0),
          child: TextFormField(
            autofocus: false,
            focusNode: _focusNodePassword2,
            key: Key("signupPassword2"),
            maxLines: 1,
            obscureText: true,
            decoration: InputDecoration(
              icon: Icon(Icons.lock),
              labelText: 'Verify password',
              contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              border: UnderlineInputBorder(),
            ),
            validator: (value) =>
                value.isEmpty ? 'Password needs to be verified' : null,
            onSaved: (value) => _passwordVerification = value,
          ),
        ));
  }

  Widget _nextButton() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      key: Key("SignUp2"),
      child: RaisedButton(
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        onPressed: _validateAndSubmit,
        //TODO: Navigate to signuplevel, then sign up.
        padding: EdgeInsets.all(12),
        color: const Color(0xFF612A30),
        child: Text(
          'Sign up and continue',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  //Login here button
  Widget _loginButton() {
    return FlatButton(
      child: RichText(
        text: TextSpan(
          text: 'Already a hero? Log in ',
          children: <TextSpan>[
            TextSpan(
              text: 'here!',
              style: TextStyle(
                decoration: TextDecoration.underline,
                decorationStyle: TextDecorationStyle.solid,
              ),
            ),
          ],
        ),
      ),
      onPressed: () {
        widget.readyToLogIn();
      },
    );
  }

  Widget _showErrorMessage() {
    if (_errorMessage.length > 0 && _errorMessage != null) {
      return new Text(
        _errorMessage,
        key: Key("SignUpErrorMessage"),
        style: TextStyle(
            fontSize: 13.0,
            color: Colors.red,
            height: 1.0,
            fontWeight: FontWeight.w300),
      );
    } else {
      return new Container(
        height: 0.0,
        key: Key("SignUpErrorMessage"),
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
      if (_passwordVerification == _password) {
        return true;
      } else {
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
        }

        setState(() {
          _isLoading = false;
        });

        if (userId.length > 0 &&
            userId != null &&
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
          if (_errorMessage ==
              "The given password is invalid. [ Password should be at least 6 characters ]") {
            _errorMessage = "The password must be 6 characters long or more.";
          }
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
  Widget _showCircularProgress() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return Container(
      height: 0.0,
      width: 0.0,
    );
  }
}
