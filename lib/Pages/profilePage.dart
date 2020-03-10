import 'package:flutter/material.dart';
import 'package:matchup/Widgets/actionConfirmation.dart';
import 'package:provider/provider.dart';

import 'package:matchup/Pages/homepage.dart';
import 'package:matchup/Pages/friendsListPage.dart';
import 'package:matchup/Widgets/loadingCircle.dart';
import 'package:matchup/bizlogic/User.dart';
import 'package:matchup/bizlogic/constants.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage();

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage>{

  ActionConfirmation _confirmer;
  var profStyle = TextStyle(fontSize: 25);

  
Widget _offsetPopup(void Function(bool) logoutCallback) => PopupMenuButton<int>(
          itemBuilder: (context) => [
                PopupMenuItem(
                  value: 1,
                  child: Text("Friends List", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700))
                ),
                PopupMenuItem(
                  value: 2,
                  child: Text("Logout", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700))
                ),
                PopupMenuItem(
                  value: 3,
                  child: Text("Delete User", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700))
                ),
          ],
          onSelected: (value)
          {
            if(value == 1){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FriendsListPage()));
            }
            if(value == 2){
                logoutCallback(false);
            }
            if(value == 3){
              _confirmer.confirmAction();
            }
          },
          
          icon: Icon(Icons.toc, size: 35),
          elevation: 5,
          
          offset: Offset(0, 100),
        );

  @override
  Widget build(BuildContext context) {
    print("building profile page");
    // check if the user has data before accessing their profile
    // final BaseAuth auth = AuthProvider.of(context).auth;
    // auth.getCurrentUser().then((value){

    final User _user = Provider.of<User>(context);
    final Future<void> Function(bool) logoutCallback = HomePageProvider.of(context).logoutCallback;

    _confirmer = ActionConfirmation(
      context,
      "Are you sure you want to delete your account?",
      // confirm deletion 
      () async { await logoutCallback(true); },
      // deny deletion 
      () async { Navigator.pop(context, false); },
      useRootNavigatior: false
    );

    if (_user.getUserName == null ||
      _user.getMain == null ||
      _user.getSecondary == null){
      return LoadingCircle.loadingCircle();
    }
    else{
      return Scaffold(
        body: Column(
        children: [
          Text(''),
          Container(height: 50),
          Align(
            alignment: Alignment.centerRight,
            child: _offsetPopup(logoutCallback),
          ),
          SizedBox(
            child: Container(
              child: Text(_user.getUserName, style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center, textScaleFactor: 5.0),
            ),
          ),
          Text(''),
          //Center(child: Image.asset(nameMap[_user.getMain], height: 300)), 
          Container(height: 50),
          Text("Main: " + _user.getMain + "\nSecondary: " + _user.getSecondary, style: profStyle),
        ]
      ),
      );
    }
  }
}