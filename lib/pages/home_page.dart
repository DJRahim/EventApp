import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:uic/list_uic.dart';
import 'package:eventapp/classes/event.dart';
import 'package:eventapp/tools/widgets.dart';
import 'package:flutter/material.dart';
import 'package:eventapp/tools/auth.dart' as auth;

// Ca est la home page pour les utilisateurs qui ne sont pas connecter
// Ca contient 2 boutons (1 pour connexion et 1 pour inscription)
// Il y a l'acces vers :
// 1- la page de recherche via le bouton situe en haut adroite (avec icon de recherche)
// 2- au menu des parametres via le bouton situe en haut agauche
// Ce menu contient la meme chose que la home page (pour l'instant)

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  final GlobalKey _scaffoldKey = new GlobalKey();

  ListUicController<Event> uic;

  Color c1 = Colors.grey[300];
  Color c2 = Colors.white;

  List<Event> listevent = List<Event>();

  initlist(int a) async {
    var x;

    switch (a) {
      case 1:
        x = await auth.getRequest('affichage_public', {});
        break;
      case 2:
        x = await auth.getRequest('autre', {});
        break;
    }

    var eventsMap = jsonDecode(x) as Map<String, dynamic>;
    var list = eventsMap.entries.map((e) => Event.fromJson(e.value)).toList();

    listevent = list;
  }

  Future<List<Event>> _getItems(int page) async {
    await Future.delayed(Duration(seconds: 1));
    List<Event> list = new List<Event>();
    int i = 0;
    while ((i + (page - 1) * 7) < listevent.length && i < 7) {
      list.add(listevent[(page - 1) * 7 + i]);
      i++;
    }

    return list;
  }

  @override
  void initState() {
    super.initState();
    initlist(1);
    uic = ListUicController<Event>(
      onGetItems: (int page) => _getItems(page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: drawer(
        context,
        listWidget: <Widget>[
          SizedBox(height: 30),
          ListTile(
            title: Text(
              "Se connecter",
              style: TextStyle(fontSize: 17),
            ),
            onTap: () {
              Navigator.pop(context);
              _connect();
            },
          ),
          SizedBox(height: 5),
          ListTile(
            title: Text(
              "S'inscrire",
              style: TextStyle(fontSize: 17),
            ),
            onTap: () {
              Navigator.pop(context);
              _signup();
            },
          ),
        ],
      ),
      appBar: AppBar(
          title: Text(
            "",
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
              width: MediaQuery.of(context).size.width,
              height: 50,
              child: Row(
                children: <Widget>[
                  Container(
                    child: Expanded(
                        child: InkWell(
                      child: Container(
                        color: c1,
                        child: Center(
                          child: AutoSizeText(
                            "Evenement de l'application",
                            style: TextStyle(fontSize: 13),
                            maxLines: 2,
                          ),
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          c1 = Colors.grey[300];
                          c2 = Colors.white;
                          initlist(1);
                          uic = ListUicController<Event>(
                            onGetItems: (int page) => _getItems(page),
                          );
                        });
                      },
                    )),
                  ),
                  Container(
                    child: Expanded(
                        child: InkWell(
                      child: Container(
                        color: c2,
                        child: Center(
                          child: AutoSizeText(
                            "Autres",
                            style: TextStyle(fontSize: 13),
                          ),
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          c2 = Colors.grey[300];
                          c1 = Colors.white;
                          initlist(2);
                          uic = ListUicController<Event>(
                            onGetItems: (int page) => _getItems(page),
                          );
                        });
                      },
                    )),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 2,
            ),
            Container(
                height: MediaQuery.of(context).size.height * 0.75,
                child: listEvent(uic, context, "Participer")),
            SizedBox(height: 7),
          ],
        ),
      ),
    );
  }

  Future<void> _connect() async {
    Navigator.pushNamed(context, '/connection');
  }

  void _signup() {
    Navigator.pushNamed(context, '/inscription');
  }
}
