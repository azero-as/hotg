import 'package:flutter/material.dart';
import 'authentication.dart';

//This is the login page

class LoginPage extends StatefulWidget {

  static String tag = 'login-page';

  LoginPage({this.auth, this.onSignedIn, this.readyToSignUp, this.onSignedOut});

  final BaseAuth auth;
  final VoidCallback onSignedIn;
  final VoidCallback readyToSignUp;
  final VoidCallback onSignedOut;

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
        //title: Text("Heroes of the Gym", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        leading: IconButton(icon: Icon(Icons.arrow_back_ios),
            key: Key("loginBackButton"),
            onPressed: (){
              widget.onSignedOut();
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
      if (_errorMessage == "Network error (such as timeout, interrupted connection or unreachable host) has occurred." || _errorMessage == "A network error (such as timeout, interrupted connection or unreachable host) has occurred.") {
        return new Text(
          _errorMessage,
          key: Key("LogInErrorMessage"),
          style: TextStyle(
              fontSize: 13.0,
              color: Colors.red,
              height: 1.0,
              fontWeight: FontWeight.w300),
        );
      } else if (_errorMessage == "There is no user record corresponding to this identifier. The user may have been deleted."){
        return new Text(
          _errorMessage = "Not able to find a user with this email and password combination.",
          key: Key("LogInErrorMessage"),
          style: TextStyle(
              fontSize: 13.0,
              color: Colors.red,
              height: 1.0,
              fontWeight: FontWeight.w300),
        );
      } else {
        return new Text(
          _errorMessage = "Wrong email or password",
          key: Key("LogInErrorMessage"),
          style: TextStyle(
              fontSize: 13.0,
              color: Colors.red,
              height: 1.0,
              fontWeight: FontWeight.w300),
        );
      }
    } else {
      return new Container(
        height: 0.0,
        key: Key("LogInErrorMessage"),
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
    if (this.mounted) {
      setState(() {
        _errorMessage = "";
        _isLoading = true;
      });
    }
    if (_validateAndSave()) {
      String userId = "";
      try {
        if (_formMode == FormMode.LOGIN) {
        userId = await widget.auth.signIn(_email, _password);
        print('Signed in: $userId');
        }
        if (this.mounted) {
          setState(() {
            _isLoading = false;
          });
        }

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
    // To prevent loading circle to continue if you've clicked the next button twice with no passwords set.
    else {
      setState(() {
        _isLoading = false;
      });
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
        margin: EdgeInsets.fromLTRB(35, 0, 35, 35),
        child: new Form(
          key: _formKey,
          child: new ListView(
            shrinkWrap: true,
            children: <Widget>[
              SizedBox(height: 25.0),
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
        child: Image.asset('assets/logo1.png'),
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
        key: Key("loginUsername"),
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
      key: Key("loginPassword"),
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
    key: Key("LogIn2"),
    child: RaisedButton(
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
    ),
      onPressed: _validateAndSubmit,
      padding: EdgeInsets.all(12),
      color: const Color(0xFF612A30),
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
        widget.readyToSignUp();
      },
    );
  }

}
