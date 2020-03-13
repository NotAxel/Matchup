import 'package:matchup/bizlogic/constants.dart' as ct;
import 'package:flutter/material.dart';
import 'dart:async';

class FilterPopupForm extends StatefulWidget{
  @override
  _FilterPopupForm createState()  => _FilterPopupForm();
}

class _FilterPopupForm extends State<FilterPopupForm> {
  static const double ButtonWidth = 130.0;
  static const double ButtonHeight = 40.0;

  List<String> filters = new List<String>(3);
  Container _underLine = Container(height: 2, color: Colors.deepPurple);
  final SnackBar _snackBar = SnackBar(content: Text("Filters saved and applyed"), duration: Duration(seconds: 3),);
  
  String _mainFilter;
  String _regionFilter;
  String _skillFilter;

  bool _isLoading;
  bool _isFilterForm;
  final _formKey = new GlobalKey<FormState>();

  // sets states for form at creation
  @override
  void initState() {
    _mainFilter = null;
    _isLoading = false;
    _regionFilter = null;
    _isFilterForm = true;
    super.initState();
  }

  // resets the form will be linked to refresh functionality
  resetForm() {
    _formKey.currentState.reset();
    _mainFilter = null;
    _regionFilter = null;
  }


  void toggleFormMode() {
    resetForm();
    setState(() {
      _isFilterForm = !_isFilterForm;
    });
  }

  // pushes form choices
  validateAndSubmit() async {
    setState(() {
      _isLoading = true;
    });
    try {
      print('test');
    }catch (e) {
      setState(() {
        _isLoading = false;
        _formKey.currentState.reset();
      });
    }
  }

  // pulls the list of characters from consts page and displays it as a drop down
  Widget showMainField() {
    return new Center(
      child: DropdownButton<String> (
        value: _mainFilter,
        isExpanded: true,
        hint: assignHint('Main'),
        onChanged: (String newValue) {
          setState(() {
            _mainFilter = newValue;
          });
        },
        items: ct.Constants.characters.
        map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      )
    );
  }


  // same as show main however for the regions field
  Widget showRegionField() {
    return new Center(
      child: DropdownButton<String> (
        value: _regionFilter,
        isExpanded: true,
        hint: assignHint('Region'),
        onChanged: (String newValue) {
          setState(() {
            _regionFilter = newValue;
          });
        },
        items: ct.Constants.regions.
        map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      )
    );
  }

  // same as show main however for the skill field
  Widget showSkillField() {
    return new Center(
      child: DropdownButton<String> (
        value: _skillFilter,
        isExpanded: true,
        hint: assignHint('Skill'),
        onChanged: (String newValue) {
          setState(() {
            _skillFilter = newValue;
          });
        },
        items: <String>["Beginner", "Intermediate", "Advanced"].
        map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      )
    );
  }

  Widget showSaveButton() {
    return new FlatButton(
      child: new Text('Save'),
      key: Key('SaveButton'),
      onPressed: () { // save the data and show snackbar
        print(_mainFilter);
        print(_regionFilter);
        print(_skillFilter);
        filters[0] = _mainFilter;
        filters[1] = _regionFilter;
        filters[2] = _skillFilter;
        Timer(Duration(seconds: 1), () {
          Navigator.pop(context, filters);
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: new Text('Filter users'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget> [
            showMainField(),
            showRegionField(),
            showSkillField()
          ]
        )
      ),
      actions: <Widget>[
        new Center(
          child: showSaveButton(),
        ),
      ]
    );
  }

  Text assignHint(String text) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 20.0
      ),
    );
  }
}