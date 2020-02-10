import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:matchup/Pages/homepage.dart';
import 'package:matchup/bizlogic/authentication.dart';
import 'homepage.dart';
import 'package:matchup/bizlogic/User.dart';
import 'package:matchup/bizlogic/userProvider.dart';
import 'package:matchup/bizlogic/constants.dart' as con;

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
    return new Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        title: new Center(child: Text("Friends List")),
        ),
      body: new StreamBuilder(
        stream: Firestore.instance.collection('Users').document(_user.getUserId).snapshots(),
        //gets a stream of the current user
        builder: (context, snapshot){
          var userData = snapshot.data;
          return new ListView.separated(
            itemCount: userData["Friends List"].length,
            itemBuilder: (BuildContext context, int index){
              return ListTile(
                // requires a new stream builder for each tile
                subtitle: new StreamBuilder(
                    stream: Firestore.instance.collection('Users').document(userData["Friends List"][index]).snapshots(),
                    builder: (context,snapshot){
                      var friend = snapshot.data;
                      return new Text(friend["Main"]);
                      //returns friend's Main
                    }
                ),
                title: new StreamBuilder(
                    stream: Firestore.instance.collection('Users').document(userData["Friends List"][index]).snapshots(),
                    builder: (context,snapshot){
                      var friend = snapshot.data;
                      return new Text(friend["Username"]);
                      //shows friend's Username
                    }
                ),
                leading: new StreamBuilder(
                    stream: Firestore.instance.collection('Users').document(userData["Friends List"][index]).snapshots(),
                    builder: (context,snapshot){
                      var friend = snapshot.data;
                      return new Image(
                        image: AssetImage(con.Constants.minSpritesMap[friend['Main']]),
                        height: 25.0,
                        width: 25.0,
                        alignment: Alignment.centerLeft,
                        //shows friend's picture
                      );
                    }
                ),
                trailing: new RaisedButton(
                  child: Text('Smash'),
                  onPressed: (){
                    new StreamBuilder(
                      stream: Firestore.instance.collection('Users').document(userData["Friends List"][index]).snapshots(),
                      builder: (context,snapshot){
                        var friend = snapshot.data;
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => cp.ChallengePage(
                            user: _user, 
                            peer: snapshot.data.documents.elementAt(index)
                          )
                          )
                        );
                      },
                    );
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
      )
    );

  }

}
