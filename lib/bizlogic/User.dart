// there will only ever be one user per running instance of the app,
// so the user should be a singleton
class User {

  // implementing singleton pattern
  User._privateConstructor();
  static final User _instance = User._privateConstructor();
  static User get instance { return _instance; }

  String _userId;
  String _email;
  String _userName; // Players username
  String _main; // Players main character
  String _secondary; // Players secondary
  String _region; // Players region they are located in

  static int _maxFriends = 31;
  List<User> _friendsList = new List<User>(_maxFriends); // Players will have a max friend count
  int _friendCount = 0; // Players friend count

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
  set setSecondary(String secondary) { _secondary= secondary; }

  // region
  String get region => _region;
  set setRegion(String region) { _region = region; }

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
}