import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';

class Event {
  String nom;
  String corps;
  DateTime dateDebut;
  DateTime dateFin;
  String photoUrl;
  Position pos;
  String lieu = "";

  Event(this.nom, this.corps, this.dateDebut, this.dateFin, this.pos,
      this.photoUrl) {
    getLieu();
  }

  void getLieu() async {
    final coordinates = new Coordinates(this.pos.latitude, this.pos.longitude);

    Geocoder.local.findAddressesFromCoordinates(coordinates).then((addresses) {
      var first = addresses.first;
      var k = "${first.addressLine}";
      this.lieu = k;
    });
  }
}
