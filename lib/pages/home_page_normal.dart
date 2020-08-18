import 'package:eventapp/classes/event.dart';
import 'package:eventapp/pages/home_page.dart';
import 'package:eventapp/tools/widgets.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uic/list_uic.dart';
import '../tools/database.dart';

// Cette page est la home page de l'utilisateur normale
// Ca contient une liste des evenements recommandes (pour l'instant seulement une liste de test)
// il y a l'acces vers :
// 1- la page de recherche via le bouton situe en haut adroite (avec icon de recherche)
// 2- au menu des parametres via le bouton situe en haut agauche
// Ce menu pour l'instant contient :
// 1- un bouton pour se deconnecter
// ...

class MyHomePageNormal extends StatefulWidget {
  MyHomePageNormal({Key key, this.title}) : super(key: key);

  final String title;

  @override
  MyHomePageNormalState createState() => MyHomePageNormalState();
}

class MyHomePageNormalState extends State<MyHomePageNormal> {
  ListUicController<Event> uic;

  List<Event> listevent = List<Event>();

  Future<void> initlist() async {
    listevent = await DBProvider.db.getAllEvents();
  }

  Future<List<Event>> _getItems(int page) async {
    await Future.delayed(Duration(seconds: 1));
    List<Event> list = new List<Event>();
    int i = 1;
    while ((i + (page - 1) * 7) <= listevent.length && i <= 7) {
      list.add(listevent[(page - 1) * 7 + i - 1]);
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
    super.initState();
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
        title: Text("Page Utilisateur"),
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
        padding: const EdgeInsets.all(8.0),
        child: listEvent(uic, context),
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
}
