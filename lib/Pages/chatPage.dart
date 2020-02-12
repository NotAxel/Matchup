import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:matchup/bizlogic/User.dart';
import 'package:matchup/bizlogic/message.dart';
import 'package:matchup/bizlogic/constants.dart';
import 'package:matchup/bizlogic/chatPageLogic.dart';
import 'package:matchup/Widgets/loadingCircle.dart';
import 'package:matchup/bizlogic/userProvider.dart';

class ChatPage extends StatefulWidget {
  final DocumentSnapshot peer;
  final String chatId;

  const ChatPage(
    {Key key, this.peer, this.chatId})
    : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  // make instance variables have underscores
  final TextEditingController _messageController = new TextEditingController();
  final ScrollController _listScrollController = new ScrollController();
  final FocusNode _focusNode = new FocusNode();

  User _user;
  Message _message;
  List<DocumentSnapshot> listMessage;

  // idea for messaging structure from flutter community guide
  // https://medium.com/flutter-community/building-a-chat-app-with-flutter-and-firebase-from-scratch-9eaa7f41782e
  @override
  Widget build(BuildContext context) {
    _user = UserProvider.of(context).user;
    _message = new Message("", widget.peer.documentID, _user.getUserId);
    return Scaffold(
      appBar: AppBar(
        title: buildPeerInfo(),
      ),
      body: GestureDetector(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            buildMessageList(),
            buildMessageInputContainer()
          ],
        ),
        onTap: (){
          FocusScope.of(context).requestFocus(new FocusNode());
        },
      )
    );
  }

  // takes a file location as a string
  // file location should be in the format
  // assets/images/small_sprites/characterName.png
  // returns sprite of the users main
  Widget buildPeerMainCharacterSprite(String main){
    return Container(
      key: Key("MAIN_SPRITE"),
      child: Image.asset(main, cacheWidth: 30, cacheHeight: 30,),
      padding: EdgeInsets.only(right: 10),
    );
  }

  // takes a file location as a string
  // file location should be in the format
  // assets/images/small_sprites/characterName.png
  // returns sprite of the users secondary 
  Widget buildPeerSecondaryCharacterSprite(String secondary){
    return Container(
      key: Key("SECONDARY_SPRITE"),
      child: Image.asset(secondary, cacheWidth: 30, cacheHeight: 30,),
      padding: EdgeInsets.only(
        left: 10,
        right: 50),
    );
  }

  // takes a string for the peer username
  // returns a text widget to be displayed in peer info
  // in the app bar
  Widget buildPeerUserName(String username){
    return Expanded(
      child: Center(
        child: Text(username), 
      )
    );
  }

  // constructs the information to be placed in the app bar about the peer
  Widget buildPeerInfo(){
    return Row(children: <Widget>[
      // puts the image of the users main left of their name
      buildPeerMainCharacterSprite(Constants.minSpritesMap[widget.peer["Main"]]),
      // places text for the Username in between main and secondary
      buildPeerUserName(widget.peer["Username"]),
      // puts the image of the users secondary right of their name
      buildPeerSecondaryCharacterSprite(Constants.minSpritesMap[widget.peer["Secondary"]])
      ],
    );
  }

  Widget snapshotError(AsyncSnapshot snapshot){
    return Center(
      child: Container(
        child: Text(
          "uh oh, an error occurred retrieving the Firebase snapshot:\n ${snapshot.error}",
          style: TextStyle(color: Colors.red),
        ),
      )
    );
  }

  Widget buildMessageList(){
    return Expanded(
      child: StreamBuilder(
        stream: Firestore.instance
            .collection("Chats")
            .document(widget.chatId)
            .collection(widget.chatId)
            .orderBy('timeStamp', descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError){
            return snapshotError(snapshot);
          }
          else if (!snapshot.hasData) {
            return LoadingCircle.loadingCircle();
          } 
          else {
            listMessage = snapshot.data.documents;
            return ListView.builder(
              padding: EdgeInsets.all(10.0),
              itemBuilder: (context, index) =>
                buildMessageBoxes(index, snapshot.data.documents[index]),
              itemCount: snapshot.data.documents.length,
              controller: _listScrollController,
              scrollDirection: Axis.vertical,
              reverse: true,
              shrinkWrap: true,
            );
          }
        },
      ),
      flex: 3
    );
  }

  // returns a containter that holds a text widget
  // the text widgets data is the time the message was sent
  Widget buildMessageTimeStamp(int timeStamp){
    // time stamp
    return Container(
      child: Text(
          ChatPageLogic.formatTimeStamp(timeStamp),
          style: TextStyle(
            color: Colors.blueGrey,
            fontSize: 12.0,
          )
        ),
      padding: EdgeInsets.only(left: 10),
    );
  }

  // building messages
  // index is the index of the current item being built obtained from listBuilder
  // and document is the snapshot of the current message log for the given chatId
  // if the fromId of the message is the current users, the message displays on right
  // otherwise, the fromId is from the peerId and appears on left
  Widget buildMessageBoxes(int index, DocumentSnapshot document){
    int timeStamp = int.tryParse(document['timeStamp']);
    bool isUserMessage = document['fromId'] == _user.getUserId;
    return Row(
      mainAxisAlignment: ChatPageLogic.rowMainAxisAlignment(isUserMessage),
      children: <Widget>[
        Container(
          // make another function for column - don't go passed 2 children deep without new function
          child: Column(
            crossAxisAlignment: ChatPageLogic.columnCrossAxisAlignment(isUserMessage),
            children: <Widget>[
              Container(
                child: Text(
                  document['content'],
                  style: TextStyle(color: ChatPageLogic.messageTextColor(isUserMessage)),
                ),
                padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                width: 175.0,
                decoration: BoxDecoration(
                  color: ChatPageLogic.messageBoxColor(isUserMessage),
                  borderRadius: BorderRadius.circular(8.0)),
              ),
              buildMessageTimeStamp(timeStamp),
              ]
            ),
            margin: ChatPageLogic.messageContainerMargins(index)
          )
        ]
      );
  }

  // container that holds send message button and message input field 
  Widget buildMessageInputContainer(){
    return Container(
      child: Row(
        children: <Widget>[
          buildSendFriendCodeButton(),
          buildMessageInput(),
          buildSendButton(),
        ],
      ),
      padding: EdgeInsets.fromLTRB(10, 10, 0, 10),
      decoration: new BoxDecoration(
        border: new Border(top: new BorderSide(color: Colors.grey[100], width: 0.5)),
        color: Colors.grey[300]
      ),
    );
  }

  Widget buildSendFriendCodeButton(){
    return Flexible(
      key: Key("SEND_FRIEND_CODE_BUTTON"),
      child: Material(
        child: IconButton(
          color: Colors.lightBlue,
          onPressed: (){
            _message.setContent = _user.getFriendCode;
            sendMessage();
          },
          icon: Icon(
            Icons.videogame_asset
          )
        ),
        color: Colors.grey[300],
      ),
      flex: 1,
    );
  }

  Widget buildMessageInput(){
    return Flexible(
      key: Key("MESSAGE_INPUT_FIELD"),
      child: TextField(
        controller: _messageController,
        minLines: 1,
        maxLines: 5,
        keyboardType: TextInputType.multiline,
        //textInputAction: TextInputAction.done,
        decoration: InputDecoration.collapsed(
          hintText: 'Send a message...',
        ),
        focusNode: _focusNode,
      ),
      flex: 6,
    );
  }


  Widget buildSendButton(){
    return Flexible(
      key: Key("SEND_MESSAGE_BUTTON"),
      child: Material(
        child: IconButton(
          color: Colors.lightBlue,
          onPressed: (){
            _message.setContent = _messageController.text;
            sendMessage();
            _messageController.clear();
          },
          icon: Icon(
            Icons.send
          )
        ),
        color: Colors.grey[300],
      ),
    flex: 1,
    );
  }

  // receives a message with updated contents when the chat box is submitted
  // creates a message document using a time stamp to ensure uniqueness in the given chatId
  void sendMessage() {
    _message.setTimeStamp = DateTime.now().millisecondsSinceEpoch;
    if (_message.getContent != "") {
      DocumentReference messageReference = Firestore.instance
        .collection("Chats")
        .document(widget.chatId)
        .collection(widget.chatId)
        .document(_message.getTimeStamp);

      // this method allows for an asyncrhonous write to occur without the whole function being async
      Firestore.instance.runTransaction((transaction) async {
        await transaction.set(messageReference, {
          'content': _message.getContent,
          'toId': _message.getToId,
          'fromId': _message.getFromId,
          'timeStamp': _message.getTimeStamp,
        });
      });
      _listScrollController.animateTo(0.0,
        duration: Duration(milliseconds: 0), curve: Curves.fastOutSlowIn);
    }
  }
}