import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:matchup/Pages/matchPage.dart';
import 'package:matchup/bizlogic/User.dart';
import 'package:matchup/bizlogic/peer.dart';
import 'package:matchup/bizlogic/authentication.dart';
import 'package:mockito/mockito.dart';
import './assetBundle.dart';


Future<Widget> makeTestableWidget(WidgetTester tester, Widget child, BaseAuth auth, User user) async {
  final AssetBundle assetBundle = TestAssetBundle(<String, List<String>>{
    'characterPortraits': <String>[
      'assets/images/characterPortraits/Bowser.png',
    ],
  });

  return DefaultAssetBundle(
    bundle: assetBundle,
    child: MultiProvider (
      providers: 
        <Provider>[
          Provider<BaseAuth>(create: (context) => auth),
          Provider<User>(create: (context) => user),
        ],
      child: MaterialApp(
        home: child,
      )
    )
  );
}

class MockAuth extends Mock implements BaseAuth{}

class Keys {
  static const Key filter = Key('filter');
  static const Key saveButton = Key('SaveButton');
}

void main() {
  testWidgets('filtering users', (WidgetTester tester) async {
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

    MatchPage page = MatchPage();
    await tester.pumpWidget(await makeTestableWidget(tester, page, mockAuth, user));

    Finder finder = find.byKey(Keys.filter);
    expect(finder, findsOneWidget);
    IconButton filterButton = finder.evaluate().first.widget;
    filterButton.onPressed();

    await tester.pump();

    finder = find.byKey(Keys.saveButton);

    expect(finder, findsOneWidget);
  });
}
