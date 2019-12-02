import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Center(child: Text("My Profile        ")),
        leading: Icon(Icons.edit)
      ),
      body: new ProfileDisplay()
    );
  }
}

class ProfileDisplay extends StatefulWidget {
  @override
  ProfileDisplayState createState() => new ProfileDisplayState();
}

class ProfileDisplayState extends State<ProfileDisplay> with SingleTickerProviderStateMixin {

  var profStyle = TextStyle(fontSize: 25);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: new Center (
          child: Column(
            children: <Widget>[
              Text(''),
              //Should get username from firebase
              Text('Username', style: profStyle),
              Text(''),
              //Should get profile pic from firebase
              Image.asset('assets/images/default_profile.jpg', height: 300),
              Text(''),
              //Should get mains from firebase
              Text('Ness, King K', style: profStyle),
          ],)
        )
    );
  }
}