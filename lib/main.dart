import 'package:flutter/material.dart';
import 'package:matchup/bizlogic/authProvider.dart';
import 'Pages/rootPage.dart';
import 'bizlogic/authentication.dart';


// tutorial followed: https://medium.com/flutterpub/flutter-how-to-do-user-login-with-firebase-a6af760b14d5
// credit: David Cheah at FlutterPub
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    BaseAuth auth = new Auth();
    return AuthProvider(
      auth: auth,
      child: MaterialApp(
        title: 'Matchup',
        theme: new ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: new RootPage(auth),
      )
    );
  }
}




