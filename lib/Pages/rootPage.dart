import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:matchup/Pages/loadingCircle.dart';
import 'package:matchup/Pages/userInfoEntryPage.dart';
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
  AuthStatus _authStatus = AuthStatus.NOT_DETERMINED;
  User user;

  @override
  void didChangeDependencies() async{
    super.didChangeDependencies();
    print("setting status to NOT_DETERMINED");
    _authStatus = AuthStatus.NOT_DETERMINED;
    await determineAuthStatus();
  }

  // first get the current user
  // then check if the user has a valid sign in method
  // this will serve as a check if the user actually still exists in the Firebase
  // then initialize the users data
  Future<void> determineAuthStatus() async{
    List<String> signInMethodsForEmail;
    BaseAuth auth = AuthProvider.of(context).auth;
    FirebaseUser firebaseUser = await auth.getCurrentUser();

    // user is signed in
    if (firebaseUser != null) {
      // first and only instantiation of user singleton
      print("CREATING THE USER NOW");
      user = User();

      signInMethodsForEmail = await auth.fetchSignInMethodsForEmail();
      if (signInMethodsForEmail.length > 0){
        await user.initializeData(firebaseUser);
        print("setting status to LOGGED_IN");
        _authStatus = AuthStatus.LOGGED_IN;
      }
      else{
        print("setting status to NOT_LOGGED_IN");
        _authStatus = AuthStatus.NOT_LOGGED_IN;
      }
    }
    // no user is signed in
    else{
        print("setting status to NOT_LOGGED_IN");
        _authStatus = AuthStatus.NOT_LOGGED_IN;
    }

    // call for a re-build once the auth status has been determined
    setState(() {});
  }


  // first get the current user
  // then initialize the users data once the user has been retrieved
  // then set the state to logged in
  Future<void> loginCallback() async{
    user = User();
    final BaseAuth auth = AuthProvider.of(context).auth;
    final FirebaseUser firebaseUser = await auth.getCurrentUser();
    await user.initializeData(firebaseUser);
    setState(() {
      print("login callback");
      _authStatus = AuthStatus.LOGGED_IN;
    });
  }

  Future<void> logoutCallback(bool deleteAccount) async{
    final BaseAuth auth = AuthProvider.of(context).auth;
    if (deleteAccount){
      print("DELETING ACCOUNT");
      await auth.deleteUser();
    }
    await auth.signOut();
    setState(() {
      print("logout callback");
      _authStatus = AuthStatus.NOT_LOGGED_IN;
    });
  }

  @override
  Widget build(BuildContext context) {
    print("running root build");
    print(_authStatus.toString());
    switch (_authStatus) {
      case AuthStatus.NOT_DETERMINED:
        print("waiting");
        return LoadingCircle.loadingCircle();
        break;
      case AuthStatus.NOT_LOGGED_IN:
        print("building loginSingupPage");
        return new UserProvider(
          user: user,
          child: LogInSignupPage(
            loginCallback: loginCallback,
            logoutCallback: logoutCallback,
          )
        );
        break;
      case AuthStatus.LOGGED_IN:
        if (user.hasBeenInitialized()) {
          print("building homepage");
          return new UserProvider(
            user: user,
            child: new HomePage(
              logoutCallback: logoutCallback,
            ),
          );
        } 
        // user pressed sign up then closed the app before entering information
        // should go to user info entry since they will have a token when they reopen
        else{
          print("building userInfoEntry from homepage");
          return UserInfoEntryPage(logoutCallback, "RootPage");
        }
        break;
      default:
        return LoadingCircle.loadingCircle();
    }
  }
}