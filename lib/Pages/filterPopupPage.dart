import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FilterPopupPage extends ModalRoute {
  // Properties that need to be overriden
  @override
  Duration get transitionDuration => Duration(milliseconds: 300);

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => false;

  @override
  Color get barrierColor => bgColor == null ? Colors.black.withOpacity(0.5) : bgColor;

  @override
  String get barrierLabel => null;

  @override
  bool get maintainState => false;

  // Variables
  double top;
  double bottom;
  double left;
  double right;
  Color bgColor;
  final Widget child;

  // Constructer
  FilterPopupPage ({
    Key key,
    this.bgColor,
    @required this.child,
    this.top,
    this.bottom,
    this.left,
    this.right,
  });

  // Override build page to create the content for popup
  @override
  Widget buildPage (
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return GestureDetector(
      onTap: () {
        SystemChannels.textInput.invokeMethod('TextInput.hide');
      } , 
      child: Material(
        type: MaterialType.transparency,
        child: SafeArea (
          bottom: true,
          child: _buildOverlayContent(context),
        ),
      )
    );
  }

  // Dynamic content pass by parameter
  Widget _buildOverlayContent(BuildContext context) {
    return Container (
      margin: EdgeInsets.only(
        bottom: this.bottom,
        left: this.left,
        right: this.right,
        top: this.top),
      child: child,
    );
  }

  // Override the transition for popup
  @override
  Widget buildTransitions(
    BuildContext context, 
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child) 
    {
      var begin = Offset(0.0, 1.0);
      var end = Offset.zero;
      var curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    }

}