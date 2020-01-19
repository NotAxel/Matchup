// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:matchup/Pages/loginSignupPage.dart';
import 'package:matchup/bizlogic/authProvider.dart';
import 'package:matchup/bizlogic/authentication.dart';
import '../mock/mockAuth.dart';
import './assetBundle.dart';

// pages that use scaffolds must be a descendant of some type of material app
Future<Widget> makeTestableWidget(WidgetTester tester, Widget child, BaseAuth auth) async{
  final AssetBundle assetBundle = TestAssetBundle(<String, List<String>>{
    'assets/images/logo.png': <String>['assets/images/logo.png'],
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

void main() {

  // huge flutter widget testing flaw - race condition occurs when loading large assets
  // this includes images, large json files, and text packages
  // https://github.com/flutter/flutter/issues/22193
  testWidgets('TEST_1', (WidgetTester tester) async {
    // check if login call back is used
    MockAuth mockAuth = new MockAuth();

    bool didSignIn = false;
    LogInSignupPage page = LogInSignupPage(loginCallback: () => didSignIn = true,);

    String expectedEmail = 'foo@gmail.com';
    String expectedPassword = '123456';

    Key email = Key('email');
    Key password = Key('password');
    
    // pump the login page
    await tester.pumpWidget(await makeTestableWidget(tester, page, mockAuth));

    // find the email field and type a valid email
    Finder emailField = find.byKey(email);
    await tester.enterText(emailField, expectedEmail);

    // find the password field and type a valid password
    Finder passwordField = find.byKey(password);
    await tester.enterText(passwordField, expectedPassword);

    // find the login button by its key and press it
    await tester.tap(find.byKey(Key('login')));

    // expect user to attempt to sign in
    expect(mockAuth.getDidAttemptSignIn, true);

    // the login call back was called during validate and submit in login page
    // this means the login was successful
    expect(didSignIn, true);
  });

  // credit: https://www.youtube.com/watch?v=75i5VmTI6A0&t=16s
  testWidgets('TEST_2', (WidgetTester tester) async {
    MockAuth mockAuth = new MockAuth();

    // check if login call back is used
    bool didSignIn = false;
    LogInSignupPage page = LogInSignupPage(loginCallback: () => didSignIn = true,);

    // pump the login page
    await tester.pumpWidget(await makeTestableWidget(tester, page, mockAuth));

    Key logo = Key('logo');
    Key password = Key('password');
    Key email = Key('email');

    Finder logoField = find.byKey(logo);
    expect(logoField, findsOneWidget);

    Finder emailField = find.byKey(email);
    expect(emailField, findsOneWidget);

    Finder passwordField = find.byKey(password);
    expect(passwordField, findsOneWidget);

    // find the login button by its key and press it
    await tester.tap(find.byKey(Key('login')));

    // email and password fields have not been filled in
    // expect user to attempt to sign in but sign in was unsuccessful
    expect(mockAuth.getDidAttemptSignIn, false);
    expect(didSignIn, false);
  });
}
