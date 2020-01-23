// Imports the Flutter Driver API.
import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

class Keys{
  static const String logo = 'logo'; // the logo found on login/signup
  static const String email = 'email'; // the email field found on login/signup
  static const String password = 'password'; // the password field found on login/signup
  static const String login = 'login'; // the login button found on login/signup
  static const String switchButton = 'switch between login/signup'; // the button that switches login/signup found on login/signup
  static const String logout = 'logout'; // the login button found on login/signup
  static const String errorMessage = 'error message'; // the error message text found on login/signup
}

void main() {
  group('GROUP: Login/signup then logout | TEST: ', () {
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

    test('test user attempts to sign up and sees error message', () async {
      String expectedEmail = '1@gmail.com';
      String expectedPassword = '123456';
      String expectedErrorMessage = "The email address is already in use by another account.";

      try{
        SerializableFinder logoutButton = find.byValueKey(Keys.logout);
        await driver.tap(logoutButton);
      }
      catch (e){
        print("*_*_*Caught login button not found exception. The user did not have a token, proceed to login");
        print("The Exception thrown is $e*_*_*");
      }

      SerializableFinder switchButton = find.byValueKey(Keys.switchButton);
      await driver.tap(switchButton);

      // wait after entering text so that it can be seen or recorded
      // await Future<void>.delayed(Duration(milliseconds: 750));
      // find the email field and type a valid email
      SerializableFinder emailField = find.byValueKey(Keys.email);
      await driver.tap(emailField);  // acquire focus
      await driver.enterText(expectedEmail);  // enter text
      await driver.waitFor(find.text(expectedEmail));  // verify text appears on UI

      SerializableFinder passwordField = find.byValueKey(Keys.password);
      await driver.tap(passwordField);  // acquire focus
      await driver.enterText(expectedPassword);  // enter text
      await driver.waitFor(find.text(expectedPassword));  // verify text appears on UI

      // wait after entering text so that it can be seen or recorded
      // await Future<void>.delayed(Duration(seconds: 2));

      // find and press login button
      SerializableFinder loginButton = find.byValueKey(Keys.login);
      await driver.tap(loginButton);

      SerializableFinder errorMessage = find.byValueKey(Keys.errorMessage);
      expect(await driver.getText(errorMessage), expectedErrorMessage);
    });
  });
}