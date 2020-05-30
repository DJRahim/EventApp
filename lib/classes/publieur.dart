import 'package:eventapp/classes/user.dart';

class Publieur extends User {
  String nomSociete;

  Publieur(
      {String nom,
      String prenom,
      String email,
      String type,
      String registerId,
      this.nomSociete})
      : super(nom, prenom, email, registerId);
}
