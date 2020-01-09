class Message{

  String _content;
  String _toId;
  String _fromId;
  DateTime _timeStamp;
  
  Message(String content, String toId, String fromId){
    _content = content;
    _toId = toId;
    _fromId = fromId;
    _timeStamp = DateTime.now();
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
  get getTimeStamp => _timeStamp;

}