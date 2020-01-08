import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:matchup/bizlogic/User.dart';
import './challengePage.dart' as cp;
import 'homepage.dart';


class MatchPage extends StatefulWidget {
  @override
  MatchPageState createState() => MatchPageState();
}

class MatchPageState extends State<MatchPage>{

  @override
  Widget build(BuildContext context) {
    final User _user = HomePageProvider.of(context).user;
    print(_user.getUserId);
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('Users').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError)
          return new Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting: return new Text('Loading...');
          default:
            return new ListView(
              children: snapshot.data.documents.map((DocumentSnapshot document) {
                return new ListTile(
                  title: new Text(document['Username']),
                  subtitle: new Text(document['Main']),
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => cp.ChallengePage(
                        userId: _user.getUserId, 
                        name: document['Username'], 
                        main: document['Main'], 
                        peerId: document.documentID)));
                  },
                );
              }).toList(),
            );
        }
      },
    );
  }

/*
  @override
  Widget build(BuildContext context) {
    List<AccountListing> listings;
    return new Scaffold(
      appBar: new AppBar(
        title: new Center(child: Text("MatchMaking     ")),
        leading: Icon(Icons.refresh)
      ),
      // body: new MatchListing(name: johnny.name, main: johnny.main)
      body: new ListView.builder(
        shrinkWrap: true,
        itemCount: listings.length,
        itemBuilder: (BuildContext ctxt, int index) {
          return new Container(
            child: InkWell(
              child: ListTile(
                leading: Icon(Icons.pregnant_woman),
                title: MatchListing(name:listings[index].userName, main:listings[index].main),
                onTap: () {
                  Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (context) => cp.ChallengePage(name:listings[index].userName, main:listings[index].main)));
                }
              ),
            ),
            decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: 1.0, color: Colors.lightBlue.shade900),
                ),
            )
          );
        }
      )
    );
  }

}

class AccountListing {
  String userName;
  String nintendoID;

  String main;
  String secondary;

  String region;
  String chattingWith;

  AccountListing({this.userName, this.nintendoID, this.main, this.secondary, this.region, this.chattingWith});
}

class MatchListing extends StatelessWidget {
  final String name;
  final String main;

  final TextStyle matchStyle = TextStyle(fontSize: 23);

  MatchListing({@required this.name, @required this.main});

  @override
  Widget build(BuildContext context) {
    return new Container(
      // color: Colors.green,
      child: Text(name + " : " + main, style: matchStyle),
      
    );
  }
  */
}

// class MatchmakingDisplay extends StatefulWidget {
//   @override
//   MatchmakingDisplayState createState() => new MatchmakingDisplayState();
// }

// class MatchmakingDisplayState extends State<MatchmakingDisplay> 
//   with SingleTickerProviderStateMixin {

//   var profStyle = TextStyle(fontSize: 25);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold();
//   }
// }