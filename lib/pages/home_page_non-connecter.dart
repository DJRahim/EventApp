import 'dart:async';
import 'package:eventapp/classes/event.dart';
import 'package:eventapp/widgets.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:uic/list_uic.dart';

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
    super.initState();

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
  }

  Event e = new Event(
      "Nom de l'evenement",
      "Decription de l'evenement",
      DateTime.now(),
      DateTime.now().add(Duration(days: 5)),
      Position(latitude: 36.7538, longitude: 3.0588),
      "");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Liste event test"),
        elevation: 10,
        backgroundColor: Colors.white,
      ),
      body: listEvent(uic, context),
      backgroundColor: Colors.white,
    );
  }
}
