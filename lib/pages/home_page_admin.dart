import 'package:eventapp/pages/liste_events_admin.dart';
import 'package:eventapp/pages/liste_publieur_admin.dart';
import 'package:eventapp/tools/widgets.dart';
import 'package:flutter/material.dart';

// Ceci est la home page de l'admin

class MyHomePageAdmin extends StatefulWidget {
  MyHomePageAdmin({Key key, this.title}) : super(key: key);

  final String title;

  @override
  MyHomePageAdminState createState() => MyHomePageAdminState();
}

class MyHomePageAdminState extends State<MyHomePageAdmin> {
  final GlobalKey _scaffoldKey = new GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: drawer(
        context,
        listWidget: <Widget>[
          SizedBox(height: 30),
        ],
      ),
      appBar: AppBar(
          title: Text(
            "Administrateur de l'application",
            style: Theme.of(context).textTheme.headline1,
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  Navigator.pushNamed(context, '/search');
                })
          ],
          iconTheme: new IconThemeData(color: Colors.blueGrey[800])),
      body: Padding(
        padding: const EdgeInsets.all(7.0),
        child: Column(
          children: <Widget>[
            Container(
              child: Expanded(
                child: Card(
                  elevation: 3,
                  child: InkWell(
                    child: Center(
                      child: Text(
                        "Liste des evenements a valider",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 30,
                        ),
                      ),
                    ),
                    onTap: () {
                      liste(1);
                    },
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Container(
              child: Expanded(
                child: Card(
                  elevation: 3,
                  child: InkWell(
                    child: Center(
                      child: Text(
                        "Liste des publieurs a valider",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 30,
                        ),
                      ),
                    ),
                    onTap: () {
                      liste(2);
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  liste(int a) async {
    switch (a) {
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => ListeEventsAdmin()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => ListePublieurAdmin()),
        );
        break;
    }
  }
}
