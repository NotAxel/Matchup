import 'package:firebase_auth/firebase_auth.dart';
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
  final BaseAuth auth;

  RootPage(this.auth);

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
  void initState() {
    super.initState();
    determineAuthStatus();
  }

  @override
  void didUpdateWidget(RootPage oldWidget){
    super.didUpdateWidget(oldWidget);
    determineAuthStatus();
  }

  void determineAuthStatus(){
    widget.auth.getCurrentUser().then((user) {
      // user is signed in
      if (user != null) {
        // first and only instantiation of user singleton
        print("CREATING THE USER NOW");
        _user = User();

        widget.auth.fetchSignInMethodsForEmail().then((signInMethods){
          if (signInMethods.length > 0){
            _user.initializeData(user).then((value){
              authStatus = AuthStatus.LOGGED_IN;
            });
          }
          else{
            print("setting status to NOT_LOGGED_IN");
            authStatus = AuthStatus.NOT_LOGGED_IN;
          }
        });
      }
      // no user is signed in
      else{
        print("setting status to NOT_LOGGED_IN");
        authStatus = AuthStatus.NOT_LOGGED_IN;
      }
    });
  }


  // first get the current user
  // then initialize the users data once the user has been retrieved
  // then set the state to logged in
  // TODO: future void async
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

  Future<void> logoutCallback(bool deleteAccount) async{
    final BaseAuth auth = AuthProvider.of(context).auth;
    if (deleteAccount){
      final FirebaseUser firebaseUser = await auth.getCurrentUser();
      print("DELETING ACCOUNT");
      await firebaseUser.delete();
      await auth.signOut();
    }
    else{
      await auth.signOut();
    }
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
    print(authStatus.toString());
    switch (authStatus) {
      case AuthStatus.NOT_DETERMINED:
        return buildWaitingScreen();
        break;
      case AuthStatus.NOT_LOGGED_IN:
        print("building loginSingupPage");
        return new UserProvider(
          user: _user,
          child: LogInSignupPage(
            loginCallback: loginCallback,
            logoutCallback: logoutCallback,
          )
        );
        break;
      case AuthStatus.LOGGED_IN:
        if (_user.getUserId.length > 0 && _user.getUserId != null) {
          print("building homepage");
          return new UserProvider(
            user: _user,
            child: new HomePage(
              logoutCallback: logoutCallback,
            ),
          );
        } 
        else
          return buildWaitingScreen();
        break;
      default:
        return buildWaitingScreen();
    }
  }
}