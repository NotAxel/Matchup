import 'package:flutter/material.dart';
import 'package:matchup/bizlogic/passwordValidator.dart';
import 'package:matchup/bizlogic/validator.dart';

class PasswordFormField{
  String _password;

  PasswordFormField();

  String get getPassword => _password;
  set setPassword(String password) { _password = password; }

  Widget buildPasswordField(){
    Validator passwordValidator = PasswordValidator();
    return Flexible(
      child: Padding(
        padding: EdgeInsets.fromLTRB(0.0, 20, 0, 50.0),
        child: new TextFormField(
            key: Key('password'),
            maxLines: 1,
            obscureText: true,
            autofocus: false,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(0.0, 15.0, 20.0, 0.0),
              hintText: "Password",
              icon: new Icon(Icons.lock,
              color: Colors.blueGrey
              )
            ),
            validator: (value) => passwordValidator.validate(value),
            onSaved: (value) => _password = passwordValidator.save(value),
        ),
      ),
      fit: FlexFit.loose,
      flex: 1
    );
  }
}