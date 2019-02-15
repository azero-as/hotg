import 'package:flutter/material.dart';
import 'login.dart';
import 'dashboard.dart';
import 'signup.dart';
import 'signuplevel.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {

  //Navigation between pages
  final routes = <String, WidgetBuilder>{
    LoginPage.tag: (context) => LoginPage(),
    Dashboard.tag: (context) => Dashboard(),
    SignupPage.tag: (context) => SignupPage(),
    SignupLevelPage.tag: (context) => SignupLevelPage(),
  };

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Heroes of the gym',
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(
        primaryColor: const Color(0xFF4FB88B),
        secondaryHeaderColor: const Color(0xFF5DC6D9),
        accentColor: const Color(0xFFFFAD32),
      ),
      home: LoginPage(), //Change this to the first page (login/signin)
      routes: routes,
    );
  }
}