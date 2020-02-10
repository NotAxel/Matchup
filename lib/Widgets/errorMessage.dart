import 'package:flutter/material.dart';

class ErrorMessage{
  String _message;

  ErrorMessage();

  String get getMessage => _message;
  set setMessage(String message) { _message = message; }

  Widget buildErrorMessage() {
    if(_message != null && _message.length > 0) {
      return Center(
        child: Row(
          children: <Widget>[
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text (
                    _message,
                    key: Key("error message"),
                    style: TextStyle(
                      fontSize: 13.0,
                      color: Colors.red,
                      height: 1.0,
                      fontWeight: FontWeight.w300),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    } else {
      return new Container(
        height: 0.0,
      );
    }
  }
}