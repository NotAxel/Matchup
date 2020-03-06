import 'package:matchup/bizlogic/validator.dart';

class PasswordValidator implements Validator{
  bool _isLogin;

  PasswordValidator(bool isLogin){
    _isLogin = isLogin;
  }

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
  String _regexSource = r'^((?=\S*?[A-Z])(?=\S*?[a-z])(?=\S*?[0-9])(?=.*?[!@#\$&*~]).{8,})$';

  String getValidatorName() {
    return "PasswordValidator";
  }

  // empty or null password data will always return empty error message
  // non empty password will return null for login
  // non empty password will return null if regexp requirements are met for signup
  String validate(String data) {
    if (data != null && data.length > 0){
      if (_isLogin){
        return null; // validate login
      }
      return validateSignUp(data);
    }
    return "Password field cannot be empty";
  }

  String validateSignUp(String data){
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