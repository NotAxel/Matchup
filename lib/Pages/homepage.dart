import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../authentication.dart';
import './friendPage.dart' as friendp;
import './profilePage.dart' as profilep;
import './messagePage.dart' as messagep;

class HomePage extends StatelessWidget {
  final String userId;
  final BaseAuth auth;
  final VoidCallback logoutCallback;

  HomePage({this.userId, this.auth, this.logoutCallback});

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Matchup login demo"),
      ),
      body: new MyTabs()
    );
  }
  
  // @override
  // Widget build(BuildContext context) {
  //   return new Scaffold(
  //     appBar: new AppBar(
  //       title: new Text("Matchup login demo"),
  //     ),
  //     body: Stack(
  //     children: <Widget>[
  //       Text("You have successfully logged into Matchup"),
  //         _showForm(),
  //       ],
  //     )
  //   );
  // }

  Widget showLogOutButton(){
    return new Padding(
        padding: EdgeInsets.fromLTRB(20.0, 45.0, 20.0, 0.0),
        child: SizedBox(
          height: 40.0,
          child: new RaisedButton(
            elevation: 5.0,
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0)),
            color: Colors.deepOrange,
            child: new Text('Logout',
                style: new TextStyle(fontSize: 20.0, color: Colors.white)),
            onPressed: logoutCallback,
          ),
        ));
  }


  Widget _showForm() {
    return new Container(
        padding: EdgeInsets.all(16.0),
        child: new Form(
          //key: _formKey,
          child: new ListView(
            shrinkWrap: true,
            children: <Widget>[
              showLogOutButton()
            ],
          ),
        ));
  }
}

class MyTabs extends StatefulWidget {
  @override
  MyTabState createState() => new MyTabState();

}

class MyTabState extends State<MyTabs> with SingleTickerProviderStateMixin {

  TabController controller;

  @override
  void initState() {
    super.initState();
    controller = new TabController(vsync: this, length: 3);
  }

  @override 
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      bottomNavigationBar: new Material(
        color: Colors.blue,
        child: new TabBar(
          controller: controller,
          tabs: <Tab>[
            new Tab(icon: new Icon(Icons.arrow_back)),
            new Tab(icon: new Icon(Icons.arrow_upward)),
            new Tab(icon: new Icon(Icons.arrow_forward)),
          ]
        ),
      ),
      body: new TabBarView(
        controller: controller,
        children: <Widget>[
          new profilep.ProfilePage(),
          new friendp.FriendPage(),
          new messagep.MessagePage(),
        ]
      )
    );
  }
}