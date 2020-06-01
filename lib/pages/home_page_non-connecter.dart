import 'dart:async';
import 'package:eventapp/classes/event.dart';
import 'package:eventapp/widgets.dart';
import 'package:flutter/material.dart';
import 'package:uic/list_uic.dart';
import '../database.dart';

// Cette page est pour afficher l'historique des evenements (en cas de non connexion internet)
// Donc ca contient juste une liste des evenements (si on clique sur, ca affiche
// une page contenant tout les infos de cet evenement)
// Remarque: Ca contient une liste generer manuellement pour tester seulement

class NoConnection extends StatefulWidget {
  NoConnection({Key key, this.title}) : super(key: key);

  final String title;

  @override
  NoConnectionState createState() => NoConnectionState();
}

class NoConnectionState extends State<NoConnection> {
  ListUicController<Event> uic;

  List<Event> listevent = List<Event>();

  Future<void> initlist() async {
    listevent = await DBProvider.db.getAllEvents();
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
      appBar: AppBar(
        title: Text("Historique des evenements"),
      ),
      body: listEvent(uic, context),
      backgroundColor: Colors.white,
    );
  }
}
