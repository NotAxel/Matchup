import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

List<String> litems = ["1", "2", "3"];
List<AccountListing> listings = [new AccountListing("John", "Marth"), johnny, jim];
AccountListing johnny = new AccountListing("Johnny", "Ness");
AccountListing jim = new AccountListing("Jim", "Lucas");

class MatchPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Center(child: Text("MatchMaking")),
      ),
      // body: new MatchListing(name: johnny.name, main: johnny.main)
      body: new ListView.builder(
        itemCount: listings.length,
        itemBuilder: (BuildContext ctxt, int index) {
          return new InkWell(
            child: ListTile(
              leading: Icon(Icons.pregnant_woman),
              title: MatchListing(name:listings[index].name, main:listings[index].main)
            ),
            onTap: () {}
          );
        }
      )
    );
  }
}

class AccountListing {
  String name;
  String main;

  AccountListing(String name, String main) {
    this.name = name;
    this.main = main;
  }
}

class MatchListing extends StatelessWidget {
  final String name;
  final String main;

  final TextStyle matchStyle = TextStyle(fontSize: 23);

  MatchListing({@required this.name, @required this.main});

  @override
  Widget build(BuildContext context) {
    return new Container(
      // color: Colors.green,
      child: Text(name + " : " + main, style: matchStyle),
      
    );
  }
}

// class MatchmakingDisplay extends StatefulWidget {
//   @override
//   MatchmakingDisplayState createState() => new MatchmakingDisplayState();
// }

// class MatchmakingDisplayState extends State<MatchmakingDisplay> 
//   with SingleTickerProviderStateMixin {

//   var profStyle = TextStyle(fontSize: 25);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold();
//   }
// }