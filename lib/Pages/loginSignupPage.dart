import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:matchup/authentication.dart';
import 'userInfoEntryPage.dart';
import 'homepage.dart';

class LogInSignupPage extends StatefulWidget {
  final String userId;
  final BaseAuth auth;
  final VoidCallback loginCallback;
  final VoidCallback logoutCallback;

  LogInSignupPage({this.userId, this.auth, this.loginCallback, this.logoutCallback});
  
  @override
  _LogInSignupPageState createState() => _LogInSignupPageState(auth: auth);
}

class LoginSignupProvider extends InheritedWidget{
  final BaseAuth auth;
  final VoidCallback loginCallback;
  final VoidCallback logoutCallback;
  final Widget child;

  LoginSignupProvider(this.auth, this.loginCallback, this.logoutCallback, this.child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }
  
  // by using this function to add the call back to the context in the tabstate build,
  // should be able to ref the call back in a tab class
  static LoginSignupProvider of(BuildContext context) =>
    context.inheritFromWidgetOfExactType(LoginSignupProvider);
}

class _LogInSignupPageState extends State<LogInSignupPage> {
  final BaseAuth auth;
  _LogInSignupPageState({this.auth});
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String _email;
  String _password;
  String _errorMessage;

  bool _isLoginForm;
  bool _isLoading;
  final _formKey = new GlobalKey<FormState>();

  @override
  void initState() {
    _errorMessage = "";
    _isLoading = false;
    _isLoginForm = true;
    super.initState();
  }

  void resetForm(){
    _formKey.currentState.reset();
    _errorMessage = "";
    _email = null;
    _password = null;
    emailController.clear();
    passwordController.clear();
  }

  void toggleFormMode() {
    resetForm();
    setState(() {
      _isLoginForm = !_isLoginForm;
    });
  } 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          body: Stack(
          children: <Widget>[
            _showLogInForm(),
          ],
        ));
  }

  Widget showEmailField(){
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 250.0, 10.0, 0.0),
      child: new TextFormField(
          obscureText: false,
          maxLines: 1,
          style: style,
          autofocus: false,
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
              hintText: "Email",
              icon: new Icon(Icons.mail, 
              color: Colors.blueGrey,
              )),
          validator: (value) => value.isEmpty ? 'Email can\'t be empty' : null,
          onSaved: (value) => _email = value.trim(),
      ),
    );
  } 

  Widget showPasswordField(){
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 15.0, 10.0, 0.0),
      child: new TextFormField(
          maxLines: 1,
          obscureText: true,
          autofocus: false,
          style: style,
          controller: passwordController,
          decoration: InputDecoration(
              //contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              hintText: "Password",
              icon: new Icon(Icons.lock,
              color: Colors.blueGrey
              )),
          validator: (value) => value.isEmpty ? 'Password can\'t be empty' : null,
          onSaved: (value) => _password = value.trim(),
      ),
    );
  }

  Widget showLogInButton(){
    return new Padding(
        padding: EdgeInsets.fromLTRB(20.0, 45.0, 20.0, 0.0),
        child: SizedBox(
          height: 40.0,
          child: new RaisedButton(
            elevation: 5.0,
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0)),
            color: Colors.deepOrange,
            child: new Text(_isLoginForm ? 'Login' : 'Create account',
                style: new TextStyle(fontSize: 20.0, color: Colors.white)),
            onPressed: validateAndSubmit,
          ),
        ));
  }
  
  Widget showSwitchButton(){
        return new FlatButton(
        child: new Text(
            _isLoginForm ? 'Create an account' : 'Have an account? Sign in',
            style: new TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300)),
        onPressed: toggleFormMode);
  }
  Widget showLogo(){
    return Image.asset('assets/images/logo.png');
  }

  Widget showErrorMessage() {
    if (_errorMessage.length > 0 && _errorMessage != null) {
      return new Text(
        _errorMessage,
        style: TextStyle(
            fontSize: 13.0,
            color: Colors.red,
            height: 1.0,
            fontWeight: FontWeight.w300),
      );
    } else {
      return new Container(
        height: 0.0,
      );
    }
  }

// Check if form is valid before perform login or signup
  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  // Perform login or signup
  void validateAndSubmit() async {
    setState(() {
      _errorMessage = "";
      _isLoading = true;
    });
    if (validateAndSave()) {
      print("passed validate and save");
      String userId = "";
      try {
        if (_isLoginForm) {
          userId = await widget.auth.signIn(_email, _password);
          print('Signed in: $userId');
        } else {
          userId = await widget.auth.signUp(_email, _password);
          //widget.auth.sendEmailVerification();
          //_showVerifyEmailSentDialog();
          print('Signed up user: $userId');
        }
        setState(() {
          _isLoading = false;
        });

        if (userId.length > 0 && userId != null && _isLoginForm) {
          widget.loginCallback();
        }
        // successfully logged in and heading to user info entry page
        else if (_isLoginForm == false){
          // return new user info entry
          Navigator.push(context,
          MaterialPageRoute(builder: (context) => HomePage(userId: userId, auth: auth, logoutCallback: widget.logoutCallback))
          );
          Navigator.push(context,
          MaterialPageRoute(builder: (context) => UserInfoEntryPage(userId: userId, auth: auth, logoutCallback: widget.logoutCallback))
          );
        }
      } catch (e) {
        print('Error: $e');
        print("IN ERROR HANDLER");
        setState(() {
          _isLoading = false;
          _errorMessage = e.message;
          _formKey.currentState.reset();
        });
      }
    }
  }

  Widget _showLogInForm() {
    return 
    /*LoginSignupProvider(
     widget.auth,
     widget.loginCallback,
     widget.logoutCallback,
     */
     new Container(
        padding: EdgeInsets.all(16.0),
        child: new Form(
          key: _formKey,
          child: new ListView(
            shrinkWrap: true,
            children: <Widget>[
              showLogo(),
              showEmailField(),
              showPasswordField(),
              showLogInButton(),
              showSwitchButton(),
              showErrorMessage(),
            ],
          ),
        ));
   // );
  }
}