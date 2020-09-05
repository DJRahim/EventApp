import 'dart:convert';
import 'package:eventapp/tools/auth.dart' as auth;
import 'package:eventapp/classes/event.dart';
import 'package:eventapp/tools/database.dart';
import 'package:eventapp/tools/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:google_map_location_picker/google_map_location_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home_page_publieur.dart';

// Cette page est pour l'ajout des evenements (donc specifique au publieurs)

class AjouterEvent extends StatefulWidget {
  AjouterEvent({Key key, this.title}) : super(key: key);

  final String title;

  @override
  AjouterEventState createState() => AjouterEventState();
}

class AjouterEventState extends State<AjouterEvent> {
  final List<GlobalKey<FormBuilderState>> _formKey = [
    GlobalKey<FormBuilderState>(),
    GlobalKey<FormBuilderState>(),
    GlobalKey<FormBuilderState>(),
    GlobalKey<FormBuilderState>()
  ];

  var a = {};
  var b = {};
  var c = {};
  var d = {};

  String suivant = "Suivant";

  SharedPreferences prefs;
  LocationResult place;
  int _index = 0;
  bool _visible = false;
  List listType = List<String>();
  List listSousType = List<String>();

  // Tout simplement ca contient une forme (FormBuilder) avec tout les champs necessaire pour la creation
  // d'un evenement (encours de developpement)

