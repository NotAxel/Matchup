import 'package:validators/validators.dart';

class GreetingKata{
  GreetingKata();
  String greet(List name){
    String res = "Hello, ";
    if(name == null)
    {
      return "Hello, my friend.";
    }
    else if(name.length == 2)
    {
      bool useParsed = false;
      bool usedOverride = false;
      List namesAfterParsing = [];
      for (String s in name){
        if (s[0] == "\"" && s[s.length - 1] == "\""){
          usedOverride = true;
          namesAfterParsing.add(s.substring(1, s.length - 1));
        }
        else if (s.contains(",")){
          useParsed = true;
          for (String postSplit in s.split(", ")){
            namesAfterParsing.add(postSplit);
          }
        }
        else{
          namesAfterParsing.add(s);
        }
      }
      if (useParsed){
        return greet(namesAfterParsing);
      }
      else if (usedOverride){
        return "Hello, " + namesAfterParsing[0] + " and " + namesAfterParsing[1] + ".";
      }
      return "Hello, " + name[0] + " and " + name[1];
    }
    else if (name.length > 2){
      int i = 0;
      List upper = [];
      List lower = [];

      for (int i = 0; i < name.length; i++){
        if(isUppercase(name[i]))
        {
          upper.add(name[i]);
        }
        else
        {
          lower.add(name[i]);
        }
      }

      res = upperLowerString(upper, lower);
      return res;
/*
      for (i = 0; i < name.length - 1; i++){
        res += name[i] + ", ";
      }
      res += "and " + name[i];
      return res;
*/
    }
    else if(isUppercase(name[0])){
      return "HELLO " + name[0] + "!";
    }
    return "Hello, " + name[0];
  }
  
  String upperLowerString(List upper, List lower)
  {
    int i = 0;
    String res = "Hello, ";
    if (lower.length == 2){
      res += lower[0] + " and " + lower[1] + ".";
    }
    else if (lower.length > 2){
      for (i = 0; i < lower.length - 1; i++){
        res += lower[i] + ", ";
      }
      res += "and " + lower[i] + ".";
    }

    if(upper.length > 0)
    {
      res += " AND HELLO ";
      for (i = 0; i < upper.length - 1; i++)
      {
        res += upper[i] + ", ";
      }
      if(upper.length > 1)
        res += "and " + upper[i] + "!";
      else
        res += upper[0] + "!";
    }

    return res;
  }
}