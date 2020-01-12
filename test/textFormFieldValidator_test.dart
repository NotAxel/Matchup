import 'package:flutter_test/flutter_test.dart';
import 'package:matchup/bizlogic/validator.dart';
import 'package:matchup/bizlogic/validatorFactory.dart';

void main(){
  test('valid email returns null', (){
    ValidatorFactory validatorFactory = new ValidatorFactory();
    Validator validator =  validatorFactory.CreateInstance("email");
    String expectedValidatorName = "EmailValidator";

    expect(validator.getValidatorName(), expectedValidatorName);
    
    String actual = validator.validate("1@gmail.com");
    expect(actual, null);
  });
}