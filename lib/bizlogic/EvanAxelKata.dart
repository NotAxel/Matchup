

import 'package:validators/validators.dart';

class kata {

  static String greet(List<String> names) {
    if(names == null) {
      return "Hello, my friend.";
    }
    if(names.length == 1) {
      if(isUppercase(names[0])) {
        return "HELLO " + names[0] + "!";
      }
      return "Hello, " + names[0] + ".";
    }
    List<String> lower= new List();
    List<String> upper= new List();
    List<String> temp= new List();
    // add all names to temp and split if needed
    for(String name in names){
      if(!name.contains("\"")) {
        temp += name.split(",");
      } else {
        temp.add(name);
      }
    }
    for(int i=0;i<temp.length;i++) {
      temp[i] = temp[i].trim();
    }
    // add strings from temp to either lowercase or uppercase
    for(String sub in temp) {
      if(isUppercase(sub)) {
        upper.add(sub);
      } else {
        lower.add(sub);
      }
    }
    for(int i=0;i<lower.length;i++) {
      lower[i] = lower[i].replaceAll('\"', '');
    }
    String out = "Hello, ";
    for(int i =0; i < lower.length ;i++) {
      if(i == lower.length -1){
        out += "and "+ lower[i] + ".";
      } else {
        if(i == lower.length - 2 && lower.length == 2) {
          out += lower[i] + " ";
        } else {
          out += lower[i] + ", ";
        }
      }
    }
    if(upper.length > 0) {
      out += " AND HELLO " + upper[0] + "!";
    }
    return out;
    // if(names.length == 1) {
    //   if(names[0] == null) return "Hello, my friend.";
    //   if(isUppercase(names[0])) return "HELLO " + names[0] + "!";
    //   else return "Hello, " + names[0] + "."; 
    // } else if(names.length > 2) {
      
      
    
    //   String out = "Hello, ";
    //   print(lower[1]);
    //   if(lower.length == 2) {
    //     out += lower[0] + " and " + lower[1] + ".";
    //   } else if(lower.length > 2) {
    //     for(int i =0; i < lower.length ;i++) {
    //       if(i == lower.length -1){
    //         out += "and "+ lower[i] + ".";
    //       }else{
    //         out += lower[i] + ", ";
    //       }
    //     }
    //   }
    //   return out;
    // }
  }

  static void printArray(List<String> array) {
    print(array.length);

    print(array.toString());
  }
}