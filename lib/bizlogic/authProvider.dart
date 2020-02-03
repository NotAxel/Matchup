import 'package:flutter/material.dart';
import 'authentication.dart';

//credit: https://github.com/bizz84/coding-with-flutter-login-demo/tree/master/lib
class AuthProvider extends InheritedWidget {
  const AuthProvider({Key key, Widget child, this.auth}) : super(key: key, child: child);
  final BaseAuth auth;

  @override
  bool updateShouldNotify(AuthProvider oldWidget){
    return oldWidget.auth != auth;
  }

  static AuthProvider of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AuthProvider>();
  }
}