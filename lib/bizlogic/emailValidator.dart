import 'package:matchup/bizlogic/validator.dart';

class EmailValidator implements Validator{
  String getValidatorName() {
    return "EmailValidator";
  }

  String validate(String data) {
    if (data.isEmpty){
      return "Email field cannot be empty";
    }
    return null;

  }
}