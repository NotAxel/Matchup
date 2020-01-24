import 'package:flutter/material.dart';
import 'package:matchup/bizlogic/constants.dart';
import 'package:matchup/Pages/homepage.dart';
import 'package:matchup/bizlogic/User.dart';
import 'package:matchup/bizlogic/userProvider.dart';

class ProfilePage extends StatefulWidget {
  final VoidCallback logoutCallback;
  final User user;

  ProfilePage({this.user, this.logoutCallback});

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> with SingleTickerProviderStateMixin {

  var profStyle = TextStyle(fontSize: 25);

  Widget showLogOutButton(VoidCallback logoutCallback){
    return new Padding(
        padding: EdgeInsets.fromLTRB(115.0, 10.0, 115.0, 0.0),
        child: SizedBox(
          height: 40.0,
          width: 100,
          child: new RaisedButton(
            key: Key('logout'),
            elevation: 5.0,
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0)),
            color: Colors.blueAccent,
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
    final User _user = UserProvider.of(context).user;
    final VoidCallback logoutCallback = HomePageProvider.of(context).logoutCallback;
    return Column(
          children: [
            Text(''),
            Container(height: 50),
            Text(_user.getUserName, style: profStyle),
            //Should get username from firebase
            Text(''),
            //Should get profile pic from firebase
            Center(child: Image.asset('assets/images/default_profile.jpg', height: 300)), 
            //Center(child: Image.asset(nameMap[_user.getMain], height: 300)),
            Container(height: 50),
            //Should get mains from firebase
//            Text(_user.getMain, style: profStyle),
            Text("Main: " + _user.getMain + "\nSecondary: " + _user.getSecondary, style: profStyle),
            _showForm(logoutCallback),
            ]
        );
  }
}