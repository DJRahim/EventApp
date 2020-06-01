import 'dart:async';
import 'dart:io';
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
import 'package:eventapp/pages/register_page3_publieur.dart';
import 'package:eventapp/pages/search_page.dart';
import 'package:eventapp/tools/widgets.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  final FirebaseMessaging _fcm = new FirebaseMessaging();

  SharedPreferences prefs;

  var status;
  Widget home = Scaffold();

  ConnectivityResult connect = ConnectivityResult.wifi;

// Ca c'est juste une methode pour le bouton quitter
  void quit() {
    SystemChannels.platform.invokeMethod<void>('SystemNavigator.pop');
  }

// Ca c'est une methode pour aller a la page NoConnection (en cas ou il n'y a pas de connection) qui contient l'historique des evenements
  void history() {
    nav.currentState.push(
        MaterialPageRoute(builder: (BuildContext context) => NoConnection()));
  }

  void firebaseCloudMessagingListeners() async {
    if (Platform.isIOS) iOSPermission();

    _fcm.getToken().then((token) {
      print(token);
      prefs.setString('registerId', token);
    });

    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('on message $message');
      },
      onResume: (Map<String, dynamic> message) async {
        print('on resume $message');
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('on launch $message');
      },
    );
  }

  void iOSPermission() {
    _fcm.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true));
    _fcm.onIosSettingsRegistered.listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
  }

  Future<void> initStatus() async {
    prefs = await SharedPreferences.getInstance();

    setState(() {
      prefs.setInt('type', 1);

      status = prefs.getInt('type');

      switch (status) {
        case 2:
          home = new MyHomePageNormal();
          break;
        case 1:
          home = new MyHomePagePublieur();
          break;
        case 0:
          home = new MyHomePageAdmin();
          break;
        default:
          home = new MyHomePage();
      }
    });
  }

  @override
  void initState() {
    // on utilise le status pour choisir la home page adequat

    initStatus();

    // Ca c'est pour gerer les notifications (c'est en commentaire pour tester d'autres fonctionnalites)
    firebaseCloudMessagingListeners();

    // Ca c'est pour gerer la connectivite (s'il y a l'internet ou non)
    // S'il y a de l'internet ca passe au home page
    // Sinon une page s'affiche qui dise 'Pas de connexion' avec 2 possibilites
    // 1- Quitter
    // 2- Voir l'historique des evenements (ils sont stockes dans la base de donnees de l'app)

    connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult connectivityResult) {
      if (connectivityResult == ConnectivityResult.none) {
        connect = ConnectivityResult.none;
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
        if (connect == ConnectivityResult.none) {
          nav.currentState
              .push(MaterialPageRoute(builder: (BuildContext context) => home));
        }
      }
    });

    super.initState();
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
      home: home,
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
        '/inscription3': (context) => RegisterPage3(),
        '/search': (context) => SearchPage(),
        '/event': (context) => EventWidget(),
        '/Ajouter-event': (context) => AjouterEvent()
      },
      debugShowCheckedModeBanner: false,
      title: 'Event App',
      // Definir un theme globale pour l'application
      theme: ThemeData(
        primaryColor: Colors.lightBlue[800],
        accentColor: Colors.cyan[600],

        // Define the default font family.
        fontFamily: 'Georgia',
        appBarTheme: AppBarTheme(elevation: 8, color: Colors.lightBlue[800]),
      ),
    );
  }
}
