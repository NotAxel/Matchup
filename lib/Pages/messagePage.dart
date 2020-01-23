import 'package:flutter/material.dart';
import '../bizlogic/userProvider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:matchup/bizlogic/User.dart';
import 'package:matchup/bizlogic/userProvider.dart';

//List<MessageListing> messageListings = [new MessageListing(name: "John", main:"Marth")];

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
      body: GestureDetector(
        child: Column(
          children: <Widget>[
            buildConversationList(context),
          ],)
      ,)
    );
  }

  Widget buildConversationList(BuildContext context){
    final User _user = UserProvider.of(context).user;
    return Container(
      child: StreamBuilder(
        stream: Firestore.instance
            .collection("Users").document(_user.getUserId)
            .collection("Chats").orderBy("chatID", descending: true).snapshots(),
        builder: (context, snapshot){
          if (snapshot.hasError){
            return snapshotError(snapshot);
          }
          else if (!snapshot.hasData) {
            return startConversation();
          } 
          else return ListView.builder(
            padding: EdgeInsets.all(10.0),
            itemBuilder: (context, index) =>
                buildConversation(context, snapshot.data.documents[index]),
            itemCount: snapshot.data.documents.length,
            reverse: true,
            controller: listScrollController,
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
          );
        }
      )
    );
  }

  Widget buildConversation(BuildContext context, DocumentSnapshot conversation){
    //Stream<DocumentSnapshot> receiver = Firestore.instance.
        //collection("Users").document(conversation.documentID).snapshots();
    return Row(children: <Widget>[
      getConversationInfo(context, conversation)
    ]);
  }

  Widget getConversationInfo(BuildContext context, DocumentSnapshot conversation){
    return Container(
      child: StreamBuilder(
        stream: Firestore.instance.
            collection("Users").document(conversation.documentID).snapshots(),
        builder: (context, snapshot){
          if (snapshot.hasError){
            return snapshotError(snapshot);
          }
          else return Container(child:
            ListView.separated(
              padding: EdgeInsets.all(10.0),
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: new Text(
                    snapshot.data.elementAt(index)['Username'],
                    style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold),
                  ),
                );
              }, separatorBuilder: (BuildContext context, int index) => Divider(
                color: Colors.blueGrey,
                thickness: 0,
              ),
            )
          );
        },
      )
    );
  }

  Widget startConversation(){
    return Center(
      child: Container(
        child: Text(
          "No current messages :(\n Go to MatchUp Listing to SMASH!",
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

  /*Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Center(child: Text("Messaging       ")),
        leading: Icon(Icons.refresh)
      ),
      // body: new MatchListing(name: johnny.name, main: johnny.main)
      body: new ListView.builder(
        itemCount: messageListings.length,
        itemBuilder: (BuildContext ctxt, int index) {
          return new InkWell(
            child: Container(
              height: 70,
              child: Align(
                alignment: Alignment.centerLeft,
                child: ListTile(
                  leading: Icon(Icons.chat_bubble_outline, size: 30,),
                  title: MessageListing(name:messageListings[index].name, 
                                      main:messageListings[index].main),
                onTap: () {
                  Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (context) => 
                      chatp.ChatPage(
                        name:messageListings[index].name, 
                        main:messageListings[index].main)));
                }
                ),
              )
            ),
            onTap: () {}
          );
        }
      )
    );
  } */
}

/*class MessageListing extends StatelessWidget {
  final String name;
  final String main;

  final TextStyle matchStyle = TextStyle(fontSize: 28);

  MessageListing({@required this.name, @required this.main});

  @override
  Widget build(BuildContext context) {
    return new Container(
      // color: Colors.green,
      child: Text(name, style: matchStyle),
      
    );
  }
}*/