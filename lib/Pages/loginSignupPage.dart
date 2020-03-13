import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:matchup/bizlogic/screenSize.dart';
import 'package:provider/provider.dart';

import 'package:matchup/Widgets/errorMessage.dart';
import 'package:matchup/Widgets/loadingCircle.dart';
import 'package:matchup/Widgets/passwordFormField.dart';
import 'package:matchup/Widgets/wrappingText.dart';
import 'package:matchup/bizlogic/authentication.dart';
import 'package:matchup/bizlogic/emailValidator.dart';
import 'package:matchup/bizlogic/validator.dart';
import 'userInfoEntryPage.dart';

class LogInSignupPage extends StatefulWidget {
  final Future<void> Function() loginCallback;
  final Future<void> Function(bool) logoutCallback;

  LogInSignupPage({this.loginCallback, this.logoutCallback});
  
  @override
  _LogInSignupPageState createState() => _LogInSignupPageState();
}

class _LogInSignupPageState extends State<LogInSignupPage> {

  _LogInSignupPageState();

  String _email;
  FocusNode _passwordFocusNode = FocusNode();
  PasswordFormField _passwordFormField = PasswordFormField(true);
  ErrorMessage _errorMessage = ErrorMessage();
  final TextEditingController _emailController = new TextEditingController();

  bool _isLoginForm;
  bool _isLoading;

  bool _showRequirements = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _errorMessage.setMessage = null;
    _isLoading = false;
    _isLoginForm = true;
    _passwordFocusNode.addListener(passwordFieldOnFocus);
    _passwordFormField.setFocusNode = _passwordFocusNode;
    super.initState();
  }

  void resetForm(){
    _formKey.currentState.reset();
    _errorMessage.setMessage = null;
    _email = null;
    _passwordFormField.setPassword = null;
  }

  void toggleFormMode() {
    setState(() {
      _isLoginForm = !_isLoginForm;
      _passwordFormField.setIsLogin = _isLoginForm;
    });
  } 

  void passwordFieldOnFocus(){
    setState(() {
      _showRequirements = !_showRequirements;
    });
  }

  

  // user defined function
  Widget _showEmailDialog() {
    // flutter defined function
        // return object of type Dialog
        return AlertDialog(
          title: new Text("enter email of lost account into email field and repress button"),
          elevation: 100.0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          content: showEmailField(),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
              key: Key('closeDialog')
            ),
            new FlatButton(
              child: new Text("Submit"),
              onPressed: () {
                Navigator.pop(context, _emailController.text);
              },
            ),
          ],
        );
  }



  // https://stackoverflow.com/questions/52645944/flutter-expanded-vs-flexible
  Widget showEmailField(){
    Validator emailValidator = EmailValidator();
    return Container(
      child:Center(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, 5, 60, 5.0),
          child: new TextFormField(
              key: Key('email'),
              controller: _emailController,
              maxLines: 1,
              autofocus: false,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                  hintText: "Email",
                  icon: new Icon(Icons.mail, 
                  color: Colors.blueGrey,
                  )),
              validator: (value) => emailValidator.validate(value),
              onSaved: (value) => _email = emailValidator.save(value),
          ),
        ),
      ),
    );
  } 

  // https://stackoverflow.com/questions/50293503/how-to-set-the-width-of-a-raisedbutton-in-flutter
  Widget showLogInButton(){
    return Container(
      child: Center(
        child: ButtonTheme(
          minWidth: 300,
          height: 50,
          child: new RaisedButton(
            key: Key('login'),
            elevation: 5.0,
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0)),
            color: Colors.blue,
            child: new Text(_isLoginForm ? 'Login' : 'Create account',
                style: new TextStyle(fontSize: 20.0, color: Colors.white)),
            onPressed: validateAndSubmit,
          ),
        ),
      ),
    );
  }
  
  Widget showSwitchButton(){
    return Container(
      child: Center(
        child: new FlatButton(
        key: Key('switch between login/signup'),
        child: new Text(
          _isLoginForm ? 'Create an account' : 'Have an account? Sign in',
          style: new TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300)),
        onPressed: toggleFormMode),
      ),
    );
  }
  Widget showLogo(){
    return Container(
      child: Image(
        key: Key('logo'),
        image: AssetImage('assets/images/logo.png'),
      ),
      alignment: Alignment.center,
    );
  }

