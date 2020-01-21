import 'package:flutter/material.dart';

class ImageLinker {

  static AssetImage linkImage(String main) {
    switch(main) {
      case "Fox" : return AssetImage('assets/images/fox_sprite.png');
      break;

      case "Marth" : return AssetImage('assets/images/marth_sprite.png');
      break;

      case "Sheik" : return AssetImage('assets/images/sheik_sprite.png');
      break;

      default: return AssetImage('assets/images/default_profile.jpg');
      break;

    }
  }

}