import 'package:eventapp/classes/event.dart';
import 'package:eventapp/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:uic/list_uic.dart';
import 'package:intl/intl.dart';

class SearchPage extends StatefulWidget {
  SearchPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  SearchPageState createState() => SearchPageState();
}

class SearchPageState extends State<SearchPage> {
  ListUicController<Event> uic;
  final ctrl = TextEditingController();

  Event e = new Event(
      "Serbess",
      "serbesel 2oumourat",
      DateTime.now(),
      DateTime.now().add(Duration(days: 5)),
      Position(latitude: 36.7538, longitude: 3.0588),
      "");

  List<Event> listevent = List<Event>();

  void initlist() {
    listevent.add(e);
    listevent.add(e);
    listevent.add(e);
    listevent.add(e);
    listevent.add(e);
    listevent.add(e);
    listevent.add(e);
    listevent.add(e);
    listevent.add(e);
  }

  Future<List<Event>> _getItems(int page) async {
    await Future.delayed(Duration(seconds: 3));
    List<Event> list = new List<Event>();
    int i = 1;
    while (listevent.length > ((page - 1) * 11) && i <= 10) {
      list.add(listevent[(page - 1) * 10 + i]);
      i++;
    }
    return list;
  }

  @override
  void initState() {
    super.initState();
  }

  void action() {
    setState(() {
      uic = ListUicController<Event>(
        onGetItems: (int page) => _getItems(page),
      );
    });
  }

  List listtype = ['sport', 'music', 'cinema', 'sortie'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            // title: TextField(
            //   controller: ctrl,
            //   decoration: InputDecoration(
            //     border: InputBorder.none,
            //     hintText: "search event",
            //   ),
            //   autofocus: false,
            // ),
            ),
        body: Padding(
          padding: EdgeInsets.all(6),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[]),
        ));
  }
}
