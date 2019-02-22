import 'package:flutter/material.dart';
import 'login.dart';
import 'dashboard.dart';
import 'authentication.dart';
import 'signup.dart';
import 'frontpage.dart';

class RootPage extends StatefulWidget {
  RootPage({this.auth});

  final BaseAuth auth;

  @override
  State<StatefulWidget> createState() => new _RootPageState();
}

//Labels to find out if a user is signed in when launching the app
enum AuthStatus {
  NOT_DETERMINED,
  NOT_LOGGED_IN,
  LOGGED_IN,
  READY_TO_LOG_IN,
  READY_TO_SIGN_UP,
}

class _RootPageState extends State<RootPage> {
  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;
  String _userId = "";

  @override
  void initState() {
    super.initState();
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        if (user != null) {
          _userId = user?.uid;
        }
        authStatus =
        user?.uid == null ? AuthStatus.NOT_LOGGED_IN : AuthStatus.LOGGED_IN;
      });
    });
  }

  void _onLoggedIn() {
    widget.auth.getCurrentUser().then((user){
      setState(() {
        _userId = user.uid.toString();
      });
    });
    setState(() {
      authStatus = AuthStatus.LOGGED_IN;

    });
  }

  void _onSignedOut() {
    setState(() {
      authStatus = AuthStatus.NOT_LOGGED_IN;
      _userId = "";
    });
  }

  void _readyToLogIn() {
    setState(() {
      authStatus = AuthStatus.READY_TO_LOG_IN;
    });
  }

  void _readyToSignUp() {
    setState(() {
      authStatus = AuthStatus.READY_TO_SIGN_UP;
    });
  }

  Widget _buildWaitingScreen() {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (authStatus) {
      case AuthStatus.NOT_DETERMINED:
        return _buildWaitingScreen();
        break;
      case AuthStatus.NOT_LOGGED_IN:
        return FrontPage(
            readyToLogIn: _readyToLogIn,
            readyToSignUp: _readyToSignUp,
        );
      case AuthStatus.READY_TO_LOG_IN:
        return new LoginPage(
          auth: widget.auth,
          onSignedIn: _onLoggedIn,
          readyToSignUp: _readyToSignUp,
          onSignedOut: _onSignedOut,
        );
      case AuthStatus.READY_TO_SIGN_UP:
        return new SignupPage(
          auth: widget.auth,
          onSignedIn: _onLoggedIn,
          readyToLogIn: _readyToLogIn,
          onSignedOut: _onSignedOut,
        );
        break;
      case AuthStatus.LOGGED_IN:
        if (_userId.length > 0 && _userId != null) {
          return new DashboardScreen(
            userId: _userId,
            auth: widget.auth,
            onSignedOut: _onSignedOut,
            title: 'Heroes Of The Gym',
          );
        } else return _buildWaitingScreen();
        break;
      default:
        return _buildWaitingScreen();
    }
  }
}