// there will only ever be one user per running instance of the app,
// so the user should be a singleton
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class User {

  // implementing singleton pattern
  static final User _instance = User._internal();

  factory User() {
    return _instance;
  }

  User._internal();

  String _userId;
  String _email;
  String _userName; // Players username
  String _main; // Players main character
  String _secondary; // Players secondary
  String _region; // Players region they are located in
  String _friendCode; // players nintendo switch friend code

  /*
  static int _maxFriends = 31;
  List<User> _friendsList = new List<User>(_maxFriends); // Players will have a max friend count
  int _friendCount = 0; // Players friend count
  */

  // Getters and Setters
  // userId
  String get getUserId => _userId;
  set setUserId(String id) { _userId = id; }

  // email 
  String get getEmail => _email;
  set setEmail(String email) { _email = email; }

  // userName
  String get getUserName => _userName;
  set setUserName(String userName) { _userName = userName; }

  // main
  String get getMain => _main;
  set setMain(String main) { _main = main; }

  // secondary
  String get getSecondary => _secondary;
  set setSecondary(String secondary) { _secondary = secondary; }

  // region
  String get getRegion => _region;
  set setRegion(String region) { _region = region; }

  String get getFriendCode => _friendCode;
  set setFriendCode(String friendCode) { _friendCode= friendCode; }

  // takes a user id as a string
  // sets the users userId and populates the users remaining fields
  // by collecting data from the firebase
  Future<void> initializeData(FirebaseUser firebaseUser) async{
    _userId = firebaseUser.uid;
    _email = firebaseUser.email;
    DocumentSnapshot userInformation = await Firestore.instance.collection('Users').document(_userId).get();
    if (userInformation.exists){
      _userName = userInformation['Username'];
      _main = userInformation['Main'];
      _secondary = userInformation['Secondary'];
      _friendCode = userInformation['NintendoID'];
      _region = userInformation['Region'];
    }
  }

  bool hasBeenInitialized(){
    return 
      _userId != null &&
      _email != null &&
      _userName != null &&
      _main != null && 
      _secondary != null &&
      _friendCode != null &&
      _region != null;
  }


  /*
  // friendsList
  List<User> get getFriendsList => _friendsList;
  set setFriendsList(List<User> friendsList) { _friendsList = friendsList; }

  // friendCount
  int get getfriendCount => _friendCount;
  set setFriendCount(int friendCount) { _friendCount = friendCount; }

  /// Adding a friend to this users friends list
  void addFriend (User friend){
    if(_friendCount < _maxFriends) {
      _friendsList.add(friend);
      _friendCount++;
    }
  }
  */
}