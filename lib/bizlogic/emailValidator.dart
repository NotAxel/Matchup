import 'package:matchup/bizlogic/validator.dart';

class EmailValidator implements Validator{
  String getValidatorName() {
    return "EmailValidator";
  }

  String validate(String data) {
    if (data == null){
      return "Email field cannot be empty";
    }
    return data.isEmpty ? "Email field cannot be empty" : null;
  }
}