import 'package:flutter/material.dart';

class WrappingText{
  static Widget wrappingText(Text text){
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(child: text,)
              ],
            ),
            fit: FlexFit.loose,
          ),
        ],
      ),
    );
  }
}