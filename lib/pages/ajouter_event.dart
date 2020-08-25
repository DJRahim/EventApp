import 'dart:convert';
import 'package:eventapp/tools/auth.dart' as auth;
import 'package:eventapp/classes/event.dart';
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
              onStepContinue: () {
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
              },
              onStepCancel: () {},
              steps: [
                Step(
                  title: Text(""),
                  content: FormBuilder(
                    key: _formKey[0],
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
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
                        SizedBox(height: 15),
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
                          decoration: theme("Type de l'evenement"),
                          hint: Text('Selectionner un type'),
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
                            decoration: theme("Sous-type de l'evenement"),
                            hint: Text('Selectionner un sous-type'),
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
                        SizedBox(height: 15),
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
                        SizedBox(height: 15),
                        FormBuilderFilterChip(
                          decoration: theme("Tranches d'age cibles"),
                          attribute: "age",
                          spacing: 3.0,
                          options: [
                            FormBuilderFieldOption(
                              value: "mineur",
                              child: Text("moins de 17 ans"),
                            ),
                            FormBuilderFieldOption(
                              value: "jeune",
                              child: Text("de 18 a 34 ans"),
                            ),
                            FormBuilderFieldOption(
                              value: "homme",
                              child: Text("de 35 a 59 ans"),
                            ),
                            FormBuilderFieldOption(
                              value: "vieu",
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
                              value: "Homme",
                              child: Text("Hommes"),
                            ),
                            FormBuilderFieldOption(
                              value: "Femme",
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
                              value: "Sante",
                              child: Text("Sante"),
                            ),
                            FormBuilderFieldOption(
                              value: "Culture",
                              child: Text("Culture"),
                            ),
                            FormBuilderFieldOption(
                              value: "Education",
                              child: Text("Education"),
                            ),
                            FormBuilderFieldOption(
                              value: "Ingenerie",
                              child: Text("Ingenerie"),
                            ),
                            FormBuilderFieldOption(
                              value: "Finance",
                              child: Text("Finance"),
                            ),
                            FormBuilderFieldOption(
                              value: "Administration",
                              child: Text("Administration"),
                            ),
                            FormBuilderFieldOption(
                              value: "Construction",
                              child: Text("Construction"),
                            ),
                            FormBuilderFieldOption(
                              value: "Droit",
                              child: Text("Droit"),
                            ),
                            FormBuilderFieldOption(
                              value: "Sport",
                              child: Text("Sport"),
                            ),
                            FormBuilderFieldOption(
                              value: "Commerce",
                              child: Text("Commerce"),
                            ),
                            FormBuilderFieldOption(
                              value: "Recherche",
                              child: Text("Recherche"),
                            ),
                            FormBuilderFieldOption(
                              value: "Tourisme",
                              child: Text("Tourisme"),
                            ),
                          ],
                          validators: [
                            FormBuilderValidators.required(
                                errorText:
                                    "Svp selectionnez les domaines d'exercices cibles")
                          ],
                        ),
                        SizedBox(height: 15),
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
      'nb_place_dispo': y['nb_place_dispo'].toString(),
      'prix': y['prix'],
      'type': y['type'],
      'sous_type': y['sous_type'],
      'age': y['age'],
      'sexe': y['sexe'],
      'domaine': y['domaine'],
      'contactEmail': y['email'],
      'contactNum': y['numero'].toString(),
      'contactLien': y['url']
    });

    var ar = event.toMap();

    SharedPreferences prefs = await SharedPreferences.getInstance();

    print(prefs.getString('token'));

    var i = await auth.getRequest(
        'profil/nouveau_evenement?token=${prefs.getString("token")}&Nom_Organisateur=serbess&categorie=festival&id_type=5&Nombre_de_place_disponible=${ar['nb_place_dispo']}&Prix=500&Date_debut=${ar['datedebut']}&Date_fin=${ar['datefin']}&Photo=oasoj&latitude=${ar['latitude']}&longitude=${ar['longitude']}&descritpion=${ar['corps']}',
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

    listType = prefs.getStringList("type");
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
