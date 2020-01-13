import 'package:matchup/bizlogic/validator.dart';

class NullValidator implements Validator{
  String getValidatorName() {
    return "NullValidator";
  }

  String validate(String data) {
    return data.isEmpty ? "NullValidator - The given validator type was not found" : null;
  }
}