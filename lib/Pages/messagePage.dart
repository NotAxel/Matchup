import 'package:flutter/material.dart';
import 'package:matchup/bizlogic/peer.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:matchup/bizlogic/User.dart';
import 'package:matchup/bizlogic/constants.dart' as con;
import './chatPage.dart' as chatp;
import 'package:matchup/Pages/deletePopupForm.dart' as dpf;
import 'package:matchup/Pages/newMessageForm.dart' as nmf;
import './chatPage.dart' as chatp;

class MessagePage extends StatefulWidget {
  @override
  MessagePageState createState() => MessagePageState();
}

class MessagePageState extends State<MessagePage>{
  final ScrollController listScrollController = new ScrollController();

  @override
  Widget build(BuildContext context){
    return new Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        title: new Center(child: Text("Messages")),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.create),
            key: Key("create conversation"),
            onPressed: () {
              createConversation(context);
            },
          ),
        ]
      ),
      body: Column(
        children: <Widget>[
          buildConversationList(context),
        ],
      )
    );
  }

  //main page layout, creates the overall list
  Widget buildConversationList(BuildContext context){
    final User user = Provider.of<User>(context);
    return Expanded(
      child: StreamBuilder(
        stream: Firestore.instance
            .collection("Users").document(user.getUserId)//snapshots of chats collection for current user
            .collection("Chats").orderBy("chatId", descending: true).snapshots(), //TODO order by time if possible
        builder: (context, snapshot){
          if (snapshot.hasError){
            return snapshotError(snapshot);
          }
          else if (!snapshot.hasData) {//if collection returns an empty list
            return noConversations();
          } 
          else {
            return ListView.separated(
            padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
            itemBuilder: (context, index) => //for each conversation builds a tile
              buildConversation(context, snapshot.data.documents[index], user),
            itemCount: snapshot.data.documents.length,
            controller: listScrollController,
            scrollDirection: Axis.vertical,
            shrinkWrap: true, 
            separatorBuilder: (BuildContext context, int index) =>  Divider(
                color: Colors.blueGrey,
                thickness: 1.5,
              ),
            );
          }
        }
      ) 
    );
  }

  //creates each tile for individual conversations
  Widget buildConversation(BuildContext context, DocumentSnapshot peerDocumentSnapshot, User user){
    return Container(
      child: FutureBuilder(//need FutureBuilder for the .get(), snapshot is of the data of the other user
        future: Firestore.instance.collection("Users").document(peerDocumentSnapshot.documentID).get(),
        builder: (context, snapshot){
          if(snapshot.connectionState == ConnectionState.done){
            try{
              // create peer using the given snapshot from the future builder
              Peer peer = Peer(
                peerDocumentSnapshot.documentID,
                snapshot.data["Username"],
                snapshot.data["Main"],
                snapshot.data["Secondary"],
                snapshot.data["Region"],
              );
              // add the peer to a list of peers so it can be searched without making
              // another backend call
              return ListTile(
                title: new Text(snapshot.data['Username'],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                  )
                ),
                leading: new Image(
                  image: AssetImage(con.Constants.minSpritesMap[snapshot.data['Main']]),
                  height: 35.0,
                  width: 35.0,
                ),
                subtitle: getLastMessage(context, peerDocumentSnapshot),
                trailing: IconButton(
                  icon: new Icon(Icons.delete_outline), 
                  onPressed: (){
                    deleteConversation(context, peerDocumentSnapshot, snapshot);
                  },
                ),
                onTap: (){  //navigates to chat page
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (BuildContext context) =>
                      chatp.ChatPage(
                        peer,
                        peerDocumentSnapshot.data["chatId"]
                      )
                    )
                  );
                }
              );
            }
            catch(e){
              Firestore.instance.collection('Users')
                .document(user.getUserId)
                .collection('Chats')
                .document(peerDocumentSnapshot.documentID).delete();
            }
          }
          else{
            return Text("");
          }
        }, 
      ),
      height: 60.0,
    );
  }

  //gets preview of most recent message for the subtitle
  Widget getLastMessage(BuildContext context, DocumentSnapshot conversation){
    return Container(
      child: StreamBuilder(
        stream: Firestore.instance.collection("Chats")
            .document(conversation.data["chatId"])
            .collection(conversation.data["chatId"])
            .orderBy('timeStamp', descending: true)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){  
          if(snapshot.connectionState == ConnectionState.active){
            if(snapshot.hasData && snapshot.data.documents.isNotEmpty){
              return Text(snapshot.data.documents
                  .first["content"],
                maxLines: 1,
                style: TextStyle(
                  fontSize: 12.0,
                  color: Colors.blueGrey[100]
                )
              );
            }
            else{
              return Text("");  //instead of returning circular indicator
            }
          }
          else{
            return Text("");  //instead of returning circular indicator
          }
        }
      ),
      padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
    );
  }

  //creates the popup to confirm account deletion
  deleteConversation(BuildContext context, DocumentSnapshot conversation, AsyncSnapshot snap){
    Navigator.push(
      context,
      FilterPopupPage(
        key: Key("delete conversation"),
        top: 200,
        left: 20,
        bottom: 300,
        right: 20,
        child: Scaffold(
          appBar: AppBar(
            title: Text("DELETE CONVERSATION?"),
            leading: new Builder(builder: (context) {
              return IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  try {
                    Navigator.pop(context);
                  } catch(e) {}
                },
              );
            }),
            brightness: Brightness.light,
          ),
          resizeToAvoidBottomPadding: false,
          body: dpf.DeletePopupForm(conversation: conversation, otherUser: snap),
        )
      )
    );
  }

  //create a conversation with another user based on username
  createConversation(BuildContext context){
    // Navigator.push(
    //   context,
    //   FilterPopupPage(
    //     top: 0,
    //     left: 20,
    //     bottom: 600,
    //     right: 20,
    //     child: Scaffold(
    //       appBar: AppBar(
    //         title: Text("New Message"),
    //         leading: new Builder(builder: (context) {
    //           return IconButton(
    //             icon: Icon(Icons.arrow_back),
    //             onPressed: () {
    //               try {
    //                 Navigator.pop(context);
    //               } catch(e) {}
    //             },
    //           );
    //         }),
    //         brightness: Brightness.light,
    //       ),
    //       resizeToAvoidBottomPadding: false,
    //       body: nmf.NewMessageForm(),
    //     )
    //   )
    // );
  }

  //when the users collection fo chats is empty
  Widget noConversations(){
    return Center(
      key: Key("no conversations"),
      child: Container(
        child: Text(
          "   No current messages :(\n\nGo to MatchList to SMASH!",
          style: TextStyle(color: Colors.blueGrey[300], fontSize: 20),
        ),
      )
    );
  }

  Widget snapshotError(AsyncSnapshot snapshot){
    return Center(
      child: Container(
        child: Text(
          "uh oh, an error occurred retrieving the Firebase snapshot:\n ${snapshot.error}",
          style: TextStyle(color: Colors.red),
        ),
      )
    );
  }
}