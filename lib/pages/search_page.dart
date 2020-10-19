import 'dart:convert';
import 'package:eventapp/classes/event.dart';
import 'package:eventapp/tools/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uic/list_uic.dart';
import 'package:eventapp/tools/auth.dart' as auth;

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
  SharedPreferences prefs;
  List listType = List<String>();

  List wilaya = [
    "Adrar",
    "Chlef",
    "Laghouat",
    "Oum El Bouaghi",
    "Batna",
    "Béjaïa",
    "Biskra",
    "Béchar",
    "Blida",
    "Bouira",
    "Tamanrasset",
    "Tébessa",
    "Tlemcen",
    "Tiaret",
    "Tizi Ouzou",
    "Alger",
    "Djelfa",
    "Jijel",
    "Sétif",
    "Saïda",
    "Skikda",
    "Sidi Bel Abbès",
    "Annaba",
    "Guelma",
    "Constantine",
    "Médéa",
    "Mostaganem",
    "M'Sila",
    "Mascara",
    "Ouargla",
    "Oran",
    "El Bayadh",
    "Illizi",
    "Bordj Bou Arreridj",
    "Boumerdès",
    "El Tarf",
    "Tindouf",
    "Tissemsilt",
    "El Oued",
    "Khenchela",
    "Souk Ahras",
    "Tipaza",
    "Mila",
    "Aïn Defla",
    "Naâma",
    "Aïn Témouchent",
    "Ghardaïa",
    "Relizane"
  ];

  List<Event> listevent = List<Event>();

  Future<List<Event>> _getItems(int page) async {
    await Future.delayed(Duration(seconds: 2));
    List<Event> list = new List<Event>();
    int i = 1;
    while ((i + (page - 1) * 7) <= listevent.length && i <= 7) {
      list.add(listevent[(page - 1) * 7 + i - 1]);
      i++;
    }
    return list;
  }

  Future<void> action() async {
    if (_formKey.currentState.saveAndValidate()) {
      var a = {};
      a.addAll(_formKey.currentState.value);

      var x = await auth.getRequest(
          'recherche?type=${a['type']}&soustype=${a['sous_type']}&next=${a['date']}&state=${a['state']}',
          {});

      var eventsMap = jsonDecode(x) as Map<String, dynamic>;
      var list = eventsMap.entries.map((e) => Event.fromJson(e.value)).toList();

      listevent = list;

      print(a);
      initList();
    }
  }

  initList() {
    setState(() {
      uic = ListUicController<Event>(
        onGetItems: (int page) => _getItems(page),
      );
    });
  }

  @override
  void initState() {
    _initType();

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
        title: Text(
          "Rechercher des evenements",
          style: Theme.of(context).textTheme.headline1,
          textAlign: TextAlign.center,
        ),
        iconTheme: new IconThemeData(color: Colors.blueGrey[800]),
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
                  elevation: 3,
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
                  elevation: 3,
                  child: Container(
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
                                attribute: "type",
                                decoration: theme("Theme de l'evenement"),
                                hint: Text('Selectionner un theme'),
                                // liste type
                                items: listType
                                    .map((type) => DropdownMenuItem(
                                        value: type, child: Text("$type")))
                                    .toList(),
                              ),
                              SizedBox(height: 10),
                              FormBuilderDropdown(
                                attribute: "state",
                                decoration: theme("Lieu de deroulement"),
                                hint: Text('Selectionner une wilaya'),
                                items: wilaya
                                    .map((lieu) => DropdownMenuItem(
                                        value: lieu, child: Text("$lieu")))
                                    .toList(),
                              ),
                              SizedBox(height: 15),
                              FormBuilderChoiceChip(
                                attribute: "date",
                                decoration: theme("Date de deroulement"),
                                spacing: 3.0,
                                options: [
                                  FormBuilderFieldOption(
                                    child: Text("Cette semaine"),
                                    value: "this_week",
                                  ),
                                  FormBuilderFieldOption(
                                    child: Text("Ce mois"),
                                    value: "this_month",
                                  ),
                                  FormBuilderFieldOption(
                                    child: Text("Cette annee"),
                                    value: "this_year",
                                  ),
                                  FormBuilderFieldOption(
                                    child: Text("Tout"),
                                    value: "all",
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              button(context, "rechercher", () {
                                setState(() {
                                  _filterstate = false;
                                  _liststate = true;
                                  action();
                                });
                              }),
                              SizedBox(
                                height: 5,
                              )
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
                      child: listEvent(uic, context, "Participer"))),
            ],
          ),
        ),
      ),
    );
  }

  _initType() async {
    prefs = await SharedPreferences.getInstance();

    listType = prefs.getStringList("Type");
  }
}
