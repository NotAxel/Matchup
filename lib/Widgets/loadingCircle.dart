import 'package:flutter/material.dart';

class LoadingCircle{
  static Widget loadingCircle(){
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
            Colors.lightBlue)
        )
      ),
    );
  }
}