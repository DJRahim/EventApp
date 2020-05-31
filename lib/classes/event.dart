import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';

class Event {
  String nom;
  String corps;
  DateTime dateDebut;
  DateTime dateFin;
  // String photoUrl;
  Position pos;
  String lieu = "";

  Event(this.nom, this.corps, this.dateDebut, this.dateFin, this.pos) {
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
        corps = json['corps'],
        dateDebut = DateTime.parse(json['datedebut']),
        dateFin = DateTime.parse(json['datefin']),
        // photoUrl = json['photo'],
        pos =
            Position(latitude: json['latitutde'], longitude: json['longitude']);

  Map<String, dynamic> toJson() => {
        'nom': nom,
        'corps': corps,
        'datedebut': dateDebut,
        'datefin': dateFin,
        // 'photoUrl': photoUrl,
        'latitude': pos.latitude,
        'longitude': pos.longitude
      };

  Event.fromMap(Map<String, dynamic> json)
      : nom = json['nom'],
        corps = json['corps'],
        dateDebut = DateTime.parse(json['datedebut']),
        dateFin = DateTime.parse(json['datefin']),
        // photoUrl = json['photo'],
        pos =
            Position(latitude: json['latitude'], longitude: json['longitude']);

  Map<String, dynamic> toMap() => {
        'nom': nom,
        'corps': corps,
        'datedebut': dateDebut.toString(),
        'datefin': dateFin.toString(),
        // 'photoUrl': photoUrl,
        'latitude': pos.latitude,
        'longitude': pos.longitude
      };
}
