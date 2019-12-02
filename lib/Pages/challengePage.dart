import 'package:flutter/material.dart';

class ChallegePage extends StatelessWidget {

  final profStyle = TextStyle(fontSize: 25);

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
                Text('Username', style: profStyle),
                Text(''),
                //Should get profile pic from firebase
                Image.asset('assets/images/default_profile.jpg', height: 300),
                Text(''),
                //Should get mains from firebase
                Text('Ness, King K', style: profStyle),
                RaisedButton(
                  onPressed: () {},
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