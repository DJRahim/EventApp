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
import 'package:eventapp/pages/register_page2.dart';
import 'package:eventapp/pages/search_page.dart';
import 'package:eventapp/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// import 'auth.dart' as auth;

void main() {
  // var h = auth.handShake();

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

  var status;
  Widget home = new AjouterEvent();

  void quit() {
    SystemChannels.platform.invokeMethod<void>('SystemNavigator.pop');
  }

  void history() {
    nav.currentState.push(
        MaterialPageRoute(builder: (BuildContext context) => NoConnection()));
  }

  void retry() {
    connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult connectivityResult) {
      if (connectivityResult != ConnectivityResult.none) {
        nav.currentState.push(
            MaterialPageRoute(builder: (BuildContext context) => RootPage()));
      }
    });
  }

  @override
  void initState() {
    super.initState();

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
        //status = handshake();

        nav.currentState.push(
            MaterialPageRoute(builder: (BuildContext context) => RootPage()));
      }
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
      home: home,
      routes: {
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
