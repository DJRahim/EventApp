import 'package:eventapp/classes/publieur.dart';
import 'package:eventapp/pages/home_page.dart';
import 'package:eventapp/tools/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../tools/database.dart';

// Cette page contient la 2eme forme pour les infos supplementaire (pour l'utilisateur normale)
// elle contient les champs :
// Nom, Prenom, age, sexe, profession, (Pas encore finis)

class RegisterPage3 extends StatefulWidget {
  RegisterPage3({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _RegisterPage3State createState() => _RegisterPage3State();
}

class _RegisterPage3State extends State<RegisterPage3> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  void reset() {
    _formKey.currentState.reset();
  }

  Future<void> confirm(BuildContext cont) async {
    if (_formKey.currentState.saveAndValidate()) {
      var c = Map<String, String>.from(_formKey.currentState.value);

      SharedPreferences prefs = await SharedPreferences.getInstance();

      DBProvider.db.deleteAll();

      DBProvider.db.newPublieur(Publieur.fromMap({
        'nom': c['nom'],
        'email': prefs.getString('email'),
        'organisme': c['organisme']
      }));

      prefs.setBool("upload", false);

      Scaffold.of(cont).showSnackBar(snackBar(
          'Inscription reussi! Veuillez valider votre email.', Colors.green));

      await Future.delayed(const Duration(seconds: 4), () {});

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (BuildContext context) => MyHomePage()),
          ModalRoute.withName('/'));
    } else {
      Scaffold.of(cont)
          .showSnackBar(snackBar('Probleme de validation!', Colors.red[800]));
    }
  }

  @override
  void dispose() {
    super.dispose();
    _formKey.currentState.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Inscription d'un publieur",
          style: Theme.of(context).textTheme.headline1,
          textAlign: TextAlign.center,
        ),
        iconTheme: new IconThemeData(color: Colors.blueGrey[800]),
      ),
      body: Builder(builder: (cont) {
        return Padding(
          padding: EdgeInsets.all(0),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                children: <Widget>[
                  SizedBox(height: 80.0),
                  FormBuilder(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(height: 20.0),
                          FormBuilderTextField(
                            attribute: "nom",
                            decoration: theme("Nom"),
                            validators: [
                              FormBuilderValidators.required(
                                  errorText: "Ce champs est obligatoire")
                            ],
                          ),
                          SizedBox(height: 20.0),
                          FormBuilderTextField(
                            attribute: "organisme",
                            decoration: theme("Nom organisme"),
                            validators: [
                              FormBuilderValidators.required(
                                  errorText: "Ce champs est obligatoire")
                            ],
                          ),
                          SizedBox(height: 20.0),
                        ],
                      )),
                  SizedBox(height: 20.0),
                  Row(
                    children: <Widget>[
                      Expanded(
                          child: button(context, "Valider", () {
                        confirm(cont);
                      })),
                      SizedBox(width: 20),
                      Expanded(child: button(context, "Effacer", reset))
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
