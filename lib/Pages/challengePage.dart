import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import './chatPage.dart' as chatp;
import './friendsListPage.dart' as friendsListp;


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
                  child: Text('Smash', style: TextStyle(fontSize: 20, color: Colors.white)),
                  color: Colors.redAccent,
                  onPressed: () {
                    goToChatPage(context, userId, peerId);
                  },
                  ),
                  RaisedButton(
                  child: Text('Add Friend', style: TextStyle(fontSize: 20, color: Colors.white)),
                  color: Colors.deepPurple,
                  onPressed: () {
                    Firestore.instance.collection('Users').document(userId).updateData({
                      'Friends List' : FieldValue.arrayUnion([peerId])});
                    //goToFriendsListPage(context,userId, peerId);
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

  // returns a chatId using the userId and peerId
  // the chatId is a combination of the two argument id
  // based on their hash values
  // the chatId is then stored in each users Chats and is used to create a chat between the two
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

  // uses the userId and peerId to construct the chatId and any necessary firebase documents required for p2p messaging
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

  /* uses the current build context, the userId, and peerId as arguments
     obtains the chatId between the user and the peer
     navigates to the chatPage in order to being p2p messaging
  */
  void goToChatPage(BuildContext context, String userId, String peerId) async{
    String chatId = await initiateChatWithPeer(userId, peerId);
    Navigator.push(
      context, 
      MaterialPageRoute(builder: (context) => 
        chatp.ChatPage(
          userId: this.userId,
          name: this.name,
          main: this.main,
          peerId: this.peerId,
          chatId: chatId)));
  }

  void goToFriendsListPage(BuildContext context, String userId, String peerId) async{
    Navigator.push(
      context, 
      MaterialPageRoute(builder: (context) => 
        friendsListp.FreindsListPage()));
  }
} 