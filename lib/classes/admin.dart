import 'package:eventapp/classes/user.dart';

class Admin extends User {
  Admin({
    String nom,
    String prenom,
    String email,
    String type,
    String registerId,
  }) : super(nom, prenom, email, registerId);
}
