import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:eventapp/pages/ajouter_event.dart';
import 'package:eventapp/pages/connect_page.dart';
import 'package:eventapp/pages/event_widget.dart';
import 'package:eventapp/pages/home_page.dart';
import 'package:eventapp/pages/home_page_admin.dart';
import 'package:eventapp/pages/home_page_non-connecter.dart';
import 'package:eventapp/pages/home_page_normal.dart';
import 'package:eventapp/pages/home_page_publieur.dart';
import 'package:eventapp/pages/register_page.dart';
import 'package:eventapp/pages/register_page2_normal.dart';
import 'package:eventapp/pages/search_page.dart';
import 'package:eventapp/widgets.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Ceci est la page root de l'application (chaque fois l'application s,ouvre, ca passe par cette page)
// Pour l'instant ca affiche 4 boutons (pour tester):
// 1- pour passer a la page de non connection
// 2- pour passer a la page de pas de compte
// 1- pour passer a la page d'utilisateur normale
// 1- pour passer a la page du publieur d'evenements
// 1- pour passer a la page d'admin de l'app

void main() {
  runApp(RootPage());
}

class RootPage extends StatefulWidget {
  RootPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => RootPageState();
}

class RootPageState extends State<RootPage> {
  final GlobalKey<NavigatorState> nav = GlobalKey<NavigatorState>();

  StreamSubscription connectivitySubscription;

  // final FirebaseMessaging _fcm = new FirebaseMessaging();

  // StreamSubscription iosSubscription;

  var status;
  Widget home;

// Ca c'est juste une methode pour le bouton quitter
  void quit() {
    SystemChannels.platform.invokeMethod<void>('SystemNavigator.pop');
  }

// Ca c'est une methode pour aller a la page NoConnection (en cas ou il n'y a pas de connection) qui contient l'historique des evenements
  void history() {
    nav.currentState.push(
        MaterialPageRoute(builder: (BuildContext context) => NoConnection()));
  }

  @override
  void initState() {
    super.initState();

    // Ca c'est pour gerer les notifications (c'est en commentaire pour tester d'autres fonctionnalites)

    // if (Platform.isIOS) {
    //   iosSubscription = _fcm.onIosSettingsRegistered.listen((data) {
    //     // save the token  OR subscribe to a topic here
    //   });

    //   _fcm.requestNotificationPermissions(IosNotificationSettings());
    // }

    // _fcm.configure(
    //   onMessage: (Map<String, dynamic> message) async {
    //     print("onMessage: $message");
    //     showDialog(
    //       context: context,
    //       builder: (context) => AlertDialog(
    //         content: ListTile(
    //           title: Text(message['notification']['title']),
    //           subtitle: Text(message['notification']['bSERbess1991ody']),
    //         ),
    //         actions: <Widget>[
    //           FlatButton(
    //             child: Text('Ok'),
    //             onPressed: () => Navigator.of(context).pop(),
    //           ),
    //         ],
    //       ),
    //     );
    //   },
    //   onLaunch: (Map<String, dynamic> message) async {
    //     print("onLaunch: $message");
    //     // TODO optional
    //   },
    //   onResume: (Map<String, dynamic> message) async {
    //     print("onResume: $message");
    //     // TODO optional
    //   },
    // );
    // _fcm.getToken().then((String token) {
    //   assert(token != null);
    //   print(token);
    // });

    // Ca c'est pour gerer la connectivite (s'il y a l'internet ou non)
    // S'il y a de l'internet ca passe au home page
    // Sinon une page s'affiche qui dise 'Pas de connexion' avec 2 possibilites
    // 1- Quitter
    // 2- Voir l'historique des evenements (ils sont stockes dans la base de donnees de l'app)

    connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult connectivityResult) {
      if (connectivityResult == ConnectivityResult.none) {
        nav.currentState.push(MaterialPageRoute(
            builder: (BuildContext context) => WillPopScope(
                  onWillPop: () async => false,
                  child: Scaffold(
                    body: Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(height: 160),
                          Icon(
                            Icons.warning,
                            size: 80,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 20),
                          Text(
                            "Pas de connexion !",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w500),
                          ),
                          SizedBox(height: 65),
                          button(context, "Quitter", quit),
                          SizedBox(height: 40),
                          Container(
                            child: InkWell(
                              child: Text(
                                "Voir l'historique des evenements",
                                style: TextStyle(
                                  color: Colors.blue[600],
                                  fontSize: 16,
                                ),
                              ),
                              onTap: history,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )));
      } else {
        // apres la verification de la connectivity, on verifie quel home page a afficher avec la fonction
        // handshake()

        //status = handshake();

        nav.currentState.push(
            MaterialPageRoute(builder: (BuildContext context) => RootPage()));
      }
      // on utilise le status pour choisir le home page adequat

      switch (status) {
        case 'NonCompte':
          home = new MyHomePage();
          break;
        case 'Normal':
          home = new MyHomePageNormal();
          break;
        case 'Publieur':
          home = new MyHomePagePublieur();
          break;
        case 'Admin':
          home = new MyHomePageAdmin();
          break;
        default:
      }
    });
  }

  @override
  void dispose() {
    super.dispose();

    connectivitySubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: nav,
      home: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              onPressed: () {
                nav.currentState.push(MaterialPageRoute(
                    builder: (BuildContext context) => NoConnection()));
              },
              child: Text("Page pas de connexion"),
            ),
            SizedBox(height: 20),
            RaisedButton(
              onPressed: () {
                nav.currentState.push(MaterialPageRoute(
                    builder: (BuildContext context) => MyHomePage()));
              },
              child: Text("Page pas de compte"),
            ),
            SizedBox(height: 20),
            RaisedButton(
              onPressed: () {
                nav.currentState.push(MaterialPageRoute(
                    builder: (BuildContext context) => MyHomePageNormal()));
              },
              child: Text("Pge utilisateur normal"),
            ),
            SizedBox(height: 20),
            RaisedButton(
              onPressed: () {
                nav.currentState.push(MaterialPageRoute(
                    builder: (BuildContext context) => MyHomePagePublieur()));
              },
              child: Text("Page publieur"),
            ),
            SizedBox(height: 20),
            RaisedButton(
              onPressed: () {
                nav.currentState.push(MaterialPageRoute(
                    builder: (BuildContext context) => MyHomePageAdmin()));
              },
              child: Text("Page admin"),
            )
          ],
        ),
      ),
      routes: {
        // La liste de tout les pages de l'application
        '/Non-connecte': (context) => NoConnection(),
        '/Non-compte': (context) => MyHomePage(),
        '/normal': (context) => MyHomePageNormal(),
        '/publieur': (context) => MyHomePagePublieur(),
        '/admin': (context) => MyHomePageAdmin(),
        '/connection': (context) => ConnectPage(),
        '/inscription': (context) => RegisterPage(),
        '/inscription2': (context) => RegisterPage2(),
        '/search': (context) => SearchPage(),
        '/event': (context) => EventWidget(),
        '/Ajouter-event': (context) => AjouterEvent()
      },
      debugShowCheckedModeBanner: false,
      title: 'Event App',
      // Definir un theme globale pour l'application
      theme: ThemeData(
        accentColor: Colors.white,
        backgroundColor: Colors.white,
        primaryColor: Colors.white,
      ),
    );
  }
}
