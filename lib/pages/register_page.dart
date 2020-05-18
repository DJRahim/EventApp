// import 'package:eventapp/auth.dart' as auth;
import 'package:eventapp/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

// Cette page contient une forme pour l'insciption des utilisateurs (normals et publieurs)
// Ca contient un champs pour le type de l'utilisateur, un email et un password
// et en plus 2 boutons, un pour reinitialiser les champs et un pour valider et envoyer
// apres validation l'utilisateur passe a une uatre forme (selon son type)
// pour remplire des infos supplementaire (la 2eme forme pour l'utilisateur normale est presaue finis
// et pour le publieur pas encore developper)

class RegisterPage extends StatefulWidget {
  RegisterPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  RegisterPageState createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  var value = "Utilisateur normale";

  // une methode pour reinitialiser la forme
  void _reset() {
    _formKey.currentState.reset();
  }

  // une methode pour valider et envoyer
  void _confirm() async {
    if (_formKey.currentState.saveAndValidate()) {
      Map<String, String> c = Map.from(_formKey.currentState.value);

      // var v = await auth.getRequest("s_inscrire", c);
      print(c);

      Navigator.pushNamed(context, '/inscription2');
    } else {
      print(_formKey.currentState.value);
      print("validation failed");
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.all(0),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: <Widget>[
                SizedBox(height: 90.0),
                FormBuilder(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        FormBuilderChoiceChip(
                          decoration: theme("Type de compte :"),
                          attribute: "type",
                          options: [
                            FormBuilderFieldOption(
                              value: "normal",
                              child: Text("Utilisateur normal"),
                            ),
                            FormBuilderFieldOption(
                                value: "publieur",
                                child: Text("publieur d'evenements")),
                          ],
                          validators: [
                            FormBuilderValidators.required(
                                errorText: "Svp selectionnez un type")
                          ],
                        ),
                        SizedBox(height: 20.0),
                        FormBuilderTextField(
                          attribute: "e-mail",
                          decoration: theme("e-mail"),
                          validators: [
                            FormBuilderValidators.email(
                                errorText: "e-mail non valide"),
                            FormBuilderValidators.required(
                                errorText: "Ce champs est obligatoire")
                          ],
                        ),
                        SizedBox(height: 20.0),
                        FormBuilderTextField(
                          obscureText: true,
                          maxLines: 1,
                          attribute: "password",
                          decoration: theme("mot de passe"),
                          validators: [
                            FormBuilderValidators.minLength(6,
                                errorText:
                                    "mot de passe doit etre > a 8 caracteres"),
                            FormBuilderValidators.required(
                                errorText: "Ce champs est obligatoire")
                          ],
                        ),
                        SizedBox(height: 20.0),
                      ],
                    )),
                Row(
                  children: <Widget>[
                    Expanded(child: button(context, "Confirmer", _confirm)),
                    SizedBox(width: 20),
                    Expanded(child: button(context, "reset", _reset))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
