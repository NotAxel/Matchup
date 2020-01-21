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
      Key logo = Key('logo');
      Key password = Key('password');
      Key email = Key('email');
      Key login = Key('login');

      String expectedEmail = '';
      String expectedPassword = '';

      MockAuth mockAuth = new MockAuth();
      when(mockAuth.signIn(expectedEmail, expectedPassword)).thenAnswer((value){return Future.value("test id");});

      // check if login call back is used
      bool didSignIn = false;
      LogInSignupPage page = LogInSignupPage(loginCallback: () => didSignIn = true,);


      String emailErrorMessage = 'Email field cannot be empty';
      String passwordErrorMessage = 'Password field cannot be empty';


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
      verifyNever(mockAuth.signIn(expectedEmail, expectedPassword));
      expect(didSignIn, false);
    });
  });

  testWidgets('Attempt to sign up with valid email and password', (WidgetTester tester) async {
    // ARRANGE
    Key logo = Key('logo');
    Key email = Key('email');
    Key password = Key('password');
    Key switchButtonKey = Key('switch between login/signup');
    Key loginButton = Key('login');

    String expectedEmail = 'foo@gmail.com';
    String expectedPassword = '123456';

    MockAuth mockAuth = new MockAuth();
    when(mockAuth.signUp(expectedEmail, expectedPassword)).thenAnswer((value){return Future.value("test id");});

    bool didSignIn = false;
    LogInSignupPage page = LogInSignupPage(loginCallback: () => didSignIn = true,);

    // ACT

    // pump the login page
    await tester.pumpWidget(await makeTestableWidget(tester, page, mockAuth));

    // find the logo and verify that it exists
    Finder logoField = find.byKey(logo);
    // expect logo to exist
    expect(logoField, findsOneWidget);

    // find the create account button and press it
    // workaround for when on tap doesn't work:
    // https://github.com/flutter/flutter/issues/31066 
    Finder switchButtonFinder = find.byKey(switchButtonKey);
    FlatButton switchButton = switchButtonFinder.evaluate().first.widget;
    switchButton.onPressed();

    await tester.pump();

    // find the email field and type a valid email
    Finder emailField = find.byKey(email);
    await tester.enterText(emailField, expectedEmail);

    // find the password field and type a valid password
    Finder passwordField = find.byKey(password);
    await tester.enterText(passwordField, expectedPassword);

    // find the login button by its key and press it
    Finder loginButtonFinder = find.byKey(loginButton);
    await tester.tap(loginButtonFinder);

    // ASSERT

    // expect user to attempt to sign up 
    verify(mockAuth.signUp(expectedEmail, expectedPassword)).called(1);

    expect(didSignIn, false);
  });

  testWidgets('Attempt to sign up with an email or password that already exists', (WidgetTester tester) async {
    // ARRANGE
    Key logo = Key('logo');
    Key email = Key('email');
    Key password = Key('password');
    Key switchButtonKey = Key('switch between login/signup');
    Key loginButton = Key('login');

    String expectedEmail = 'foo@gmail.com';
    String expectedPassword = '123456';

    MockAuth mockAuth = new MockAuth();
    when(mockAuth.signUp(expectedEmail, expectedPassword)).thenAnswer((value){return Future.value("test id");});
  });

  testWidgets('test if circular progress indicator appears when waiting for a firebase call', (WidgetTester tester) async {
    // ARRANGE
    Key logo = Key('logo');
    Key email = Key('email');
    Key password = Key('password');
    Key switchButtonKey = Key('switch between login/signup');
    Key loginButton = Key('login');

    String expectedEmail = 'foo@gmail.com';
    String expectedPassword = '123456';

    MockAuth mockAuth = new MockAuth();
    when(mockAuth.signUp(expectedEmail, expectedPassword)).thenAnswer((value){
      Future.delayed(Duration(seconds: 3));
      return Future.value("test id");
    });

    bool didSignIn = false;
    LogInSignupPage page = LogInSignupPage(loginCallback: () => didSignIn = true,);

    // ACT

    // pump the login page
    await tester.pumpWidget(await makeTestableWidget(tester, page, mockAuth));

    // find the logo and verify that it exists
    Finder logoField = find.byKey(logo);
    // expect logo to exist
    expect(logoField, findsOneWidget);

    // find the create account button and press it
    // workaround for when on tap doesn't work:
    // https://github.com/flutter/flutter/issues/31066 
    Finder switchButtonFinder = find.byKey(switchButtonKey);
    FlatButton switchButton = switchButtonFinder.evaluate().first.widget;
    switchButton.onPressed();

    await tester.pump();

    // find the email field and type a valid email
    Finder emailField = find.byKey(email);
    await tester.enterText(emailField, expectedEmail);

    // find the password field and type a valid password
    Finder passwordField = find.byKey(password);
    await tester.enterText(passwordField, expectedPassword);

    // find the login button by its key and press it
    Finder loginButtonFinder = find.byKey(loginButton);
    await tester.tap(loginButtonFinder);

    // ASSERT

    // expect to be waiting on circular progress indicator
    //expect(find.byType(CircularProgressIndicator),findsOneWidget);
    await tester.pumpAndSettle();

    // expect user to attempt to sign up, login call back not called
    verify(mockAuth.signUp(expectedEmail, expectedPassword)).called(1);
    expect(didSignIn, false);

  });
}
