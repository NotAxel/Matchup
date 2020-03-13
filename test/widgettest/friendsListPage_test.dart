// friendsList page test

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:matchup/Pages/friendsListPage.dart';
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
  static const Key SHOW_INFO = Key("showInfoButton");
  static const Key CLOSE_SHOW_INFO = Key("closeShowInfo");
  static const Key CHAT = Key("chatButton");
  static const Key NO_FRIENDS = Key("noFriends");
}

void main() {
  testWidgets('friends list page test', (WidgetTester tester) async {
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

    FriendsListPage page = FriendsListPage();
    await tester.pumpWidget(await makeTestableWidget(tester, page, mockAuth, user));

    Finder finder = find.byKey(Keys.SHOW_INFO);
    expect(finder, findsOneWidget);
    await tester.tap(finder);
    await tester.pump();

    finder = find.byKey(Keys.CLOSE_SHOW_INFO);
    expect(finder, findsOneWidget);
    await tester.tap(finder);
    await tester.pump();

    finder = find.byKey(Keys.NO_FRIENDS);
    expect(finder, findsOneWidget);
  });
}