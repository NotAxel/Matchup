import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserInfoEntryPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return new _UserInfoEntryPage();
  }
}

class _UserInfoEntryPage extends State<UserInfoEntryPage> {
  String _mainChar;

  Widget showMainField(){
    return new Center(
      child: DropdownButton<String>(
        value: _mainChar,
        icon: Icon(Icons.arrow_downward),
        iconSize: 24,
          elevation: 16,
          style: TextStyle(color: Colors.deepPurple),
          underline: Container(
            height: 2,
            color: Colors.deepPurpleAccent,
          ),
          onChanged: (String newValue) {
            setState(() {
              _mainChar = newValue;
            });
          },
          items: <String>['Fox', 'Marth', 'Sheik', 'Falco']
            .map<DropdownMenuItem<String>>((String value){
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
          }).toList(),
      ));
  } 

  Widget _showUserInfoEntryForm() {
    return new Container(
        padding: EdgeInsets.all(16.0),
        child: new Form(
          //key: _formKey,
          child: new ListView(
            shrinkWrap: true,
            children: <Widget>[
              showMainField(),
            ],
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          body: Stack(
          children: <Widget>[
            _showUserInfoEntryForm(),
          ],
        ));
  }

}