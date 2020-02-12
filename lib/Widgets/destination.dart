import 'package:flutter/material.dart';

class Destination {
  Destination(this._name, this._page, this._navItem);
  final String _name;
  final Widget _page;
  final BottomNavigationBarItem _navItem;

  String get getName => _name;
  Widget get getPage => _page;
  BottomNavigationBarItem get getNavItem => _navItem;

}

