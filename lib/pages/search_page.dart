import 'package:eventapp/classes/event.dart';
import 'package:eventapp/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:uic/list_uic.dart';
import 'package:intl/intl.dart';

// Ceci est la page de recherche
// Elle permet d'effectuer des recherche avec filtrage
// pour l'instant rahi khalota ghir chouf hadja wa7doukhra

class SearchPage extends StatefulWidget {
  SearchPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  SearchPageState createState() => SearchPageState();
}

class SearchPageState extends State<SearchPage> {
  ListUicController<Event> uic;
  final ctrl = TextEditingController();

  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  bool _filterstate = true;
  bool _liststate = false;

  List listtype = ['sport', 'music', 'cinema', 'sortie'];

  Event e = new Event(
      "Nom de l'evenement",
      "Decription de l'evenement",
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
  }

  Future<List<Event>> _getItems(int page) async {
    await Future.delayed(Duration(seconds: 3));
    List<Event> list = new List<Event>();
    int i = 1;
    while (listevent.length > ((page - 1) * 10) && i <= 10) {
      list.add(listevent[(page - 1) * 10 + i]);
      i++;
    }
    return list;
  }

  void action() {
    uic = ListUicController<Event>(
      onGetItems: (int page) => _getItems(page),
    );
  }

  @override
  void initState() {
    initlist();
    initlist();
    initlist();
    initlist();
    initlist();
    initlist();
    initlist();
    initlist();
    initlist();
    super.initState();
  }

  @override
  void dispose() {
    _formKey.currentState.dispose();
    ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: ctrl,
          autofocus: false,
          decoration: theme("Rechercher"),
          onSubmitted: (str) {
            setState(() {
              _filterstate = false;
              _liststate = true;
              action();
            });
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Visibility(
                replacement: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: FlatButton(
                        onPressed: () {
                          setState(() {
                            _filterstate = true;
                          });
                        },
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.arrow_right),
                            Text("Filtrage"),
                          ],
                        )),
                  ),
                ),
                visible: _filterstate,
                child: Card(
                  child: Container(
                    height: 460,
                    child: Padding(
                      padding: const EdgeInsets.all(6),
                      child: FormBuilder(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              FlatButton(
                                  onPressed: () {
                                    setState(() {
                                      _filterstate = false;
                                    });
                                  },
                                  child: Row(
                                    children: <Widget>[
                                      Icon(Icons.arrow_drop_down),
                                      Text("Filtrage"),
                                    ],
                                  )),
                              SizedBox(height: 10),
                              FormBuilderDropdown(
                                attribute: "Type",
                                decoration: theme("Type de l'evenement"),
                                hint: Text('Selectionner type'),
                                validators: [FormBuilderValidators.required()],
                                items: listtype
                                    .map((value) => DropdownMenuItem(
                                        value: value, child: Text("$value")))
                                    .toList(),
                              ),
                              SizedBox(height: 10),
                              FormBuilderDropdown(
                                attribute: "Sous-type",
                                decoration: theme("Sous-type de l'evenement"),
                                hint: Text('Selectionner sous-type'),
                                validators: [FormBuilderValidators.required()],
                                items: listtype
                                    .map((value) => DropdownMenuItem(
                                        value: value, child: Text("$value")))
                                    .toList(),
                              ),
                              SizedBox(height: 10),
                              FormBuilderChoiceChip(
                                attribute: "date",
                                decoration: theme("Date"),
                                options: [
                                  FormBuilderFieldOption(
                                      child: Text("Aujourd'hui"),
                                      value: "today"),
                                  FormBuilderFieldOption(
                                      child: Text("Demain"), value: "tomorrow"),
                                  FormBuilderFieldOption(
                                      child: Text("Prochaine semaine"),
                                      value: "next_week"),
                                  FormBuilderFieldOption(
                                      child: Text("Prochaine mois"),
                                      value: "next_month"),
                                ],
                                validators: [FormBuilderValidators.required()],
                              ),
                              SizedBox(height: 10),
                              FormBuilderDateTimePicker(
                                attribute: "date",
                                inputType: InputType.date,
                                format: DateFormat("dd-MM-yyyy"),
                                decoration: theme("ou choisir une date"),
                              ),
                              SizedBox(height: 10),
                              button(context, "rechercher", () {
                                setState(() {
                                  _filterstate = false;
                                  _liststate = true;
                                  action();
                                });
                              })
                            ],
                          )),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Visibility(
                  visible: _liststate,
                  child: Container(
                      height: MediaQuery.of(context).size.height * 0.83,
                      child: listEvent(uic, context))),
            ],
          ),
        ),
      ),
    );
  }
}
