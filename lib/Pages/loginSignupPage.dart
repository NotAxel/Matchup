import 'package:flutter/material.dart';
import 'package:matchup/Widgets/errorMessage.dart';
import 'package:matchup/Widgets/loadingCircle.dart';
import 'package:matchup/Widgets/passwordFormField.dart';
import 'package:matchup/Widgets/wrappingText.dart';
import 'package:matchup/bizlogic/authProvider.dart';
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
  PasswordFormField _passwordFormField = new PasswordFormField();
  ErrorMessage _errorMessage = new ErrorMessage();
  final ScrollController _listScrollController = new ScrollController();

  bool _isLoginForm;
  bool _isLoading;
  final _formKey = new GlobalKey<FormState>();

  @override
  void initState() {
    _errorMessage.setMessage = null;
    _isLoading = false;
    _isLoginForm = true;
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
    });
  } 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
      children: <Widget>[
        _showLogInForm(),
      ],
    ));
  }

  // https://stackoverflow.com/questions/52645944/flutter-expanded-vs-flexible
  Widget showEmailField(){
    Validator emailValidator = EmailValidator();
    return Flexible(
      child:Padding(
        padding: EdgeInsets.fromLTRB(0.0, 10, 0.0, 0.0),
        child: new TextFormField(
            key: Key('email'),
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
      fit: FlexFit.loose,
      flex: 1,
    );
  } 


  // https://stackoverflow.com/questions/50293503/how-to-set-the-width-of-a-raisedbutton-in-flutter
  Widget showLogInButton(){
    return Flexible(
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
      fit: FlexFit.loose,
      flex: 1
    );
  }
  
  Widget showSwitchButton(){
    return Flexible(
      child: new FlatButton(
      key: Key('switch between login/signup'),
      child: new Text(
        _isLoginForm ? 'Create an account' : 'Have an account? Sign in',
        style: new TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300)),
      onPressed: toggleFormMode),
      fit: FlexFit.loose,
      flex: 1
    );
  }
  Widget showLogo(){
    return Expanded(
      child: Image(
        key: Key('logo'),
        image: AssetImage('assets/images/logo.png'),
      ),
      flex: 2
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
    final BaseAuth auth = AuthProvider.of(context).auth;
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
            MaterialPageRoute(builder: (context) => UserInfoEntryPage(widget.logoutCallback, "LoginSignupPage"))
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
    return WrappingText.wrappingText(
      Text(
        requirements,
        key: Key("password requirements"),)
    );
  }

  Widget _showLogInForm() {
    if (_isLoading){
      return LoadingCircle.loadingCircle();
    }
    else{
     return Container(
        padding: EdgeInsets.all(16.0),
        child: new Form(
          key: _formKey,
          child: new Column(
            children: <Widget>[
              showLogo(),
              showEmailField(),
              _passwordFormField.buildPasswordField(),
              showLogInButton(),
              showSwitchButton(),
              showPasswordRequirements(),
              _errorMessage.buildErrorMessage(),
            ],
          ),
        )
      );
    }
  }
}