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
    return Material(
        type: MaterialType.transparency,
        child: showDeleteForm(),
    );
  }

  Widget showDeleteForm() {
    return Container(
      margin: EdgeInsets.fromLTRB(20, 150, 20, 450),
      // width: 350,
      // height: 200,
      decoration: new BoxDecoration(
        border: Border.all(color: Colors.black, width: 1.0),
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      child: Center(
        child: Padding( 
          padding: EdgeInsets.fromLTRB(10, 5, 10, 5.0),
          child: new Form(
            key: _formKey,
            child: new ListView(
              shrinkWrap: true,
              children: <Widget>[
                Text("DELETE CONVERSATION?", 
                  style: TextStyle(fontSize: 22, 
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                showConfirmationMessage(),
                const SizedBox(height: 10),
                showButtons(),
              ],
            )
          ),
        )
      )
    );
  }

  Widget showConfirmationMessage() {
    return Center(
      child: Text("Delete conversation with " + widget.otherUser.data['Username'] + "?", 
        style: TextStyle(fontSize: 20.0, 
          color: Colors.black,
          fontWeight: FontWeight.normal
          ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget showDeleteButton() { 
    return new Padding(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: SizedBox(
        height: ButtonHeight,
        width: ButtonWidth,
        child: new RaisedButton(
          elevation: 5.0,
          color: Colors.red,
          shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(30.0)
          ),
          child: new Text('Delete'),
          onPressed: () {
            validateAndSubmit();
          },
        ),
      ),
    );
  }

  Widget showCancelButton() {  
    return new Padding(
      padding: EdgeInsets.fromLTRB(5.0, 5, 5, 0),
      child: SizedBox(
        height: ButtonHeight,
        width: ButtonWidth,
        child: new FlatButton(
          color: Colors.white,
          shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(30.0)
          ),
          child: new Text('Cancel'),
          onPressed: (){Navigator.of(context).pop();}
       )
      ),
    );
  }

  Widget showButtons() {
    return new Container(
      child: new Column(
        children: <Widget>[
          showDeleteButton(),
          showCancelButton(),
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