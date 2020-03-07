import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:matchup/bizlogic/User.dart';
import 'package:provider/provider.dart';

import 'package:matchup/Pages/matchPage.dart';
import 'package:matchup/bizlogic/authentication.dart';
import 'package:mockito/mockito.dart';
import './assetBundle.dart';

// pages that use scaffolds must be a descendant of some type of material app
Future<Widget> makeTestableWidget(WidgetTester tester, Widget child, User user) async{
  final AssetBundle assetBundle = TestAssetBundle(<String, List<String>>{
    'assets/images/logo.png': <String>['assets/images/logo.png'],
    'assets/images/regionsMap.png': <String>['assets/images/regionsMap.png'],
  });

  return DefaultAssetBundle(
    bundle: assetBundle,
    child: Provider<User>(
        create: (context) => user,
        child: MaterialApp(
          home: child,
        ),
      )
  );
}


void main(){
  
  testWidgets('Scroll to refresh', (WidgetTester tester) async{
    print("scroll to refresh!!!1");
      User user = User();
      await tester.pumpWidget(await makeTestableWidget(tester, MatchPage(), user)
      );
      final key = Key("Refresh");
      expect(find.byKey(key), findsOneWidget);
  });
}