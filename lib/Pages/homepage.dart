import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import './profilePage.dart' as profilep;
import './messagePage.dart' as messagep;
import './matchPage.dart' as matchp;
import './friendsListPage.dart' as freindsLp;

class HomePage extends StatefulWidget{
  final VoidCallback logoutCallback;

  HomePage({this.logoutCallback});

  @override
  HomePageState createState() => new HomePageState();
}

// this class will be used to pass the callback to the tabs created by homepage
class HomePageProvider extends InheritedWidget{
  final VoidCallback logoutCallback;
  final Widget child;

  HomePageProvider(this.logoutCallback, this.child);

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

  Widget loadingCircle(){
    return Center(
        child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
                Colors.lightBlue)));
  }
  
  @override
  Widget build(BuildContext context) {
    return HomePageProvider(
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
            new Tab(icon: new Icon(Icons.contacts)),
          ]
        ),
      ),
      body: new TabBarView(
        controller: controller,
        children: <Widget>[
          new profilep.ProfilePage(),
          new matchp.MatchPage(),
          new messagep.MessagePage(),
          new freindsLp.FreindsListPage(),
        ]
      ))
    );
  }
}