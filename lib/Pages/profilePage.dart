import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Center(child: Text("Profile")),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: new Center (
          child: Column(
            children: <Widget>[
              Text(''),
              Text('Username', style: TextStyle(fontSize: 25)),
              Text(''),
              Image.asset('assets/images/default_profile.jpg', height: 300),
              Text(''),
              Text('Fox, Falco', style: TextStyle(fontSize: 25)),
          ],)
        )
    );
  }
}