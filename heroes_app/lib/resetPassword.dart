import 'package:flutter/material.dart';
import 'authentication.dart';

//This is the login page

class ResetPasswordPage extends StatefulWidget {
  ResetPasswordPage({this.auth, this.readyToLogIn});

  final BaseAuth auth;
  final VoidCallback readyToLogIn;

  @override
  _ResetPasswordPageState createState() => new _ResetPasswordPageState();
}

enum FormMode { FORGOT_PASSWORD }

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _formKey = new GlobalKey<FormState>();

  String _email;
  String _errorMessage;
  bool _isLoading;

  @override
  Widget build(BuildContext context) {
    //Returns all the elements to the page
    return new Theme(
        data: ThemeData.dark(),
        child: Scaffold(
            backgroundColor: Theme.of(context).secondaryHeaderColor,
            appBar: new AppBar(
              backgroundColor: Theme.of(context).secondaryHeaderColor,
              leading: IconButton(
                  icon: Icon(Icons.arrow_back_ios),
                  key: Key("loginBackButton"),
                  onPressed: () {
                    widget.readyToLogIn();
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
            )));
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

  @override
  void initState() {
    _isLoading = false;
    _errorMessage = "";
    super.initState();
  }

//---------FORM WIDGETS------------

  Widget _returnBody() {
    return new Container(
        padding: EdgeInsets.only(left: 24.0, right: 24.0),
        margin: EdgeInsets.fromLTRB(35, 0, 35, 35),
        child: new Form(
          key: _formKey,
          child: new ListView(
            shrinkWrap: true,
            children: <Widget>[
              SizedBox(height: 25.0),
              //_logo(),
              _textHeader("Reset password"),
              _emailInput(),
              _resetPasswordButton(),
              _showErrorMessage(),
            ],
          ),
        ));
  }

  //Welcome text
  Widget _textHeader(String t) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
      child: new Text(
        t,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 25.0,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  //Email input field
  Widget _emailInput() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 50.0, 0.0, 0.0),
      child: TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        key: Key('EmailInput'),
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

  Widget _resetPasswordButton() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      key: Key("PasswordReset"),
      child: RaisedButton(
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        onPressed: () {
          _validateAndSend();
        },
        padding: EdgeInsets.all(12),
        color: const Color(0xFF612A30),
        child: Text(
          'Send email',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  void _validateAndSend() {
    if (this.mounted) {
      setState(() {
        _errorMessage = "";
      });
    }

    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      this
          .widget
          .auth
          .forgotPassword(_email)
          .then((_) => {
                showDialog(
                        context: context,
                        builder: (context) => _onSendEmail(context))
                    .then((_) => {widget.readyToLogIn()})
              })
          .catchError((error) => {
                setState(() {
                  _errorMessage = error.message;
                }),
                print(error),
              });
    }
  }

  Widget _showErrorMessage() {
    if (_errorMessage.length > 0 && _errorMessage != null) {
      if (_errorMessage ==
          "There is no user record corresponding to this identifier. The user may have been deleted.") {
        return new Center(
            child: Text(
          _errorMessage = "Not able to find a user with this email.",
          key: Key("ResetErrorMessage"),
          style: TextStyle(
              fontSize: 13.0,
              color: Colors.red,
              height: 1.0,
              fontWeight: FontWeight.w300),
        ));
      } else {
        return new Center(
            child: Text(
          _errorMessage = "Something went wrong.",
          key: Key("ResetErrorMessage"),
          style: TextStyle(
              fontSize: 13.0,
              color: Colors.red,
              height: 1.0,
              fontWeight: FontWeight.w300),
        ));
      }
    } else {
      return new Container(
        height: 0.0,
        key: Key("ResetErrorMessage"),
      );
    }
  }

  //Pop-up window when sending email to reset password
  Widget _onSendEmail(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        new Container(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
            margin: EdgeInsets.fromLTRB(35, 0, 35, 35),
            child: new ListView(
              shrinkWrap: true,
              children: <Widget>[
                new Container(
                    padding: EdgeInsets.fromLTRB(25, 8, 0, 8),
                    color: Theme.of(context).primaryColor,
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        RichText(
                          text: TextSpan(
                            text: 'Email sent!',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        Align(
                          //alignment: Alignment.topRight,
                          child: RaisedButton(
                            color: Theme.of(context).primaryColor,
                            textColor: Colors.white,
                            onPressed: () => Navigator.pop(context),
                            child: Icon(
                              Icons.close,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    )),
                new Container(
                  padding: EdgeInsets.fromLTRB(25, 40, 25, 40),
                  color: Colors.white,
                  child: Column(
                    children: <Widget>[
                      RichText(
                        text: TextSpan(
                          text: 'Go check your inbox to reset your password.',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                  //SizedBox(height: 100.0),
                )
              ],
            )),
      ],
    );
  }
}
