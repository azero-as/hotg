import 'package:flutter/material.dart';
import 'authentication.dart';
import 'rootPage.dart';
import 'login.dart';
import 'package:flutter/services.dart';
import 'frontpage.dart';
import 'signup.dart';
import 'signuplevel.dart';
import 'package:scoped_model/scoped_model.dart';
import 'models/user.dart';
import 'models/workout.dart';

void main() async {
  // Lock screen in portrait mode
   await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);
  runApp(new Heroes());
}

class Heroes extends StatelessWidget {

  final User user = new User();
  final Workout workout = new Workout();

  //Navigation between pages
  final routes = <String, WidgetBuilder>{
    LoginPage.tag: (context) => LoginPage(),
    FrontPage.tag: (context) => FrontPage(),
    SignupPage.tag: (context) => SignupPage(),
    SignupLevelPage.tag: (context) => SignupLevelPage(),
  };

  @override
  Widget build(BuildContext context) {
    return ScopedModel<User>(
      model: user,
      child: ScopedModel<Workout>(
          model: workout,
          child: new MaterialApp(
            title: 'Heroes of the gym',
            debugShowCheckedModeBanner: false,
            theme: new ThemeData(
              primaryColor: const Color(0xFF612A30),
              secondaryHeaderColor: const Color(0xFF212838),
              accentColor: const Color(0xFF5e72a1),
            ),
            routes: routes,
            home: new RootPage(auth: new Auth(), user: user),
          )),
      );
  }
}
