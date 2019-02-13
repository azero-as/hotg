import 'package:flutter/material.dart';
import 'login.dart';
import 'dashboard.dart';
import 'frontpage.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {

  //Navigation between pages
  final routes = <String, WidgetBuilder>{
    LoginPage.tag: (context) => LoginPage(),
    Dashboard.tag: (context) => Dashboard(),
    FrontPage.tag: (context) => FrontPage(),
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
      home: FrontPage(), //Change this to the first page (login/signin)
      routes: routes,
    );
  }
}
