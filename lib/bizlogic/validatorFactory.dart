import 'package:matchup/bizlogic/emailValidator.dart';
import 'package:matchup/bizlogic/passwordValidator.dart';
import 'package:matchup/bizlogic/validator.dart';

class ValidatorFactory{

  ValidatorFactory();

  Validator CreateInstance(String type){
    switch(type){
      case "email": {
        return new EmailValidator();
      }
      case "password": {
        return new PasswordValidator();
      }
    }
  }
}