  @override
  initState() {
    _initType();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _formKey[0].currentState.dispose();
    _formKey[1].currentState.dispose();
    _formKey[2].currentState.dispose();
    _formKey[3].currentState.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Creation d'un evenement",
          style: Theme.of(context).textTheme.headline1,
          textAlign: TextAlign.center,
        ),
        iconTheme: new IconThemeData(color: Colors.blueGrey[800]),
      ),
      body: Builder(builder: (cont) {
        return Padding(
          padding: EdgeInsets.all(10),
          child: Container(
            decoration: BoxDecoration(),
            child: Stepper(
              type: StepperType.horizontal,
              currentStep: _index,
              onStepTapped: (index) {
                setState(() {
                  _index = index;
                });
              },
              controlsBuilder: (context, {onStepCancel, onStepContinue}) {
                return Row(
                  children: <Widget>[
                    Expanded(
                        child: button(context, suivant, () {
                      setState(() {
                        if (_index <= 3) {
                          // Sauvegarder l'etape actuelle
                          if (_formKey[_index].currentState.saveAndValidate()) {
                            switch (_index) {
                              case 0:
                                a.addAll(_formKey[_index].currentState.value);
                                print(a);
                                _index++;

                                break;
                              case 1:
                                b.addAll(_formKey[_index].currentState.value);
                                print(b);
                                _index++;

                                break;
                              case 2:
                                c.addAll(_formKey[_index].currentState.value);
                                print(c);
                                _index++;
                                suivant = "Valider";

                                break;
                              case 3:
                                d.addAll(_formKey[_index].currentState.value);
                                print(d);
                                _confirm(cont);
                                break;
                              default:
                            }
                          }
                        }
                      });
                    }))
                  ],
                );
              },
              steps: [
                Step(
                  title: Text(""),
                  content: FormBuilder(
                    key: _formKey[0],
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text("Etape 1"),
                        SizedBox(height: 15),
                        FormBuilderTextField(
                          attribute: "nom",
                          decoration: theme("Nom de l'evenement"),
                          validators: [
                            FormBuilderValidators.required(
                                errorText: "Ce champs est obligatoire")
                          ],
                        ),
                        SizedBox(height: 15),
                        FormBuilderDateTimePicker(
                          attribute: "heure_debut",
                          inputType: InputType.time,
                          decoration: theme("Heure debut de l'evenement"),
                          validators: [
                            FormBuilderValidators.required(
                                errorText: "Ce champs est necessaire")
                          ],
                          initialTime: TimeOfDay(hour: 8, minute: 0),
                        ),
                        SizedBox(height: 15),
                        FormBuilderDateTimePicker(
                          attribute: "heure_fin",
                          inputType: InputType.time,
                          decoration: theme("Heure fin de l'evenement"),
                          validators: [
                            FormBuilderValidators.required(
                                errorText: "Ce champs est necessaire")
                          ],
                          initialTime: TimeOfDay(hour: 17, minute: 0),
                        ),
                        SizedBox(height: 15),
                        FormBuilderDateRangePicker(
                          attribute: "date_range",
                          firstDate: DateTime(1970),
                          lastDate: DateTime(2030),
                          format: DateFormat("dd-MM-yyyy"),
                          decoration: theme("Date debut et fin"),
                          validators: [
                            FormBuilderValidators.required(
                                errorText: "Ce champs est necessaire")
                          ],
                        ),
                        SizedBox(height: 15),
                        button(context, "Lieu de deroulement", () async {
                          var result = await showLocationPicker(
                            context,
                            "AIzaSyCdT5Sdo4Gn6i725HrgD2phksfORE-Rw2s",
                            initialCenter: LatLng(36.7538, 3.0588),
                            myLocationButtonEnabled: true,
                            layersButtonEnabled: true,
                            resultCardAlignment: Alignment.bottomCenter,
                          );
                          setState(() => place = result);
                        }),
                        SizedBox(height: 15),
                        FormBuilderTextField(
                          attribute: "corps",
                          decoration: theme("Description"),
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          validators: [
                            FormBuilderValidators.required(
                                errorText: "Ce champs est obligatoire")
                          ],
                        ),
                        SizedBox(height: 50),
                      ],
                    ),
                  ),
                ),
                Step(
                  //2 eme etape: categorie / type et sous-type
                  title: Text(""),
                  content: FormBuilder(
                    key: _formKey[1],
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text("Etape 2"),
                        SizedBox(height: 15),
                        FormBuilderTextField(
                          keyboardType: TextInputType.number,
                          attribute: "nb_place_dispo",
                          decoration: theme("Nombre de place disponible"),
                          validators: [
                            FormBuilderValidators.numeric(
                                errorText: "Ce champs doit etre numerique"),
                          ],
                        ),
                        SizedBox(height: 15),
                        FormBuilderChoiceChip(
                          decoration: theme("Prix"),
                          attribute: "prix",
                          spacing: 3.0,
                          options: [
                            FormBuilderFieldOption(
                              value: "payant",
                              child: Text("Payant"),
                            ),
                            FormBuilderFieldOption(
                              value: "gratuit",
                              child: Text("Gratuit"),
                            ),
                          ],
                          validators: [
                            FormBuilderValidators.required(
                                errorText: "Svp selectionnez l'un des deux")
                          ],
                        ),
                        SizedBox(height: 15),
                        FormBuilderDropdown(
                          attribute: "type",
                          decoration: theme("Theme de l'evenement"),
                          hint: Text('Selectionner un theme'),
                          // liste type
                          items: listType
                              .map((gender) => DropdownMenuItem(
                                  value: gender, child: Text("$gender")))
                              .toList(),
                          onChanged: (value) {
                            setSousType(value);
                          },
                          validators: [
                            FormBuilderValidators.required(
                                errorText: "Ce champs est obligatoire")
                          ],
                        ),
                        SizedBox(height: 15),
                        Visibility(
                          visible: _visible,
                          child: FormBuilderDropdown(
                            attribute: "sous_type",
                            decoration: theme("Sous-theme de l'evenement"),
                            hint: Text('Selectionner un sous-theme'),
                            items: listSousType
                                .map((gender) => DropdownMenuItem(
                                    value: gender, child: Text("$gender")))
                                .toList(),
                            validators: [
                              FormBuilderValidators.required(
                                  errorText: "Ce champs est obligatoire")
                            ],
                          ),
                        ),
                        SizedBox(height: 50),
                      ],
                    ),
                  ),
                ),
                Step(
                  //3 eme etape:  public cible
                  title: Text(""),
                  content: FormBuilder(
                    key: _formKey[2],
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text("Etape 3"),
                        SizedBox(height: 15),
                        FormBuilderFilterChip(
                          decoration: theme("Tranches d'age cibles"),
                          attribute: "age",
                          spacing: 3.0,
                          options: [
                            FormBuilderFieldOption(
                              value: "0-17",
                              child: Text("moins de 17 ans"),
                            ),
                            FormBuilderFieldOption(
                              value: "18-34",
                              child: Text("de 18 a 34 ans"),
                            ),
                            FormBuilderFieldOption(
                              value: "35-59",
                              child: Text("de 35 a 59 ans"),
                            ),
                            FormBuilderFieldOption(
                              value: "60+",
                              child: Text("60 ans et plus"),
                            ),
                          ],
                          validators: [
                            FormBuilderValidators.required(
                                errorText:
                                    "Svp selectionnez les tranches d'age cibles")
                          ],
                        ),
                        SizedBox(height: 15),
                        FormBuilderFilterChip(
                          decoration: theme("Sexe cible"),
                          attribute: "sexe",
                          spacing: 3.0,
                          options: [
                            FormBuilderFieldOption(
                              value: "1",
                              child: Text("Hommes"),
                            ),
                            FormBuilderFieldOption(
                              value: "2",
                              child: Text("Femmes"),
                            ),
                          ],
                          validators: [
                            FormBuilderValidators.required(
                                errorText: "Ce champ est obligatoire")
                          ],
                        ),
                        SizedBox(height: 15),
                        FormBuilderFilterChip(
                          decoration: theme("Domaines cibles"),
                          attribute: "doamine",
                          spacing: 3.0,
                          options: [
                            FormBuilderFieldOption(
                              value: "1",
                              child: Text("Sante"),
                            ),
                            FormBuilderFieldOption(
                              value: "2",
                              child: Text("Culture"),
                            ),
                            FormBuilderFieldOption(
                              value: "3",
                              child: Text("Education"),
                            ),
                            FormBuilderFieldOption(
                              value: "4",
                              child: Text("Ingenerie"),
                            ),
                            FormBuilderFieldOption(
                              value: "5",
                              child: Text("Finance"),
                            ),
                            FormBuilderFieldOption(
                              value: "6",
                              child: Text("Administration"),
                            ),
                            FormBuilderFieldOption(
                              value: "7",
                              child: Text("Construction"),
                            ),
                            FormBuilderFieldOption(
                              value: "8",
                              child: Text("Droit"),
                            ),
                            FormBuilderFieldOption(
                              value: "9",
                              child: Text("Sport"),
                            ),
                            FormBuilderFieldOption(
                              value: "10",
                              child: Text("Commerce"),
                            ),
                            FormBuilderFieldOption(
                              value: "11",
                              child: Text("Recherche"),
                            ),
                            FormBuilderFieldOption(
                              value: "12",
                              child: Text("Tourisme"),
                            ),
                          ],
                          validators: [
                            FormBuilderValidators.required(
                                errorText:
                                    "Svp selectionnez les domaines d'exercices cibles")
                          ],
                        ),
                        SizedBox(height: 50),
                      ],
                    ),
                  ),
                ),
                Step(
                  title: Text(""),
                  content: FormBuilder(
                    key: _formKey[3],
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        //4 eme etape: Contact
                        Text("Etape 4"),
                        SizedBox(height: 15),
                        FormBuilderTextField(
                          attribute: "email",
                          decoration: theme("e-mail"),
                          validators: [
                            FormBuilderValidators.email(
                                errorText: "e-mail non valide"),
                          ],
                        ),
                        SizedBox(height: 15),
                        FormBuilderTextField(
                          attribute: "numero",
                          keyboardType: TextInputType.number,
                          decoration: theme("Numero de telephone"),
                          validators: [
                            FormBuilderValidators.numeric(
                                errorText: "Ce champs doit etre numerique"),
                          ],
                        ),
                        SizedBox(height: 15),
                        FormBuilderTextField(
                          attribute: "url",
                          decoration: theme("Lien (site web ou reseau social)"),
                          validators: [
                            FormBuilderValidators.url(
                                errorText: "Ce champs doit etre un url")
                          ],
                        ),
                        SizedBox(height: 50),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      }),
    );
  }

  _confirm(BuildContext cont) async {
    var y = {};
    y.addAll(a);
    y.addAll(b);
    y.addAll(c);
    y.addAll(d);

    DateTime d1 = y['date_range'][0];
    DateTime d2 = y['heure_debut'];
    DateTime f = y['date_range'][1];
    DateTime f2 = y['heure_fin'];

    DateTime datedebut = new DateTime(
      d1.year,
      d1.month,
      d1.day,
      d2.hour,
      d2.minute,
      d2.second,
    );
    DateTime datefin = new DateTime(
      f.year,
      f.month,
      f.day,
      f2.hour,
      f2.minute,
      f2.second,
    );

    final r = new DateFormat('yyyy-MM-dd hh:mm:ss');

    double latitude = place.latLng.latitude;
    double longitude = place.latLng.longitude;

    var event = Event.fromMap({
      'nom': y['nom'],
      'description': y['corps'],
      'datedebut': r.format(datedebut),
      'datefin': r.format(datefin),
      'photo': 'dcdc',
      'latitude': latitude,
      'longitude': longitude,
      'nbPlaceDispo': y['nb_place_dispo'].toString(),
      'prix': y['prix'],
      'type': y['type'],
      'sousType': y['sous_type'],
      'age': y['age'].toString(),
      'sexe': y['sexe'].toString(),
      'domaine': y['domaine'].toString(),
      'contactEmail': y['email'],
      'contactNum': y['numero'].toString(),
      'contactLien': y['url']
    });

    var ar = event.toMap();

    var profil = "";

    for (var term in y['age']) {
      profil = profil + term + ",";
    }
    for (var term in y['sexe']) {
      var termstr = "";
      switch (term) {
        case 1:
          termstr = "Homme";
          break;
        case 2:
          termstr = "Femme";
          break;
      }
      profil = profil + termstr + ",";
    }
    profil = profil + y["type"] + ",";

    profil = profil + y["sous_type"] + ",";

    for (var term in y['domaine']) {
      var termstr = "";
      switch (term) {
        case 1:
          termstr = "Sante";
          break;
        case 2:
          termstr = "Culture";
          break;
        case 3:
          termstr = "Education";
          break;
        case 4:
          termstr = "Ingenerie";
          break;
        case 5:
          termstr = "Finance";
          break;
        case 6:
          termstr = "Administration";
          break;
        case 7:
          termstr = "Construction";
          break;
        case 8:
          termstr = "Droit";
          break;
        case 9:
          termstr = "Sport";
          break;
        case 10:
          termstr = "Commerce";
          break;
        case 11:
          termstr = "Recherche";
          break;
        case 12:
          termstr = "Tourisme";
          break;
      }
      profil = profil + termstr + ",";
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();

    print(prefs.getString('token'));

    var i = await auth.getRequest(
        'profil/nouveau_evenement?token=${prefs.getString("token")}&Nom_Organisateur=serbess&id_type=5&Nombre_de_place_disponible=${ar['nb_place_dispo']}&Prix=500&Date_debut=${ar['datedebut']}&Date_fin=${ar['datefin']}&Photo=oasoj&latitude=${ar['latitude']}&longitude=${ar['longitude']}&descritpion=${ar['corps']}&profile=$profil',
        {});

    var j = jsonDecode(i);

    print(j);

    Scaffold.of(cont).showSnackBar(snackBar('Evenement cree!', Colors.green));

    await Future.delayed(const Duration(seconds: 4), () {});

    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => MyHomePagePublieur()),
        ModalRoute.withName('/'));
  }

  _initType() async {
    prefs = await SharedPreferences.getInstance();

    listType = prefs.getStringList("Type");
  }

  setSousType(String type) async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      if (type != "Theatre") {
        listSousType = prefs.getStringList(type);
        _visible = true;
      }
    });
  }
}
