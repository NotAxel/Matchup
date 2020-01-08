import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

/** This is the default user class that each user will have. The information for this 
 * will be pulled form the firebase server.
 */

int MAX_FRIENDS = 31;

class User {
  String email;
  String userName; // Players username
  String main; // Players main character
  String secondary; // Players secondary
  String region; // Players region they are located in
  var friendsList = new List(MAX_FRIENDS); // Players will have a max friend count
  int friendCount = 0; // Players friend count


  //Getters
  String get getName {
    return userName;
  }

  String get getMain {
    return main;
  }

  String get getSecondary {
    return secondary;
  }

  String get getRegion {
    return region;
  }
  
  int get getFriendCount {
    return friendCount;
  }

  /// Adding a friend to this users friends list
  void addFriend (User friend){
    if(friendCount < MAX_FRIENDS) {
      friendsList.add(friend);
    }
  }
}