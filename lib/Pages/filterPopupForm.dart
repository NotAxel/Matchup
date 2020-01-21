import 'package:matchup/bizlogic/constants.dart' as ct;
import 'package:flutter/material.dart';

class FilterPopupForm extends StatefulWidget{
  @override
  _FilterPopupForm createState()  => _FilterPopupForm();
}

class _FilterPopupForm extends State<FilterPopupForm> {
  static const double ButtonWidth = 130.0;
  static const double ButtonHeight = 40.0;

  Container _underLine = Container(height: 2, color: Colors.deepPurple);
  
  String _mainFilter;
  String _regionFilter;

  bool _isLoading;
  bool _isFilterForm;
  final _formKey = new GlobalKey<FormState>();

  @override
  void initState() {
    _mainFilter = null;
    _isLoading = false;
    _regionFilter = null;
    _isFilterForm = true;
    super.initState();
  }

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

  validateAndSubmit() async {
    setState(() {
      _isLoading = true;
    });
    if(validateAndSave()) {
      try {
        print('test');
      }catch (e) {
        setState(() {
          _isLoading = false;
          _formKey.currentState.reset();
        });
      }
    }
  }

  bool validateAndSave() {
    final form = _formKey.currentState;
    //form.save();
    return true;
  }

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

  Widget showSaveButton() {
    return new Padding(
      padding: EdgeInsets.fromLTRB(5.0, 15, 5, 0),
      child: SizedBox(
        height: ButtonHeight,
        width: ButtonWidth,
        child: new RaisedButton(
          elevation: 10.0,
          color: Colors.lightGreen,
          shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(30.0)
          ),
          child: new Text('Save'),
          onPressed: () {},
        ),
      ),
    );
  }

  Widget showResetButton() {
    return new Padding(
      padding: EdgeInsets.fromLTRB(5.0, 15, 5, 0),
      child: SizedBox(
        height: ButtonHeight,
        width: ButtonWidth,
        child: new RaisedButton(
          elevation: 10.0,
          color: Colors.deepOrange,
          onPressed: () {},
          shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(30.0)
          ),
          child: new Text('Reset'),
          //onPressed: resetForm(),
       )
      ),
    );
  }

  Widget showButtons() {
    return new Container(
      child: new Row(
        children: <Widget>[
          const SizedBox(width: 23),
          showResetButton(),
          const SizedBox(width: 15),
          showSaveButton(),
          const SizedBox(width: 24),
        ],)
    );
  }

  Widget _showFilterForm() {
    return new Container(
      padding: EdgeInsets.all(16.0),
      child: new Form(
        key: _formKey,
        child: new ListView(
          shrinkWrap: true,
          children: <Widget>[
            const SizedBox(height: 15),
            showMainField(),
            const SizedBox(height: 20),
            showRegionField(),
            const SizedBox(height: 20),
            showButtons(),
          ],
        )
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget> [
        _showFilterForm(),
      ],
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