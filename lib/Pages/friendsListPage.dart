import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:matchup/Pages/homepage.dart';
import 'package:matchup/bizlogic/authentication.dart';
import 'homepage.dart';
import 'package:matchup/bizlogic/User.dart';
import 'package:matchup/bizlogic/userProvider.dart';

import 'challengePage.dart' as cp;

class FreindsListPage extends StatefulWidget{
  final BaseAuth auth;
  final VoidCallback logoutCallback;

  FreindsListPage({this.auth, this.logoutCallback});
  
  @override
  FreindsListPageState createState() => FreindsListPageState();
}

class FreindsListPageState extends State<FreindsListPage>{


  @override
  Widget build(BuildContext context) {
    final User _user  = UserProvider.of(context).user;
    return new StreamBuilder(
      stream: Firestore.instance.collection('Users').document(_user.getUserId).snapshots(),
      builder: (context, snapshot){
      var userData = snapshot.data;
      return new ListView.separated(
        itemCount: userData["Friends List"].length,
        itemBuilder: (BuildContext context, int index){
          return ListTile(
            title: new Text(
              userData["Friends List"][index]
            ),
            subtitle: new Text(
              userData["Friends List"][index]
            ),
            trailing: new RaisedButton(
              child: Text('smash'),
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => cp.ChallengePage(
                    userId: _user.getUserId, 
                    name: _user.getUserName, 
                    main: _user.getMain, 
                    peerId: ["Friends List"][index])));
              },
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) =>  Divider(
          color: Colors.blueGrey,
          thickness: 1.5,
        ),
      );

      }
    );
    /*
    return StreamBuilder<QuerySnapshot>( // used to be <QuerySnapshot>
      stream: Firestore.instance.collection('Users').snapshots(), // .document(_user.getUserId) was added i think
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) { // used to be <QuerySnapshot>
        if (snapshot.hasError)
          return new Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting: return new Text('Loading...');
          default:
            return new ListView(
              //children: snapshot.data.data(document)
              children: snapshot.data.documents.map((DocumentSnapshot document) {
                return new ListTile(
                  //title: new Text(snapshot.data.data.values(_user.getFriends)),
                  title: new Text(document['Username']),
                  subtitle: new Text(document['Main']),
                  trailing: new RaisedButton(
                    child: Text('smash'),
                    onPressed: (){
                      Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => cp.ChallengePage(
                        userId: _user.getUserId, 
                        name: document['Username'], 
                        main: document['Main'], 
                        peerId: document.documentID)));

                    },
                  ),
                
                );
              }).toList(),
            );
        }
      },
    );*/
  }



}