import 'package:flutter_test/flutter_test.dart';
import 'package:matchup/bizlogic/greetingkata.dart';

main() {
  test("Requirement 1", (){
    GreetingKata kata = new GreetingKata();
    String result = kata.greet(["Keeg"]);
    expect(result, "Hello, Keeg");
  });
  test("Requirement 2", (){
    GreetingKata kata = new GreetingKata();
    String result = kata.greet(null);
    expect(result, "Hello, my friend.");
  });

  test("Requirement 3", (){
    GreetingKata kata = new GreetingKata();
    String result = kata.greet(["KYLE"]);
    expect(result, "HELLO KYLE!");
  });
  test("Requirement 4", (){
    GreetingKata kata = new GreetingKata();
    List names = ["Keegan", "Kyle"];
    String result = kata.greet(names);
    expect(result, "Hello, Keegan and Kyle");
  });

  test("Requirement 5", (){
    GreetingKata kata = new GreetingKata();
    List names = ["Keegan", "Kyle", "Brendan"];
    String result = kata.greet(names);
    expect(result, "Hello, Keegan, Kyle, and Brendan.");
  });
  test("Requirement 6", (){
    GreetingKata kata = new GreetingKata();
    List names = ["Keegan", "Kyle", "BRENDAN"];
    String result = kata.greet(names);
    expect(result, "Hello, Keegan and Kyle. AND HELLO BRENDAN!");
  });

  test("Requirement 7", (){
    GreetingKata kata = new GreetingKata();
    List names = ["Keegan", "Kyle, Brendan"];
    String result = kata.greet(names);
    expect(result, "Hello, Keegan, Kyle, and Brendan.");
  });

  test("Requirement 8", (){
    GreetingKata kata = new GreetingKata();
    List names = ["Bob", "\"Charlie, Dianne\""];
    String result = kata.greet(names);
    expect(result, "Hello, Bob and Charlie, Dianne.");
  });

}