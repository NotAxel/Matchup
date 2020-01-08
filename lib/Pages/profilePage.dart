import 'package:flutter/material.dart';
import 'package:matchup/Pages/homepage.dart';
import 'package:matchup/bizlogic/authentication.dart';

class ProfilePage extends StatefulWidget {
  final BaseAuth auth;
  final VoidCallback logoutCallback;

  ProfilePage({this.auth, this.logoutCallback});

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> with SingleTickerProviderStateMixin {

  var profStyle = TextStyle(fontSize: 25);

  Widget showLogOutButton(VoidCallback logoutCallback){
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
            onPressed: logoutCallback 
          ),
        ));
  }

  Widget _showForm(VoidCallback logoutCallback) {
    return new Container(
        padding: EdgeInsets.all(16.0),
        child: new Form(
          //key: _formKey,
          child: new ListView(
            shrinkWrap: true,
            children: <Widget>[
              showLogOutButton(logoutCallback)
            ],
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    final VoidCallback logoutCallback = HomePageProvider.of(context).logoutCallback;
    return Scaffold(
          body: Stack(
          children: <Widget>[
            _showForm(logoutCallback)
            /*
            Text(''),
            //Should get username from firebase
            Text('Username', style: profStyle),
            Text(''),
            //Should get profile pic from firebase
            Image.asset('assets/images/default_profile.jpg', height: 300),
            Text(''),
            //Should get mains from firebase
            Text('Ness, King K', style: profStyle),
            */
          ],
        ));
  }
}