import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:matchup/bizlogic/User.dart';
import '../bizlogic/authentication.dart';
import './profilePage.dart' as profilep;
import './messagePage.dart' as messagep;
import './matchPage.dart' as matchp;

class HomePage extends StatefulWidget{
  final String userId;
  final BaseAuth auth;
  final VoidCallback logoutCallback;

  HomePage({this.userId, this.auth, this.logoutCallback});

  @override
  HomePageState createState() => new HomePageState();
}

// this class will be used to pass the callback to the tabs created by homepage
class HomePageProvider extends InheritedWidget{
  final User user;
  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final Widget child;

  HomePageProvider(this.user, this.auth, this.logoutCallback, this.child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }

  // by using this function to add the call back to the context in the tabstate build,
  // should be able to ref the call back in a tab class
  static HomePageProvider of(BuildContext context) =>
    context.dependOnInheritedWidgetOfExactType<HomePageProvider>();
  }

class HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  TabController controller;
  User _user;

  @override
  void initState() {
    _user = User.instance;
    _user.setUserId = widget.userId;
    initializeUserInformation(_user);
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
        return new HomePageProvider(
          _user,
          widget.auth,
          widget.logoutCallback,
          Scaffold( bottomNavigationBar: new Material(
            color: Colors.blue,
            child: 
              TabBar(
              controller: controller,
              tabs: <Tab>[
                new Tab(icon: new Icon(Icons.face)),
                new Tab(icon: new Icon(Icons.pie_chart)),
                new Tab(icon: new Icon(Icons.chat)),
              ]
            ),
          ),
          body: new TabBarView(
            controller: controller,
            children: <Widget>[
              new profilep.ProfilePage(),
              new matchp.MatchPage(),
              new messagep.MessagePage(),
            ]
          ))
        );
          /*
          appBar: new AppBar(
            actions: <Widget>[
              _showForm(),
          ],),
          */
          
        
      }
    
      // TODO: @Brendan
      void initializeUserInformation(User user) async{
        DocumentReference userReference = Firestore.instance.collection('Users').document(user.getUserId);
        DocumentSnapshot userData = await userReference.get();
        user.setUserName = "a";
      }
}