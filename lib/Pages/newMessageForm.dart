import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import './challengePage.dart' as cp;
class NewMessageForm extends StatefulWidget{

  @override
  _NewMessageForm createState()  => _NewMessageForm();
}

class _NewMessageForm extends State<NewMessageForm> {
  String _errorMessage;
  bool _isLoading;
  String _otherName = 'temp';
  final _formKey = new GlobalKey<FormState>();

  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget> [
        showNewMessageForm(),
      ],
    );
  }

  Widget showNewMessageForm(){
    return new Container(
      padding: EdgeInsets.all(16.0),
      child: new Form(
        key: _formKey,
        child: new ListView(
          shrinkWrap: true,
          children: <Widget>[
            showOtherUserSearchField(),
          ],
        ),
      )
    );
  }

  Widget showOtherUserSearchField() {
    return new TextFormField(
      autocorrect: false,
      obscureText: false,
      maxLength: 30,
      maxLines: 1,
      style: style,
      autofocus: false,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        hintText: "Username",
        fillColor: Colors.blueGrey,
        suffixIcon: IconButton(
          icon: new Icon(Icons.send), 
          onPressed: (){
            validateAndSubmit();
          },
        )
      ),
      validator: (value) => validateEntry(value),
      onSaved: (value) => _otherName = value.trim(),
    );
  }

  validateAndSubmit() async {
    setState(() {
      _errorMessage = "";
      _isLoading = true;
    });
    if (validateAndSave()){
      try {
        QuerySnapshot qs = await Firestore.instance.collection("Users").where("Username", isEqualTo: _otherName).snapshots().first;
        DocumentSnapshot peer = qs.documents.first;
        Navigator.popAndPushNamed(context, "/challenge", arguments: <Object>[peer]);
      } 
      catch (e) {
        print('Error: $e');
        setState(() {
          _isLoading = false;
          _errorMessage = e.message;
          _formKey.currentState.reset();
        });
      } 
    }
  }

  // Check if form is valid before saving edited chat information
  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    _isLoading = false;
    return false;
  }

  String validateEntry(String value){
    if(value.isEmpty){
      return 'Username cannot be empty';
    }
  }
  
}