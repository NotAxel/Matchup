import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:matchup/Pages/filterPopupPage.dart';
import 'package:matchup/Pages/filterPopupContent.dart';
import 'package:matchup/bizlogic/User.dart';
import 'package:matchup/bizlogic/userProvider.dart';
import './challengePage.dart' as cp;
import 'package:matchup/bizlogic/mainToImageLinker.dart' as il;
import 'package:matchup/Pages/filterPopupForm.dart' as fpf;
import 'package:matchup/bizlogic/constants.dart' as con;


class MatchPage extends StatefulWidget {
  @override
  MatchPageState createState() => MatchPageState();
}

class MatchPageState extends State<MatchPage>{

  String _mainFilter;

  @override
  Widget build (BuildContext context) {
    final User _user = UserProvider.of(context).user;
    return new Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        title: new Center(child: Text("MatchList")),
        leading: IconButton(
          icon: Icon(Icons.refresh),
          onPressed: () {
          
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => cp.ChallengePage(
                        user: _user, 
                        peer: snapshot.data.documents.elementAt(index),
                        )
                      )
                    );
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
    {BuildContext popupContext}
  ) {
    Navigator.push(
      context,
      FilterPopupPage(
        top: 100,
        left: 20,
        bottom: 400,
        right: 20,
        child: FilterPopupContent(
          content: Scaffold(
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
      )
    );
  }


}

