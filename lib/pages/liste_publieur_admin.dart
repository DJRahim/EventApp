import 'dart:convert';
import 'package:eventapp/classes/publieur.dart';
import 'package:uic/list_uic.dart';
import 'package:eventapp/tools/widgets.dart';
import 'package:flutter/material.dart';
import 'package:eventapp/tools/auth.dart' as auth;

// Ca est la home page pour les utilisateurs qui ne sont pas connecter
// Ca contient 2 boutons (1 pour connexion et 1 pour inscription)
// Il y a l'acces vers :
// 1- la page de recherche via le bouton situe en haut adroite (avec icon de recherche)
// 2- au menu des parametres via le bouton situe en haut agauche
// Ce menu contient la meme chose que la home page (pour l'instant)

class ListePublieurAdmin extends StatefulWidget {
  ListePublieurAdmin({Key key, this.title}) : super(key: key);

  final String title;

  @override
  ListePublieurAdminState createState() => ListePublieurAdminState();
}

class ListePublieurAdminState extends State<ListePublieurAdmin> {
  final GlobalKey _scaffoldKey = new GlobalKey();

  ListUicController<Publieur> uic;

  List<Publieur> listpublieur = List<Publieur>();

  initlist() async {
    var a = await auth.getRequest('affichage_public', {});

    var pubMaps = jsonDecode(a) as Map<String, dynamic>;
    var list = pubMaps.entries.map((e) => Publieur.fromJson(e.value)).toList();

    listpublieur = list;
  }

  Future<List<Publieur>> _getItems(int page) async {
    await Future.delayed(Duration(seconds: 1));
    List<Publieur> list = new List<Publieur>();
    int i = 0;
    while ((i + (page - 1) * 7) < listpublieur.length && i < 7) {
      list.add(listpublieur[(page - 1) * 7 + i]);
      i++;
    }

    return list;
  }

  @override
  void initState() {
    super.initState();
    initlist();
    uic = ListUicController<Publieur>(
      onGetItems: (int page) => _getItems(page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
          title: Text(
            "Liste des publieurs a valider",
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
                child: listPublieur(uic, context)),
            SizedBox(height: 7),
          ],
        ),
      ),
    );
  }
}
