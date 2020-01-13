import 'package:matchup/bizlogic/emailValidator.dart';
import 'package:matchup/bizlogic/passwordValidator.dart';
import 'package:test/test.dart';
import 'package:matchup/bizlogic/validator.dart';

void main(){
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

  test('empty email returns error message', (){
    Validator validator = EmailValidator();
    String expectedValidatorName = "EmailValidator";
    String expectedErrorMessage = "Email field cannot be empty";

    expect(validator.getValidatorName(), expectedValidatorName);
    
    String actual = validator.validate(null);
    expect(actual, expectedErrorMessage);
  });

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

  test('empty password returns error message', (){
    Validator validator = PasswordValidator();
    String expectedValidatorName = "PasswordValidator";
    String expectedErrorMessage = "Password field cannot be empty";

    expect(validator.getValidatorName(), expectedValidatorName);
    
    String actual = validator.validate(null);
    expect(actual, expectedErrorMessage);
  });

}