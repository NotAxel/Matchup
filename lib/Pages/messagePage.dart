import 'package:flutter/material.dart';
import '../bizlogic/userProvider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:matchup/bizlogic/User.dart';
import 'package:matchup/bizlogic/userProvider.dart';
import 'package:matchup/bizlogic/mainToImageLinker.dart' as il;
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
        ),
      body: Column(
        children: <Widget>[
          buildConversationList(context),
        ],
      )
    );
  }

  Widget buildConversationList(BuildContext context){
    final User _user = UserProvider.of(context).user;
    return Expanded(
      child: StreamBuilder(
        stream: Firestore.instance
            .collection("Users").document(_user.getUserId)  //snapshots of chats for current user
            .collection("Chats").orderBy("chatId", descending: true).snapshots(), //TODO order by time
        builder: (context, snapshot){
          if (snapshot.hasError){
            return snapshotError(snapshot);
          }
          else if (!snapshot.hasData) {
            return startConversation();
          } 
          else return ListView.separated(
            padding: EdgeInsets.fromLTRB(15.0, 10.0, 10.0, 10.0),
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
      ) 
    );
  }

  Widget buildConversation(BuildContext context, DocumentSnapshot conversation){
    final User _user = UserProvider.of(context).user;
    return Container(
      child: FutureBuilder(
        future: Firestore.instance.collection("Users").document(conversation.documentID).get(),
        builder: (context, snapshot){
          if(snapshot.connectionState == ConnectionState.done){
            return ListTile(
              title: new Text(snapshot.data['Username'],
              style: TextStyle(
              fontSize: 30.0,
              )
              ),
              leading: new Image(
                image: il.ImageLinker.linkImage(snapshot.data['Main']),
                height: 25.0,
                width: 25.0,
              ),
              trailing: getLastMessage(context, conversation),
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>
                  chatp.ChatPage(
                  userId: _user.getUserId,
                  name: _user.getUserName,
                  main: _user.getMain,
                  peerId: conversation.documentID,
                  chatId: conversation.data["chatId"])
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
      width: 175.0,
    );
  }

  Widget getLastMessage(BuildContext context, DocumentSnapshot conversation){
    return Container(
      child: StreamBuilder(
        stream: Firestore.instance.collection("Chats")
            .document(conversation.data["chatId"])
            .collection(conversation.data["chatId"])
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
          if(snapshot.connectionState == ConnectionState.active){
            if(snapshot.data.documents.isNotEmpty){
              return Text(snapshot.data.documents
                  .first["content"],
                maxLines: 1,
                style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.blueGrey[100]
                )
              );
            }
            else{
              return Text("");
            }
          }
          else{
            return CircularProgressIndicator();
          }
        }
      ),
      padding: EdgeInsets.fromLTRB(15.0, 10.0, 0.0, 10.0),
    );
  }

  Widget startConversation(){
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
}