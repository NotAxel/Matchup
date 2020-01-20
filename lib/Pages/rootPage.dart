import 'package:flutter/material.dart';
import 'package:matchup/bizlogic/User.dart';
import 'package:matchup/bizlogic/authProvider.dart';
import 'package:matchup/bizlogic/authentication.dart';
import 'package:matchup/bizlogic/userProvider.dart';
import 'homepage.dart';
import 'loginSignupPage.dart';

enum AuthStatus {
NOT_DETERMINED,
NOT_LOGGED_IN,
LOGGED_IN,
}

class RootPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage>{
  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;
  User _user;

  // first get the current user
  // then initialize the users data
  // 
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final BaseAuth auth = AuthProvider.of(context).auth;
    auth.getCurrentUser().then((user) {
      if (user != null) {
        // first and only instantiation of user singleton
        _user = User();
      }
      _user.initializeData(user).then((value){
        setState(() {
          print("checking login status");
          authStatus =
              user?.uid == null ? AuthStatus.NOT_LOGGED_IN : AuthStatus.LOGGED_IN;
        });
      });
    });
  }

  // first get the current user
  // then initialize the users data once the user has been retrieved
  // then set the state to logged in
  void loginCallback() {
    final BaseAuth auth = AuthProvider.of(context).auth;
    auth.getCurrentUser().then((user){
      _user.initializeData(user).then((value){
        setState(() {
          print("successfully logged in");
          authStatus = AuthStatus.LOGGED_IN;
        });
      });
    });
  }

  void logoutCallback() {
    Navigator.of(context).maybePop();
    setState(() {
      print("successfully logged out");
      authStatus = AuthStatus.NOT_LOGGED_IN;
    });
  }

  Widget buildWaitingScreen() {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print("running root build");
    switch (authStatus) {
      case AuthStatus.NOT_DETERMINED:
        return buildWaitingScreen();
        break;
      case AuthStatus.NOT_LOGGED_IN:
        return new UserProvider(
          user: _user,
          child: LogInSignupPage(
            loginCallback: loginCallback,
            logoutCallback: logoutCallback),
        );
        break;
      case AuthStatus.LOGGED_IN:
        if (_user.getUserId.length > 0 && _user.getUserId != null) {
          return new UserProvider(
            user: _user,
            child: new HomePage(
              logoutCallback: logoutCallback,
            ),
          );
        } else
          return buildWaitingScreen();
        break;
      default:
        return buildWaitingScreen();
    }
  }
}