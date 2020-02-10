import 'package:matchup/bizlogic/validator.dart';

class PasswordValidator implements Validator{
  /* Password validation requirements
    Minimum password length:
      8 characters
    Password must contain:
      At least one upper case character
      At least one lower case character
      At least one numeric digit between 0 and 9 
      At least one special character (!@#\$&*~)
    Password must not contain:
      White space characters
  */
  String _regexSource = r'^((?=\S*?[A-Z])(?=\S*?[a-z])(?=\S*?[0-9])(?=.*?[!@#\$&*~]).{8,})\S$';

  String getValidatorName() {
    return "PasswordValidator";
  }

  // TODO: implement a stronger password requirement algorithm once deployed
  String validate(String data) {
    final regex = RegExp(_regexSource);
    final matches = regex.allMatches(data);
    for (Match match in matches) {
      if (match.start == 0 && match.end == data.length) {
        return null;
      }
    }
    return "Password did not meet requirements";
  }

  String save(String data){
    return data;
  }
}