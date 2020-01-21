// Imports the Flutter Driver API.
import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('GROUP: Login/signup then logout | TEST: ', () {
    // First, define the Finders and use them to locate widgets from the
    // test suite. Note: the Strings provided to the `byValueKey` method must
    // be the same as the Strings we used for the Keys in step 1.
    final emailFieldFinder = find.byValueKey('email');
    final passwordFieldFinder = find.byValueKey('password');

    FlutterDriver driver;

    // Connect to the Flutter driver before running any tests.
    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    // Close the connection to the driver after the tests have completed.
    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });

    test('test user attempts to log in', () async {
      String expectedEmail = '1@gmail.com';
      String expectedPassword = '123456';
      String email = 'email';
      String login = 'login';
      String logout = 'logout';

      try{
        SerializableFinder logoutButton = find.byValueKey(logout);
        await driver.tap(logoutButton);
      }
      catch (e){
        print("*_*_*Caught login button not found exception. The user did not have a token, proceed to login");
        print("The Exception thrown is $e*_*_*");
      }

      // wait after entering text so that it can be seen or recorded
      await Future<void>.delayed(Duration(milliseconds: 750));

      // find the email field and type a valid email
      SerializableFinder emailField = find.byValueKey(email);
      await driver.tap(emailField);  // acquire focus
      await driver.enterText(expectedEmail);  // enter text
      await driver.waitFor(find.text(expectedEmail));  // verify text appears on UI

      // wait after entering text so that it can be seen or recorded
      await Future<void>.delayed(Duration(seconds: 2));

      // find and press login button
      SerializableFinder loginButton = find.byValueKey(login);
      await driver.tap(loginButton);
    });
  });
}