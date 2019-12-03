import 'package:flutter/material.dart';
import './chatPage.dart' as chatp; 


class ChallengePage extends StatelessWidget {

  final profStyle = TextStyle(fontSize: 25);

  final String name;
  final String main;

  ChallengePage({@required this.name, @required this.main});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Challenge"),
      ),
      body: Center(
        child:  Scaffold(
          body: new Center (
            child: Column(
              children: <Widget>[
                Text(''),
                //Should get username from firebase
                Text(this.name, style: profStyle),
                Text(''),
                //Should get profile pic from firebase
                Image.asset('assets/images/default_profile.jpg', height: 300),
                Text(''),
                //Should get mains from firebase
                Text(this.main, style: profStyle),
                RaisedButton(
                  onPressed: () {
                    Navigator.push(
                      context, 
                      MaterialPageRoute(builder: (context) => 
                        chatp.ChatPage(
                          name: this.name,
                          main: this.main)));
                  },
                  child: Text('Smash', style: TextStyle(fontSize: 30, color: Colors.white)),
                  color: Colors.redAccent,
                  ),
                RaisedButton(
                  onPressed: () {
                    // Navigate back to first route when tapped.
                  },
                  child: Text('Go back!'),
                ),
              ],
            )
          )
        )
      ),
    );
  }
} 