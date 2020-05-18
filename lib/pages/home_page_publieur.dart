import 'package:eventapp/classes/event.dart';
import 'package:eventapp/pages/home_page.dart';
import 'package:eventapp/widgets.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:uic/list_uic.dart';

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

  Event e = new Event(
      "Nom de l'evenement",
      "Decription de l'evenement",
      DateTime.now(),
      DateTime.now().add(Duration(days: 5)),
      Position(latitude: 36.7538, longitude: 3.0588),
      "");

  void initlist() {
    listevent.add(e);
    listevent.add(e);
    listevent.add(e);
    listevent.add(e);
    listevent.add(e);
    listevent.add(e);
  }

  Future<List<Event>> _getItems(int page) async {
    await Future.delayed(Duration(seconds: 3));
    List<Event> list = new List<Event>();
    int i = 1;
    while (listevent.length > ((page - 1) * 11) && i <= 10) {
      list.add(listevent[(page - 1) * 10 + i]);
      i++;
    }
    return list;
  }

  @override
  void initState() {
    uic = ListUicController<Event>(
      onGetItems: (int page) => _getItems(page),
    );
    initlist();
    initlist();
    initlist();
    initlist();
    initlist();
    initlist();
    initlist();
    initlist();
    initlist();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: drawer(context, listWidget: [
        ListTile(
          title: Text("Se deconnecter"),
          onTap: () {
            logout();
            Navigator.pop(context);
          },
        ),
      ]),
      appBar: AppBar(
        title: Text("Evenements culturels"),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                Navigator.pushNamed(context, '/search');
              })
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(7.0),
        child: Column(
          children: <Widget>[
            Container(
                height: MediaQuery.of(context).size.height * 0.84,
                child: listEvent(uic, context)),
            SizedBox(height: 7),
            button(context, "Ajouter evenement", action)
          ],
        ),
      ),
    );
  }

  void logout() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (BuildContext context) => MyHomePage()),
        ModalRoute.withName('/'));

    // le traitement de la deconnexion pas encore programme
  }

  void action() {
    Navigator.pushNamed(context, '/Ajouter-event');
  }
}
