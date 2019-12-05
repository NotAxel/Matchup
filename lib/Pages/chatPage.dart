import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'homepage.dart';

class ChatPage extends StatefulWidget {
  final String userId;
  final String name;
  final String main;
  final String peerId;

  const ChatPage({Key key, this.userId, this.name, this.main, this.peerId}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController messageController = new TextEditingController();
  final _formKey = new GlobalKey<FormState>();

  @override
  void initState() {
    Firestore.instance.collection("Users").document(widget.userId).updateData({'chattingWith': widget.peerId});
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.userId.toString())
      ),
      body: Center(
        child:  Scaffold(
          body: new Center (
            child: Column(
              children: <Widget>[
                new Text(widget.peerId.toString()),
              ],
            )
          ),
          bottomNavigationBar: TextField(
            controller: messageController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'chat', 
            ),
            onSubmitted: (value){
              Firestore.instance.collection("Users").document(widget.peerId).updateData({'message': value});
              messageController.clear();
            },
          ),
        )
      ),
    );
  }
}