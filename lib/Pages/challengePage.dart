import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:matchup/bizlogic/constants.dart';
import 'package:matchup/bizlogic/User.dart';
import './chatPage.dart' as chatp;


class ChallengePage extends StatefulWidget {

  final User user;
  final DocumentSnapshot peer;

  ChallengePage({@required this.user, @required this.peer});

  @override
  _ChallengePageState createState() => _ChallengePageState();
}

class _ChallengePageState extends State<ChallengePage> {
  final profStyle = TextStyle(fontSize: 25);

  bool _visible = true;
  void _toggle()
  {
    setState(() {
      _visible = false;
      print("success");
    });
  }

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
                Text(this.widget.peer.data["Username"], style: TextStyle(fontSize: 30)),
//                Text(this.peer.data["Username"] + "\nUser Id\n" + this.user.getUserId +  "\nPeer Id\n" + this.peer.documentID, style: profStyle),
                Text(''),
                //Should get profile pic from firebase
                Image.asset(nameMap[this.widget.peer["Main"]], height: 300),
                Text(''),
                //Should get mains from firebase
                Text(this.widget.peer.data["Main"], style: profStyle),

                RaisedButton(
                  
                  child: Text('Smash', style: TextStyle(fontSize: 30, color: Colors.white)),
                  color: Colors.redAccent,
                  onPressed: () {
                    goToChatPage(context, widget.user, this.widget.peer.documentID);
                  },
                  ),
                  
                  Visibility(visible: true,
                  child: new RaisedButton(
                    child: Text('Add Friend', style: TextStyle(fontSize: 20, color: Colors.white)),
                    color: Colors.redAccent,
                    onPressed: () {
                      Firestore.instance.collection('Users').document(widget.user.getUserId).updateData({
                        'Friends List' : FieldValue.arrayUnion([this.widget.peer.documentID])});
                      setState(() {
                        _visible = false;
                      });
                      _showDialog(context);

                      //_toggle();
                      //add pop-up if successfull
                    },
                  )),
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

  void changeOpacity(context)
  {

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

  void goToChatPage(BuildContext context, User user, String peerId) async{
    String chatId = await initiateChatWithPeer(user.getUserId, peerId);
    Navigator.push(
      context, 
      MaterialPageRoute(builder: (context) => 
        chatp.ChatPage(
          user: this.widget.user,
          peer: this.widget.peer,
          chatId: chatId)));
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