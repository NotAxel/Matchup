import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:matchup/bizlogic/message.dart';

class ChatPage extends StatefulWidget {
  final String userId;
  final String name;
  final String main;
  final String peerId;
  final String chatId;

  const ChatPage(
      {Key key, this.userId, this.name, this.main, this.peerId, this.chatId})
      : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController messageController = new TextEditingController();
  final ScrollController listScrollController = new ScrollController();
  final FocusNode focusNode = new FocusNode();

  //final _formKey = new GlobalKey<FormState>();

  Message _message;
  var listMessage;

  @override
  void initState() {
    super.initState();
    // messages are from to the peer from the user
    _message = new Message("", widget.peerId, widget.userId);
  }

  // idea for messaging structure from flutter community guide
  // https://medium.com/flutter-community/building-a-chat-app-with-flutter-and-firebase-from-scratch-9eaa7f41782e
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chatting"),),
      body: GestureDetector(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            showIds(),
            buildMessageList(context),
            buildMessageInputContainer(context)
          ],
        ),
        onTap: (){
          FocusScope.of(context).requestFocus(new FocusNode());
        },
      )
    );
  }

  Widget showIds(){
    return Text("USER ID:" +
        widget.userId.toString() +
        "\n" +
        "PEER ID:" +
        widget.peerId.toString());
  }

  Widget snapshotError(){
    return Center(
      child: Container(
        child: Text(
          "uh oh, an error occurred retrieving the Firebase snapshot",
          style: TextStyle(color: Colors.red),
        ),
      )
    );
  }

  Widget loadingCircle(){
    return Center(
        child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
                Colors.lightBlue)));
  }

  Widget buildMessageList(BuildContext context){
    return Expanded(
      child: StreamBuilder(
        stream: Firestore.instance
            .collection("Chats")
            .document(widget.chatId)
            .collection(widget.chatId)
            .orderBy("timeStamp", descending: true)
            .limit(20)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError){
            return snapshotError();
          }
          else if (!snapshot.hasData) {
            return loadingCircle();
          } 
          else {
            return ListView.builder(
              padding: EdgeInsets.all(10.0),
              itemBuilder: (context, index) =>
                  buildMessageBoxes(index, snapshot.data.documents[index]),
              itemCount: snapshot.data.documents.length,
              reverse: true,
              controller: listScrollController,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
            );
          }
        },
      ),
      flex: 3
    );
  }

  // building messages
  // arguments are the index of the current item being built obtained from listBuilder
  // and document is the snapshot of the current message log for the given chatId
  // if the fromId of the message is the current users, the message displays on right
  // otherwise, the fromId is from the peerId and appears on left
  Widget buildMessageBoxes(int index, DocumentSnapshot document) {
    if (document['fromId'] == widget.userId) {
      // Right (my message)
      return Row(children: <Widget>[
        // Text
        Container(
          child: Text(
            document['content'],
            style: TextStyle(color: Colors.white),
          ),
          padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
          width: 175.0,
          decoration: BoxDecoration(
              color: Colors.blue[400],
              borderRadius: BorderRadius.circular(8.0)),
          margin: EdgeInsets.only(
              left: 180,
              bottom: isLastMessageRight(index) ? 20.0 : 10.0,
              right: 10.0),
        )
      ]);
    } else {
      return Row(children: <Widget>[
        // Text
        Container(
          child: Text(
            document['content'],
            style: TextStyle(color: Colors.black),
          ),
          padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
          width: 175.0,
          decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(8.0)),
          margin: EdgeInsets.only(
              bottom: isLastMessageRight(index) ? 20.0 : 10.0, right: 10.0),
        )
      ]);
    }
  }

  bool isLastMessageLeft(int index) {
    if ((index > 0 &&
            listMessage != null &&
            listMessage[index - 1]['idFrom'] == widget.userId) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  bool isLastMessageRight(int index) {
    if ((index > 0 &&
            listMessage != null &&
            listMessage[index - 1]['idFrom'] != widget.userId) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  // container that holds send message button and message input field 
  Widget buildMessageInputContainer(BuildContext context){
    return Container(
      child: Row(
        children: <Widget>[
          buildMessageInput(context),
          buildSendButton(),
        ],),
      padding: EdgeInsets.fromLTRB(20, 10, 0, 10),
      decoration: new BoxDecoration(
        border: new Border(top: new BorderSide(color: Colors.grey[100], width: 0.5)),
        color: Colors.grey[300]
      ),
    );
  }

  Widget buildMessageInput(BuildContext context){
    return Flexible(
        child: TextField(
        controller: messageController,
        minLines: 1,
        maxLines: 5,
        keyboardType: TextInputType.multiline,
        //textInputAction: TextInputAction.done,
        decoration: InputDecoration.collapsed(
          hintText: 'Send a message...',
        ),
        focusNode: focusNode,
        onSubmitted: (messageContents) {
        },
      ),
      flex: 1,
    );
  }


  Widget buildSendButton(){
    return Material(
      child: IconButton(
        color: Colors.lightBlue,
        onPressed: (){
          _message.setContent = messageController.text;
          sendMessage();
          messageController.clear();
        },
        icon: Icon(
          Icons.send
        )
      ),
      color: Colors.grey[300],
    );
  }

  // receives a message with updated contents when the chat box is submitted
  // creates a message document using a time stamp to ensure uniqueness in the given chatId
  void sendMessage() {
    if (_message.getContent != "") {
      DocumentReference messageReference = Firestore.instance
          .collection("Chats")
          .document(widget.chatId)
          .collection(widget.chatId)
          .document(DateTime.now().millisecondsSinceEpoch.toString());

      // this method allows for an asyncrhonous write to occur without the whole function being async
      Firestore.instance.runTransaction((transaction) async {
        await transaction.set(messageReference, {
          'content': _message.getContent,
          'toId': _message.getToId,
          'fromId': _message.getFromId,
          'timeStamp': _message.getTimeStamp
        });
      });
      listScrollController.animateTo(0.0,
          duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    }
  }
}