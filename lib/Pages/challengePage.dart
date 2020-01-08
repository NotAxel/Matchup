import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import './chatPage.dart' as chatp;


class ChallengePage extends StatelessWidget {

  final profStyle = TextStyle(fontSize: 25);

  final String userId;
  final String name;
  final String main;
  final String peerId;

  ChallengePage({@required this.userId, @required this.name, @required this.main, @required this.peerId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Challenge"),
      ),
      body: Center(
        child:  Scaffold(
          body: new Center (
            child: Column(
              children: <Widget>[
                Text(''),
                //Should get username from firebase
                Text(this.name + " " + this.userId.toString() +  " " + this.peerId.toString(), style: profStyle),
                Text(''),
                //Should get profile pic from firebase
                Image.asset('assets/images/default_profile.jpg', height: 300),
                Text(''),
                //Should get mains from firebase
                Text(this.main, style: profStyle),
                RaisedButton(
                  child: Text('Smash', style: TextStyle(fontSize: 30, color: Colors.white)),
                  color: Colors.redAccent,
                  onPressed: () {
                    InitiateChatWithPeer(userId, peerId);
                    Navigator.push(
                      context, 
                      MaterialPageRoute(builder: (context) => 
                        chatp.ChatPage(
                          userId: this.userId,
                          name: this.name,
                          main: this.main,
                          peerId: this.peerId)));
                  },
                  ),
                RaisedButton(
                  child: Text('Go back!'),
                  onPressed: () {
                    // goes back
                    Navigator.pop(context);
                  },
                ),
              ],
            )
          )
        )
      ),
    );
  }

  void InitiateChatWithPeer(String userId, String peerId){
    String chatId = userId + "_" + peerId;
    // if the chat does not already exist for one of the users, create it
    Firestore.instance.collection('Users').document(userId).collection('Chats').document(peerId).setData({'chatId': chatId});
    Firestore.instance.collection('Users').document(peerId).collection('Chats').document(userId).setData({'chatId': chatId});
  }
} 