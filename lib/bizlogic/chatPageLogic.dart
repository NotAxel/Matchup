import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatPageLogic{
  // chooses if the row main axis alignment is end or start
  // end places message box on right of row for user message
  // start places message box on left of row for peer message
  static MainAxisAlignment rowMainAxisAlignment(bool isUserMessage) {
    if (isUserMessage){
      return MainAxisAlignment.end;
    }
    return MainAxisAlignment.start;
  }

  // chooses if the column cross axis alignment is end or start
  // end puts the widget on the right side of the column for user message
  // start puts the widget on the left side of the column for peer message
  static CrossAxisAlignment columnCrossAxisAlignment(bool isUserMessage) {
    if (isUserMessage){
      return CrossAxisAlignment.end;
    }
    return CrossAxisAlignment.start;
  }

  // returns black for user message text
  // returns black for peer message text
  static Color messageTextColor(bool isUserMessage){
    if (isUserMessage){
      return Colors.white;
    }
    return Colors.black;
  }

  // returns blue for user message box 
  // returns grey for peer message text
  static Color messageBoxColor(bool isUserMessage){
    if (isUserMessage){
      return Colors.blue[400];
    }
    return Colors.grey[300];
  }

  // translatest the milliseconds since epoch time
  // into utc time and returns the string
  // example: 24 Jan 2017 9:30 PM
  static String formatTimeStamp(String timeStamp){
    return DateFormat('dd MMM y').add_jm()
      .format(DateTime.fromMillisecondsSinceEpoch(int.parse(timeStamp)));
  }

  static EdgeInsets messageContainerMargins(int index){
    if (index == 0){
      return EdgeInsets.only(bottom: 20);
    } 
    else {
      return EdgeInsets.only(bottom: 10);
    }
  }
}