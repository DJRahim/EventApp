import 'package:eventapp/classes/profession.dart';
import 'package:eventapp/classes/sexe.dart';
import 'package:eventapp/classes/sous_type.dart';
import 'package:geolocator/geolocator.dart';

class Normal {
  String nom;
  String prenom;
  String email;
  String registerId;
  String age;
  String sexe;
  int numtel;
  String profession;
  Position location;
  List<SousType> listeInteret;

  Normal(
    this.nom,
    this.prenom,
    this.email,
    this.registerId,
    this.age,
    this.sexe,
    this.profession,
    this.numtel,
    this.location,
  );

  Normal.fromJson(Map<String, dynamic> json)
      : registerId = json['registerId'],
        nom = json['nom'],
        prenom = json['prenom'],
        email = json['email'],
        age = json['age'],
        sexe = json['sexe'],
        profession = json['profession'],
        numtel = json['numtel'],
        location =
            Position(latitude: json['latitutde'], longitude: json['longitude']);

  Map<String, dynamic> toJson() => {
        'registerId': registerId,
        'nom': nom,
        'prenom': prenom,
        'email': email,
        'age': age,
        'sexe': sexe,
        'profession': profession,
        'numtel': numtel,
        'latitude': location.latitude,
        'longitude': location.longitude
      };

  Normal.fromMap(Map<String, dynamic> json)
      : registerId = json['registerId'],
        nom = json['nom'],
        prenom = json['prenom'],
        email = json['email'],
        age = json['age'],
        sexe = json['sexe'],
        profession = json['profession'],
        numtel = json['numtel'],
        location =
            Position(latitude: json['latitude'], longitude: json['longitude']);

  Map<String, dynamic> toMap() => {
        'registerId': registerId,
        'nom': nom,
        'prenom': prenom,
        'email': email,
        'age': age,
        'sexe': sexe,
        'profession': profession,
        'numtel': numtel,
        'latitude': location.latitude,
        'longitude': location.longitude
      };
}
