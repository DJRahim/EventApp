import 'package:auto_size_text/auto_size_text.dart';
import 'package:eventapp/classes/profession.dart';
import 'package:eventapp/classes/user_normal.dart';
import 'package:eventapp/tools/database.dart';
import 'package:eventapp/pages/home_page.dart';
import 'package:eventapp/tools/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:google_map_location_picker/google_map_location_picker.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:eventapp/tools/geolocation.dart' as Geoloc;

// Cette page contient la 2eme forme pour les infos supplementaire (pour l'utilisateur normale)
// elle contient les champs :
// Nom, Prenom, age, sexe, profession, (Pas encore finis)

class RegisterPage2 extends StatefulWidget {
  RegisterPage2({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _RegisterPage2State createState() => _RegisterPage2State();
}

class _RegisterPage2State extends State<RegisterPage2> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  final GlobalKey<FormBuilderState> _formKey2 = GlobalKey<FormBuilderState>();

  bool _visible1 = false;
  bool _visible2 = false;
  bool _visible3 = false;
  List listType = List<String>();
  List listSousType1 = List<String>();
  List listSousType2 = List<String>();
  List listSousType3 = List<String>();

  String suivant = "Suivant";

  LocationData locationData;

  int _index = 0;

  SharedPreferences prefs;

  var a = {};
  var b = {};
  LocationResult place;
  var loc = 0;
  bool map = false;

  @override
  void initState() {
    super.initState();
    _initType();
    local();
  }

  @override
  void dispose() {
    initTypeSousType();
    super.dispose();
    _formKey.currentState.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Inscription d'un utilisateur",
          style: Theme.of(context).textTheme.headline1,
          textAlign: TextAlign.center,
        ),
        iconTheme: new IconThemeData(color: Colors.blueGrey[800]),
      ),
      body: Builder(builder: (cont) {
        return Padding(
          padding: EdgeInsets.all(10),
          child: Container(
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
                        child:
                            button(context, suivant, () => confirm1(context))),
                  ],
                );
              },
              steps: <Step>[
                Step(
                  title: Text(""),
                  content: Column(
                    children: <Widget>[
                      FormBuilder(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(child: AutoSizeText("Etape 1")),
                              SizedBox(height: 15.0),
                              FormBuilderTextField(
                                attribute: "nom",
                                decoration: theme("Nom d'utilisateur"),
                                validators: [
                                  FormBuilderValidators.required(
                                      errorText: "Ce champs est obligatoire")
                                ],
                              ),
                              SizedBox(height: 20.0),
                              FormBuilderChoiceChip(
                                decoration: theme("Tranches d'age cibles"),
                                attribute: "age",
                                spacing: 3.0,
                                options: [
                                  FormBuilderFieldOption(
                                    value: "-17",
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
                                          "Svp selectionnez une tranche d'age")
                                ],
                              ),
                              SizedBox(height: 20.0),
                              FormBuilderDropdown(
                                attribute: "sexe",
                                decoration: theme("sexe"),
                                hint: Text('Selectionner sexe'),
                                items: ["Homme", "Femme"]
                                    .map((gender) => DropdownMenuItem(
                                        value: gender, child: Text("$gender")))
                                    .toList(),
                                validators: [
                                  FormBuilderValidators.required(
                                      errorText:
                                          "Svp selectionnez l'un des deux")
                                ],
                              ),
                              SizedBox(height: 20.0),
                              FormBuilderDropdown(
                                attribute: "profession",
                                decoration: theme("Domaine d'exercice"),
                                hint: Text(
                                    "Selectionner votre domaine d'exercices"),
                                items: splitEnum(Profession.values.toList())
                                    .map((p) => DropdownMenuItem(
                                        value: p, child: Text("$p")))
                                    .toList(),
                              ),
                              SizedBox(height: 15),
                            ],
                          )),
                      SizedBox(height: 20.0),
                    ],
                  ),
                ),
                Step(
                    title: Text(""),
                    content: Column(
                      children: <Widget>[
                        FormBuilder(
                          key: _formKey2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(child: AutoSizeText("Etape 2")),
                              SizedBox(height: 15),
                              Text("Selectionner 3 themes culturels"),
                              SizedBox(height: 15),
                              FormBuilderDropdown(
                                attribute: "type1",
                                decoration: theme("Theme culturel"),
                                items: listType
                                    .map((gender) => DropdownMenuItem(
                                        value: gender, child: Text("$gender")))
                                    .toList(),
                                onChanged: (value) {
                                  setSousType(value, 1);
                                },
                                validators: [
                                  FormBuilderValidators.required(
                                      errorText: "Ce champs est obligatoire")
                                ],
                              ),
                              SizedBox(height: 15),
                              Visibility(
                                visible: _visible1,
                                child: FormBuilderFilterChip(
                                  decoration: theme("Sous-themes culturels"),
                                  attribute: "sous-type1",
                                  spacing: 3.0,
                                  options: listSousType1
                                      .map(
                                        (val) => FormBuilderFieldOption(
                                          value: val.toString(),
                                          child: Text(val.toString()),
                                        ),
                                      )
                                      .toList(),
                                  validators: [
                                    FormBuilderValidators.required(
                                        errorText:
                                            "Svp selectionnez les themes qu'il vous interessent")
                                  ],
                                ),
                              ),
                              SizedBox(height: 15),
                              FormBuilderDropdown(
                                attribute: "type2",
                                decoration: theme("Theme culturel"),
                                // liste type
                                items: listType
                                    .map((gender) => DropdownMenuItem(
                                        value: gender, child: Text("$gender")))
                                    .toList(),
                                onChanged: (value) {
                                  setSousType(value, 2);
                                },
                                validators: [
                                  FormBuilderValidators.required(
                                      errorText: "Ce champs est obligatoire")
                                ],
                              ),
                              SizedBox(height: 15),
                              Visibility(
                                visible: _visible2,
                                child: FormBuilderFilterChip(
                                  decoration: theme("Sous-themes culturels"),
                                  attribute: "sous-type2",
                                  spacing: 3.0,
                                  options: listSousType2
                                      .map(
                                        (val) => FormBuilderFieldOption(
                                          value: val.toString(),
                                          child: Text(val.toString()),
                                        ),
                                      )
                                      .toList(),
                                  validators: [
                                    FormBuilderValidators.required(
                                        errorText:
                                            "Svp selectionnez les themes qu'il vous interessent")
                                  ],
                                ),
                              ),
                              SizedBox(height: 15),
                              FormBuilderDropdown(
                                attribute: "type3",
                                decoration: theme("Theme culturel"),
                                // liste type
                                items: listType
                                    .map((gender) => DropdownMenuItem(
                                        value: gender, child: Text("$gender")))
                                    .toList(),
                                onChanged: (value) {
                                  setSousType(value, 3);
                                },
                                validators: [
                                  FormBuilderValidators.required(
                                      errorText: "Ce champs est obligatoire")
                                ],
                              ),
                              SizedBox(height: 15),
                              Visibility(
                                visible: _visible3,
                                child: FormBuilderFilterChip(
                                  decoration: theme("Sous-themes culturels"),
                                  attribute: "sous-type3",
                                  spacing: 3.0,
                                  options: listSousType3
                                      .map(
                                        (val) => FormBuilderFieldOption(
                                          value: val.toString(),
                                          child: Text(val.toString()),
                                        ),
                                      )
                                      .toList(),
                                  validators: [
                                    FormBuilderValidators.required(
                                        errorText:
                                            "Svp selectionnez les themes qu'il vous interessent")
                                  ],
                                ),
                              ),
                              SizedBox(height: 15),
                            ],
                          ),
                        )
                      ],
                    ))
              ],
            ),
          ),
        );
      }),
    );
  }

  _initType() async {
    prefs = await SharedPreferences.getInstance();

    listType = prefs.getStringList("Type");

    print(listType);
  }

  setSousType(String type, int n) async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      if (type != "Theatre") {
        switch (n) {
          case 1:
            listSousType1 = prefs.getStringList(type);
            _visible1 = true;
            break;
          case 2:
            listSousType2 = prefs.getStringList(type);
            _visible2 = true;
            break;
          case 3:
            listSousType3 = prefs.getStringList(type);
            _visible3 = true;
            break;
        }
      }
    });
  }

  confirm1(BuildContext cont) {
    setState(() {
      if (_index <= 1) {
        switch (_index) {
          case 0:
            if (_formKey.currentState.saveAndValidate()) {
              a.addAll(_formKey.currentState.value);
              print(a);
              suivant = "Valider";
              _index++;
            }
            break;
          case 1:
            if (_formKey2.currentState.saveAndValidate()) {
              b.addAll(_formKey2.currentState.value);
              print(b);
              confirm(cont);
            }
            break;
          default:
        }
      }
    });
  }

  local() async {
    Geoloc.requestLocationPermission();
    Geoloc.gpsService(context);
    Location location = new Location();

    locationData = await location.getLocation();
    print(locationData);
  }

  Future<void> confirm(BuildContext cont) async {
    var c = {};
    c.addAll(a);
    c.addAll(b);
    local();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("upload", false);

    double latitude = locationData.latitude;
    double longitude = locationData.longitude;

    var choix = c['type1'] + "," + c['type2'] + "," + c['type3'];
    var choix2 = "";

    for (var item in c['sous-type1']) {
      choix2 = choix2 + "," + item;
    }
    for (var item in c['sous-type2']) {
      choix2 = choix2 + "," + item;
    }
    for (var item in c['sous-type3']) {
      choix2 = choix2 + "," + item;
    }

    choix = choix + choix2;

    DBProvider.db.deleteAll();

    DBProvider.db.newUser(Normal.fromMap({
      'nom': c['nom'],
      'email': prefs.getString('email'),
      'age': c['age'],
      'sexe': c['sexe'],
      'domaine': c['profession'],
      'latitude': latitude,
      'longitude': longitude,
      'chois': choix.toString()
    }));

    prefs.setString("choixUser", choix2);
    prefs.setString("choixUser2", choix);

    Scaffold.of(cont).showSnackBar(snackBar(
        'Inscription reussi! \nVeuillez valider votre email.', Colors.green));

    await Future.delayed(const Duration(seconds: 4), () {});

    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (BuildContext context) => MyHomePage()),
        ModalRoute.withName('/'));
  }
}
