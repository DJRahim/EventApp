import 'dart:convert';

import 'package:eventapp/classes/event.dart';
import 'package:eventapp/classes/publieur.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:intl/intl.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uic/list_uic.dart';
import 'package:eventapp/tools/auth.dart' as auth;

// Ceci est un widget globale pour les boutons
Material button(BuildContext context, String s, void action()) {
  return Material(
    elevation: 3,
    borderRadius: BorderRadius.circular(30.0),
    color: Colors.lightBlue[400],
    child: MaterialButton(
      minWidth: MediaQuery.of(context).size.width,
      padding: EdgeInsets.fromLTRB(15.0, 12.0, 15.0, 12.0),
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
      contentPadding: EdgeInsets.fromLTRB(18.0, 14.0, 18.0, 14.0),
      labelText: s,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(32.0),
      ));
}

// Ceci est un widget globale pour les champs de saisie
TextFormField textField(String s1, String s2, TextEditingController a) {
  return TextFormField(
    obscureText: true,
    controller: a,
    decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(18.0, 14.0, 18.0, 14.0),
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
  return SingleChildScrollView(
    child: Card(
      elevation: 5,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 320,
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
            Container(
              width: MediaQuery.of(context).size.width,
              child: Card(
                  elevation: 4,
                  color: Colors.white,
                  child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text("    De : " + e.dateDebut,
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                          Text("A : " + e.dateFin + "    ",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                        ],
                      ))),
            ),
            SizedBox(height: 20.0),
            Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Card(
                        elevation: 4,
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                e.nom,
                                style: TextStyle(
                                    fontSize: 28, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 10.0),
                              Text(
                                e.description,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w100),
                              ),
                              SizedBox(height: 20.0),
                            ],
                          ),
                        )),
                  ),
                  SizedBox(height: 15.0),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Card(
                      elevation: 4,
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Nombre de place disponible : ",
                              style: TextStyle(
                                  fontSize: 19, fontWeight: FontWeight.w600),
                            ),
                            Text(
                              e.nbPlaceDispo,
                              style: TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.w600,
                                color: Colors.red[700],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 15.0),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Card(
                      elevation: 4,
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Cet evenement est :  ",
                              style: TextStyle(
                                  fontSize: 19, fontWeight: FontWeight.w600),
                            ),
                            Text(
                              e.prix + " ",
                              style: TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.w600,
                                color: Colors.green[700],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 15.0),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Card(
                      elevation: 4,
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Contact",
                              style: TextStyle(
                                  fontSize: 21, fontWeight: FontWeight.w600),
                            ),
                            SizedBox(height: 10.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "email : ",
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w100),
                                ),
                                Text(
                                  e.contactEmail + " ",
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w100),
                                ),
                              ],
                            ),
                            SizedBox(height: 10.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "numero : ",
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w100),
                                ),
                                Text(
                                  e.contactNum + " ",
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w100),
                                ),
                              ],
                            ),
                            SizedBox(height: 10.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    "URL : ",
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w100),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    e.contactLien + " ",
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 5,
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w100,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Card(
                      elevation: 4,
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Column(
                          children: <Widget>[
                            Text(
                              "Image",
                              style: TextStyle(
                                  fontSize: 21, fontWeight: FontWeight.w600),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Image.network(
                              e.photo,
                              width: MediaQuery.of(context).size.width,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    ),
  );
}

// Ceci est un widget qui represente un evenement dans une liste

Widget eventItem(Event e, BuildContext context, String person) {
  return Column(
    children: <Widget>[
      GestureDetector(
        child: Card(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Column(
              children: <Widget>[
                Image(
                  image: AssetImage('assets/${e.type}.jpg'),
                  height: 130,
                  width: 200,
                ),
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(height: 10.0),
                          Text(e.nom,
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600)),
                          SizedBox(height: 10.0),
                          Text(e.lieu,
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w600)),
                          SizedBox(height: 15.0),
                        ],
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(height: 10.0),
                        Text(
                            'De: ' +
                                DateFormat('y/d/M')
                                    .format(DateTime.parse(e.dateDebut)),
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.w600)),
                        SizedBox(height: 15.0),
                        Text(
                            '  A: ' +
                                DateFormat('y/d/M')
                                    .format(DateTime.parse(e.dateFin)),
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.w600)),
                      ],
                    ),
                    SizedBox(height: 15.0),
                  ],
                ),
              ],
            ),
          ),
          elevation: 5,
        ),
        onTap: () {
          Navigator.pushNamed(context, '/event', arguments: [e, person]);
        },
      ),
      SizedBox(height: 5)
    ],
  );
}

