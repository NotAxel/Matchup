import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'homepage.dart';
import '../authentication.dart';

class UserInfoEntryPage extends StatefulWidget {
  final String userId;
  final BaseAuth auth;
  final VoidCallback logoutCallback;

  UserInfoEntryPage({this.userId, this.auth, this.logoutCallback});

  @override
  _UserInfoEntryPage createState() => _UserInfoEntryPage();
}

class _UserInfoEntryPage extends State<UserInfoEntryPage> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  Container _underLine = Container(height: 2, color: Colors.deepPurple);
  String _errorMessage;
  String _dropDownError;
  String _mainChar;
  String _secondaryChar;
  String _userName = 'temp';
  String _region = 'Please select a region';
  String _nintendoID;
  String _userID;
  String _userEmail = "waiting"; // used for testing

  bool _isLoading;
  bool _isUserForm;
  final _formKey = new GlobalKey<FormState>();

  @override
  void initState() {
    _errorMessage = "";
    _isLoading = false;
    _mainChar = null;
    _region = null;
    _nintendoID = null;
    _isUserForm = true;
    super.initState();
  }

  void resetForm() {
    _formKey.currentState.reset();
    _errorMessage = "";
    _mainChar = null;
    _region = null;
    _nintendoID = null;
  }

  void toggleFormMode() {
    resetForm();
    setState(() {
      _isUserForm = !_isUserForm;
    });
  }

  Widget showSecondaryField() {
    return new Center(
      child: DropdownButton<String>(
        value: _secondaryChar,
        icon: Icon(Icons.arrow_downward),
        isExpanded: true,
        hint:Text(
            'Secondary', // Text drop down at base
            textAlign: TextAlign.justify,
            style: TextStyle( // Text Style base 
              fontSize: 20.0,
              )),
        iconSize: 24,
          elevation: 16,
          style: TextStyle(color: Colors.deepPurple),
          underline: _underLine,
          onChanged: (String newValue) {
            setState(() {
             _secondaryChar = newValue;
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
  

  Widget showMainField(){
    return new Center(
      child: DropdownButton<String>(
        value: _mainChar,
        icon: Icon(Icons.arrow_downward),
        isExpanded: true,
        hint:Text(
            'Main', // Text drop down at base
            textAlign: TextAlign.justify,
            style: TextStyle( // Text Style base 
              fontSize: 20.0,
              )),
        iconSize: 24,
          elevation: 16,
          style: TextStyle(color: Colors.deepPurple),
          underline: _underLine,
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

  Widget showRegionField() {
    return new Center(
      child: DropdownButton<String>(
          value: _region,
          icon: Icon(Icons.arrow_downward),
          isExpanded: true,
          hint: Text(
            'Region', // Text drop down at base
            textAlign: TextAlign.justify,
            style: TextStyle( // Text Style base 
              fontSize: 20.0,
              )),
          iconSize: 24,
            elevation: 24,
            style: TextStyle(color: Colors.deepPurple),
            underline: _underLine,
            onChanged: (String newValue) {
              setState(() {
                _region = newValue;
              });
            },
            items: <String>['','NAW', 'NAE', 'EU']
              .map<DropdownMenuItem<String>>((String value){
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
            }).toList(),
        ));
  }

  Widget showNintendoIDEntryForm() {
    return new Center(
      child: TextFormField(
        obscureText: false,
        maxLines: 1,
        style: style,
        autofocus: false,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          hintText: "Nintendo ID",
        ),
        validator: (value) => value.isEmpty ? 'Nintendo ID can\'t be empty' : null,
        onSaved: (value) => _nintendoID = value.trim(),
      )); 
  }

  Widget showUserNameField() {
    return new Center(
      child: TextFormField(
        obscureText: false,
        maxLines: 1,
        style: style,
        autofocus: false,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          hintText: "Username",
        ),
        validator: (value) => value.isEmpty ? 'Username cannot be empty' : null,
        onSaved: (value) => _userName = value.trim(),
      )); 
  }

  Widget showUserEmail() {
    return new Center (
      child: Text(_userEmail)
    );
  }

  Widget showSaveButton() {
    double height = 30.0;
    return new Padding(
      padding: EdgeInsets.fromLTRB(5.0, 15.0, 5.0, 0.0),
        child: SizedBox(
        height: height,
          child: new RaisedButton(
            elevation: 10.0,
            color: Colors.deepOrange,
            shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(30.0)),
            child: new Text('Save Profile', style: style),
            onPressed: validateAndSubmit,
          )
      )
    );
  }

  validateAndSubmit() async {
    setState(() {
      _errorMessage = "";
      _isLoading = true;
    });
    if (validateAndSave()){
      try {
        FirebaseUser currUser = await widget.auth.getCurrentUser();
        _userID = currUser.uid;
        _userEmail = currUser.email;
        Firestore.instance.collection('Users').document(_userID).setData({
          'Username' : _userName, 
          'Main' : _mainChar, 
          'Secondary' : _secondaryChar, 
          'Region' : _region, 
          'Username' : _userName, 
          'NintendoID' : _nintendoID, 
          'chattingWith' : null,
          'message': null});
        Navigator.of(context).pop();
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

  // Check if form is valid before perform login or signup
  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Widget _showUserInfoEntryForm() {
    return new Container(
        padding: EdgeInsets.all(16.0),
        child: new Form(
          key: _formKey,
          child: new ListView(
            shrinkWrap: true,
            children: <Widget>[
              showMainField(),
              showSecondaryField(),
              showRegionField(),
              showNintendoIDEntryForm(),
              showUserNameField(),
              showSaveButton(),
              showErrorMessage(),
              showUserEmail(),
              
            ],
            
          ),
        ));
  }

  Widget showErrorMessage() {
    if(_errorMessage.length > 0 && _errorMessage != null) {
      return new Text (
        _errorMessage,
        style: TextStyle(
            fontSize: 13.0,
            color: Colors.red,
            height: 1.0,
            fontWeight: FontWeight.w300),
      );
    } /*else if (_dropDownError != null) {
      return new Text (
        _dropDownError,
        style: TextStyle(
            fontSize: 13.0,
            color: Colors.red,
            height: 1.0,
            fontWeight: FontWeight.w300),
      );
    } */else {
      return new Container(
        height: 0.0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Customization'),
      ),
      body: Stack(
        children: <Widget>[
          _showUserInfoEntryForm(),
        ],

      ));
  }

}