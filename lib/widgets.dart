import 'package:eventapp/classes/event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:geocoder/geocoder.dart';
import 'package:intl/intl.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uic/list_uic.dart';

// Ceci est un widget globale pour les boutons
Material button(BuildContext context, String s, void action()) {
  return Material(
    elevation: 5.0,
    borderRadius: BorderRadius.circular(30.0),
    color: Colors.blueAccent,
    child: MaterialButton(
      minWidth: MediaQuery.of(context).size.width,
      padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
      onPressed: action,
      child: Text(
        s,
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white),
      ),
    ),
  );
}

// Ceci est une decoration globale (pour les boutons, champs de text, ...)
InputDecoration theme(String s) {
  return InputDecoration(
      contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
      labelText: s,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)));
}

// Ceci est un widget globale pour les champs de saisie
TextFormField textField(String s1, String s2, TextEditingController a) {
  return TextFormField(
    obscureText: true,
    controller: a,
    decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        hintText: s1,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    validator: (value) {
      if (value.isEmpty) {
        return s2;
      }
      return null;
    },
  );
}

// Ceci est un widget qui represente un evenement
Widget event(void action(GoogleMapController c), List<Marker> m, Event e,
    BuildContext context) {
  return Card(
    elevation: 7,
    color: Colors.white,
    child: Padding(
      padding: const EdgeInsets.all(6.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 360,
            width: MediaQuery.of(context).size.width,
            child: GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: CameraPosition(
                target: LatLng(e.pos.latitude, e.pos.longitude),
                zoom: 14.4746,
              ),
              onMapCreated: action,
              markers: Set.from(m),
            ),
          ),
          SizedBox(height: 12.0),
          Card(
              elevation: 6,
              color: Colors.white,
              child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text(
                          "De:  " +
                              DateFormat.yMd().add_jm().format(e.dateDebut),
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold)),
                      SizedBox(width: 15.0),
                      Text(
                          "A:  " +
                              DateFormat.yMd()
                                  .add_jm()
                                  .format(e.dateFin.add(new Duration(days: 5))),
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold)),
                    ],
                  ))),
          SizedBox(height: 20.0),
          Card(
              elevation: 6,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      e.nom,
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 20.0),
                    Text(e.corps,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600)),
                  ],
                ),
              ))
        ],
      ),
    ),
  );
}

// Ceci est un widget qui represente un evenement dans une liste

Widget eventItem(Event e, BuildContext context) {
  return GestureDetector(
    child: Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: 390,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 10.0),
                  Text(e.nom,
                      style:
                          TextStyle(fontSize: 19, fontWeight: FontWeight.w500)),
                  SizedBox(height: 10.0),
                  Text(e.lieu,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                  SizedBox(height: 15.0),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 10.0),
                Text('De: ' + DateFormat('y/d/M').format(e.dateDebut),
                    style:
                        TextStyle(fontSize: 17, fontWeight: FontWeight.w500)),
                SizedBox(height: 20.0),
                Text('  A: ' + DateFormat('y/d/M').format(e.dateFin),
                    style:
                        TextStyle(fontSize: 17, fontWeight: FontWeight.w500)),
              ],
            ),
            SizedBox(height: 15.0),
          ],
        ),
      ),
      elevation: 5,
    ),
    onTap: () {
      Navigator.pushNamed(context, '/event', arguments: e);
    },
  );
}

// et ceci represente la liste des evenements

Widget listEvent(ListUicController<Event> uic, BuildContext context) {
  return ListUic<Event>(
    controller: uic,
    itemBuilder: (item) {
      return Column(
        children: <Widget>[eventItem(item, context), SizedBox(height: 5)],
      );
    },
    emptyProgressText: "",
    emptyDataIcon: Icon(Icons.refresh, size: 52.0, color: Colors.teal[200]),
    emptyDataText: "no items",
    emptyErrorIcon: Icon(Icons.error, size: 52.0, color: Colors.redAccent),
    emptyErrorText: "loading error",
    errorText: "there is a problem",
    errorColor: Colors.blueGrey[200],
  );
}

// une methode pour transformer un point (latitude et longitude) en addresse

dynamic posToLoc(double lat, double long) async {
  final coordinates = new Coordinates(lat, long);
  var addresses =
      await Geocoder.local.findAddressesFromCoordinates(coordinates);

  return addresses.first;
}

// Ca est le menu des parametres

Widget drawer(BuildContext context, {List<Widget> listWidget}) {
  return Drawer(
      child: Scaffold(
    appBar: AppBar(
      elevation: 8,
      backgroundColor: Colors.white,
    ),
    body: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: listWidget,
    ),
  ));
}

// Ceci est pour le filtrage des recherche pas encore finis (ca contient des problemes)
Widget menu(List listtype) {
  return FormBuilder(
      child: Column(
    children: <Widget>[
      Row(
        children: <Widget>[
          FormBuilderDropdown(
            attribute: "Type",
            decoration: theme("Type de l'evenement"),
            hint: Text('Selectionner type'),
            validators: [FormBuilderValidators.required()],
            items: listtype
                .map((value) =>
                    DropdownMenuItem(value: value, child: Text("$value")))
                .toList(),
          ),
          FormBuilderDropdown(
            attribute: "Sous-type",
            decoration: theme("Sous-type de l'evenement"),
            hint: Text('Selectionner type'),
            validators: [FormBuilderValidators.required()],
            items: listtype
                .map((value) =>
                    DropdownMenuItem(value: value, child: Text("$value")))
                .toList(),
          ),
        ],
      ),
      FormBuilderChoiceChip(
        attribute: "date",
        options: [
          FormBuilderFieldOption(child: Text("Aujourd'hui"), value: "today"),
          FormBuilderFieldOption(child: Text("Demain"), value: "tomorrow"),
          FormBuilderFieldOption(
              child: Text("Prochaine semaine"), value: "next_week"),
          FormBuilderFieldOption(
              child: Text("Prochaine mois"), value: "next_month"),
        ],
        validators: [FormBuilderValidators.required()],
      ),
      FormBuilderDateTimePicker(
        attribute: "date",
        inputType: InputType.date,
        format: DateFormat("dd-MM-yyyy"),
        decoration: theme("ou choisir une date"),
      )
    ],
  ));
}
