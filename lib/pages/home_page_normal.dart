import 'dart:convert';
import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:eventapp/classes/event.dart';
import 'package:eventapp/pages/home_page.dart';
import 'package:eventapp/pages/liste_participation.dart';
import 'package:eventapp/tools/widgets.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uic/list_uic.dart';
import 'package:eventapp/tools/auth.dart' as auth;

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
  Color c1 = Colors.grey[300];
  Color c2 = Colors.white;

  final FirebaseMessaging _fcm = new FirebaseMessaging();
  SharedPreferences prefs;

  void firebaseCloudMessagingListeners() async {
    prefs = await SharedPreferences.getInstance();

    if (Platform.isIOS) iOSPermission();

    _fcm.getToken().then((token) {
      print(token);
      prefs.setString('registerId', token);
    });

    _fcm.configure(
      onMessage: (Map<String, dynamic> msg) async {
        print('on message $msg');
        var message = msg['notification'];
        setState(() {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: ListTile(
                    title: Text(message['title']),
                    subtitle: Text(message['body']),
                  ),
                  actions: <Widget>[
                    FlatButton(
                        child: Text('Visualiser'),
                        onPressed: () async {
                          var id1 = msg['data'];
                          var id = id1['event'];

                          var a = await auth.getRequest(
                              'profil/evenement?id_evenment=$id', {});
                          var b = jsonDecode(a);

                          var event = Event.fromJson(b);

                          Navigator.pushNamed(context, '/event',
                              arguments: [event, "Participer"]);
                          Navigator.pop(context);
                        }),
                    FlatButton(
                        child: Text('Annuler'),
                        onPressed: () {
                          setState(() {
                            Navigator.pop(context);
                          });
                        })
                  ],
                );
              });
        });
      },
      onResume: (Map<String, dynamic> msg) async {
        print('on resume $msg');

        setState(() async {
          var id1 = msg['data'];
          var id = id1['event'];

          var a = await auth.getRequest('profil/evenement?id_evenment=$id', {});
          var b = jsonDecode(a);

          print(b);

          var event = Event.fromJson(b);

          Navigator.pushNamed(context, '/event',
              arguments: [event, "Participer"]);
        });
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

  initlist(int b) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var a;

    switch (b) {
      case 1:
        var x = prefs.getString('token');

        a = await auth.getRequest('profil/ma_liste?token=$x', {});
        break;
      case 2:
        a = await auth.getRequest('autre', {});
        break;
    }

    var eventsMap = jsonDecode(a) as Map<String, dynamic>;
    var list = eventsMap.entries.map((e) => Event.fromJson(e.value)).toList();

    listevent = list;
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
    // Instancier les types et sous-types
    initTypeSousType();

    initlist(1);

    uic = ListUicController<Event>(
      onGetItems: (int page) => _getItems(page),
    );

    super.initState();

    firebaseCloudMessagingListeners();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: drawer(context, listWidget: [
        SizedBox(height: 30),
        ListTile(
          title: Text("Se deconnecter"),
          onTap: () {
            logout(context);
            Navigator.pop(context);
          },
        ),
        ListTile(
          title: Text("Liste de participation"),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => ListeParticipation()),
            );
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
        padding: const EdgeInsets.all(7.0),
        child: Column(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: 30,
              child: Row(
                children: <Widget>[
                  Container(
                    child: Expanded(
                        child: InkWell(
                      child: Container(
                        color: c1,
                        child: Center(
                          child: AutoSizeText(
                            "Evenement de l'application",
                            style: TextStyle(fontSize: 17),
                            maxLines: 2,
                          ),
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          c1 = Colors.grey[300];
                          c2 = Colors.white;
                          initlist(1);
                          uic = ListUicController<Event>(
                            onGetItems: (int page) => _getItems(page),
                          );
                        });
                      },
                    )),
                  ),
                  Container(
                    child: Expanded(
                        child: InkWell(
                      child: Container(
                        color: c2,
                        child: Center(
                          child: AutoSizeText(
                            "Autres",
                            style: TextStyle(fontSize: 17),
                          ),
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          c2 = Colors.grey[300];
                          c1 = Colors.white;
                          initlist(2);
                          uic = ListUicController<Event>(
                            onGetItems: (int page) => _getItems(page),
                          );
                        });
                      },
                    )),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 2,
            ),
            Container(
                height: MediaQuery.of(context).size.height * 0.86,
                child: listEvent(uic, context, "Participer")),
            SizedBox(height: 7),
          ],
        ),
      ),
    );
  }

  logout(BuildContext cont) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    showAlertDialog(
        cont, "Deconnexion", "Etes-vous sur de vouloir se deconnecter?", () {
      Navigator.pop(context);
    }, () {
      prefs.clear();
      prefs.setInt('type', -1);

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (BuildContext context) => MyHomePage()),
          ModalRoute.withName('/'));
    });
  }
}
