import 'package:geolocator/geolocator.dart';

class Normal {
  String nom;
  String email;
  String registerId;
  String age;
  String sexe;
  String profession;
  Position location;
  List<String> listeInteret;

  Normal(
    this.nom,
    this.email,
    this.registerId,
    this.age,
    this.sexe,
    this.profession,
    this.location,
  );

  Normal.fromJson(Map<String, dynamic> json)
      : registerId = json['registerId'],
        nom = json['nom'],
        email = json['email'],
        age = json['age'],
        sexe = json['sexe'],
        profession = json['profession'],
        location =
            Position(latitude: json['latitutde'], longitude: json['longitude']);

  Map<String, dynamic> toJson() => {
        'registerId': registerId,
        'nom': nom,
        'email': email,
        'age': age,
        'sexe': sexe,
        'profession': profession,
        'latitude': location.latitude,
        'longitude': location.longitude
      };

  Normal.fromMap(Map<String, dynamic> json)
      : registerId = json['registerId'],
        nom = json['nom'],
        email = json['email'],
        age = json['age'],
        sexe = json['sexe'],
        profession = json['profession'],
        location =
            Position(latitude: json['latitude'], longitude: json['longitude']);

  Map<String, dynamic> toMap() => {
        'registerId': registerId,
        'nom': nom,
        'email': email,
        'age': age,
        'sexe': sexe,
        'profession': profession,
        'latitude': location.latitude,
        'longitude': location.longitude
      };
}
