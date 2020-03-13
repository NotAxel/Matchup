import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:matchup/bizlogic/User.dart';
import 'package:matchup/bizlogic/peer.dart';
import 'package:provider/provider.dart';

class NewMessageForm extends StatefulWidget{
  final User user;
  const NewMessageForm(this.user);

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
    return Material(
        type: MaterialType.transparency,
        child: showNewMessageForm(),
    );
  }

  Widget showNewMessageForm(){
    return Container(
      margin: EdgeInsets.fromLTRB(20, 50, 20, 650),
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
                Text("New Message", 
                  style: TextStyle(fontSize: 22, 
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                showOtherUserSearchField(),
              ],
            )
          ),
        )
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
        DocumentSnapshot peerDocSnap = qs.documents.first;
        Peer peer = Peer(
          peerDocSnap.documentID,
          peerDocSnap.data['Username'],
          peerDocSnap.data['Main'],
          peerDocSnap.data['Secondary'],
          peerDocSnap.data['Region'],
          peerDocSnap.data['Skill'],
        );
        String chatId = await widget.user.initiateChatWithPeer(peer.getUserId);
        Navigator.of(context).pop(<Object>[peer, chatId]);

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
    else if(value.compareTo(widget.user.getUserName) == 0){
      return 'You cannot message yourself...find a friend';
    }
  }
}