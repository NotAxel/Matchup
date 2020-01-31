import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:matchup/Pages/loadingCircle.dart';
import 'package:matchup/bizlogic/constants.dart' as con;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:matchup/bizlogic/authProvider.dart';
import 'package:matchup/bizlogic/authentication.dart';
import 'package:matchup/bizlogic/friendCodeValidator.dart';
import 'package:matchup/bizlogic/validator.dart';

class UserInfoEntryPage extends StatefulWidget {
  final VoidCallback logoutCallback;

  UserInfoEntryPage({this.logoutCallback});

  @override
  _UserInfoEntryPage createState() => _UserInfoEntryPage();
}

class _UserInfoEntryPage extends State<UserInfoEntryPage> {
  static const MAIN = "main";
  static const SECONDARY = "secondary";
  static const REGION = "region";

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

  bool _isLoading;
  final _formKey = new GlobalKey<FormState>();

  @override
  void initState() {
    _errorMessage = "";
    _isLoading = false;
    _mainChar = null;
    _secondaryChar = null;
    _region = null;
    _nintendoID = null;
    super.initState();
  }

  void resetForm() {
    _formKey.currentState.reset();
    _errorMessage = "";
    _mainChar = null;
    _secondaryChar = null;
    _region = null;
    _nintendoID = null;
  }

  void submitDropdownValue(String value, String hintText){
    setState(() {
      if (hintText == MAIN){
        _mainChar = value;
      }
      else if (hintText == SECONDARY){
        _secondaryChar = value; 
      }
      else if (hintText == REGION){
        _region = value;
      }
    });
  }

  // the hint text determines what value the dropdown menu will change
  // the dropdown items should correspond with the list related to the hint text
  // eg if you give main as hint text, dropdownItems should be the list of characters
  Widget showDropdown(String hintText, List<String> dropdownItems){
    String value;
    return new Center(
      child: DropdownButton<String>(
        value: value,
        icon: Icon(Icons.arrow_downward),
        isExpanded: true,
        hint:Text(
          hintText, // Text drop down at base
          textAlign: TextAlign.justify,
          style: TextStyle( // Text Style base 
            fontSize: 20.0,
          )
        ),
        iconSize: 24,
          elevation: 16,
          style: TextStyle(color: Colors.deepPurple),
          underline: _underLine,
          onChanged: (String newValue) {
            submitDropdownValue(newValue, hintText);
          },
          items: dropdownItems
            .map<DropdownMenuItem<String>>((String value){
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
          }).toList(),
      ));
  } 

  Widget showNintendoIDEntryForm() {
    Validator friendCodeValidator = new FriendCodeValidator();
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
        validator: (value) => friendCodeValidator.validate(value),
        onSaved: (value) => _nintendoID = friendCodeValidator.save(value),
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
        final BaseAuth auth = AuthProvider.of(context).auth;
        FirebaseUser currUser = await auth.getCurrentUser();
        _userID = currUser.uid;
        Firestore.instance.collection('Users').document(_userID).setData({
          'Username' : _userName, 
          'Main' : _mainChar, 
          'Secondary' : _secondaryChar, 
          'Region' : _region, 
          'Username' : _userName, 
          'NintendoID' : _nintendoID});
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

  // Check if form is valid before saving user information
  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    _isLoading = false;
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
              showDropdown(MAIN, con.Constants.characters),
              showDropdown(SECONDARY, con.Constants.characters),
              showDropdown(REGION, con.Constants.regions),
              showNintendoIDEntryForm(),
              showUserNameField(),
              showSaveButton(),
              showErrorMessage(),
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
    } else {
      return new Container(
        height: 0.0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading){
      return LoadingCircle.loadingCircle();
    }
    else{
      return Scaffold(
        appBar: AppBar(
          title: Text('Profile Customization'),
        ),
        body: Stack(
          children: <Widget>[
            _showUserInfoEntryForm(),
          ],
        )
      );
    }
  }

}