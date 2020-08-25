import 'dart:async';
import 'package:eventapp/classes/event.dart';
import 'package:eventapp/tools/widgets.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// Cette page est pour l'affichage d'un evenement avec tous ses infos (nom, dates, lieu, description ...)

class EventWidget extends StatefulWidget {
  EventWidget({Key key, this.title}) : super(key: key);

  final String title;

  @override
  EventWidgetState createState() => EventWidgetState();
}

class EventWidgetState extends State<EventWidget> {
  Completer<GoogleMapController> _controller = Completer();

  List<Marker> m = [];

  Event e = new Event(
      "Evenement",
      "Description de l'evenement de l'evenement de l'evenement de l'evenement de l'evenement de l'evenement de l'evenement de l'evenement de l'evenement de l'evenement",
      DateTime.now().toString(),
      DateTime.now().toString(),
      Position(latitude: 3.4950495, longitude: 34.43434),
      "500",
      "Gratuit",
      "sport",
      "Footbal",
      ["034830"],
      ["Homme"],
      ["domaine"],
      "djeddouabderrahim@gmail.com",
      "03873486",
      "serbess.dz");

  void action(GoogleMapController controller) {
    _controller.complete(controller);
  }

  @override
  Widget build(BuildContext context) {
    // e = ModalRoute.of(context).settings.arguments;
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
            height: 10,
          ),
          Container(
              height: MediaQuery.of(context).size.height * 0.91,
              child: event(action, m, e, context)),
          SizedBox(height: 7),
          button(context, "Participer", participe)
        ],
      ),
    ));
  }

  void participe() {}
}
