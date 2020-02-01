import 'package:matchup/bizlogic/validator.dart';

class FriendCodeValidator implements Validator{
  String formattingError = '''Your Nintendo Switch Friend Code
    must begin with SW- followed by the remaining 12 digits of your code
    with a dash after the fourth digit and the eigth digit\n
    Example: SW-8496-9128-4205''';

  String getValidatorName() {
    return "FriendCodeValidator";
  }

  // returns an error message if the string is improperly formatted
  // returns null otherwise
  // a properly formatted string is the formatting of a nintendo friend code
  // eg SW-8496-9128-4205
  String checkFormatting(String friendCode){
    if (friendCode.length != 17 ||
      friendCode.substring(0, 3) != "SW-" || 
      int.tryParse(friendCode.substring(3, 7)) == null ||
      friendCode.substring(7, 8) != "-" || 
      int.tryParse(friendCode.substring(8, 12)) == null ||
      friendCode.substring(12, 13) != "-" ||
      int.tryParse(friendCode.substring(13, 17)) == null){
      return formattingError;
    }
    return null;
  }

  // a null or empty string returns an error message
  String validate(String friendCode) {
    if (friendCode != null && friendCode.isNotEmpty){
      return checkFormatting(friendCode);
    }
    return "Friend Code field cannot be empty";
  }

  String save(String data){
    return data.trim();
  }
}