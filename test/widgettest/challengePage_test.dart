// Challenge Page Test

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:matchup/Pages/challengePage.dart';
import 'package:matchup/bizlogic/User.dart';
import 'package:matchup/bizlogic/peer.dart';
import 'package:provider/provider.dart';

import 'package:matchup/bizlogic/authentication.dart';
import 'package:mockito/mockito.dart';
import './assetBundle.dart';

// pages that use scaffolds must be a descendant of some type of material app
Future<Widget> makeTestableWidget(WidgetTester tester, Widget child, BaseAuth auth, User user) async{
  final AssetBundle assetBundle = TestAssetBundle(<String, List<String>>{
    'characterPortraits': <String>[
      'assets/images/characterPortraits/Bowser.png',
    ],
  });

  return DefaultAssetBundle(
    bundle: assetBundle,
    child: MultiProvider(
      providers: 
        <Provider>[
          Provider<BaseAuth>(create: (context) => auth),
          Provider<User>(create: (context) => user),
          ],
        child: MaterialApp(
          home: child,
        ),
      )
  ,);
}

// mock for firebase auth functionality
class MockAuth extends Mock implements BaseAuth{}

class Keys{
  static const Key ADD_FRIEND = Key("addFriend");
  static const Key GO_CHAT = Key("goChat");
}

void main() {
  testWidgets('challenge page tests', (WidgetTester tester) async {
    MockAuth mockAuth = new MockAuth();

    User user = User();
    user.setUserId = "123";
    user.setEmail = "testUser@domain.com";
    user.setUserName = "testUser";
    user.setMain = "Marth";
    user.setSecondary = "Marth";
    user.setRegion = "West Coast (WC)";
    user.setFriendCode = "SW-1234-1234-1234";
    user.setFriendCode = "SW-1234-1234-1234";

    Peer peer = Peer('456', "testPeer", "Bowser", "Bowser", "West Coast (WC)");

    ChallengePage page = ChallengePage(peer);
    await tester.pumpWidget(await makeTestableWidget(tester, page, mockAuth, user));

    Finder finder = find.byKey(Keys.GO_CHAT);
    expect(finder, findsOneWidget);
    await tester.tap(finder); // had to comment out send message animation to get this to work
    await tester.pump();

    finder = find.byKey(Keys.ADD_FRIEND);
    expect(finder, findsOneWidget);
    await tester.tap(finder); // had to comment out send message animation to get this to work
    await tester.pump();
  });
 
}