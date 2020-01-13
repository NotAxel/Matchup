// interface that is the wrapper for all validator classes produced by validatorFactory
abstract class Validator{
  // returns name of subclass ie passwordValidator, emailValidator etc.
  String getValidatorName();

  // processes the given data an error message or null if the data was valid
  String validate(String data);

  // process the given data to be saved once it is validated
  String save(String data);
}