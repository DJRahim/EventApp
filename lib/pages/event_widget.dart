import 'dart:async';
import 'dart:convert';
import 'package:eventapp/classes/event.dart';
import 'package:eventapp/pages/connect_page.dart';
import 'package:eventapp/tools/widgets.dart';
import 'package:flutter/material.dart';
import 'package:eventapp/tools/auth.dart' as auth;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Cette page est pour l'affichage d'un evenement avec tous ses infos (nom, dates, lieu, description ...)

class EventWidget extends StatefulWidget {
  EventWidget({Key key, this.title}) : super(key: key);

  final String title;

  @override
  EventWidgetState createState() => EventWidgetState();
}

class EventWidgetState extends State<EventWidget> {
  Completer<GoogleMapController> _controller = Completer();
  SharedPreferences prefs;

  List<Marker> m = [];
  var a;
  Event e;

  void action(GoogleMapController controller) {
    _controller.complete(controller);
  }

  @override
  Widget build(BuildContext context) {
    a = ModalRoute.of(context).settings.arguments;
    e = a[0];
    m.add(Marker(
        markerId: MarkerId("mark"),
        draggable: false,
        position: LatLng(e.pos.latitude, e.pos.longitude)));
    return Scaffold(
        body: Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 20,
          ),
          Container(
              height: MediaQuery.of(context).size.height * 0.90,
              child: event(action, m, e, context)),
          SizedBox(height: 7),
          button(context, a[1], () {
            participe(e);
          })
        ],
      ),
    ));
  }

  participe(Event e) async {
    prefs = await SharedPreferences.getInstance();
    var b = prefs.getInt("type");
    switch (b) {
      case 1:
        var a = await auth.getRequest('auth/', {});

        var c = jsonDecode(a);
        break;
      case 2:
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Confirmer votre participation"),
                actions: <Widget>[
                  FlatButton(
                      child: Text('Confirmer'),
                      onPressed: () async {
                        var a = await auth.getRequest(
                            'profil/je_participe?token=${prefs.getString('token')}&id_evenement=${e.idEvent}',
                            {});

                        var c = jsonDecode(a);

                        Scaffold.of(context).showSnackBar(snackBar(
                            'Inscription reussi! \nVeuillez valider votre email.',
                            Colors.green));

                        await Future.delayed(const Duration(seconds: 4), () {});
                      }),
                  FlatButton(child: Text('Annuler'), onPressed: () {})
                ],
              );
            });

        break;
      default:
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (BuildContext context) => ConnectPage()),
            ModalRoute.withName('/'));
    }
  }
}
