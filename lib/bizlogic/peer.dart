class Peer {
  String _userId;
  String _userName; // Players username
  String _main; // Players main character
  String _secondary; // Players secondary
  String _region; // Players region they are located in

  Peer(this._userId, this._userName, this._main, this._secondary, this._region);

  // userId
  String get getUserId => _userId;
  set setUserId(String id) { _userId = id; }

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
}