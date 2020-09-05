import 'dart:convert';
import 'package:eventapp/tools/database.dart';
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

class ListeEventsAdmin extends StatefulWidget {
  ListeEventsAdmin({Key key, this.title}) : super(key: key);

  final String title;

  @override
  ListeEventsAdminState createState() => ListeEventsAdminState();
}

class ListeEventsAdminState extends State<ListeEventsAdmin> {
  final GlobalKey _scaffoldKey = new GlobalKey();

  ListUicController<Event> uic;

  List<Event> listevent = List<Event>();

  initlist() async {
    var a = await auth.getRequest('profil/admin/lister_evenement', {});

    var eventsMap = jsonDecode(a) as Map<String, dynamic>;
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
    initlist();
    uic = ListUicController<Event>(
      onGetItems: (int page) => _getItems(page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
          title: Text(
            "Liste des evenements a valider",
            style: Theme.of(context).textTheme.headline1,
            textAlign: TextAlign.center,
          ),
          iconTheme: new IconThemeData(color: Colors.blueGrey[800])),
      body: Padding(
        padding: const EdgeInsets.all(7.0),
        child: Column(
          children: <Widget>[
            Container(
                height: MediaQuery.of(context).size.height * 0.88,
                child: listEvent(uic, context, "Valider")),
            SizedBox(height: 7),
          ],
        ),
      ),
    );
  }
}
