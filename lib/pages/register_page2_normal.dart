import 'package:eventapp/classes/profession.dart';
import 'package:eventapp/classes/sexe.dart';
import 'package:eventapp/classes/user_normal.dart';
import 'package:eventapp/tools/database.dart';
import 'package:eventapp/pages/home_page.dart';
import 'package:eventapp/tools/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:google_map_location_picker/google_map_location_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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

  LocationResult place;
  var loc = 0;
  bool map = false;

  void reset() {
    _formKey.currentState.reset();
  }

  Future<void> confirm(BuildContext cont) async {
    if (loc == 0) {
      Geoloc.getCurrentLocation();
      if (Geoloc.currentPosition != null) {
        loc = 1;
      }
    }

    if (loc != 0) {
      if (_formKey.currentState.saveAndValidate()) {
        var c = Map<String, String>.from(_formKey.currentState.value);

        SharedPreferences prefs = await SharedPreferences.getInstance();
        double latitude;
        double longitude;
        if (loc == 1) {
          latitude = Geoloc.currentPosition.latitude;
          longitude = Geoloc.currentPosition.longitude;
        } else {
          latitude = place.latLng.latitude;
          longitude = place.latLng.longitude;
        }

        DBProvider.db.newUser(Normal.fromMap({
          'registerId': 'jdkjdde',
          'nom': c['nom'],
          'prenom': c['prenom'],
          'email': prefs.getString('email'),
          'age': c['age'],
          'sexe': c['sexe'],
          'profession': c['profession'],
          'numtel': 063737,
          'latitude': latitude,
          'longitude': longitude
        }));

        Scaffold.of(cont).showSnackBar(snackBar(
            'Inscription reussi! \nVeuillez valider votre email.',
            Colors.green));

        await Future.delayed(const Duration(seconds: 4), () {});

        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (BuildContext context) => MyHomePage()),
            ModalRoute.withName('/'));
      } else {
        Scaffold.of(cont)
            .showSnackBar(snackBar('Probleme de validation!', Colors.red[800]));
      }
    } else {
      setState(() {
        map = true;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _formKey.currentState.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Builder(builder: (cont) {
        return Padding(
          padding: EdgeInsets.all(0),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                children: <Widget>[
                  SizedBox(height: 80.0),
                  FormBuilder(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(height: 20.0),
                          FormBuilderTextField(
                            attribute: "nom",
                            decoration: theme("Nom"),
                            validators: [
                              FormBuilderValidators.required(
                                  errorText: "Ce champs est obligatoire")
                            ],
                          ),
                          SizedBox(height: 20.0),
                          FormBuilderTextField(
                            attribute: "prenom",
                            decoration: theme("Prenom"),
                            validators: [
                              FormBuilderValidators.required(
                                  errorText: "Ce champs est obligatoire")
                            ],
                          ),
                          SizedBox(height: 20.0),
                          FormBuilderTextField(
                            keyboardType: TextInputType.number,
                            attribute: "age",
                            decoration: theme("Age"),
                            validators: [
                              FormBuilderValidators.numeric(
                                  errorText: "l'age doit etre numerique"),
                              FormBuilderValidators.max(90,
                                  errorText: "l'age doit etre < 90 ans"),
                            ],
                          ),
                          SizedBox(height: 20.0),
                          FormBuilderDropdown(
                            attribute: "sexe",
                            decoration: theme("sexe"),
                            hint: Text('Selectionner sexe'),
                            validators: [],
                            items: splitEnum(Sexe.values.toList())
                                .map((gender) => DropdownMenuItem(
                                    value: gender, child: Text("$gender")))
                                .toList(),
                          ),
                          SizedBox(height: 20.0),
                          FormBuilderDropdown(
                            attribute: "profession",
                            decoration: theme("profession"),
                            hint:
                                Text('Selectionner votre profession actuelle'),
                            validators: [],
                            items: splitEnum(Profession.values.toList())
                                .map((p) => DropdownMenuItem(
                                    value: p, child: Text("$p")))
                                .toList(),
                          ),
                          SizedBox(height: 15),
                          Visibility(
                            visible: map,
                            child: button(context, "selectionner manuellement",
                                () async {
                              var result = await showLocationPicker(
                                context,
                                "AIzaSyCdT5Sdo4Gn6i725HrgD2phksfORE-Rw2s",
                                initialCenter: LatLng(36.7538, 3.0588),
                                myLocationButtonEnabled: true,
                                layersButtonEnabled: true,
                                resultCardAlignment: Alignment.bottomCenter,
                              );
                              setState(() {
                                place = result;
                                loc = 2;
                              });
                            }),
                          ),
                        ],
                      )),
                  SizedBox(height: 20.0),
                  Row(
                    children: <Widget>[
                      Expanded(
                          child: button(context, "Confirmer", () {
                        confirm(cont);
                      })),
                      SizedBox(width: 20),
                      Expanded(child: button(context, "reset", reset))
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
