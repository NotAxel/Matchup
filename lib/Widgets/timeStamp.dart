import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimeStamp{
  // returns a containter that holds a text widget
  // the text widgets data is the time the message was sent
  static Widget buildTimeStamp(int timeStamp){
    // time stamp
    return Container(
      child: Text(
          formatTimeStamp(timeStamp),
          style: TextStyle(
            color: Colors.blueGrey,
            fontSize: 12.0,
          )
        ),
      padding: EdgeInsets.only(left: 10),
    );
  }

  // translatest the milliseconds since epoch time
  // into local time and returns the string
  // when testing on machines in different time zones,
  // this function will fail when using a static time
  // as your expected value
  // example: 24 Jan 2017 9:30 PM
  static String formatTimeStamp(int timeStamp){
    if (timeStamp != null){
      return DateFormat('dd MMM y').add_jm()
        .format(DateTime.fromMillisecondsSinceEpoch(timeStamp));
    }
    return "";
  }
}