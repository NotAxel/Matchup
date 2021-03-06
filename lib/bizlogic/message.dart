class Message{

  String _content;
  String _toId;
  String _fromId;
  int _timeStamp;
  
  Message(String content, String toId, String fromId){
    _content = content;
    _toId = toId;
    _fromId = fromId;
  }

  // content
  String get getContent => _content;
  set setContent(String content){ _content = content; } 

  // toId
  String get getToId => _toId;
  set setToId(String toId){ _toId = toId; } 

  // fromId 
  String get getFromId => _fromId;
  set setFromId(String fromId){ _fromId = fromId; } 

  // timeStamp
  String get getTimeStamp => _timeStamp.toString();
  set setTimeStamp(int timeStamp){ _timeStamp = timeStamp; }

}