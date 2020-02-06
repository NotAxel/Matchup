import 'package:flutter/material.dart';
import 'package:matchup/Pages/homepage.dart';
import 'package:matchup/Widgets/loadingCircle.dart';
import 'package:matchup/bizlogic/User.dart';
import 'package:matchup/bizlogic/constants.dart';
import 'package:matchup/bizlogic/userProvider.dart';

class ProfilePage extends StatefulWidget {
  final Future<void> Function(bool) logoutCallback;
  final User user;

  ProfilePage({this.user, this.logoutCallback});

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> with SingleTickerProviderStateMixin {

  var profStyle = TextStyle(fontSize: 25);

  Widget showLogOutButton(Future<void> Function(bool) logoutCallback){
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
            onPressed: ()=>logoutCallback(false) 
          ),
        )
    );
  }

  Widget _showForm(void Function(bool) logoutCallback) {
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
    print("building profile page");
    //// check if the user has data before accessing their profile
    //final BaseAuth auth = AuthProvider.of(context).auth;
    //auth.getCurrentUser().then((value){

    //});
    final User _user = UserProvider.of(context).user;
    final void Function(bool) logoutCallback = HomePageProvider.of(context).logoutCallback;
    //if (false){

    //}
    if (_user.getUserName == null ||
      _user.getMain == null ||
      _user.getSecondary == null){
      return LoadingCircle.loadingCircle();
    }
    else{
      return Column(
        children: [
          Text(''),
          Container(height: 50),
          Text(_user.getUserName, style: profStyle),
          Text(''),
          Center(child: Image.asset(nameMap[_user.getMain], height: 300)), 
          Container(height: 50),
          Text("Main: " + _user.getMain + "\nSecondary: " + _user.getSecondary, style: profStyle),
          _showForm(logoutCallback),
        ]
      );
    }
  }
}