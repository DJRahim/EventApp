import 'package:eventapp/classes/profession.dart';
import 'package:eventapp/classes/sexe.dart';
import 'package:eventapp/classes/sous_type.dart';
import 'package:eventapp/classes/user.dart';
import 'package:geolocator/geolocator.dart';

class Normal extends User {
  int age;
  Sexe sexe;
  int numtel;
  Profession profession;
  Position location;
  List<SousType> listeInteret;

  Normal(
      {String nom,
      String prenom,
      String email,
      String type,
      String registerId,
      this.age,
      this.sexe,
      this.profession,
      this.numtel,
      this.location,
      this.listeInteret})
      : super(nom, prenom, email, registerId);
}
