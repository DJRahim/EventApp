import 'package:eventapp/tools/widgets.dart';
import 'package:flutter/material.dart';

// Ceci est la home page de l'admin (pas encore developper)

class MyHomePageAdmin extends StatefulWidget {
  MyHomePageAdmin({Key key, this.title}) : super(key: key);

  final String title;

  @override
  MyHomePageAdminState createState() => MyHomePageAdminState();
}

class MyHomePageAdminState extends State<MyHomePageAdmin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Evenements culturels"),
        leading: IconButton(icon: Icon(Icons.menu), onPressed: _param),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                Navigator.pushNamed(context, '/search');
              })
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            button(context, "connectez-vous", _connect),
            SizedBox(
              height: 25.0,
            ),
            button(context, "inscrivez-vous", _signup)
          ],
        ),
      ),
    );
  }

  void _param() {
    Navigator.pushNamed(context, '/settings');
  }

  void _connect() {
    Navigator.pushNamed(context, '/connection');
  }

  void _signup() {
    Navigator.pushNamed(context, '/inscription');
  }
}
