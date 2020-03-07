import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';


import 'package:matchup/Pages/filterPopupPage.dart';
import 'package:matchup/bizlogic/User.dart';
import 'package:matchup/Pages/filterPopupForm.dart' as fpf;
import 'package:matchup/bizlogic/constants.dart' as con;


class MatchPage extends StatefulWidget {
  @override
  MatchPageState createState() => MatchPageState();
}

class MatchPageState extends State<MatchPage>{

  String _mainFilter;

  @override
  Widget build(BuildContext context) {
    final User _user = Provider.of<User>(context);
    return new Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        title: new Center(child: Text("MatchList")),
        leading: IconButton(
          icon: Icon(Icons.refresh),
          onPressed: () {
            // TODO add in a refresh page function
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () {
              showPopup(context, widget, 'Filters');
            },
          ),
        ],
      ),
      body: new StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('Users').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError)
            return new Text('Error: ${snapshot.error}');
          switch (snapshot.connectionState) {
            case ConnectionState.waiting: return new Text('Loading...');
          default:
          snapshot.data.documents.removeWhere((item) => item.documentID == _user.getUserId);
            return new ListView.separated(
              itemCount: snapshot.data.documents.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: new Text(
                    snapshot.data.documents.elementAt(index)['Username'],
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold),
                    ),
                  subtitle: new Image(
                    image: AssetImage(con.Constants.minSpritesMap[snapshot.data.documents.elementAt(index)['Main']]),
                    height: 25.0,
                    width: 25.0,
                    alignment: Alignment.centerLeft,
                  ),
                  trailing: new Text(
                    snapshot.data.documents.elementAt(index)['Region'],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    )
                  ),
                    onTap: (){
                      Navigator.pushNamed(context, "/challenge", 
                      arguments: <Object>[snapshot.data.documents.elementAt(index)]);
                    },
                  );
                },
              separatorBuilder: (BuildContext context, int index) =>  Divider(
                color: Colors.blueGrey,
                indent: 15,
                endIndent: 15,
                thickness: 1.5,
              ),
          );
        }
      })
    );
  }

  showPopup(
    BuildContext context,
    Widget widget,
    String title,
  ) {
    Navigator.push(
      context,
      FilterPopupPage(
        top: 200,
        left: 20,
        bottom: 200,
        right: 20,
        child: Scaffold(
          appBar: AppBar(
            title: Text(title),
            leading: new Builder(builder: (context) {
              return IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  try {
                    Navigator.pop(context);
                  } catch(e) {}
                },
              );
            }),
            brightness: Brightness.light,
          ),
          resizeToAvoidBottomPadding: false,
          body: fpf.FilterPopupForm(),
        ),
      )
    );
  }


}

