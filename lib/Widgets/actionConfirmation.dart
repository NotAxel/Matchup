import 'package:flutter/material.dart';

class ActionConfirmation{
  BuildContext _context;
  String _cancelMessage;
  VoidCallback _yesOnPressed;
  VoidCallback _noOnPressed;
  bool useRootNavigatior;

  ActionConfirmation(this._context, this._cancelMessage, this._yesOnPressed, this._noOnPressed, {this.useRootNavigatior = true});

  // yes or no option buttons that go in the cancel form alert
  // the Key for yes button: yesButton
  // the Key for no button: noButton
  Widget _alertButton(String hintText, VoidCallback alertButtonOnPressed){
    return FlatButton(
      key: Key(hintText.toLowerCase() + "Button"),
      child: Text(hintText),
      onPressed: alertButtonOnPressed
    );
  }

  // popup that alerts the user they are about to cancel account creation
  // appears when the user attempts to press the back button
  Future<bool> confirmAction(){
    return showDialog(
      barrierDismissible: false,
      useRootNavigator: this.useRootNavigatior,
      context: _context,
      builder: (context)=>AlertDialog(
        key: Key("cancelForm"),
        title: Text("Cancel Form"),
        content: Text(_cancelMessage),
        actions: <Widget>[
          _alertButton("Yes", _yesOnPressed),
          _alertButton("No", _noOnPressed)
        ],
      )
    );
  }
}