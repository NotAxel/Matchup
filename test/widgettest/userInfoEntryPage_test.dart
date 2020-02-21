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

class Keys{
  static const Key main = Key('main'); // the logo found on login/signup
  static const Key secondary = Key('secondary'); // the email field found on login/signup
  static const Key region = Key('region'); // the password field found on login/signup
  static const Key login = Key('login'); // the login button found on login/signup
  static const Key switchButton = Key('switch between login/signup'); // the button that switches login/signup found on login/signup
  static const Key errorMessage = Key('error message'); // the error message text found on login/signup
}

void main(){}