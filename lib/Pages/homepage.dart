import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Flutter login demo"),
      ),
      body: new Container(
        child: new Text("Hello World"),
      ),
    );
  }
}