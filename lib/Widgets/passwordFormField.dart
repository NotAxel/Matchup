import 'package:flutter/material.dart';
import 'package:matchup/bizlogic/passwordValidator.dart';
import 'package:matchup/bizlogic/validator.dart';

class PasswordFormField{
  String _password;
  bool _isLogin;
  FocusNode _passwordFocusNode;

  PasswordFormField(bool isLogin){
    _isLogin = isLogin;
  }

  String get getPassword => _password;
  set setPassword(String password) { _password = password; }

  bool get getIsLogin => _isLogin;
  set setIsLogin(bool isLogin) { _isLogin = isLogin; }

  set setFocusNode(FocusNode passwordFocusNode) { _passwordFocusNode = passwordFocusNode; }

  Widget buildPasswordField(){
    Validator passwordValidator = PasswordValidator(_isLogin);
    return new TextFormField(
        key: Key('password'),
        focusNode: _passwordFocusNode,
        maxLines: 1,
        obscureText: true,
        autofocus: false,
        decoration: InputDecoration(
          //contentPadding: EdgeInsets.fromLTRB(0.0, 15.0, 20.0, 0.0),
          hintText: "Password",
          icon: new Icon(Icons.lock,
          color: Colors.white,
          ),
          fillColor: Colors.white,
          filled: true
        ),
        validator: (value) => passwordValidator.validate(value),
        onSaved: (value) => _password = passwordValidator.save(value),
    );
  }
}