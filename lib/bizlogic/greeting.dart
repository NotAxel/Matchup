import 'package:flutter_test/flutter_test.dart';
import 'package:validators/validators.dart';

greet(List names) {
  int capNum = 0;
  int lowerNum = 0;
  String greeting = "Hello, ";
  String caps = "AND HELLO ";
  if(names == null){
    return("Hello, my friend.");
  }
  if(names.length == 1){
    if(isUppercase(names[0])){
      return("HELLO " + names[0] + "!");
    }
    return("Hello, " + names[0] + ".");
  }
  for(int i = 0; i < names.length; i++){
    List split = names[i].split(", ");
    if(isUppercase(names[i])){
        capNum ++;
    }
    else{
      lowerNum ++;
    }
  }
  for(int i = 0; i < names.length - 1; i++){
    if(isUppercase(names[i])){
      caps += names[i];
    }
    else{
      greeting +=  names[i];
      if(lowerNum == 2){
        greeting += " ";
      }
      else{
        greeting += ", ";
      }
    }
  }
  greeting += "and " + names[names.length-1] + ".";
  if(capNum > 0){
    greeting += " " + caps + "!";
  }
  return(greeting);
}