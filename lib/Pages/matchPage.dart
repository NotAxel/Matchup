import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import './challengePage.dart' as cp;

List<String> litems = ["1", "2", "3"];
List<AccountListing> listings = [new AccountListing("John", "Marth"), johnny, jim, jim1, jim2, jim3, jim4, jim5, jim6, jim7, jim8, jim9, jim10];
AccountListing johnny = new AccountListing("Johnny", "Ness");
AccountListing jim = new AccountListing("Jim", "Lucas");
AccountListing jim1= new AccountListing("Jeff", "Yoshi");
AccountListing jim2= new AccountListing("Jeffrey", "Roy");
AccountListing jim3= new AccountListing("Jeb", "Mario");
AccountListing jim4= new AccountListing("Jimichangas", "Lucas");
AccountListing jim5= new AccountListing("Jun", "Dr Mario");
AccountListing jim6= new AccountListing("Jimmy", "Wolf");
AccountListing jim7= new AccountListing("Josh", "Fox");
AccountListing jim8= new AccountListing("Joshua", "Falco");
AccountListing jim9= new AccountListing("Jarl", "Pikachu");
AccountListing jim10= new AccountListing("Jacob", "Lucario");

class MatchPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Center(child: Text("MatchMaking     ")),
        leading: Icon(Icons.refresh)
      ),
      // body: new MatchListing(name: johnny.name, main: johnny.main)
      body: new ListView.builder(
        shrinkWrap: true,
        itemCount: listings.length,
        itemBuilder: (BuildContext ctxt, int index) {
          return new Container(
            child: InkWell(
              child: ListTile(
                leading: Icon(Icons.pregnant_woman),
                title: MatchListing(name:listings[index].name, main:listings[index].main),
                onTap: () {
                  Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (context) => cp.ChallengePage(name:listings[index].name, main:listings[index].main)));
                }
              ),
            ),
            decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: 1.0, color: Colors.lightBlue.shade900),
                ),
            )
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
