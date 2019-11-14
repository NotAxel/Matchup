import 'package:flutter/material.dart';
import '../authentication.dart';

class HomePage extends StatelessWidget {
  final String userId;
  final BaseAuth auth;
  final VoidCallback logoutCallback;

  HomePage({this.userId, this.auth, this.logoutCallback});

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Matchup login demo"),
      ),
      body: new Container(
        child: new Text("Welcome to Matchup, you have successfully logged in"),
      ),
    );
  }
}