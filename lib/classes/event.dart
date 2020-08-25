import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

class Event {
  String nom;
  String description;
  String dateDebut;
  String dateFin;
  String photo;
  Position pos;
  String nbPlaceDispo;
  String prix;
  String type;
  String sousType;
  List age;
  List sexe;
  List domaine;
  String contactEmail;
  String contactNum;
  String contactLien;
  String lieu = "";

  Event(
      this.nom,
      this.description,
      this.dateDebut,
      this.dateFin,
      this.pos,
      this.nbPlaceDispo,
      this.prix,
      this.type,
      this.sousType,
      this.age,
      this.sexe,
      this.domaine,
      this.contactEmail,
      this.contactNum,
      this.contactLien) {
    setLieu();
  }

  void setLieu() async {
    final coordinates = new Coordinates(this.pos.latitude, this.pos.longitude);
    var list = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = list.first;
    lieu = "${first.addressLine}";
  }

  Event.fromJson(Map<String, dynamic> json)
      : nom = json['nom'],
        description = json['description'],
        dateDebut = new DateFormat('yyyy-MM-dd hh:mm:ss')
            .format(DateTime.parse(json['datedebut'])),
        dateFin = new DateFormat('yyyy-MM-dd hh:mm:ss')
            .format(DateTime.parse(json['datefin'])),
        nbPlaceDispo = json['nb_place_dispo'],
        prix = json['prix'],
        type = json['type'],
        sousType = json['sous-type'],
        age = json['age'],
        sexe = json['sexe'],
        domaine = json['domaine'],
        contactEmail = json['contactEmail'],
        contactNum = json['contactNum'],
        contactLien = json['contactLien'],
        photo = json['photo'],
        pos =
            Position(latitude: json['latitude'], longitude: json['longitude']);

  Map<String, dynamic> toJson() => {
        'nom': nom,
        'description': description,
        'datedebut': dateDebut,
        'datefin': dateFin,
        'photo': photo,
        'latitude': pos.latitude,
        'longitude': pos.longitude,
        'nb_place_dispo': nbPlaceDispo,
        'prix': prix,
        'type': type,
        'sous_type': sousType,
        'age': age,
        'sexe': sexe,
        'domaine': domaine,
        'contactEmail': contactEmail,
        'contactNum': contactNum,
        'contactLien': contactLien
      };

  Event.fromMap(Map<String, dynamic> json)
      : nom = json['nom'],
        description = json['description'],
        dateDebut = new DateFormat('yyyy-MM-dd hh:mm:ss')
            .format(DateTime.parse(json['datedebut'])),
        dateFin = new DateFormat('yyyy-MM-dd hh:mm:ss')
            .format(DateTime.parse(json['datefin'])),
        nbPlaceDispo = json['nb_place_dispo'],
        prix = json['prix'],
        type = json['type'],
        sousType = json['sous_type'],
        age = json['age'],
        sexe = json['sexe'],
        domaine = json['domaine'],
        contactEmail = json['contactEmail'],
        contactNum = json['contactNum'],
        contactLien = json['contactLien'],
        photo = json['photo'],
        pos =
            Position(latitude: json['latitude'], longitude: json['longitude']);

  Map<String, dynamic> toMap() => {
        'nom': nom,
        'description': description,
        'datedebut': dateDebut,
        'datefin': dateFin,
        'photo': photo,
        'latitude': pos.latitude,
        'longitude': pos.longitude,
        'nb_place_dispo': nbPlaceDispo,
        'prix': prix,
        'type': type,
        'sous_type': sousType,
        'age': age,
        'sexe': sexe,
        'domaine': domaine,
        'contactEmail': contactEmail,
        'contactNum': contactNum,
        'contactLien': contactLien
      };
}
