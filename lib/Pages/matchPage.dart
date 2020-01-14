import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:matchup/bizlogic/User.dart';
import './challengePage.dart' as cp;
import 'homepage.dart';
import 'package:matchup/bizlogic/userbase.dart' as ub;
import 'package:matchup/bizlogic/mainToImageLinker.dart' as il;


class MatchPage extends StatefulWidget {
  @override
  MatchPageState createState() => MatchPageState();
}

class MatchPageState extends State<MatchPage>{

  @override
  Widget build (BuildContext context) {
    ub.userbase.getUsers();
    final User _user = HomePageProvider.of(context).user;
    return new Scaffold(
      appBar: new AppBar(
        title: new Center(child: Text("MatchList                   ")),
        leading: Icon(Icons.refresh)
      ),
      body: new StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance.collection('Users').snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError)
              return new Text('Error: ${snapshot.error}');
            switch (snapshot.connectionState) {
              case ConnectionState.waiting: return new Text('Loading...');
            default:
              return new ListView.separated(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (BuildContext context, int index) {
                  if(snapshot.data.documents.elementAt(index).documentID != _user.getUserId) {
                    return ListTile(
                      title: new Text(
                        snapshot.data.documents.elementAt(index)['Username'],
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold),
                        ),
                      subtitle: new Image(
                        image: il.ImageLinker.linkImage(snapshot.data.documents.elementAt(index)['Main']),
                        height: 25.0,
                        width: 25.0,
                        alignment: Alignment.centerLeft,),
                      trailing: new Text(
                        snapshot.data.documents.elementAt(index)['Region'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        )),
                      onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => cp.ChallengePage(
                          userId: _user.getUserId, 
                          name: snapshot.data.documents.elementAt(index)['Username'], 
                          main: snapshot.data.documents.elementAt(index)['Main'], 
                          peerId: snapshot.data.documents.elementAt(index).documentID)));
                    },
                    );
                  } else { // used to skip the user so that they dont see themselves in matchlist
                    return Container(
                      child: Text('User'),
                      height: 0.0,
                    );
                  }
                },
                separatorBuilder: (BuildContext context, int index) => const Divider(),
            );
            }
          }
        )
      );
    }

  // @override
  // Widget build(BuildContext context) {
  //   final User _user = HomePageProvider.of(context).user;
  //   final CollectionReference userBase = ub.userbase.getUserCollection();
  //   print("User base testing ");
  //   print("user id " + _user.getUserId);
  //   return StreamBuilder<QuerySnapshot>(
  //     stream: Firestore.instance.collection('Users').snapshots(),
  //     builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
  //       if (snapshot.hasError)
  //         return new Text('Error: ${snapshot.error}');
  //       switch (snapshot.connectionState) {
  //         case ConnectionState.waiting: return new Text('Loading...');
  //         default:
  //           return new ListView(
  //             children: snapshot.data.documents.map((DocumentSnapshot document) {
  //               print("Username " + document.documentID);
  //               if(document.documentID != _user.getUserId) {
  //                 return new ListTile(
  //                   title: new Text(document['Username']),
  //                   subtitle: new Text(document['Main']),
  //                   onTap: (){
  //                     Navigator.push(
  //                       context,
  //                       MaterialPageRoute(builder: (context) => cp.ChallengePage(
  //                         userId: _user.getUserId, 
  //                         name: document['Username'], 
  //                         main: document['Main'], 
  //                         peerId: document.documentID)));
  //                   },
  //                 );
  //               } else {
                  
  //               }
  //             }).toList() ,
  //           );
  //       }
  //     },
  //   );
  // } 

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