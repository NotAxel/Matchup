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

// mock for firebase auth functionality
class MockAuth extends Mock implements BaseAuth{}

void main() {

  // huge flutter widget testing flaw - race condition occurs when loading large assets
  // this includes images, large json files, and text packages
  // https://github.com/flutter/flutter/issues/22193
  testWidgets('Sign in successfully with valid email and password', (WidgetTester tester) async {
    // ARRANGE
    // check if login call back is used
    Key logo = Key('logo');
    Key email = Key('email');
    Key password = Key('password');
    Key login = Key('login');

    String expectedEmail = 'foo@gmail.com';
    String expectedPassword = '123456';

    MockAuth mockAuth = new MockAuth();
    when(mockAuth.signIn(expectedEmail, expectedPassword)).thenAnswer((value){return Future.value("test id");});

    bool didSignIn = false;
    LogInSignupPage page = LogInSignupPage(loginCallback: () => didSignIn = true,);

    // ACT 
    // pump the login page
    await tester.pumpWidget(await makeTestableWidget(tester, page, mockAuth));

    // find the logo and verify that it exists
    Finder logoField = find.byKey(logo);
    // expect logo to exist
    expect(logoField, findsOneWidget);

    // find the email field and type a valid email
    Finder emailField = find.byKey(email);
    await tester.enterText(emailField, expectedEmail);

    // find the password field and type a valid password
    Finder passwordField = find.byKey(password);
    await tester.enterText(passwordField, expectedPassword);

    // find the login button by its key and press it
    Finder loginButton = find.byKey(login);
    await tester.tap(loginButton); 

    // ASSERT 

    // expect user to attempt to sign in
    verify(mockAuth.signIn(expectedEmail, expectedPassword)).called(1);

    // the login call back was called during validate and submit in login page
    expect(didSignIn, true);
  });

  // credit: https://www.youtube.com/watch?v=75i5VmTI6A0&t=16s
  testWidgets('Attempt to sign in with empty email and password field', (WidgetTester tester) async {
    await tester.runAsync(() async{
      // ARRANGE 
      MockAuth mockAuth = new MockAuth();

      // check if login call back is used
      bool didSignIn = false;
      LogInSignupPage page = LogInSignupPage(loginCallback: () => didSignIn = true,);

      String expectedEmail = '';
      String expectedPassword = '';

      String emailErrorMessage = 'Email field cannot be empty';
      String passwordErrorMessage = 'Password field cannot be empty';

      Key logo = Key('logo');
      Key password = Key('password');
      Key email = Key('email');
      Key login = Key('login');

      // ACT

      // pump the login page
      await tester.pumpWidget(await makeTestableWidget(tester, page, mockAuth));

      // find the logo and verify that it exists
      Finder logoField = find.byKey(logo);
      // expect logo to exist
      expect(logoField, findsOneWidget);

      // find the email field and type a valid email
      Finder emailField = find.byKey(email);
      await tester.enterText(emailField, expectedEmail);

      // find the password field and type a valid password
      Finder passwordField = find.byKey(password);
      await tester.enterText(passwordField, expectedPassword);

      // find the login button by its key and press it
      Finder loginButton = find.byKey(login);
      await tester.tap(loginButton); 

      // find the error messages for the email and password fields
      await tester.pumpAndSettle();
      Finder emailError = find.text(emailErrorMessage);
      Finder passwordError = find.text(passwordErrorMessage);

      // ASSERT 

      // expect email and password error text to display after login attempt 
      expect(emailError, findsOneWidget);
      expect(passwordError, findsOneWidget);

      // email and password fields have not been filled in
      // expect user to attempt to sign in but sign in was unsuccessful
      //expect(mockAuth.getDidAttemptSignIn, false);
      expect(didSignIn, false);
    });
  });

  testWidgets('Attempt to sign up with valid email and password', (WidgetTester tester) async {
    // ARRANGE
    MockAuth mockAuth = new MockAuth();

    bool didSignUp = false;
    LogInSignupPage page = LogInSignupPage(loginCallback: () => didSignUp = true,);

    String expectedEmail = 'foo@gmail.com';
    String expectedPassword = '123456';

    Key logo = Key('logo');
    Key email = Key('email');
    Key password = Key('password');
    Key switchButton = Key('switch between login/signup');
    Key loginButton = Key('login');
    
    // ACT

    // pump the login page
    await tester.pumpWidget(await makeTestableWidget(tester, page, mockAuth));

    // find the logo and verify that it exists
    Finder logoField = find.byKey(logo);
    // expect logo to exist
    expect(logoField, findsOneWidget);

    // find the email field and type a valid email
    Finder emailField = find.byKey(email);
    await tester.enterText(emailField, expectedEmail);

    // find the password field and type a valid password
    Finder passwordField = find.byKey(password);
    await tester.enterText(passwordField, expectedPassword);

    // find the create account button and press it
    Finder switchButtonFinder = find.byKey(switchButton);
    await tester.tap(switchButtonFinder);

    // wait for switch to the signup page
    await tester.pump();

    // find the login button by its key and press it
    Finder loginButtonFinder = find.byKey(loginButton);
    await tester.tap(loginButtonFinder);

    // ASSERT

    // expect user to attempt to sign up 
    //expect(mockAuth.getDidAttemptSignUp, true);

    // the login call back was called during validate and submit in login page
    // this means the login was successful
    expect(didSignUp, true);
  });
}
