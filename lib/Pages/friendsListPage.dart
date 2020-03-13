import 'package:flutter/material.dart';
import 'package:matchup/bizlogic/peer.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:matchup/bizlogic/User.dart';
import 'package:matchup/bizlogic/constants.dart' as con;
import './chatPage.dart' as chatp;

class FriendsListPage extends StatefulWidget {
  @override
  FriendsListPageState createState() => FriendsListPageState();
}

class FriendsListPageState extends State<FriendsListPage>{
  final ScrollController listScrollController = new ScrollController();
  
  @override
  Widget build(BuildContext context){
    return new Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        title: new Center(child: Text("Friends List")),
        actions: <Widget>[
          IconButton(
            key: Key("infoButton"),
            icon: Icon(Icons.person), 
            onPressed: () { 
              _showInfo(context);
            },
          ),
        ]
      ),
      body: Column(
        children: <Widget>[
          buildFriendsList(context),
        ],
      )
    );
  }

  Widget buildFriendsList(BuildContext context){
    final User _user = Provider.of<User>(context);
    return Expanded(
      child: StreamBuilder(
        stream: Firestore.instance
            .collection("Users").document(_user.getUserId)
            .collection("Friends").orderBy("Friend", descending: true).snapshots(), 
        builder: (context, snapshot){
          if (snapshot.hasError){
            return snapshotError(snapshot);
          }
          else if (!snapshot.hasData) { 
            return noFriends();
          } 
          else {
            print(snapshot.data);
            return ListView.separated(
            padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
            itemBuilder: (context, index) =>
                buildFriends(context, snapshot.data.documents[index]),
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

  Widget buildFriends(BuildContext context, DocumentSnapshot friend){
    return Container(
      child: FutureBuilder(
        future: Firestore.instance.collection("Users").document(friend.documentID).get(),
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
              subtitle: new Image(
                image: AssetImage(con.Constants.minSpritesMap[snapshot.data['Secondary']]),
                height: 15.0,
                width: 15.0,
                alignment: Alignment.bottomLeft,
              ),

              trailing: IconButton(
                key: Key("chatButton"),
                icon: new Icon(Icons.chat), 
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (BuildContext context) =>
                      chatp.ChatPage(
                        Peer(
                          friend.documentID,
                          snapshot.data["Username"],
                          snapshot.data["Main"],
                          snapshot.data["Secondary"],
                          snapshot.data["Region"],
                          snapshot.data["Skill"],
                        ),
                        snapshot.data["chatId"]
                      )
                    )
                  );
                },
              ),
              onLongPress: (){
                _showID(context,snapshot);
                
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

 void _showInfo(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return AlertDialog(
        title: new Text('Here is the Friends List!'),
        elevation: 100.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text("Here you can:", style: TextStyle(fontWeight: FontWeight.bold)),
              Text("Press the message icon to chat with a friend"),
              Text(""),
              Text("Hold down a user to see their Nintendo ID"),
            ]
          )
        ),
        actions: <Widget>[
          // button at the bottom of the dialog
          new FlatButton(
            key: Key("closeShowInfo"),
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
void _showID(BuildContext context, AsyncSnapshot snapshot) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return AlertDialog(
        title: new Text(snapshot.data['Username'], style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 100.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text("NintendoID: ", style: TextStyle(fontWeight: FontWeight.bold)),
              Text(snapshot.data['NintendoID']),
              //prints the friends Nintendo ID
            ]
          )
        ),
        actions: <Widget>[
          // button at the bottom of the dialog
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

  Widget noFriends(){
    return Center(
      child: Container(
        child: Text(
          "No current friends :(",
          key: Key("noFriends"),
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

