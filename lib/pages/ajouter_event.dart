import 'dart:ffi';

import 'package:eventapp/classes/event.dart';
import 'package:eventapp/database.dart';
import 'package:eventapp/pages/home_page_publieur.dart';
import 'package:eventapp/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:google_map_location_picker/google_map_location_picker.dart';

// Cette page est pour l'ajout des evenements (donc specifique au publieurs)

class AjouterEvent extends StatefulWidget {
  AjouterEvent({Key key, this.title}) : super(key: key);

  final String title;

  @override
  AjouterEventState createState() => AjouterEventState();
}

class AjouterEventState extends State<AjouterEvent> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  LocationResult place;

  // Tout simplement ca contient une forme (FormBuilder) avec tout les champs necessaire pour la creation
  // d'un evenement (encours de developpement)

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
          padding: EdgeInsets.all(15),
          child: SingleChildScrollView(
            child: Container(
              decoration: BoxDecoration(),
              child: FormBuilder(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      FormBuilderTextField(
                        attribute: "nom",
                        decoration: theme("nom"),
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
                        validator: (val) => null,
                        initialTime: TimeOfDay(hour: 8, minute: 0),
                      ),
                      SizedBox(height: 15),
                      FormBuilderDateTimePicker(
                        attribute: "heure_fin",
                        inputType: InputType.time,
                        decoration: theme("Heure fin de l'evenement"),
                        validator: (val) => null,
                        initialTime: TimeOfDay(hour: 17, minute: 0),
                      ),
                      SizedBox(height: 15),
                      FormBuilderDateRangePicker(
                        attribute: "date_range",
                        firstDate: DateTime(1970),
                        lastDate: DateTime(2030),
                        format: DateFormat("dd-MM-yyyy"),
                        decoration: theme("date debut et fin"),
                      ),
                      SizedBox(height: 15),
                      button(context, "selectionner un lieu", () async {
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
                      // SizedBox(height: 15),
                      // FormBuilderTextField(
                      //   keyboardType: TextInputType.number,
                      //   attribute: "nb_place_dispo",
                      //   decoration: theme("Nembre de place disponible"),
                      //   validators: [
                      //     FormBuilderValidators.numeric(
                      //         errorText: "Ce champs doit etre numerique"),
                      //   ],
                      // ),
                      // SizedBox(height: 15),
                      // FormBuilderTextField(
                      //   keyboardType:
                      //       TextInputType.numberWithOptions(decimal: false),
                      //   attribute: "prix",
                      //   decoration: theme("Prix"),
                      //   validators: [
                      //     FormBuilderValidators.numeric(
                      //         errorText: "Ce champs doit etre numerique"),
                      //   ],
                      // ),
                      // SizedBox(height: 15),
                      // Text("Contact"),
                      // SizedBox(height: 15),
                      // FormBuilderTextField(
                      //   attribute: "e-mail",
                      //   decoration: theme("e-mail"),
                      //   validators: [
                      //     FormBuilderValidators.email(
                      //         errorText: "e-mail non valide"),
                      //     FormBuilderValidators.required(
                      //         errorText: "Ce champs est obligatoire")
                      //   ],
                      // ),
                      // SizedBox(height: 15),
                      // FormBuilderTextField(
                      //   attribute: "numero",
                      //   keyboardType: TextInputType.number,
                      //   decoration: theme("numero de telephone"),
                      //   validators: [
                      //     FormBuilderValidators.numeric(
                      //         errorText: "Ce champs doit etre numerique"),
                      //   ],
                      // ),
                      // SizedBox(height: 15),
                      // FormBuilderTextField(
                      //   attribute: "url",
                      //   decoration: theme("lien"),
                      //   validators: [
                      //     FormBuilderValidators.url(
                      //         errorText: "Ce champs doit etre un url")
                      //   ],
                      // ),
                      // SizedBox(height: 15),
                      // FormBuilderRangeSlider(
                      //   attribute: "age_cible",
                      //   validators: [FormBuilderValidators.min(6)],
                      //   min: 0.0,
                      //   max: 100.0,
                      //   initialValue: RangeValues(18, 30),
                      //   divisions: 50,
                      //   activeColor: Colors.red,
                      //   inactiveColor: Colors.pink[100],
                      //   decoration: InputDecoration(
                      //     labelText: "Age cibles",
                      //   ),
                      // ),
                      SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                              child: button(context, "Confirmer", () {
                            _confirm(cont);
                          })),
                          SizedBox(width: 15),
                          Expanded(child: button(context, "effacer", _reset)),
                        ],
                      ),
                      SizedBox(height: 15),
                    ],
                  )),
            ),
          ),
        );
      }),
    );
  }

  Future<void> _confirm(BuildContext cont) async {
    if (_formKey.currentState.saveAndValidate()) {
      var c = Map.from(_formKey.currentState.value);

      DateTime d = c['date_range'][0];
      DateTime d2 = c['heure_debut'];
      DateTime f = c['date_range'][1];
      DateTime f2 = c['heure_fin'];

      DateTime datedebut = new DateTime(
        d.year,
        d.month,
        d.day,
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

      double latitude = place.latLng.latitude;
      double longitude = place.latLng.longitude;

      var event = Event.fromMap({
        'nom': c['nom'],
        'corps': c['corps'],
        'datedebut': datedebut.toString(),
        'datefin': datefin.toString(),
        'latitude': latitude,
        'longitude': longitude
      });

      DBProvider.db.newEvent(event);

      Scaffold.of(cont).showSnackBar(snackBar('Evenement cree!', Colors.green));

      await Future.delayed(const Duration(seconds: 4), () {});

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => MyHomePagePublieur()),
          ModalRoute.withName('/'));
    } else {
      Scaffold.of(cont)
          .showSnackBar(snackBar('Probleme de validation!', Colors.red[800]));
    }
  }

  void _reset() {
    DBProvider.db.deleteEvent();
    _formKey.currentState.reset();
  }
}
