import 'package:flutter/material.dart';
import 'Pages/rootPage.dart';
import 'bizlogic/authentication.dart';


// tutorial followed: https://medium.com/flutterpub/flutter-how-to-do-user-login-with-firebase-a6af760b14d5
// credit: David Cheah at FlutterPub
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Matchup',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new RootPage(auth: new Auth()));
  }
}




