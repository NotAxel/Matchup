import 'package:flutter/material.dart';
import 'User.dart';

//credit: https://github.com/bizz84/coding-with-flutter-login-demo/tree/master/lib
class UserProvider extends InheritedWidget {
  const UserProvider({Key key, Widget child, this.user}) : super(key: key, child: child);
  final User user;

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static UserProvider of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<UserProvider>();
  }
}