import 'package:matchup/bizlogic/validator.dart';

class PasswordValidator implements Validator{
  String getValidatorName() {
    return "PasswordValidator";
  }

  // TODO: implement a stronger password requirement algorithm
  String validate(String data) {
    if (data == null){
      return "Password field cannot be empty";
    }
    return data.isEmpty ? "Password field cannot be empty" : null;
  }
}