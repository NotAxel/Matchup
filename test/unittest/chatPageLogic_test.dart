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
    // for local time on US west coast, the expected should be 11:32 AM
    // for GMT/UTC it should be 7:32 PM
    // tested and works, but skip during the build since it will not work
    // on both local and travis
    test('given an integer time stamp, returns formatted datetime', (){
      // ARRANGE
      int timeStamp = 1580239938614;
      String expectedDate = "28 Jan 2020 7:32 PM" ;
      String actualDate;
      
      // ACT
      actualDate = ChatPageLogic.formatTimeStamp(timeStamp);

      // ASSERT
      expect(actualDate, expectedDate);
    }, skip: true);

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

  group("rowMainAxisAlignment", (){
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

    test('peer messages are placed on the left of message rows', (){
      // ARRANGE
      MainAxisAlignment expectedAllignment = MainAxisAlignment.start;
      bool isUserMessage = false;
      MainAxisAlignment actualAllignment;

      // ACT
      actualAllignment = ChatPageLogic.rowMainAxisAlignment(isUserMessage);

      // ASSERT
      expect(actualAllignment, expectedAllignment);
    });
  });

  group("columnCrossAxisAlignment", (){
    test("user messages appears on the right of message columns", (){
      // ARRANGE
      CrossAxisAlignment expectedAllignment = CrossAxisAlignment.end;
      bool isUserMessage = true;
      CrossAxisAlignment actualAllignment;

      // ACT
      actualAllignment = ChatPageLogic.columnCrossAxisAlignment(isUserMessage);

      // ASSERT
      expect(actualAllignment, expectedAllignment);
    });

    test("peer messages appears on the left of message columns", (){
      // ARRANGE
      CrossAxisAlignment expectedAllignment = CrossAxisAlignment.start;
      bool isUserMessage = false;
      CrossAxisAlignment actualAllignment;

      // ACT
      actualAllignment = ChatPageLogic.columnCrossAxisAlignment(isUserMessage);

      // ASSERT
      expect(actualAllignment, expectedAllignment);
    });
  });
  group("messageTextColor", (){
    test("user message text is white", (){
      // ARRANGE
      Color expectedColor = Colors.white;
      bool isUserMessage = true;
      Color actualColor;

      // ACT
      actualColor = ChatPageLogic.messageTextColor(isUserMessage);

      // ASSERT
      expect(actualColor, expectedColor);
    });
    
    test("peer message text is black", (){
      // ARRANGE
      Color expectedColor = Colors.black;
      bool isUserMessage = false;
      Color actualColor;

      // ACT
      actualColor = ChatPageLogic.messageTextColor(isUserMessage);

      // ASSERT
      expect(actualColor, expectedColor);
    });
  });
}