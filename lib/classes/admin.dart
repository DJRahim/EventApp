import 'package:eventapp/classes/user.dart';

class Admin extends User {
  Admin({
    String nom,
    String email,
    String registerId,
  }) : super(nom, email, registerId);
}
