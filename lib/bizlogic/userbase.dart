import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:matchup/bizlogic/User.dart';

class userbase {

  static CollectionReference getUserCollection() {
    return Firestore.instance.collection('Users');
  }

  static void getUsers() {
    List<User> userBase;
    CollectionReference usersCollectionReference = Firestore.instance.collection('Users');
    print("test " + usersCollectionReference.id);
    Stream qs = Firestore.instance.collection('Users').snapshots();

  }
}