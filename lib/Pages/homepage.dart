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
      body: Stack(
      children: <Widget>[
        Text("You have successfully logged into Matchup"),
          _showForm(),
        ],
      )
    );
  }
  
  Widget showLogOutButton(){
    return new Padding(
        padding: EdgeInsets.fromLTRB(20.0, 45.0, 20.0, 0.0),
        child: SizedBox(
          height: 40.0,
          child: new RaisedButton(
            elevation: 5.0,
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0)),
            color: Colors.deepOrange,
            child: new Text('Logout',
                style: new TextStyle(fontSize: 20.0, color: Colors.white)),
            onPressed: logoutCallback,
          ),
        ));
  }


  Widget _showForm() {
    return new Container(
        padding: EdgeInsets.all(16.0),
        child: new Form(
          //key: _formKey,
          child: new ListView(
            shrinkWrap: true,
            children: <Widget>[
              showLogOutButton()
            ],
          ),
        ));
  }
}