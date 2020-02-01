import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:matchup/Pages/userInfoEntryPage.dart';
import 'package:matchup/bizlogic/authProvider.dart';
import 'package:matchup/bizlogic/authentication.dart';
import 'package:mockito/mockito.dart';
import './assetBundle.dart';

// pages that use scaffolds must be a descendant of some type of material app
Future<Widget> makeTestableWidget(WidgetTester tester, Widget child, BaseAuth auth) async{
  final AssetBundle assetBundle = TestAssetBundle(<String, List<String>>{
    'assets/images/logo.png': <String>['assets/images/logo.png'],
    'assets/images/default_profile.jpg': <String>['assets/images/default_profile.jpg'],
  });

  return DefaultAssetBundle(
    bundle: assetBundle,
    child: AuthProvider(
        auth: auth,
        child: MaterialApp(
          home: child,
        ),
      )
  ,);
}

void main(){}