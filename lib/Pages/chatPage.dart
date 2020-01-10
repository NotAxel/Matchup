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

  final _formKey = new GlobalKey<FormState>();

  Message _message;
  var listMessage;

  @override
  void initState() {
    // simulates how the message class will be used to communicate and send data to the firebase
    _message = new Message('', widget.peerId, widget.userId);
    super.initState();
  }

  // idea for messaging structure from flutter community guide
  // https://medium.com/flutter-community/building-a-chat-app-with-flutter-and-firebase-from-scratch-9eaa7f41782e
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Chatting")),
      body: Center(
          child: Scaffold(
        body: new Center(
            child: Column(
          children: <Widget>[
            new Text("USER ID:" +
                widget.userId.toString() +
                "\n" +
                "PEER ID:" +
                widget.peerId.toString()),
            Flexible(
              child: StreamBuilder(
                stream: Firestore.instance
                    .collection("Chats")
                    .document(widget.chatId)
                    .collection(widget.chatId)
                    .orderBy("timeStamp", descending: true)
                    .limit(20)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                        child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.lightBlue)));
                  } else {
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
            )
          ],
        )),
        bottomNavigationBar: TextField(
          controller: messageController,
          minLines: 1,
          maxLines: 5,
          keyboardType: TextInputType.multiline,
          textInputAction: TextInputAction.send,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'chat',
          ),
          onSubmitted: (messageContents) {
            _message.setContent = messageContents;
            sendMessage();
            messageController.clear();
          },
        ),
      )),
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
          width: 200.0,
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
          width: 200.0,
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
}
