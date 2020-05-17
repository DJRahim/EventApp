import 'package:eventapp/widgets.dart';
import 'package:flutter/material.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: drawer(
        context,
        listWidget: <Widget>[
          ListTile(
            title: Text("Se connecter"),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text("S'inscrire"),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      appBar: AppBar(
        title: Text("Evenements culturels"),
        backgroundColor: Colors.white,
        elevation: 8,
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

  void _connect() {
    Navigator.pushNamed(context, '/connection');
  }

  void _signup() {
    Navigator.pushNamed(context, '/inscription');
  }
}
