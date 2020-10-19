import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:eventapp/classes/event.dart';
import 'package:eventapp/classes/publieur.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
      child: AutoSizeText(
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

Widget map(double lat, double long, BuildContext context, List<Marker> m,
    void action(GoogleMapController c)) {
  return Container(
    height: 320,
    width: MediaQuery.of(context).size.width,
    child: GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: CameraPosition(
        target: LatLng(0.0, 0.0) ?? LatLng(lat, long),
        zoom: 14.4746,
      ),
      onMapCreated: action,
      markers: Set.from(m),
    ),
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
            map(e.pos.latitude, e.pos.longitude, context, m, action),
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
                          SizedBox(
                            child: AutoSizeText(
                                "    De : " +
                                    DateFormat('dd-MM-yyyy hh:mm:ss')
                                        .format(DateTime.parse(e.dateDebut)),
                                style: Theme.of(context).textTheme.bodyText2),
                          ),
                          SizedBox(
                            child: AutoSizeText(
                                "A : " +
                                    DateFormat('dd-MM-yyyy hh:mm:ss')
                                        .format(DateTime.parse(e.dateFin)) +
                                    "    ",
                                style: Theme.of(context).textTheme.bodyText2),
                          ),
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
                              SizedBox(
                                child: AutoSizeText(
                                  e.nom,
                                  style: Theme.of(context).textTheme.headline2,
                                ),
                              ),
                              SizedBox(height: 10.0),
                              SizedBox(
                                child: AutoSizeText(
                                  e.description,
                                  style: Theme.of(context).textTheme.bodyText2,
                                ),
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
                            SizedBox(
                              child: AutoSizeText(
                                "Nombre de place disponible : ",
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                            ),
                            SizedBox(
                              child: AutoSizeText(
                                e.nbPlaceDispo,
                                style: Theme.of(context).textTheme.bodyText2,
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
                            SizedBox(
                              child: AutoSizeText(
                                "Cet evenement est :  ",
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                            ),
                            SizedBox(
                              child: AutoSizeText(
                                e.prix + " ",
                                style: Theme.of(context).textTheme.bodyText2,
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
                            SizedBox(
                              child: AutoSizeText(
                                "Contact",
                                style: Theme.of(context).textTheme.headline2,
                              ),
                            ),
                            SizedBox(height: 10.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(
                                  child: AutoSizeText(
                                    "email : ",
                                    style:
                                        Theme.of(context).textTheme.bodyText2,
                                  ),
                                ),
                                SizedBox(
                                  child: AutoSizeText(
                                    e.contactEmail + " ",
                                    style:
                                        Theme.of(context).textTheme.bodyText2,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(
                                  child: AutoSizeText(
                                    "numero : ",
                                    style:
                                        Theme.of(context).textTheme.bodyText2,
                                  ),
                                ),
                                SizedBox(
                                  child: AutoSizeText(
                                    e.contactNum + " ",
                                    style:
                                        Theme.of(context).textTheme.bodyText2,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(
                                  child: AutoSizeText(
                                    "URL : ",
                                    style:
                                        Theme.of(context).textTheme.bodyText2,
                                  ),
                                ),
                                SizedBox(
                                  child: AutoSizeText(
                                    e.contactLien + " ",
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 5,
                                    style:
                                        Theme.of(context).textTheme.bodyText2,
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
                            SizedBox(
                              child: AutoSizeText(
                                "Image",
                                style: TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.w600),
                              ),
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

String typeOrNot(String type) {
  var a = [
    "Music",
    "Cinema",
    "Loisirs",
    "Theatre",
    "Arts",
    "Sport",
    "Sante",
    "Voyage",
    "Fetes",
    "Bienfaisance",
    "Religion",
  ];

  if (a.contains(type.toString())) {
    return type;
  } else {
    var z = idTypeToNom(type);
    if (a.contains(z)) {
      return z;
    }
    return "Autre";
  }
}

// Ceci est un widget qui represente un evenement dans une liste

Widget eventItem(Event e, BuildContext context, String person) {
  var x = typeOrNot(e.type);
  // e.setLieu();
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
                  image: AssetImage('assets/$x.jpg'),
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
                          SizedBox(
                            child: AutoSizeText(e.nom,
                                style: Theme.of(context).textTheme.bodyText1),
                          ),
                          SizedBox(height: 10.0),
                          SizedBox(
                            child: AutoSizeText(e.lieu ?? "!!",
                                style: Theme.of(context).textTheme.bodyText1),
                          ),
                          SizedBox(height: 15.0),
                        ],
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(height: 10.0),
                        SizedBox(
                          child: AutoSizeText(
                              'De: ' +
                                  DateFormat('d/M/y')
                                      .format(DateTime.parse(e.dateDebut)),
                              style: Theme.of(context).textTheme.bodyText1),
                        ),
                        SizedBox(height: 15.0),
                        SizedBox(
                          child: AutoSizeText(
                              '  A: ' +
                                  DateFormat('d/M/y')
                                      .format(DateTime.parse(e.dateFin)),
                              style: Theme.of(context).textTheme.bodyText1),
                        ),
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
    emptyDataIcon: Icon(Icons.refresh, size: 40.0, color: Colors.teal[200]),
    emptyDataText: "Pas d'evenements",
    emptyErrorIcon: Icon(Icons.error, size: 40.0, color: Colors.redAccent),
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
    emptyDataIcon: Icon(Icons.refresh, size: 40.0, color: Colors.teal[200]),
    emptyDataText: "Pas de publieur",
    emptyErrorIcon: Icon(Icons.error, size: 40.0, color: Colors.redAccent),
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
                    SizedBox(
                      child: AutoSizeText(
                        "Nom du publieur : ",
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ),
                    SizedBox(
                      child: AutoSizeText(
                        p.nom + " ",
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      child: AutoSizeText(
                        "Email : ",
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ),
                    SizedBox(
                      child: AutoSizeText(
                        p.email + " ",
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      child: AutoSizeText(
                        "Nom du son organisme : ",
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ),
                    SizedBox(
                      child: AutoSizeText(
                        p.organisme + " ",
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
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
                            'profil/admin/valider_publieur?etat=0&id_publieur=${p.idPub}',
                            {});

                        var c = jsonDecode(a);

                        print(c);
                      }),
                    ),
                    SizedBox(width: 5),
                    Expanded(
                      child: button(context, "Bloquer", () async {
                        var a = await auth.getRequest(
                            'profil/admin/valider_publieur?etat=1&id_publieur=${p.idPub}',
                            {});

                        var c = jsonDecode(a);

                        print(c);
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

idTypeToNom(String id) {
  switch (id) {
    case '1':
      return "Music";
      break;
    case '2':
      return "Cinema";
      break;
    case '3':
      return "Loisirs";
      break;
    case '4':
      return "Theatre";
      break;
    case '5':
      return "Arts";
      break;
    case '6':
      return "Sport";
      break;
    case '7':
      return "Sante";
      break;
    case '8':
      return "Voyage";
      break;
    case '9':
      return "Fetes";
      break;
    case '10':
      return "Bienfaisance";
      break;
    case '11':
      return "Religion";
      break;
    default:
      return "Autre";
  }
}

initTypeSousType() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  prefs.setStringList("Type", [
    "Music",
    "Cinema",
    "Loisirs",
    "Theatre",
    "Arts",
    "Sport",
    "Sante",
    "Voyage",
    "Fetes",
    "Bienfaisance",
    "Religion",
  ]);

  prefs.setStringList(
      "Music", ["Rai", "Chaabi", "Traditionnel", "Rap", "Rock", "Jazz"]);

  prefs.setStringList("Cinema", [
    "Horreur",
    "Comedie",
    "Science-Fiction",
    "Action",
    "Aventure",
    "Crime",
    "Documentaire",
    "Animation",
    "Guerre",
    "Romance",
    "Mystere",
    "Drama",
    "Sport",
    "Super-Heros",
    "Historique"
  ]);

  prefs.setStringList("Loisirs",
      ["Jeux", "Cirque", "Photographie", "dessin", "Peinture", "Lecture"]);

  prefs.setStringList(
      "Arts", ["Dance", "Beaux-Arts", "Art-litteraire", "Artisanat", "Opera"]);

  prefs.setStringList("Sport", [
    "Football",
    "Basketball",
    "Handball",
    "Volleyball",
    "Natation",
    "Automobile",
    "Arts-martiaux"
  ]);

  prefs.setStringList(
      "Sante", ["Ftness", "Sante-mentale", "Yoga", "Medecine-naturelle"]);

  prefs.setStringList(
      "Voyage", ["Escalade", "Voyages", "Visite", "Randonnee", "Camping"]);

  prefs.setStringList("Fetes", [
    "nationale",
    "religieuse",
    "Journee-nationale",
    "Journee-mondiale",
    "Activite-saisonniere"
  ]);

  prefs.setStringList("Bienfaisance",
      ["Environnement", "Droit-humain", "animal", "Pauverete", "Nettoyage"]);

  prefs.setStringList(
      "Religion", ["concours", "cercle", "conference", "charite"]);
}

addEventsTest(String token) async {
  var e = new Event(
      0,
      "MUSEE NATIONAL DU MOUJAHID",
      "Ouvert en 1984, le musée retrace les différentes luttes en consacrant une bonne partie de ses collections à la lutte contre la présence française et à la guerre dAlgérie : expositions darmes, objets de guerre, documents darchives, photos, rapports, le plus souvent accompagnées détiquettes explicatives en arabe. Vous découvrirez notamment de nombreux objets personnels et armes ayant appartenu à lémir Abdelkader ainsi quun portrait de lui peint en 1853 par Ange Tissier, remis au pays par la France en 1976. Parmi les objets les plus intéressants : léventail avec lequel le dey Hussein a souffleté le consul de France en 1827, ce qui aurait provoqué la prise dAlger par les Français en 1830. Une visite intéressante pour confronter les points de vue... Au sous-sol du musée se trouve la crypte.\nOuvert tous les jours de De 9h à 16h45. Entrée 20 DA.",
      '2020-09-01 09:00:00',
      '2020-12-23 16:45:00',
      new Position(latitude: 36.742848, longitude: 3.070210),
      "900",
      "payant",
      "5",
      "5",
      "ijdls",
      "sjdjsd",
      "sljdskd",
      "museemoujahid@gmail.com",
      "021669208",
      "https://www.kherdja.com/detail-guide/7545-musee-national-du-moujahid.html",
      "kdufs");

  var a = await auth.getRequest(
      'profil/nouveau_evenement?token=$token&Nom_Organisateur=${e.nom}&categorie=festival&id_type=Voyage&Nombre_de_place_disponible=${e.nbPlaceDispo}&profil=18-34,homme,Cinema,Voyage,Music,Jazz,Comedie,Camping,&Prix=${e.prix}&Date_debut=${e.dateDebut}&Date_fin=${e.dateFin}&Photo=jnbjn&latitude=${e.pos.latitude}&longitude=${e.pos.longitude}&descritpion=${e.description}&contact_email=${e.contactEmail}&contact_num=${e.contactNum}&contact_lien=${e.contactLien}',
      {});

  var c = jsonDecode(a);

  print(c);

  var e1 = new Event(
      0,
      "MUSEE NATIONAL CIRTA",
      "Le Musée de Cirta de Constantine, présente le passé de la ville de la préhistoire, aux périodes numide, romaine, hafside, ottomane et coloniale ainsi que des vestiges de Tiddis et de la Kalâa des Béni Hammad.Horaires de la Visitedu Samedi au Jeudi de 08.00h à 12h midi et du 13.00h à 17.00h soirle Vendredi de 13.30h à 17.00h",
      '2020-10-01 08:00:00',
      '2020-10-02 17:00:00',
      new Position(latitude: 36.362784, longitude: 6.606032),
      "200",
      "gratuit",
      "8",
      "5",
      "ijdls",
      "sjdjsd",
      "sljdskd",
      "cirtaconstantine@gmail.com",
      "031921938",
      "https://www.kherdja.com/detail-guide/7556-musee-national-cirta-de-constantine.html",
      "kdufs");

  var a1 = await auth.getRequest(
      'profil/nouveau_evenement?token=$token&Nom_Organisateur=${e1.nom}&categorie=festival&id_type=Voyage&Nombre_de_place_disponible=${e1.nbPlaceDispo}&profil=18-34,homme,Cinema,Voyage,Music,Jazz,Comedie,Camping,&Prix=${e1.prix}&Date_debut=${e1.dateDebut}&Date_fin=${e1.dateFin}&Photo=jnbjn&latitude=${e1.pos.latitude}&longitude=${e1.pos.longitude}&descritpion=${e1.description}&contact_email=${e1.contactEmail}&contact_num=${e1.contactNum}&contact_lien=${e1.contactLien}',
      {});

  var c1 = jsonDecode(a1);

  print(c1);

  var e2 = new Event(
      0,
      "MUSÉE NATIONAL DE PRÉHISTOIRE",
      "Ancienne demeure de style turc, située en haut de lavenue Didouche Mourad, sous le Palais du Peuple, est lexemple classique des belles maisons de style turc construites sur les hauteurs dAlger. A linstar des Palais de la Casbah, celles-ci se distinguent par la richesse de leur déco : colonnades et escaliers de marbre, faïences italiennes et portugaises alliées aux boiseries, jardins secrets. Dans les patios, où flotte une suave senteur de jasmin, chantent de magnifiques jets deau. La villa du Bardo abrite le musée de la Préhistoire et de lEthnographie, lun des plus riches et des plus intéressants dAfrique.",
      '2021-01-20 09:00:00',
      '2021-02-20 22:00:00',
      new Position(latitude: 36.761016, longitude: 3.047209),
      "1000",
      "payant",
      "5",
      "5",
      "ijdls",
      "sjdjsd",
      "sljdskd",
      "teripark@gmail.com",
      "021612677",
      "http://www.bardo-museum.dz/index.php/fr/",
      "kdufs");

  var a2 = await auth.getRequest(
      'profil/nouveau_evenement?token=$token&Nom_Organisateur=${e2.nom}&categorie=festival&id_type=Arts&Nombre_de_place_disponible=${e2.nbPlaceDispo}&profil=18-34,homme,Cinema,Voyage,Music,Jazz,Comedie,Camping,&Prix=${e2.prix}&Date_debut=${e2.dateDebut}&Date_fin=${e2.dateFin}&Photo=jnbjn&latitude=${e2.pos.latitude}&longitude=${e2.pos.longitude}&descritpion=${e2.description}&contact_email=${e2.contactEmail}&contact_num=${e2.contactNum}&contact_lien=${e2.contactLien}',
      {});

  var c2 = jsonDecode(a2);

  print(c2);

  var e3 = new Event(
      0,
      "TERI PARK",
      "Un nouvel espace dattractions, de divertissements et de loisirs vous ouvre ses portes!, Teri Park, situé à Chéraga, ouvre ses portes pour le plus grand bonheur des plus petits, mais aussi de toute la famille, un lieu entièrement dédié au divertissements et aux loisirs, sétendant sur plus de 7000 M2 couvert, avec parking.  Manèges, parcours, boutiques, cinéma 5D, restauration et bien dautres services vous seront proposés, autant vous dire que les enfants ne voudront pas sortir de là!, Horaires douverture:, \nHiver: \n Du dimanche au mercredi: de 14h00 à 21h00. \n Jeudi : de 14h00 à 22h00.  \n Vendredi : de 15h00 à 22h00. \n Samedi : de 11h00 à 21h00. \nEté:Du dimanche au jeudi et samedi : de 11h00 à Minuit. \n Vendredi : de 15h00 à minuit. \nRamadhan:, Tous les jours de la semaine après lftour de 22h00 à 02h00 du matin.    \nTarifs et modes daccès: \n - Le premier accès est conditionné par lachat dune carte familiale (nombre maximum : 5 personnes par carte) \n - Le prix de la carte est fixé à 1200 DA \n - La première carte inclut 20 points que vous pouvez utiliser pour accéder à quelques attractions de votre choix \n - Laccès aux attractions vous coûtera entre 2 et 6 points \n - Le prix d1 point est de 50 DA \n - La carte devient la propriété de son acquéreur dès le premier achat, est rechargeable au niveau de nos caisses et bornes automatiques et reste valable pendant une année \n - Le second accès ne requiert pas lachat dune autre carte, la première étant rechargeable (vous pouvez acheter le nombre de points que vous désirez).  \nLachat de la carte Teri Park vous offre plusieurs avantages : \n Parking gratuit et sécurisé (également pour personnes à mobilité réduite) \n Accès à l’espace pour bébés \n Infirmerie pour les premiers soins, Sachez que Teri Park offre des bonus en fonction du niveau de vos recharges. Les bonus peuvent atteindre jusquà 60 points.",
      '2020-11-21 14:00:00',
      '2021-03-21 22:00:00',
      new Position(latitude: 36.762076, longitude: 2.923454),
      "900",
      "payant",
      "3",
      "5",
      "ijdls",
      "sjdjsd",
      "sljdskd",
      "teripark@gmail.com",
      "0560062276",
      "https://www.facebook.com/TeriParkDZ/",
      "kdufs");

  var a3 = await auth.getRequest(
      'profil/nouveau_evenement?token=$token&Nom_Organisateur=${e3.nom}&categorie=festival&id_type=Loisirs&Nombre_de_place_disponible=${e3.nbPlaceDispo}&profil=18-34,homme,Cinema,Voyage,Music,Jazz,Comedie,Camping,&Prix=${e3.prix}&Date_debut=${e3.dateDebut}&Date_fin=${e3.dateFin}&Photo=jnbjn&latitude=${e3.pos.latitude}&longitude=${e3.pos.longitude}&descritpion=${e3.description}&contact_email=${e3.contactEmail}&contact_num=${e3.contactNum}&contact_lien=${e3.contactLien}',
      {});

  var c3 = jsonDecode(a3);

  print(c3);

  var e4 = new Event(
      0,
      "HAVANA MUSIC AND FOOD (SAID HAMDINE)",
      "Le Rendez-vous incontournable des amateurs de Grillades (viande et poisson). Ambiance Tropicale Cubaine. Situé à Said Hamdine, cest le second établissement après celui du centre commercial de Bab Ezzouar-Alger. Le Nouveau lieu  des sorties Algéroises.....\nStyle Culinaire: Barbecue Brunch Dîners Français.",
      '2020-11-22 11:00:00',
      '2020-12-23 22:00:00',
      new Position(latitude: 36.730020, longitude: 3.031236),
      "300",
      "payant",
      "1",
      "5",
      "ijdls",
      "sjdjsd",
      "sljdskd",
      "havanamusic@gmail.com",
      "0782362002",
      "http://www.havana-dz.com/",
      "kdufs");

  var a4 = await auth.getRequest(
      'profil/nouveau_evenement?token=$token&Nom_Organisateur=${e4.nom}&categorie=festival&id_type=Music&Nombre_de_place_disponible=${e4.nbPlaceDispo}&profil=18-34,homme,Cinema,Voyage,Music,Jazz,Comedie,Camping,&Prix=${e4.prix}&Date_debut=${e4.dateDebut}&Date_fin=${e4.dateFin}&Photo=jnbjn&latitude=${e4.pos.latitude}&longitude=${e4.pos.longitude}&descritpion=${e4.description}&contact_email=${e4.contactEmail}&contact_num=${e4.contactNum}&contact_lien=${e4.contactLien}',
      {});

  var c4 = jsonDecode(a4);

  print(c4);

  var e5 = new Event(
      0,
      "OPÉRA DALGER (BOUALEM BESSAIH)",
      "Un bâtiment, un édifice qui témoigne des relations entre la Chine et lAlgérie. LOpéra est cadeau de la Chine à lAlgérie. \nBâti sur un terrai de 4 hectares, situé à Oueld Fayet, il a été conçu selon notre architecture locale. \nPouvant accueillir jusquà 1400 places, il a pour but de promouvoir notre patrimoine national, mais aussi le patrimoine universel.",
      '2020-11-30 10:00:00',
      '2021-06-30 23:00:00',
      new Position(latitude: 36.737898, longitude: 2.930429),
      "1200",
      "payant",
      "1",
      "5",
      "ijdls",
      "sjdjsd",
      "sljdskd",
      "operaalger@gmail.com",
      "022768023",
      "https://www.facebook.com/operaalger/",
      "kdufs");

  var a5 = await auth.getRequest(
      'profil/nouveau_evenement?token=$token&Nom_Organisateur=${e5.nom}&categorie=festival&id_type=Music&Nombre_de_place_disponible=${e5.nbPlaceDispo}&profil=18-34,homme,Cinema,Voyage,Music,Jazz,Comedie,Camping,&Prix=${e5.prix}&Date_debut=${e5.dateDebut}&Date_fin=${e5.dateFin}&Photo=jnbjn&latitude=${e5.pos.latitude}&longitude=${e5.pos.longitude}&descritpion=${e5.description}&contact_email=${e5.contactEmail}&contact_num=${e5.contactNum}&contact_lien=${e5.contactLien}',
      {});

  var c5 = jsonDecode(a5);

  print(c5);

  var e6 = new Event(
      0,
      "INSTITUT FRANÇAIS D ALGER",
      "Centre Culturel Français (CCF) en Algerie\nSitué au cœur de la ville, à deux pas de la Grande Poste et de la Wilaya, lInstitut français dAlger est un lieu de rencontres et déchanges, ainsi quun des acteurs de la vie culturelle et artistique algéroise.",
      '2020-12-22 09:00:00',
      '2021-04-10 20:00:00',
      new Position(latitude: 36.774670, longitude: 3.060132),
      "700",
      "gratuit",
      "5",
      "5",
      "ijdls",
      "sjdjsd",
      "sljdskd",
      "institutfrancaisalger@gmail.com",
      "021737820",
      "http://www.if-algerie.com/alger/linstitut",
      "kdufs");

  var a6 = await auth.getRequest(
      'profil/nouveau_evenement?token=$token&Nom_Organisateur=${e6.nom}&categorie=festival&id_type=Voyage&Nombre_de_place_disponible=${e6.nbPlaceDispo}&profil=18-34,homme,Cinema,Voyage,Music,Jazz,Comedie,Camping,&Prix=${e6.prix}&Date_debut=${e6.dateDebut}&Date_fin=${e6.dateFin}&Photo=jnbjn&latitude=${e6.pos.latitude}&longitude=${e6.pos.longitude}&descritpion=${e6.description}&contact_email=${e6.contactEmail}&contact_num=${e6.contactNum}&contact_lien=${e6.contactLien}',
      {});

  var c6 = jsonDecode(a6);

  print(c6);
}
