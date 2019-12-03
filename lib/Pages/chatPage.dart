import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {

  final profStyle = TextStyle(fontSize: 25);

  final String name;
  final String main;

  ChatPage({@required this.name, @required this.main});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(this.name),
      ),
      body: Center(
        child:  Scaffold(
          body: new Center (
            child: Column(
              children: <Widget>[
              ],
            )
          )
        )
      ),
    );
  }
} 