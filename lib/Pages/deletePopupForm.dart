import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:matchup/bizlogic/authentication.dart';

import 'package:provider/provider.dart';

class DeletePopupForm extends StatefulWidget{
  final DocumentSnapshot conversation;
  final AsyncSnapshot otherUser;

  const DeletePopupForm({Key key, this.conversation, this.otherUser}) : super(key: key);

  @override
  _DeletePopupForm createState()  => _DeletePopupForm();
}

class _DeletePopupForm extends State<DeletePopupForm> {
  static const double ButtonWidth = 130.0;
  static const double ButtonHeight = 40.0;
  String _errorMessage;
  bool _isLoading;
  final _formKey = new GlobalKey<FormState>();
  
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget> [
        showDeleteForm(),
      ],
    );
  }

  Widget showDeleteForm() {
    return new Container(
      padding: EdgeInsets.all(16.0),
      child: new Form(
        key: _formKey,
        child: new ListView(
          shrinkWrap: true,
          children: <Widget>[
            const SizedBox(height: 15),
            showConfirmationMessage(),
            const SizedBox(height: 20),
            showButtons(),
          ],
        )
      ),
    );
  }

  Widget showConfirmationMessage() {
    return new Center(
      child: Text("Delete conversation with " + widget.otherUser.data['Username'] + "?")
    );
  }

  Widget showYesButton() { 
    return new Padding(
      padding: EdgeInsets.fromLTRB(5.0, 15, 5, 0),
      child: SizedBox(
        height: ButtonHeight,
        width: ButtonWidth,
        child: new RaisedButton(
          elevation: 10.0,
          color: Colors.lightGreen,
          shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(30.0)
          ),
          child: new Text('YES'),
          onPressed: () {
            validateAndSubmit();
          },
        ),
      ),
    );
  }

  Widget showNoButton() {  //change to NO button
    return new Padding(
      padding: EdgeInsets.fromLTRB(5.0, 15, 5, 0),
      child: SizedBox(
        height: ButtonHeight,
        width: ButtonWidth,
        child: new RaisedButton(
          elevation: 10.0,
          color: Colors.deepOrange,
          shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(30.0)
          ),
          child: new Text('NO'),
          onPressed: (){Navigator.of(context).pop();}
       )
      ),
    );
  }

  Widget showButtons() {
    return new Container(
      child: new Row(
        children: <Widget>[
          const SizedBox(width: 23),
          showYesButton(),
          const SizedBox(width: 15),
          showNoButton(),
          const SizedBox(width: 24),
        ],)
    );
  }

  validateAndSubmit() async {
    setState(() {
      _errorMessage = "";
      _isLoading = true;
    });
    if (validateAndSave()){
      try {
        final BaseAuth auth = Provider.of<BaseAuth>(context, listen: false);
        FirebaseUser currUser = await auth.getCurrentUser();
        Firestore.instance.collection('Users')
          .document(currUser.uid)
          .collection('Chats')
          .document(widget.conversation.documentID).delete();
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
  
}