import 'package:flutter/material.dart';
import 'chatPage.dart' as chatp;

List<MessageListing> messageListings = [new MessageListing(name: "John", main:"Marth")];

class MessagePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Center(child: Text("Messaging       ")),
        leading: Icon(Icons.refresh)
      ),
      // body: new MatchListing(name: johnny.name, main: johnny.main)
      body: new ListView.builder(
        itemCount: messageListings.length,
        itemBuilder: (BuildContext ctxt, int index) {
          return new InkWell(
            child: Container(
              height: 70,
              child: Align(
                alignment: Alignment.centerLeft,
                child: ListTile(
                  leading: Icon(Icons.chat_bubble_outline, size: 30,),
                  title: MessageListing(name:messageListings[index].name, 
                                      main:messageListings[index].main),
                onTap: () {
                  Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (context) => 
                      chatp.ChatPage(
                        name:messageListings[index].name, 
                        main:messageListings[index].main)));
                }
                ),
              )
            ),
            onTap: () {}
          );
        }
      )
    );
  }
}

class MessageListing extends StatelessWidget {
  final String name;
  final String main;

  final TextStyle matchStyle = TextStyle(fontSize: 28);

  MessageListing({@required this.name, @required this.main});

  @override
  Widget build(BuildContext context) {
    return new Container(
      // color: Colors.green,
      child: Text(name, style: matchStyle),
      
    );
  }
}