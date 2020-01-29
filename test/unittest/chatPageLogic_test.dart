import 'package:flutter/material.dart'; 
import 'package:test/test.dart'; 
import 'package:matchup/bizlogic/chatPageLogic.dart'; 

void main(){
  group("messageBoxColor", (){
    test('if the user sent the message, the box is blue', (){
      // ARRANGE
      bool isUserMessage = true;
      Color expectedColor = Colors.blue[400];
      Color actualColor;
      
      // ACT
      actualColor = ChatPageLogic.messageBoxColor(isUserMessage);

      // ASSERT
      expect(actualColor, expectedColor);
    });

    test('if the peer sent the message, the box is grey', (){
      // ARRANGE
      bool isUserMessage = false;
      Color expectedColor = Colors.grey[300];
      Color actualColor;
      
      // ACT
      actualColor = ChatPageLogic.messageBoxColor(isUserMessage);

      // ASSERT
      expect(actualColor, expectedColor);
    });
  });
  group("formatTimeStamp", (){
    test('given an integer time stamp, returns formatted datetime', (){
      // ARRANGE
      int timeStamp = 1580239938614;
      String expectedDate = "28 Jan 2020 11:32 AM" ;
      String actualDate;
      
      // ACT
      actualDate = ChatPageLogic.formatTimeStamp(timeStamp);

      // ASSERT
      expect(expectedDate, actualDate);
    });

    test('given a null time stamp, returns empty string', (){
      // ARRANGE
      int timeStamp;
      String expectedDate = "";
      String actualDate;
      
      // ACT
      actualDate = ChatPageLogic.formatTimeStamp(timeStamp);

      // ASSERT
      expect(expectedDate, actualDate);
    });
  });
  group("messageContainerMargins", (){
    test('last message has bottom margin of 20', (){
      // ARRANGE
      int index = 0;
      double expectedInsetValue = 20.0;
      EdgeInsets expectedInsets = EdgeInsets.only(bottom: expectedInsetValue);
      EdgeInsets actualInsets;
      
      // ACT
      actualInsets = ChatPageLogic.messageContainerMargins(index);

      // ASSERT
      expect(actualInsets, expectedInsets);

    });

    test('last message has bottom margin of 10', (){
      // ARRANGE
      int index = 1;
      double expectedInsetValue = 10.0;
      EdgeInsets expectedInsets = EdgeInsets.only(bottom: expectedInsetValue);
      EdgeInsets actualInsets;
      
      // ACT
      actualInsets = ChatPageLogic.messageContainerMargins(index);

      // ASSERT
      expect(actualInsets, expectedInsets);
    });
  });
}