import 'package:geolocator/geolocator.dart';

class Normal {
  String nom;
  String email;
  String registerId;
  String age;
  String sexe;
  String domaine;
  Position location;
  List<String> listeInteret;

  Normal(
    this.nom,
    this.email,
    this.registerId,
    this.age,
    this.sexe,
    this.domaine,
    this.location,
  );

  Normal.fromJson(Map<String, dynamic> json)
      : nom = json['nom'],
        email = json['email'],
        age = json['age'],
        sexe = json['sexe'],
        domaine = json['domaine'],
        location =
            Position(latitude: json['latitutde'], longitude: json['longitude']);

  Map<String, dynamic> toJson() => {
        'nom': nom,
        'email': email,
        'age': age,
        'sexe': sexe,
        'domaine': domaine,
        'latitude': location.latitude,
        'longitude': location.longitude
      };

  Normal.fromMap(Map<String, dynamic> json)
      : nom = json['nom'],
        email = json['email'],
        age = json['age'],
        sexe = json['sexe'],
        domaine = json['domaine'],
        location =
            Position(latitude: json['latitude'], longitude: json['longitude']);

  Map<String, dynamic> toMap() => {
        'nom': nom,
        'email': email,
        'age': age,
        'sexe': sexe,
        'domaine': domaine,
        'latitude': location.latitude,
        'longitude': location.longitude
      };
}
