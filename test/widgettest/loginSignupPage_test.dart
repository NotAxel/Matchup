// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:matchup/Pages/loginSignupPage.dart';
import 'package:matchup/bizlogic/authProvider.dart';
import 'package:matchup/bizlogic/authentication.dart';
import 'package:matchup/bizlogic/emailValidator.dart';
import 'package:matchup/bizlogic/passwordValidator.dart';
import 'package:matchup/bizlogic/validator.dart';
import '../mock/mockAuth.dart';

void main() {
  // pages that use scaffolds must be a descendant of some type of material app
  Widget makeTestableWidget(Widget child, BaseAuth auth){
    return AuthProvider(
      auth: auth,
      child: MaterialApp(
        home: child,
      ),
      );
  }

  // credit: https://www.youtube.com/watch?v=75i5VmTI6A0&t=16s
  testWidgets('email or password is empty does not sign in', (WidgetTester tester) async {
    // check if login call back is used
    bool didSignIn = false;
    LogInSignupPage page = LogInSignupPage(loginCallback: () => didSignIn = true,);
    MockAuth mockAuth = new MockAuth();

    String email = "";
    String password = "";

    Validator emailValidator = EmailValidator();
    Validator passwordValidator = PasswordValidator();
    
    // pump the login page
    await tester.pumpWidget(makeTestableWidget(page, mockAuth));

    // find the login button by its key and press it
    await tester.tap(find.byKey(Key('Login')));

    // validate, save, and sign in
    if (emailValidator.validate(email) == null && passwordValidator.validate(password) == null){
      mockAuth.signIn(email, password);
    }

    // expect user to attempt to sign in but sign in was unsuccessful
    expect(mockAuth.getDidAttemptSignIn, false);
    expect(didSignIn, false);
  });
}
