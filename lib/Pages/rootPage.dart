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
  // then check if the user has a valid sign in method
  // this will serve as a check if the user actually still exists in the Firebase
  // then initialize the users data
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final BaseAuth auth = AuthProvider.of(context).auth;
    auth.getCurrentUser().then((user) {
      // user is signed in
      if (user != null) {
        // first and only instantiation of user singleton
        print("CREATING THE USER NOW");
        _user = User();

        auth.fetchSignInMethodsForEmail().then((signInMethods){
          if (signInMethods.length > 0){
            _user.initializeData(user).then((value){
              setState(() {
                authStatus = AuthStatus.LOGGED_IN;
              });
            });
          }
          else{
            setState(() {
              print("setting status to NOT_LOGGED_IN");
              authStatus = AuthStatus.NOT_LOGGED_IN;
            });
          }
        });
      }
      // no user is signed in
      else{
        setState(() {
          print("setting status to NOT_LOGGED_IN");
          authStatus = AuthStatus.NOT_LOGGED_IN;
        });
      }
    });
  }

  // first get the current user
  // then initialize the users data once the user has been retrieved
  // then set the state to logged in
  void loginCallback() {
    print("CREATING THE USER NOW");
    _user = User();
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