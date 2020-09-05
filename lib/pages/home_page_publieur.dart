import 'dart:convert';
import 'package:eventapp/classes/event.dart';
import 'package:eventapp/pages/home_page.dart';
import 'package:eventapp/tools/widgets.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uic/list_uic.dart';
import 'package:eventapp/tools/auth.dart' as auth;

// Ceci est la home page du publieur
// Ca contient la liste de ces evenements (pour l'instant juste une liste de test)
// et un bouton pour l'ajout d'un evenement
// Il y a l'acces vers :
// 1- une forme pour l'ajout des evenements
// 2- la page de recherche via le bouton situe en haut adroite (avec icon de recherche)
// 3- au menu des parametres via le bouton situe en haut agauche
// Ce menu pour l'instant contient :
// 1- un bouton pour se deconnecter
// ...

class MyHomePagePublieur extends StatefulWidget {
  MyHomePagePublieur({Key key, this.title}) : super(key: key);

  final String title;

  @override
  MyHomePagePublieurState createState() => MyHomePagePublieurState();
}

class MyHomePagePublieurState extends State<MyHomePagePublieur> {
  ListUicController<Event> uic;

  List<Event> listevent = List<Event>();

  initlist() async {
    // API

    var a = await auth.getRequest('affichage_public', {});

    var eventsJson = jsonDecode(a) as List;
    List<Event> events =
        eventsJson.map((tagJson) => Event.fromJson(tagJson)).toList();

    print(events);

    listevent = events;
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
    initlist();
    uic = ListUicController<Event>(
      onGetItems: (int page) => _getItems(page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: drawer(context, listWidget: [
        ListTile(
          title: Text("Se deconnecter"),
          onTap: () {
            logout(context);
            Navigator.pop(context);
          },
        ),
      ]),
      appBar: AppBar(
        title: Text("Page Publieur"),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                Navigator.pushNamed(context, '/search');
              })
        ],
        iconTheme: new IconThemeData(color: Colors.blueGrey[800]),
      ),
      body: Padding(
        padding: const EdgeInsets.all(7.0),
        child: Column(
          children: <Widget>[
            Container(
                height: MediaQuery.of(context).size.height * 0.84,
                child: listEvent(uic, context, "Modifier")),
            SizedBox(height: 7),
            button(context, "Ajouter evenement", action)
          ],
        ),
      ),
    );
  }

  Future<void> logout(BuildContext cont) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    showAlertDialog(
        cont, "Deconnexion", "Etes-vous sur de vouloir se deconnecter?", () {},
        () {
      prefs.clear();
      prefs.setInt('type', -1);

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (BuildContext context) => MyHomePage()),
          ModalRoute.withName('/'));
    });
  }

  void action() {
    Navigator.pushNamed(context, '/Ajouter-event');
  }
}
