import 'dart:convert';
import 'package:eventapp/pages/home_page.dart';
import 'package:eventapp/pages/home_page_admin.dart';
import 'package:eventapp/pages/home_page_normal.dart';
import 'package:eventapp/pages/home_page_publieur.dart';
import 'package:eventapp/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:eventapp/auth.dart' as auth;

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
      print(_formKey.currentState.value);
      Map<String, String> c = Map.from(_formKey.currentState.value);
      var a = await auth.getRequest(
          'auth/se_connecter?password=${c['password']}&email=${c['email']}', c);

      var b = jsonDecode(a);

      var home;

      switch (b['type']) {
        case "2":
          home = MyHomePageNormal();
          break;
        case "1":
          home = MyHomePagePublieur();
          break;
        case "0":
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

        await Future.delayed(const Duration(seconds: 2), () {});

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
        );
      }),
    );
  }
}
