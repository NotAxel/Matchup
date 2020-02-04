import 'package:flutter/material.dart';

class ErrorMessage{
  static Widget showErrorMessage(String errorMessage) {
    if(errorMessage.length > 0 && errorMessage != null) {
      return new Text (
        errorMessage,
        key: Key("error message"),
        softWrap: true,
        style: TextStyle(
            fontSize: 13.0,
            color: Colors.red,
            height: 1.0,
            fontWeight: FontWeight.w300),
      );
    } else {
      return new Container(
        height: 0.0,
      );
    }
  }
}