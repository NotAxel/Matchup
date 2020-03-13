import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:matchup/bizlogic/User.dart';
import 'package:matchup/bizlogic/peer.dart';
import 'package:provider/provider.dart';

import 'package:matchup/Pages/chatPage.dart';
import 'package:matchup/bizlogic/authentication.dart';
import 'package:mockito/mockito.dart';
import './assetBundle.dart';

// pages that use scaffolds must be a descendant of some type of material app
Future<Widget> makeTestableWidget(WidgetTester tester, Widget child, BaseAuth auth, User user) async{
  final AssetBundle assetBundle = TestAssetBundle(<String, List<String>>{
    'smallSprites': <String>[
      'assets/images/small_sprites/bowser_sprite.png',
      'assets/images/small_sprites/marth_sprite.png',
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
  static const Key SEND_FRIEND_CODE = Key("SEND_FRIEND_CODE_BUTTON");
}

void main() {
  testWidgets('send friend code', (WidgetTester tester) async {
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

    Peer peer = Peer('456', "testPeer", "Bowser", "Bowser", "West Coast (WC)", "Beginner");

    ChatPage page = ChatPage(peer, '123');
    await tester.pumpWidget(await makeTestableWidget(tester, page, mockAuth, user));

    Finder finder = find.byKey(Keys.SEND_FRIEND_CODE);
    expect(finder, findsOneWidget);
    await tester.tap(finder); // had to comment out send message animation to get this to work
    await tester.pump();
  });
}