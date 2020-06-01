import 'dart:convert';
import 'package:eventapp/pages/home_page.dart';
import 'package:eventapp/pages/home_page_admin.dart';
import 'package:eventapp/pages/home_page_normal.dart';
import 'package:eventapp/pages/home_page_publieur.dart';
import 'package:eventapp/tools/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:eventapp/tools/auth.dart' as auth;
import 'package:shared_preferences/shared_preferences.dart';

import '../tools/database.dart';

// Cette page est pour la connexion de tous les utilisateurs par email et password
// Donc c'est une forme simple avec 2 champs de saisie et 2 bouttons
// 1- pour reinitialiser les champs
// 2- pour valider et envoyer

class ConnectPage extends StatefulWidget {
  ConnectPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  ConnectPageState createState() => ConnectPageState();
}

class ConnectPageState extends State<ConnectPage> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

// La methode qui permet de reinitialiser les champs
  void _reset() {
    _formKey.currentState.reset();
  }

// la mathode qui permet de valider et envoyer les champs a l'api
  void _confirm(BuildContext cont) async {
    if (_formKey.currentState.saveAndValidate()) {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      Map<String, String> c = Map.from(_formKey.currentState.value);
      var a = await auth.getRequest(
          'auth/se_connecter?email=${c['email']}&password=${c['password']}', c);

      var b = jsonDecode(a);
      // print(c);

      // print(b);

      var home;

      switch (b['type']) {
        case 2:
          home = MyHomePageNormal();
          var user = await DBProvider.db.getAllUsers();
          var us = user[0].toMap();

          // print(us);

          await auth.getRequest(
              "profil/upload?type=2&token=${b['token']}&nom=${us['nom']}&prenom=${us['prenom']}&id_phone=${prefs.getString('registerId')}&chois=['1','2','3','4','5']&age=${us['age']}&num=${us['numtel']}&profesion=${us['profession']}&sex=${us['sexe']}",
              {});
          break;
        case 1:
          home = MyHomePagePublieur();

          var user = await DBProvider.db.getAllPubli();
          var us = user[0].toMap();

          // print(us);

          await auth.getRequest(
              "profil/upload?type=1&token=${b['token']}&nom=${us['nom']}&prenom=${us['prenom']}&id_phone=${prefs.getString('registerId')}&nom_organis=serbess&num=988786",
              {});
          break;
        case 0:
          home = MyHomePageAdmin();
          break;
        default:
          home = MyHomePage();
      }

      if (home.toString() == 'MyHomePage') {
        Scaffold.of(cont).showSnackBar(
            snackBar('Probleme dans la connexion!', Colors.red[800]));
      } else {
        Scaffold.of(cont)
            .showSnackBar(snackBar('Connexion reussi!', Colors.green));

        prefs.setString('token', b['token']);
        prefs.setInt('type', b['type']);

        await Future.delayed(const Duration(seconds: 4), () {});

        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (BuildContext context) => home),
            ModalRoute.withName('/'));
      }
    } else {
      Scaffold.of(cont)
          .showSnackBar(snackBar('Probleme de validation!', Colors.red[800]));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Builder(builder: (context) {
        return Padding(
          padding: EdgeInsets.all(0),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    FormBuilder(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(height: 260),
                          FormBuilderTextField(
                            attribute: "email",
                            decoration: theme("email"),
                            validators: [
                              FormBuilderValidators.email(
                                  errorText: "e-mail non valide"),
                              FormBuilderValidators.required(
                                  errorText: "Ce champs est obligatoire!")
                            ],
                          ),
                          SizedBox(height: 20.0),
                          FormBuilderTextField(
                            attribute: "password",
                            decoration: theme("password"),
                            obscureText: true,
                            maxLines: 1,
                            validators: [
                              FormBuilderValidators.minLength(6,
                                  errorText:
                                      "mot de passe doit etre > a 6 caracteres"),
                              FormBuilderValidators.required(
                                  errorText: "Ce champs est obligatoire!")
                            ],
                          ),
                          SizedBox(height: 30.0),
                          Row(
                            children: <Widget>[
                              Expanded(
                                  child: button(context, "Confirmer",
                                      () => _confirm(context))),
                              SizedBox(width: 20),
                              Expanded(child: button(context, "reset", _reset))
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