// et ceci represente la liste des evenements

Widget listEvent(
    ListUicController<Event> uic, BuildContext context, String person) {
  return ListUic<Event>(
    controller: uic,
    itemBuilder: (item) {
      return eventItem(item, context, person);
    },
    emptyProgressText: "",
    emptyDataIcon: Icon(Icons.refresh, size: 52.0, color: Colors.teal[200]),
    emptyDataText: "Pas d'evenements",
    emptyErrorIcon: Icon(Icons.error, size: 52.0, color: Colors.redAccent),
    emptyErrorText: "Erreur de chargement",
    errorText: "Il y a un probleme",
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

// Ceci est une methode pour convetir la liste des enum vers une liste de String

List splitEnum(List a) {
  var b = List();
  for (int i = 0; i < a.length; i++) {
    b.add(a[i].toString().split('.')[1]);
  }

  return b;
}

// Ca est le menu des parametres

Widget drawer(BuildContext context, {List<Widget> listWidget}) {
  return Drawer(
      elevation: 10,
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: listWidget,
        ),
      ));
}

// Ceci est une barre qui s'affiche en bas et qui contient un message
SnackBar snackBar(String text, Color col) {
  return SnackBar(
    content: Text(text),
    action: SnackBarAction(
      label: '',
      onPressed: () {},
    ),
    backgroundColor: col,
  );
}

// Ca c'est pour afficher des message de confirmation (lorsque la deconnexion par exemple)
showAlertDialog(BuildContext context, String text1, String text2,
    void action1(), void action2()) {
  // set up the buttons
  Widget cancelButton = FlatButton(
    child: Text("Annuler"),
    onPressed: action1,
  );
  Widget continueButton = FlatButton(
    child: Text("Confirmer"),
    onPressed: action2,
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text(text1),
    content: Text(text2),
    actions: [
      cancelButton,
      continueButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

// et ceci represente la liste des publieurs

Widget listPublieur(ListUicController<Publieur> uic, BuildContext context) {
  return ListUic<Publieur>(
    controller: uic,
    itemBuilder: (item) {
      return publieurItem(item, context);
    },
    emptyProgressText: "",
    emptyDataIcon: Icon(Icons.refresh, size: 52.0, color: Colors.teal[200]),
    emptyDataText: "Pas de publieur",
    emptyErrorIcon: Icon(Icons.error, size: 52.0, color: Colors.redAccent),
    emptyErrorText: "Erreur de chargement",
    errorText: "Il y a un probleme",
    errorColor: Colors.blueGrey[200],
  );
}

Widget publieurItem(Publieur p, BuildContext context) {
  return Column(
    children: <Widget>[
      GestureDetector(
        child: Card(
          elevation: 5,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Column(
              children: <Widget>[
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Nom du publieur : ",
                      style:
                          TextStyle(fontSize: 19, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      p.nom + " ",
                      style:
                          TextStyle(fontSize: 19, fontWeight: FontWeight.w100),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Email : ",
                      style:
                          TextStyle(fontSize: 19, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      p.email + " ",
                      style:
                          TextStyle(fontSize: 19, fontWeight: FontWeight.w100),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Nom du son organisme : ",
                      style:
                          TextStyle(fontSize: 19, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      p.organisme + " ",
                      style:
                          TextStyle(fontSize: 19, fontWeight: FontWeight.w100),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: button(context, "Valider", () async {
                        var a = await auth.getRequest(
                            'profil/admin/valider_publieur?etat=2&id_publieur=${p.idPub}',
                            {});

                        var c = jsonDecode(a);
                      }),
                    ),
                    SizedBox(width: 5),
                    Expanded(
                      child: button(context, "Bloquer", () async {
                        // var a = await auth.getRequest('auth/', {});

                        // var c = jsonDecode(a);
                      }),
                    )
                  ],
                ),
                SizedBox(height: 15),
              ],
            ),
          ),
        ),
      )
    ],
  );
}

idTypeToNom(int id) {
  switch (id) {
    case 1:
      return "Music";
      break;
    case 2:
      return "Cinema";
      break;
    case 3:
      return "Loisirs";
      break;
    case 4:
      return "Theatre";
      break;
    case 5:
      return "Arts";
      break;
    case 6:
      return "Sport";
      break;
    case 7:
      return "Sante";
      break;
    case 8:
      return "Voyage";
      break;
    case 9:
      return "Fetes";
      break;
    case 10:
      return "Bienfaisance";
      break;
    case 11:
      return "Religion";
      break;
    default:
      return "Autre";
  }
}
