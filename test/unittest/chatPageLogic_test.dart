import 'package:flutter/material.dart';
import 'package:test/test.dart';
import 'package:matchup/bizlogic/chatPageLogic.dart';

void main(){
  test('user messages are placed on the right of message rows', (){
    // ARRANGE
    MainAxisAlignment expectedAllignment = MainAxisAlignment.end;
    bool isUserMessage = true;
    MainAxisAlignment actualAllignment;

    // ACT
    actualAllignment = ChatPageLogic.rowMainAxisAlignment(isUserMessage);

    // ASSERT
    expect(actualAllignment, expectedAllignment);
  });

  test('peer messages are placed on the right of message rows', (){
    // ARRANGE
    MainAxisAlignment expectedAllignment = MainAxisAlignment.start;
    bool isUserMessage = false;
    MainAxisAlignment actualAllignment;

    // ACT
    actualAllignment = ChatPageLogic.rowMainAxisAlignment(isUserMessage);

    // ASSERT
    expect(actualAllignment, expectedAllignment);
  });
}