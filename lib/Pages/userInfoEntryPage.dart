import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:matchup/Widgets/actionConfirmation.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import 'package:matchup/Widgets/loadingCircle.dart';
import 'package:matchup/bizlogic/constants.dart' as con;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:matchup/bizlogic/authentication.dart';
import 'package:matchup/bizlogic/friendCodeValidator.dart';
import 'package:matchup/bizlogic/validator.dart';

class UserInfoEntryPage extends StatefulWidget {
  final Future<void> Function() loginCallback;
  final Future<void> Function(bool) logoutCallback;

  UserInfoEntryPage(this.loginCallback, this.logoutCallback);

  @override
  _UserInfoEntryPage createState() => _UserInfoEntryPage();
}

class _UserInfoEntryPage extends State<UserInfoEntryPage> {
  static const MAIN = "Main";
  static const SECONDARY = "Secondary";
  static const REGION = "Region";
  static const SKILL = "Skill";

  BaseAuth _auth;
  ActionConfirmation _confirmer;

  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  Container _underLine = Container(height: 2, color: Colors.deepPurple);
  String _mainChar;
  String _secondaryChar;
  String _userName = 'temp';
  String _region = 'Please select a region';
  String _skill;
  String _nintendoID;
  String _userID;

  bool _isLoading;
  final _formKey = new GlobalKey<FormState>();

  @override
  void initState() {
    _isLoading = false;
    _mainChar = null;
    _secondaryChar = null;
    _region = null;
    _nintendoID = null;
    super.initState();
  }

  //void resetForm() {
    //_formKey.currentState.reset();
    //_mainChar = null;
    //_secondaryChar = null;
    //_region = null;
    //_nintendoID = null;
  //}

  String getDropdownButtonValue(String hintText){
    if (hintText == MAIN){
      return _mainChar;
    }
    else if (hintText == SECONDARY){
      return _secondaryChar;
    }
    else if (hintText == REGION){
      return _region;
    }
    else if (hintText == SKILL){
      return _skill;
    }
    return null;
  }

  void setDropdownButtonValue(String value, String hintText){
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
      else if (hintText == SKILL){
        _skill = value;
      }
    });
  }

  // the hint text determines what value the dropdown menu will change
  // the dropdown items should correspond with the list related to the hint text
  // eg if you give main as hint text, dropdownItems should be the list of characters
  // keys will be: main, secondary, region from constants above
  Widget showDropdown(String hintText, List<String> dropdownItems){
    return new Center(
      child: DropdownButton<String>(
        key: Key(hintText),
        value: getDropdownButtonValue(hintText),
        icon: Icon(Icons.arrow_downward),
        isExpanded: true,
        hint: Text(
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
          setDropdownButtonValue(newValue, hintText);
        },
        items: dropdownItems
          .map<DropdownMenuItem<String>>((String value){
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                key: Key(hintText + value),
              ),
            );
          }).toList(),
      )
    );
  } 

  Widget showNintendoFriendCodeEntryForm() {
    Validator friendCodeValidator = new FriendCodeValidator();
    return new Center(
      child: TextFormField(
        key: Key("FriendCode"),
        obscureText: false,
        maxLines: 1,
        style: style,
        autofocus: false,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          hintText: "Nintendo Friend Code",
          errorMaxLines: 5
        ),
        validator: (value) => friendCodeValidator.validate(value),
        onSaved: (value) => _nintendoID = friendCodeValidator.save(value),
      )); 
  }

  Widget showUserNameField() {
    return new Center(
      child: TextFormField(
        key: Key("Username"),
        obscureText: false,
        maxLength: 30,
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
            key: Key("SaveProfile"),
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
      _isLoading = true;
    });
    if (validateAndSave()){
      FirebaseUser currUser = await _auth.getCurrentUser();
      _userID = currUser.uid;
      await Firestore.instance.collection('Users').document(_userID).setData({
        'Main' : _mainChar, 
        'Secondary' : _secondaryChar, 
        'Region' : _region, 
        'Skill' : _skill,
        'Username' : _userName, 
        'NintendoID' : _nintendoID});
      await widget.loginCallback();
      Navigator.of(context).pop();
    }
    setState(() {
      _isLoading = false;
    });
  }

  // Check if form is valid before saving user information
  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  // original dimensions of regions map
  // height: 500, width: 410
  Widget showRegionsMap(){
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Image(
        key: Key('RegionsMap'),
        image: AssetImage('assets/images/regionsMap.png'),
        height: 250,
        width: 205,
      ),
    );
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
            showDropdown(SKILL, <String>["Beginner", "Intermediate", "Advanced"]),
            showNintendoFriendCodeEntryForm(),
            showUserNameField(),
            showSaveButton(),
            showRegionsMap(),
          ],
        ),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    _auth = Provider.of<BaseAuth>(context);

    _confirmer = ActionConfirmation(
      context, 
      '''Are you sure you want to cancel Profile Customization?\n
This will also delete your account.''',
      // confirm cancelation 
      () async {
        await widget.logoutCallback(true);
        Navigator.maybePop(context, true);
      }, 
      // deny cancelation
      () async => Navigator.pop(context, false) 
    );

    if (_isLoading){
      return LoadingCircle.loadingCircle();
    }
    else{
      return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            title: Text('Profile Customization'),
            leading: IconButton(
              key: Key("cancelButton"),
              icon: Icon(Icons.cancel), 
              onPressed: ()=>Navigator.maybePop(context))
          ),
          body: Stack(
            children: <Widget>[
              _showUserInfoEntryForm(),
            ],
          )
        ),
        onWillPop: _confirmer.confirmAction,
      );
    }
  }

}