// Check if form is valid before perform login or signup
  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    setState(() {
      _isLoading = false;
    });
    return false;
  }

  // Perform login or signup
  void validateAndSubmit() async {
    final BaseAuth auth = Provider.of<BaseAuth>(context, listen: false);
    setState(() {
      _errorMessage.setMessage = null; 
      _isLoading = true;
    });
    if (validateAndSave()) {
      print("passed validate and save");
      String userId = "";
      try {
        if (_isLoginForm) {
          // use this future to test the loading icon
          print("calling sign in function");
          userId = await auth.signIn(_email, _passwordFormField.getPassword);
          print('Signed in: $userId');
        } else {
          print("calling sign up function");
          userId = await auth.signUp(_email, _passwordFormField.getPassword);
          //widget.auth.sendEmailVerification();
          //_showVerifyEmailSentDialog();
          print('Signed up user: $userId');
        }
        setState(() {
          _isLoading = false;
        });

        if (userId != null && userId.length > 0 && _isLoginForm) {
          // found user, collect their data information from the data base and initialize the users info
          // this can be done in the login call back
          await widget.loginCallback();
        }
        // successfully logged in and heading to user info entry page
        else if (_isLoginForm == false){
          Navigator.push(context,
            MaterialPageRoute(builder: (context) => UserInfoEntryPage(widget.loginCallback, widget.logoutCallback))
          );
        }
      } catch (e) {
        print("IN ERROR HANDLER");
        print('Error $e');
        setState(() {
          _isLoading = false;
          _errorMessage.setMessage = e.message;
        });
      }
    }
  }

  Widget showPasswordRequirements(){
    String requirements = 
      "Minimum password length:\n" +
      "  8 characters\n" +
      "Password must contain:\n" +
      "  At least one upper case character\n" +
      "  At least one lower case character\n" +
      "  At least one numeric digit between 0 and 9\n" +
      "  At least one special character (!@#\$&*~)\n" +
      "Password must not contain:\n"
      "  White space characters\n";
    if (!_isLoginForm){
      return Expanded(
        child: Container(
          child: FittedBox(
            child: WrappingText.wrappingText( 
              Text(
                requirements,
                key: Key("password requirements"),
              ),
            ),
          ),
          alignment: Alignment.center,
        ),
        flex: 3,
      );
    }
    return Container();
  }

  Widget showPasswordField(){
    return Container(
      child:Center(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, 5, 60, 5.0),
          child: _passwordFormField.buildPasswordField(),
        ),
      ),
    );
  }

  Widget showErrorMessage(){
    return Container(
      child:_errorMessage.buildErrorMessage(),
      alignment: Alignment.center,
      padding: EdgeInsets.all(5),
    );
  }

  Widget showForgotPassword(){
    if (_isLoginForm){
      return Container(
        key: Key('forgot password'),
        child: Center(
          child: new FlatButton(
            child: new Text(
                'Forgot Password',
                style: new TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300)
              ),
            onPressed: () {
              showPopup();
              //String email = await  _showEmailDialog();
            },

          )
        ),
        alignment: Alignment.center,
      );
    }
    return Container();
  }

  showPopup() async {
    final Auth auth = Provider.of<BaseAuth>(context, listen: false);
    String email = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return _showEmailDialog();
      }
    );


    auth.resetPassword(email);
  }

  Widget _showLogInForm() {
    if (_isLoading){
      return LoadingCircle.loadingCircle();
    }
    else{
      return new Form(
        key: _formKey,
        child: new ListView(
          children: <Widget>[
            Container(
              child: Column(
                children: <Widget>[
                  Expanded(child: showLogo(), flex: 3,), 
                  Expanded(child: showEmailField(), flex: 2,), 
                  Expanded(child: showPasswordField(), flex: 2,), 
                  showErrorMessage(),
                  showPasswordRequirements(),
                  Expanded(child: showLogInButton()), 
                  Expanded(child: showForgotPassword()),
                  Expanded(child: showSwitchButton()),
                ]
              ),
              height: ScreenSize.getSafeBlockHeight * 100,
              width: ScreenSize.getSafeBlockWidth * 100,
            )
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    //print("In login signup page build");
    ScreenSize.init(context);
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/matchupBackground.png'), 
          fit: BoxFit.cover
        )
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Stack(
          children: <Widget>[
            _showLogInForm(),
            ],
          ),
        )
      )
    );
  }
}