import 'package:flutter/material.dart';

// https://medium.com/flutter-community/flutter-effectively-scale-ui-according-to-different-screen-sizes-2cb7c115ea0a

// uses the MediaQuery to divide up the screen size into blocks
class ScreenSize{
  static MediaQueryData _mediaQueryData;
  static double _screenWidth;
  static double _screenHeight;
  static double _blockWidth; // one block is equal to 1% of the screen width
  static double _blockHeight; // one block is equal to 1% of the screen height

  static double _safeAreaWidth; // combined left and right safe areas
  static double _safeAreaHeight; // combined top and bottom safe areas

  // take into account safe areas
  static double _safeBlockWidth; // one block is equal to 1% of the screen width
  static double _safeBlockHeight; // one block is equal to 1% of the screen height

  static init(BuildContext context){
    // get the base screen width and height of the device from the media query
    _mediaQueryData = MediaQuery.of(context);
    _screenWidth = _mediaQueryData.size.width;
    _screenHeight = _mediaQueryData.size.height;

    // divide the width and height into blocks
    _blockWidth = _screenWidth / 100;
    _blockHeight = _screenHeight / 100;

    // calculate the safe areas for the screen
    _safeAreaWidth = _mediaQueryData.padding.left + 
    _mediaQueryData.padding.right;
    _safeAreaHeight = _mediaQueryData.padding.top +
    _mediaQueryData.padding.bottom;

    // calculate total screen available with respect to safe area
    _safeBlockWidth = (_screenWidth -
    _safeAreaWidth) / 100;
    _safeBlockHeight = (_screenHeight -
    _safeAreaHeight) / 100;
  }

  static double get getScreenWidth => _screenWidth;
  static double get getScreenHeight => _screenHeight;
  static double get getBlockWidth => _blockWidth;
  static double get getBlockHeight => _blockHeight;
  static double get getSafeBlockWidth => _safeBlockWidth;
  static double get getSafeBlockHeight => _safeBlockHeight;
}