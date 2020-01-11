import 'package:flutter_test/flutter_test.dart';

import 'package:matchup/bizlogic/EvanAxelKata.dart' as EA;

void main() {
  test('1 Normal name', () {
    expect(EA.kata.greet(["Bob"]), "Hello, Bob.");
  });
  test('2 No name', () {
    expect(EA.kata.greet(null), "Hello, my friend.");
  });
  test('3 Yelling', () {
    expect(EA.kata.greet(["JERRY"]), "HELLO JERRY!");
  });

  test('4 Two people', () {
    expect(EA.kata.greet(["Jill", "Jane"]), "Hello, Jill and Jane.");
  });

  test('5 More than two people', () {
    expect(EA.kata.greet(["Amy", "Brian", "Charlotte"]), "Hello, Amy, Brian, and Charlotte.");
  });

  test('6 More than two people and yelling', () {
    expect(EA.kata.greet(["Amy", "BRIAN", "Charlotte"]), "Hello, Amy and Charlotte. AND HELLO BRIAN!");
  });
  
  test('7 Name contains comma', () {
    expect(EA.kata.greet(["Bob", "Charlie, Dianne"]), "Hello, Bob, Charlie, and Dianne.");
  });

  test('8 escape characters', () {
    expect(EA.kata.greet(["Bob", "\"Charlie, Dianne\""]), "Hello, Bob and Charlie, Dianne.");
  });
}