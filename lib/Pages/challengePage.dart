import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:matchup/bizlogic/peer.dart';
import 'package:provider/provider.dart';

import 'package:matchup/bizlogic/constants.dart';
import 'package:matchup/bizlogic/User.dart';


class ChallengePage extends StatefulWidget {

  final Peer _peer;

  ChallengePage(this._peer);

  @override
  _ChallengePageState createState() => _ChallengePageState();
}

class _ChallengePageState extends State<ChallengePage> {
  final profStyle = TextStyle(fontSize: 25);
  bool isFriend = false;


  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context){
    User user = Provider.of<User>(context, listen: false);
    checkIfFriend(context, user, widget._peer);
    //initState();
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
                Text(this.widget._peer.getUserName, style: TextStyle(fontSize: 30)),
                Text(''),
                //Should get profile pic from firebase
                Image.asset(nameMap[this.widget._peer.getMain], height: 300),
                Text(''),
                //Should get mains from firebase
                Text(this.widget._peer.getMain, style: profStyle),
                
                RaisedButton(
                  child: Text('Chat', style: TextStyle(fontSize: 20, color: Colors.white)),
                  color: Colors.redAccent,
                  onPressed: () {
                    goToChatPage(context, user);
                  },
                  ),
                  if(!isFriend)
                    RaisedButton(
                      child: Text('Add Friend', style: TextStyle(fontSize: 20, color: Colors.white)),
                      color: Colors.redAccent,
                      onPressed: () {
                        Firestore.instance
                          .collection('Users').document(user.getUserId)
                          .collection('Friends').document(this.widget._peer.getUserId).setData({'Friend': this.widget._peer.getUserId});
                        _showDialog(context);
                        //add pop-up if successfull
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

  void goToChatPage(BuildContext context, User user) async{
    String chatId = await initiateChatWithPeer(user.getUserId, this.widget._peer.getUserId);
    Navigator.pushNamed(context, "/chat", 
      arguments: <Object>[
        Peer(
          this.widget._peer.getUserId,
          this.widget._peer.getUserName,
          this.widget._peer.getMain,
          this.widget._peer.getSecondary,
          this.widget._peer.getRegion,
        ),
        chatId
      ]
    );
  }

  checkIfFriend(BuildContext context, User user, Peer _peer) async{
    DocumentSnapshot ds = await Firestore.instance.collection('Users').document(user.getUserId).collection('Friends').document(_peer.getUserId).get();
    if(this.mounted){
      this.setState((){
        isFriend = ds.exists;
      });
    }

}

} 



// user defined function
void _showDialog(BuildContext context) {
  // flutter defined function
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return AlertDialog(
        title: new Text("Friend Added!"),
        elevation: 100.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        //content: new Text("Alert Dialog body"),
        actions: <Widget>[
          // usually buttons at the bottom of the dialog
          new FlatButton(
            child: new Text("Close"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}