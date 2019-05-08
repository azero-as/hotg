import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingScreen extends StatefulWidget {
  static String tag = 'loading-screen';

  @override
  State<StatefulWidget> createState() => new _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  Widget build(BuildContext context) {
    // Make sure status bar colour matches the rest of the page
    FlutterStatusbarcolor.setStatusBarColor(Color(0xFF212838));
    return Scaffold(
        body: Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).secondaryHeaderColor,
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircleAvatar(
                      backgroundImage: AssetImage('assets/logo2.png'),
                      radius: 50,
                      child: SizedBox(
                        child: CircularProgressIndicator(
                          strokeWidth: 5,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Color(0xFF354078)),
                        ),
                        height: 100,
                        width: 100,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    ));
  }
}
