import 'dart:async';
import 'package:eventapp/classes/event.dart';
import 'package:eventapp/widgets.dart';
import 'package:flutter/material.dart';
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

  Event e;

  void action(GoogleMapController controller) {
    _controller.complete(controller);
  }

  @override
  Widget build(BuildContext context) {
    e = ModalRoute.of(context).settings.arguments;
    m.add(Marker(
        markerId: MarkerId("mark"),
        draggable: false,
        position: LatLng(e.pos.latitude, e.pos.longitude)));
    return Scaffold(
        appBar: AppBar(),
        body: Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              event(action, m, e, context),
            ],
          ),
        ));
  }
}
