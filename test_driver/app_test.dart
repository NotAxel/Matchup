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
  static const String userName = 'Username'; 
  static const String friendCode = 'FriendCode'; 
  static const String main = 'Main'; 
  static const String secondary = 'Secondary'; 
  static const String region = 'Region'; 
  static const String saveProfile = 'SaveProfile'; // the error message text found on login/signup
  static const String deleteAccount = 'DeleteAccount'; 
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

    // acceptance test # 1
    test('Successful login to an existing account', () async{
      String expectedEmail = 'driverTestAccount@gmail.com';
      String expectedPassword = 'Test123!';

      SerializableFinder emailField = find.byValueKey(Keys.email);
      await driver.tap(emailField);  // acquire focus
      await driver.enterText(expectedEmail);  // enter text
      await driver.waitFor(find.text(expectedEmail));  // verify text appears on UI

      SerializableFinder passwordField = find.byValueKey(Keys.password);
      await driver.tap(passwordField);  // acquire focus
      await driver.enterText(expectedPassword);  // enter text
      await driver.waitFor(find.text(expectedPassword));  // verify text appears on UI

      SerializableFinder loginButton = find.byValueKey(Keys.login);
      await driver.tap(loginButton);
    });

    // acceptance test # 2
   test('unsuccessful login an existing account', () async{

      try{
        SerializableFinder logoutButton = find.byValueKey(Keys.logout);
        await driver.tap(logoutButton, timeout: Duration(seconds: 1));
      }
      catch(e){
        print("Didn't have to logout");
      }

      String expectedEmail = 'driverTestAccount@gmail.com';
      String expectedPassword = '123456';
      String expectedErrorMessage = "The password is invalid or the user does not have a password.";

      SerializableFinder emailField = find.byValueKey(Keys.email);
      await driver.tap(emailField);  // acquire focus
      await driver.enterText(expectedEmail);  // enter text
      await driver.waitFor(find.text(expectedEmail));  // verify text appears on UI

      SerializableFinder passwordField = find.byValueKey(Keys.password);
      await driver.tap(passwordField);  // acquire focus
      await driver.enterText(expectedPassword);  // enter text
      await driver.waitFor(find.text(expectedPassword));  // verify text appears on UI

      SerializableFinder loginButton = find.byValueKey(Keys.login);
      await driver.tap(loginButton);

      SerializableFinder errorMessage = find.byValueKey(Keys.errorMessage);
      expect(await driver.getText(errorMessage), expectedErrorMessage);
    });

    // acceptance test # 3
    test('Successful signup', () async{
      String expectedEmail = 'SuccessfulSignupTest@gmail.com';
      String expectedPassword = 'Test123!';

      try{
        SerializableFinder logoutButton = find.byValueKey(Keys.logout);
        await driver.tap(logoutButton, timeout: Duration(seconds: 1));
      }
      catch(e){
        print("Didn't have to logout");
      }

      SerializableFinder switchButton = find.byValueKey(Keys.switchButton);
      await driver.tap(switchButton);

      SerializableFinder emailField = find.byValueKey(Keys.email);
      await driver.tap(emailField);  // acquire focus
      await driver.enterText(expectedEmail);  // enter text
      await driver.waitFor(find.text(expectedEmail));  // verify text appears on UI

      SerializableFinder passwordField = find.byValueKey(Keys.password);
      await driver.tap(passwordField);  // acquire focus
      await driver.enterText(expectedPassword);  // enter text
      await driver.waitFor(find.text(expectedPassword));  // verify text appears on UI

      SerializableFinder loginButton = find.byValueKey(Keys.login);
      await driver.tap(loginButton);

      SerializableFinder cancelButton = find.byValueKey("cancelButton");
      await driver.tap(cancelButton);

      SerializableFinder yesButton = find.text("Yes");
      await driver.tap(yesButton);
    });

    // acceptance test # 4
    test('unsuccessful signup', () async {
      String expectedEmail = '1@gmail.com';
      String expectedPassword = 'Test123!';
      String expectedErrorMessage = "The email address is already in use by another account.";

      try{
        SerializableFinder logoutButton = find.byValueKey(Keys.logout);
        await driver.tap(logoutButton, timeout: Duration(seconds: 1));
      }
      catch(e){
        print("Didn't have to logout");
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

    // acceptance test # 5
    test('Successful signup, customize profile, then delete account from profile page', () async{
      await driver.runUnsynchronized(() async{
        String expectedEmail = 'SuccessfulSignupTest@gmail.com';
        String expectedPassword = 'Test123!';

        try{
          SerializableFinder logoutButton = find.byValueKey(Keys.logout);
          await driver.tap(logoutButton, timeout: Duration(seconds: 1));
        }
        catch(e){
          print("Didn't have to logout");
        }

        // login signup page
        // last test ends on sign up page so we dont need to switch

        SerializableFinder emailField = find.byValueKey(Keys.email);
        await driver.tap(emailField);  // acquire focus
        await driver.enterText(expectedEmail);  // enter text
        await driver.waitFor(find.text(expectedEmail));  // verify text appears on UI

        SerializableFinder passwordField = find.byValueKey(Keys.password);
        await driver.tap(passwordField);  // acquire focus
        await driver.enterText(expectedPassword);  // enter text
        await driver.waitFor(find.text(expectedPassword));  // verify text appears on UI

        SerializableFinder loginButton = find.byValueKey(Keys.login);
        await driver.tap(loginButton);

        // userInfoEntry Page
        // username
        SerializableFinder usernameField = find.byValueKey(Keys.userName);
        await driver.tap(usernameField);
        await driver.enterText('test');

        // friend code
        SerializableFinder friendCodeField = find.byValueKey(Keys.friendCode);
        await driver.tap(friendCodeField);
        await driver.enterText('SW-1234-1234-1234');

        // main
        SerializableFinder mainDropdown = find.byValueKey(Keys.main);
        await driver.tap(mainDropdown);

        SerializableFinder mainText = find.text("Bowser");
        await driver.tap(mainText);

        // secondary
        SerializableFinder secondaryDropdown = find.byValueKey(Keys.secondary);
        await driver.tap(secondaryDropdown);

        SerializableFinder secondaryText = find.text("Bowser");
        await driver.tap(secondaryText);

        SerializableFinder regionDropDown = find.byValueKey(Keys.region);
        await driver.tap(regionDropDown);

        SerializableFinder regionText = find.text('West Coast (WC)');
        await driver.tap(regionText);

        SerializableFinder finder = find.byValueKey(Keys.saveProfile);
        await driver.tap(finder);

        // flutter bugged out, deletes by hand but not in driver
        SerializableFinder deleteButton = find.byValueKey(Keys.deleteAccount);
        await driver.tap(deleteButton);

        await driver.waitFor(find.text("Yes"));
        SerializableFinder yesButton = find.text("Yes");
        await driver.tap(yesButton);
      });

    // acceptance test # 6
    test('Successful signup, customize profile, then send a message', () async{
      await driver.runUnsynchronized(() async{
        String expectedEmail = 'SuccessfulSignupTest@gmail.com';
        String expectedPassword = 'Test123!';

        try{
          SerializableFinder logoutButton = find.byValueKey(Keys.logout);
          await driver.tap(logoutButton, timeout: Duration(seconds: 1));
        }
        catch(e){
          print("Didn't have to logout");
        }

        // login signup page
        // last test ends on sign up page so we dont need to switch

        SerializableFinder emailField = find.byValueKey(Keys.email);
        await driver.tap(emailField);  // acquire focus
        await driver.enterText(expectedEmail);  // enter text
        await driver.waitFor(find.text(expectedEmail));  // verify text appears on UI

        SerializableFinder passwordField = find.byValueKey(Keys.password);
        await driver.tap(passwordField);  // acquire focus
        await driver.enterText(expectedPassword);  // enter text
        await driver.waitFor(find.text(expectedPassword));  // verify text appears on UI

        SerializableFinder loginButton = find.byValueKey(Keys.login);
        await driver.tap(loginButton);

        // userInfoEntry Page
        // username
        SerializableFinder usernameField = find.byValueKey(Keys.userName);
        await driver.tap(usernameField);
        await driver.enterText('test');

        // friend code
        SerializableFinder friendCodeField = find.byValueKey(Keys.friendCode);
        await driver.tap(friendCodeField);
        await driver.enterText('SW-1234-1234-1234');

        // main
        SerializableFinder mainDropdown = find.byValueKey(Keys.main);
        await driver.tap(mainDropdown);

        SerializableFinder mainText = find.text("Bowser");
        await driver.tap(mainText);

        // secondary
        SerializableFinder secondaryDropdown = find.byValueKey(Keys.secondary);
        await driver.tap(secondaryDropdown);

        SerializableFinder secondaryText = find.text("Bowser");
        await driver.tap(secondaryText);

        SerializableFinder regionDropDown = find.byValueKey(Keys.region);
        await driver.tap(regionDropDown);

        SerializableFinder regionText = find.text('West Coast (WC)');
        await driver.tap(regionText);

        SerializableFinder finder = find.byValueKey(Keys.saveProfile);
        await driver.tap(finder);

        // tap the match page
        finder = find.byValueKey("matchPage");
        await driver.tap(finder);

        // tap the first peer profile
        finder = find.byValueKey("peerProfile");
        await driver.tap(finder);

        // tap chat button
        finder = find.byValueKey("chat");
        await driver.tap(finder);

        // tap send friend code button
        finder = find.byValueKey("sendFriendCode");
        await driver.tap(finder);
      });
    });

    // acceptance test # 7
    test('type and send a message', () async{
        // tap send friend code button
        SerializableFinder finder = find.byValueKey("messageInputField");
        await driver.tap(finder);
        await driver.enterText("testing sending a message");
        
        // press the send button
        finder = find.byValueKey("sendButton");
        await driver.tap(finder);

        // expect the chat box
        finder = find.byType("chatBox");
    });

    // acceptance test # 8
    test('go into conversations and make sure chat is there and send a message from the conversation page', () async{
        // go to the conversation tab
        SerializableFinder finder = find.byValueKey("conversationTab");
        await driver.tap(finder);

        // check and make sure the conversation is there
        finder = find.byValueKey("conversation");
        await driver.tap(finder);

        // tap send friend code button
        finder = find.byValueKey("messageInputField");
        await driver.tap(finder);
        await driver.enterText("testing sending a message");
        
        // press the send button
        finder = find.byValueKey("sendButton");
        await driver.tap(finder);

        // expect the chat box
        finder = find.byType("chatBox");
    });

  });
  }
);
}