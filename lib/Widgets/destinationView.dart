import 'package:flutter/material.dart';
import 'package:matchup/Pages/challengePage.dart';
import 'package:matchup/Pages/chatPage.dart';
import 'package:matchup/Widgets/destination.dart';

class DestinationView extends StatefulWidget {
  const DestinationView(this.destination, { Key key}) : super(key: key);

  final Destination destination;


  @override
  _DestinationViewState createState() => _DestinationViewState();
}

class _DestinationViewState extends State<DestinationView> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
          settings: settings,
          builder: (BuildContext context) {
            List<Object> arguments = settings.arguments;
            switch (settings.name){
              case '/':
                return widget.destination.getPage;
              case '/challenge':
                return ChallengePage(arguments[0]);
              case '/chat':
                return ChatPage(arguments[0], arguments[1],);
            }
          },
        );
      },
    );
  }
}