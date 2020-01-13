import 'package:matchup/bizlogic/NullValidator.dart';
import 'package:matchup/bizlogic/emailValidator.dart';
import 'package:matchup/bizlogic/passwordValidator.dart';
import 'package:matchup/bizlogic/validator.dart';

class ValidatorFactory{

  ValidatorFactory();

  Validator createInstance(String type){
    switch(type){
      case "email": {
        return new EmailValidator();
      }
      case "password": {
        return new PasswordValidator();
      }
      default: {
        return new NullValidator();
      }
    }
  }
}