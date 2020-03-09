import 'package:flutter/material.dart';
import 'package:matchup/Pages/filterPopupPage.dart';
import 'package:matchup/bizlogic/peer.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:matchup/bizlogic/User.dart';
import 'package:matchup/bizlogic/constants.dart' as con;
import './chatPage.dart' as chatp;
import 'package:matchup/Pages/deletePopupForm.dart' as dpf;

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
            onPressed: () {
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

  Widget buildConversationList(BuildContext context){
    final User _user = Provider.of<User>(context);
    return Expanded(
      child: StreamBuilder(
        stream: Firestore.instance
            .collection("Users").document(_user.getUserId)  //snapshots of chats for current user
            .collection("Chats").orderBy("chatId", descending: true).snapshots(), //TODO order by time
        builder: (context, snapshot){
          if (snapshot.hasError){
            return snapshotError(snapshot);
          }
          else if (!snapshot.hasData) {   //TODO FIX not showing no Conversation widget
            return noConversations();
          } 
          else {
            print(snapshot.data);
            return ListView.separated(
            padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
            itemBuilder: (context, index) =>
                buildConversation(context, snapshot.data.documents[index]),
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

  Widget buildConversation(BuildContext context, DocumentSnapshot peer){
    final User user = Provider.of<User>(context);
    return Container(
      child: FutureBuilder(
        future: Firestore.instance.collection("Users").document(peer.documentID).get(),
        builder: (context, snapshot){
          if(snapshot.connectionState == ConnectionState.done){
            return ListTile(
              title: new Text(snapshot.data['Username'],  //fixed indentation
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
              subtitle: getLastMessage(context, peer),
              trailing: IconButton(
                icon: new Icon(Icons.delete_outline), 
                onPressed: (){
                  deleteConversation(context, peer, snapshot);
                },
              ),
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (BuildContext context) =>
                    chatp.ChatPage(
                      Peer(
                       peer.documentID,
                       snapshot.data["Username"],
                       snapshot.data["Main"],
                       snapshot.data["Secondary"],
                       snapshot.data["Region"],
                      ),
                      snapshot.data["chatId"]
                    )
                  )
                );
              }
            );
          }
          else{
            return Text("");
          }
        }, 
      ),
      height: 60.0,
    );
  }

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
            if(snapshot.data.documents.isNotEmpty){
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

  Widget noConversations(){
    return Center(
      child: Container(
        child: Text(
          "No current messages :(\n Go to Matchup Listing to SMASH!",
          style: TextStyle(color: Colors.blueGrey[300]),
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

  deleteConversation(BuildContext context, DocumentSnapshot conversation, AsyncSnapshot snap){
    Navigator.push(
      context,
      FilterPopupPage(
        top: 200,
        left: 20,
        bottom: 200,
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
          body: dpf.DeletePopupForm(conversation: conversation, otherUser: snap,),
          //),
        )
      )
    );
  }
}