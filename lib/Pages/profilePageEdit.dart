import 'package:flutter/material.dart';
import 'package:matchup/Pages/homepage.dart';
import 'package:matchup/bizlogic/User.dart';
import 'package:matchup/bizlogic/constants.dart' as con;
import 'package:matchup/bizlogic/userProvider.dart';

class ProfilePageEdit extends StatefulWidget {
  final VoidCallback logoutCallback;
  final User user;

  ProfilePageEdit({this.user, this.logoutCallback});

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePageEdit> with SingleTickerProviderStateMixin {
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

  @override
  void initState() {
    _errorMessage = "";
    _mainChar = null;
    _region = null;
    _nintendoID = null;
    super.initState();
  }

  Widget showSecondaryField(){
    return new Center(
      child: DropdownButton<String>(
        value: _secondaryChar,
        icon: Icon(Icons.arrow_downward),
/*         isExpanded: true, */
        hint:Text(
            'Select Secondary', // Text drop down at base
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
          items: con.Constants.characters
            .map<DropdownMenuItem<String>>((String value){
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
          }).toList(),
      )
    );
  } 

  Widget showMainField(){
    return new Center(
      child: DropdownButton<String>(
        value: _mainChar,
        icon: Icon(Icons.arrow_downward),
/*         isExpanded: true, */
        hint:Text(
            'Select Main', // Text drop down at base
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
          items: con.Constants.characters
            .map<DropdownMenuItem<String>>((String value){
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
          }).toList(),
      )
    );
  } 

  var profStyle = TextStyle(fontSize: 25);

  Widget showLogOutButton(VoidCallback logoutCallback){
    return new Padding(
        padding: EdgeInsets.fromLTRB(115.0, 10.0, 115.0, 0.0),
        child: SizedBox(
          height: 40.0,
          width: 100,
          child: new RaisedButton(
            key: Key('logout'),
            elevation: 5.0,
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0)),
            color: Colors.blueAccent,
            child: new Text('Confirm',
                style: new TextStyle(fontSize: 20.0, color: Colors.white)),
            onPressed: logoutCallback 
          ),
        ));
  }

  Widget _showForm(VoidCallback logoutCallback) {
    return new Container(
        padding: EdgeInsets.all(16.0),
        child: new Form(
          //key: _formKey,
          child: new ListView(
            shrinkWrap: true,
            children: <Widget>[
              showLogOutButton(logoutCallback)
            ],
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    final User _user = UserProvider.of(context).user;
    final VoidCallback logoutCallback = HomePageProvider.of(context).logoutCallback;
    return Column(
          children: [
            Container(height: 50),
/*             Text(_user.getUserName, style: profStyle), */
            Text("User Configuration", style: profStyle),
            Center(child: Image.asset(con.nameMap[_user.getMain], height: 300)), 
            //Center(child: Image.asset(nameMap[_user.getMain], height: 300)),
/*             Container(height: 50), */
            Text("Main:"),
            showMainField(),
            Text("Secondary:"),
            showSecondaryField(),
            //Should get mains from firebase
//            Text(_user.getMain, style: profStyle),
/*             Text("Main: " + _user.getMain + "\nSecondary: " + _user.getSecondary, style: profStyle), */
            _showForm(logoutCallback),
            ]
        );
  }
}