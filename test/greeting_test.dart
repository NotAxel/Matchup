import 'package:flutter_test/flutter_test.dart';
import 'package:matchup/bizlogic/greeting.dart';
main(){
  test("req1", (){
    List names = ["Bob"];
    String result = "Hello, Bob.";
    expect(result, greet(names));
  });
  test("req2", (){
    String result = "Hello, my friend.";
    expect(result, greet(null));
  });
  test("req3", (){
    List names = ["BRENDAN"];
    String result = "HELLO BRENDAN!";
    expect(result, greet(names));
  });
  test("req4", (){
    String result = "Hello, Garret and Brendan.";
    List names = ["Garret", "Brendan"];
    expect(result, greet(names));
  });
  test("req5", (){
    String result = "Hello, Garret, Brendan, and Evan.";
    List names = ["Garret", "Brendan", "Evan"];
    expect(result, greet(names));
  });
  test("req6", (){
    String result = "Hello, Garret and Brendan. AND HELLO EVAN!";
    List names = ["Garret", "EVAN", "Brendan"];
    expect(result, greet(names));
  });
  test("req7", (){
    String result = "Hello, Garret, Brendan, and Evan.";
    List names = ["Garret", "Brendan, Evan"];
    expect(result, greet(names));
  });
  test("req8", (){
    String result = "Hello, Garret and Brendan, Evan.";
    List names = ["Garret", "\"Brendan, Evan\""];
    expect(result, greet(names));
  });
}
    