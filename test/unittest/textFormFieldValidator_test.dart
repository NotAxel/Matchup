import 'package:flutter_test/flutter_test.dart';
import 'package:matchup/bizlogic/emailValidator.dart';
import 'package:matchup/bizlogic/friendCodeValidator.dart';
import 'package:matchup/bizlogic/passwordValidator.dart';
import 'package:matchup/bizlogic/validator.dart';

void main(){
  group("email validator", (){
    test('valid email returns null', (){
      Validator validator = EmailValidator();
      String expectedValidatorName = "EmailValidator";

      expect(validator.getValidatorName(), expectedValidatorName);
      
      String actual = validator.validate("1@gmail.com");
      expect(actual, null);
    });

    test('empty email returns error message', (){
      Validator validator = EmailValidator();
      String expectedValidatorName = "EmailValidator";
      String expectedErrorMessage = "Email field cannot be empty";

      expect(validator.getValidatorName(), expectedValidatorName);
      
      String actual = validator.validate("");
      expect(actual, expectedErrorMessage);
    });

    test('null email returns error message', (){
      Validator validator = EmailValidator();
      String expectedValidatorName = "EmailValidator";
      String expectedErrorMessage = "Email field cannot be empty";

      expect(validator.getValidatorName(), expectedValidatorName);
      
      String actual = validator.validate(null);
      expect(actual, expectedErrorMessage);
    });

    test('save properly trims email', (){
      Validator validator = EmailValidator();
      String expectedValidatorName = "EmailValidator";
      String expectedEmail = "foo@gmail.com";

      expect(validator.getValidatorName(), expectedValidatorName);

      String actual = validator.save("   foo@gmail.com  ");
      expect(actual, expectedEmail);
    });
  });

  group("password validator", (){
    test('valid password returns null', (){
      Validator validator = PasswordValidator();
      String expectedValidatorName = "PasswordValidator";

      expect(validator.getValidatorName(), expectedValidatorName);
      
      String actual = validator.validate("1@gmail.com");
      expect(actual, null);
    });

    test('empty password returns error message', (){
      Validator validator = PasswordValidator();
      String expectedValidatorName = "PasswordValidator";
      String expectedErrorMessage = "Password field cannot be empty";

      expect(validator.getValidatorName(), expectedValidatorName);
      
      String actual = validator.validate("");
      expect(actual, expectedErrorMessage);
    });

    test('null password returns error message', (){
      Validator validator = PasswordValidator();
      String expectedValidatorName = "PasswordValidator";
      String expectedErrorMessage = "Password field cannot be empty";

      expect(validator.getValidatorName(), expectedValidatorName);
      
      String actual = validator.validate(null);
      expect(actual, expectedErrorMessage);
    });
  });
  group("friend code validator", (){
    const String FRIEND_CODE_ERROR = '''Your Nintendo Switch Friend Code
    must begin with SW- followed by the remaining 12 digits of your code
    with a dash after the fourth digit and the eigth digit\n
    Example: SW-8496-9128-4205''';
    test('empty friend code returns error message', (){
      // ARRANGE
      Validator validator = FriendCodeValidator();
      String expectedValidatorName = "FriendCodeValidator";
      String expectedErrorMessage = "Friend Code field cannot be empty";

      // ACT
      String actual = validator.validate("");

      // ASSERT
      expect(validator.getValidatorName(), expectedValidatorName);
      expect(actual, expectedErrorMessage);
    });

    test('null friend code returns error message', (){
      // ARRANGE
      Validator validator = FriendCodeValidator();
      String expectedErrorMessage = "Friend Code field cannot be empty";

      // ACT
      String actual = validator.validate(null);

      // ASSERT
      expect(actual, expectedErrorMessage);
    });

    test("friend code too short", (){
      // ARRANGE
      Validator validator = FriendCodeValidator();
      String friendCode = "too short";

      // ACT
      String actualError = validator.validate(friendCode);

      // ASSERT
      expect(actualError, FRIEND_CODE_ERROR);
    });

    test("friend code too long", (){
      // ARRANGE
      Validator validator = FriendCodeValidator();
      String friendCode = '''This is a stupid friend code that is guarenteed to be too 
        long why would anyone enter this? I have no idea, but it is possible.''';

      // ACT
      String actualError = validator.validate(friendCode);

      // ASSERT
      expect(actualError, FRIEND_CODE_ERROR);
    });
    
    test("friend code doesnt begin with SW- but is otherwise valid", (){
      // ARRANGE
      Validator validator = FriendCodeValidator();
      String friendCode = "XZ_1234-5678-9123";
      print(friendCode.substring(0, 3));

      // ACT
      String actualError = validator.validate(friendCode);

      // ASSERT
      expect(actualError, FRIEND_CODE_ERROR);
    });

    test('''friend code doesnt have a valid int in the first 4 digits 
      but is otherwise valid''', (){
      // ARRANGE
      Validator validator = FriendCodeValidator();
      String friendCode = "SW-1ABC-5678-9123";
      print(friendCode.substring(3, 7));

      // ACT
      String actualError = validator.validate(friendCode);

      // ASSERT
      expect(actualError, FRIEND_CODE_ERROR);
    });

    test("friend code doesnt have second dash but is otherwise valid", (){
      // ARRANGE
      Validator validator = FriendCodeValidator();
      String friendCode = "SW-1234!5678-9123";
      print(friendCode.substring(7, 8));

      // ACT
      String actualError = validator.validate(friendCode);

      // ASSERT
      expect(actualError, FRIEND_CODE_ERROR);
    });

    test('''friend code doesnt have a valid int in the second 4 digits 
      but is otherwise valid''', (){
      // ARRANGE
      Validator validator = FriendCodeValidator();
      String friendCode = "SW-1234-5ABC-9123";
      print(friendCode.substring(8, 12));

      // ACT
      String actualError = validator.validate(friendCode);

      // ASSERT
      expect(actualError, FRIEND_CODE_ERROR);
    });

    test("friend code doesnt have third dash but is otherwise valid", (){
      // ARRANGE
      Validator validator = FriendCodeValidator();
      String friendCode = "SW-1234-5678!9123";
      print(friendCode.substring(12, 13));

      // ACT
      String actualError = validator.validate(friendCode);

      // ASSERT
      expect(actualError, FRIEND_CODE_ERROR);
    });

    test('''friend code doesnt have a valid int in the third 4 digits 
      but is otherwise valid''', (){
      // ARRANGE
      Validator validator = FriendCodeValidator();
      String friendCode = "SW-1234-5678-9ABC";
      print(friendCode.substring(13, 17));

      // ACT
      String actualError = validator.validate(friendCode);

      // ASSERT
      expect(actualError, FRIEND_CODE_ERROR);
    });

     test("testing save with a valid code", (){ 
      // ARRANGE
      Validator validator = FriendCodeValidator();
      String friendCode = "   SW-1234-5678-9123   ";
      String expectedCode = "SW-1234-5678-9123";
      print(friendCode.substring(13, 17));

      // ACT
      String actualCode = validator.save(friendCode);

      // ASSERT
      expect(actualCode, expectedCode);
    });
  });
}