import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:matchup/bizlogic/User.dart';
import 'package:provider/provider.dart';

class NewMessageForm extends StatefulWidget{

  @override
  _NewMessageForm createState()  => _NewMessageForm();
}

class _NewMessageForm extends State<NewMessageForm> {
  User _user;
  String _errorMessage;
  bool _isLoading;
  String _otherName = 'temp';
  final _formKey = new GlobalKey<FormState>();
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  
  @override
  Widget build(BuildContext context) {
    _user = Provider.of<User>(context);
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
        DocumentSnapshot peerDocSnap = qs.documents.first;
        String chatId = await initiateChatWithPeer(_user.getUserId, peerDocSnap.documentID);
        Navigator.popAndPushNamed(context, "/chat", arguments: <Object>[peerDocSnap, chatId]);
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
  
  String constructChatid(String userId, String peerId){
    String chatId;
    if (userId.hashCode <= peerId.hashCode) {
      chatId = '$userId-$peerId';
    } 
    else {
      chatId = '$peerId-$userId';
    }
    return chatId;
  }

  Future<String> initiateChatWithPeer(String userId, String peerId) async{
    String chatId = constructChatid(userId, peerId);

    // dont have to use await here since they are just references like memory addresses
    DocumentReference userReference = Firestore.instance.collection('Users').document(userId).collection('Chats').document(peerId);
    DocumentReference peerReference = Firestore.instance.collection('Users').document(peerId).collection('Chats').document(userId);

    // need to use await here because of the db get call 
    DocumentSnapshot userSnapshot = await userReference.get();
    DocumentSnapshot peerSnapshot = await peerReference.get();

    // if the chat does not exist for the users, create it
    if (!userSnapshot.exists){
      Firestore.instance.collection('Users').document(userId).collection('Chats').document(peerId).setData({'chatId': chatId});
    }

    // if the chat does not exist for the peer, create it
    if (!peerSnapshot.exists){
      Firestore.instance.collection('Users').document(peerId).collection('Chats').document(userId).setData({'chatId': chatId});
    }

    return chatId;
  }
}