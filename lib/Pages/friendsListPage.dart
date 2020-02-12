import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:matchup/bizlogic/authentication.dart';
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
    // TODO: implement build
    

    final User _user  = UserProvider.of(context).user;
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
                  trailing: new RaisedButton(
                    child: Text('smash'),
                    onPressed: (){
                      Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => cp.ChallengePage(
                        document,
                        )
                      )
                    );

                    },
                  ),
                
                );
              }).toList(),
            );
        }
      },
    );
  }



}