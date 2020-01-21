import 'package:flutter/material.dart';

class FilterPopupContent extends StatefulWidget {
  final Widget content;

  FilterPopupContent ({
    Key key,
    this.content, 
  }) : super(key: key);

  _FilterPopupContent createState() => _FilterPopupContent();
}

class _FilterPopupContent extends State<FilterPopupContent> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container (
      child: widget.content,
    );
  }
}