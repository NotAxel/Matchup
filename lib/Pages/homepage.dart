import 'package:flutter/material.dart';
import 'package:matchup/Widgets/destination.dart';
import 'package:matchup/Widgets/destinationView.dart';
import 'package:matchup/bizlogic/screenSize.dart';
import './profilePage.dart' as profilep;
import './profilePageEdit.dart' as profilepe;
import './messagePage.dart' as messagep;
import './matchPage.dart' as matchp;
import './friendsListPage.dart' as freindsLp;

class HomePage extends StatefulWidget{
  final Future<void> Function(bool) logoutCallback;

  HomePage({Key key, this.logoutCallback}) : super(key: key);

  @override
  HomePageState createState() => new HomePageState();
}

// this class will be used to pass the callback to the tabs created by homepage
class HomePageProvider extends InheritedWidget{
  final Future<void> Function(bool) logoutCallback;
  final Widget child;

  HomePageProvider(this.logoutCallback, this.child);

  @override
  bool updateShouldNotify(HomePageProvider oldWidget) {
    return oldWidget.child != child ||
    oldWidget.logoutCallback != logoutCallback;
  }

  // by using this function to add the call back to the context in the tabstate build,
  // should be able to ref the call back in a tab class
  static HomePageProvider of(BuildContext context) =>
    context.dependOnInheritedWidgetOfExactType<HomePageProvider>();
  }

class HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  int _currentIndex = 0;

  static List<Destination> destinations = <Destination>[
    // Profile Page
    Destination(
      'Profile', 
      profilep.ProfilePage(), 
      BottomNavigationBarItem(
        icon: Icon(Icons.face),
        title: Text("Profile"),
        backgroundColor: Colors.blue
      )
    ),
    // Match Page
    Destination(
      'Match', 
      matchp.MatchPage(), 
      BottomNavigationBarItem(
        icon: Icon(Icons.pie_chart),
        title: Text("Matchlist"),
      )
    ),
    // Match Page
    Destination(
      'Messages', 
      messagep.MessagePage(), 
      BottomNavigationBarItem(
        icon: Icon(Icons.chat),
        title: Text("Messages"),
      ),
    ),
  ];

  void _bottomNavigationBarOnTap(int index){
    setState(() {
      _currentIndex = index;
    });
  }

  Widget buildBottomNavigationBar(){
    return BottomNavigationBar(
      items: destinations.map((Destination destination){
        return destination.getNavItem;
      }).toList(),
      currentIndex: _currentIndex,
      onTap: _bottomNavigationBarOnTap,
    );
  }
  
  @override
  Widget build(BuildContext context) {
    ScreenSize.init(context);
    return HomePageProvider(
      widget.logoutCallback,
      Scaffold( 
        body: SafeArea(
          top: false,
          child: IndexedStack(
            index: _currentIndex,
            children: destinations.map((Destination destination){
              return DestinationView(destination);
            }).toList(),
          ),
        ),
        bottomNavigationBar: buildBottomNavigationBar(),
      ),
    );
  }
}