import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

abstract class BaseAuth {
  Future<String> signIn(String email, String password);

  Future<String> signUp(String email, String password);

  Future<FirebaseUser> getCurrentUser();

  Future<void> sendEmailVerification();

  Future<void> signOut();

  Future<bool> isEmailVerified();

  Future<List<String>> fetchSignInMethodsForEmail();

  Future<bool> deleteUser();

  Future<String> reauthenticateWithCredential(String email, String password);
}

class Auth implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<String> signIn(String email, String password) async {
    AuthResult result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    FirebaseUser user = result.user;
    return user.uid;
  }

  Future<String> signUp(String email, String password) async {
    AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    FirebaseUser user = result.user;
    return user.uid;
  }

  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user;
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  Future<void> sendEmailVerification() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    user.sendEmailVerification();
  }

  Future<bool> isEmailVerified() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.isEmailVerified;
  }

  Future<List<String>> fetchSignInMethodsForEmail() async{
    FirebaseUser user = await _firebaseAuth.currentUser();
    return _firebaseAuth.fetchSignInMethodsForEmail(email: user.email.toString());
  }

  // returns true if the user was successfully deleted
  // returns false if an error was caught
  Future<bool> deleteUser() async{
    final FirebaseUser firebaseUser = await _firebaseAuth.currentUser();
    if (firebaseUser != null){
      try{
        await firebaseUser.delete();
      }
      catch(ERROR_REQUIRES_RECENT_LOGIN){
        return false;
      }
      return true;
    }
    else{
      return false;
    }
  }

  // returns null if the user was successfully authenticated 
  // with the given email and password
  // if there was an error, returns the error message
  @override
  Future<String> reauthenticateWithCredential(String email, String password) async{
    // TODO: implement reauthenticateWithCredential
    final FirebaseUser firebaseUser = await _firebaseAuth.currentUser();
    AuthCredential credential = EmailAuthProvider.getCredential(
      email: email, password: password);
    AuthResult result = await firebaseUser.reauthenticateWithCredential(credential);
    return result.user.uid;
  }
}