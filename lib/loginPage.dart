import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'registrationPage.dart';
class LogInPage extends StatefulWidget {
  
  @override
  _LogInPageState createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String _email;
  String _password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          body: Stack(
          children: <Widget>[
            _showLogInForm(),
          ],
        ));
  }

  Widget showEmailField(){
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 250.0, 10.0, 0.0),
      child: new TextFormField(
          obscureText: false,
          style: style,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
              hintText: "Email",
              icon: new Icon(Icons.mail, 
              color: Colors.blueGrey,
              )),
          validator: (value) => value.isEmpty ? 'Email can\'t be empty' : null,
          onSaved: (value) => _email = value.trim(),
      ),
    );
  } 

  Widget showPasswordField(){
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 15.0, 10.0, 0.0),
      child: new TextFormField(
          obscureText: true,
          style: style,
          controller: passwordController,
          decoration: InputDecoration(
              //contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              hintText: "Password",
              icon: new Icon(Icons.lock,
              color: Colors.blueGrey
              )),
          validator: (value) => value.isEmpty ? 'Password can\'t be empty' : null,
          onSaved: (value) => _password = value.trim(),
      ),
    );
  }

  Widget showLogInButton(){
    return new Padding(
        padding: EdgeInsets.fromLTRB(20.0, 45.0, 20.0, 0.0),
        child: SizedBox(
          height: 40.0,
          child: new RaisedButton(
            elevation: 5.0,
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0)),
            color: Colors.deepOrange,
            child: new Text('LOGIN', 
                style: new TextStyle(fontSize: 20.0, color: Colors.white)),
            onPressed: (){
              //where you put AXELS FUNCTIONS
              //for FIRST PAGE...can delete alert dialog
              return AlertDialog(
                title: Text(_email),
                content: Text(_password), //implement firebase stuff here
              ); 
              
            },
          ),
        ));
  }
  
  Widget showRegisterButton(){
        return new FlatButton(
        child: new Text(
            'Create an account',
            style: new TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300)),
        onPressed: (){
          //where you put AXELS FUNCTIONS
          //for FIRST PAGE...push is what procs next page
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RegistrationPage()),
          );
        },
        );
  }

  Widget _showLogInForm() {
    return new Container(
        padding: EdgeInsets.all(16.0),
        child: new Form(
          //key: _formKey,
          child: new ListView(
            shrinkWrap: true,
            children: <Widget>[
              //showLogo(),
              showEmailField(),
              showPasswordField(),
              showLogInButton(),
              showRegisterButton(),
              //showErrorMessage(),
            ],
          ),
        ));
  }
}