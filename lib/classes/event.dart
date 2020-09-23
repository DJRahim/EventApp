import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

class Event {
  int idEvent;
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
  String age;
  String sexe;
  String domaine;
  String contactEmail;
  String contactNum;
  String contactLien;
  String lieu;
  String source;

  Event(
      [this.idEvent,
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
      this.contactLien,
      this.photo]) {
    setLieu();
  }

  void setLieu() async {
    if (pos == null) {
      lieu = "!";
    } else {
      final coordinates =
          new Coordinates(this.pos.latitude, this.pos.longitude);
      var list = await Geocoder.local.findAddressesFromCoordinates(coordinates);
      var first = list.first;
      lieu = "${first.addressLine}";
    }
  }

  Event.fromJson(Map<String, dynamic> json)
      : idEvent = json['id_evenment'],
        nom = json['Nom_Organisateur'],
        description = json['descritpion'],
        dateDebut = "0000-00-00 00:00:00" ?? json['Date_debut'],
        dateFin = "0000-00-00 00:00:00" ?? json['Date_fin'],
        nbPlaceDispo = json['Nombre_de_place_disponible'].toString(),
        prix = "!" ?? json['Prix'],
        type = json['id_type'],
        contactEmail = "!" ?? json['contact_email'],
        contactNum = "!" ?? json['contact_num'].toString(),
        contactLien = "!" ?? json['contact_lien'],
        photo = "!" ?? json['Photo'],
        source = json['source'],
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
        'nbPlaceDispo': nbPlaceDispo,
        'prix': prix,
        'type': type,
        'sousType': sousType,
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
        nbPlaceDispo = json['nbPlaceDispo'],
        prix = json['prix'],
        type = json['type'],
        sousType = json['sousType'],
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
        'nom': nom.toString(),
        'description': description.toString(),
        'datedebut': dateDebut.toString(),
        'datefin': dateFin.toString(),
        'photo': photo.toString(),
        'latitude': pos.latitude,
        'longitude': pos.longitude,
        'nbPlaceDispo': nbPlaceDispo.toString(),
        'prix': prix.toString(),
        'type': type.toString(),
        'sousType': sousType.toString(),
        'age': age.toString(),
        'sexe': sexe.toString(),
        'domaine': domaine.toString(),
        'contactEmail': contactEmail.toString(),
        'contactNum': contactNum.toString(),
        'contactLien': contactLien.toString()
      };
}
