import 'package:cloud_firestore/cloud_firestore.dart';
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
Future<Widget> makeTestableWidget(WidgetTester tester, Widget child, BaseAuth auth) async{
  final AssetBundle assetBundle = TestAssetBundle(<String, List<String>>{
    'assets/images/logo.png': <String>['assets/images/logo.png'],
    'assets/images/regionsMap.png': <String>['assets/images/regionsMap.png'],
  });

  return DefaultAssetBundle(
    bundle: assetBundle,
    child: Provider<BaseAuth>(
        create: (context) => auth,
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
    Peer peer = Peer('123', "testPeer", "Bowser", "Bowser", "West Coast (WC)");
    ChatPage page = ChatPage(peer, '123');
    await tester.pumpWidget(await makeTestableWidget(tester, page, mockAuth));
  }, skip: true);
}