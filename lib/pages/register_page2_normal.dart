import 'package:eventapp/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

// Cette page contient la 2eme forme pour les infos supplementaire (pour l'utilisateur normale)
// elle contient les champs :
// Nom, Prenom, age, sexe, profession, (Pas encore finis)

class RegisterPage2 extends StatefulWidget {
  RegisterPage2({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _RegisterPage2State createState() => _RegisterPage2State();
}

class _RegisterPage2State extends State<RegisterPage2> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  void reset() {
    _formKey.currentState.reset();
  }

  void confirm() {
    if (_formKey.currentState.saveAndValidate()) {
      var c = Map<String, String>.from(_formKey.currentState.value);

      print(c);
    } else {
      print(_formKey.currentState.value);
      print("validation failed");
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
      appBar: AppBar(),
      body: Padding(
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
                          attribute: "prenom",
                          decoration: theme("Prenom"),
                          validators: [
                            FormBuilderValidators.required(
                                errorText: "Ce champs est obligatoire")
                          ],
                        ),
                        SizedBox(height: 20.0),
                        FormBuilderTextField(
                          keyboardType: TextInputType.number,
                          attribute: "age",
                          decoration: theme("Age"),
                          validators: [
                            FormBuilderValidators.numeric(
                                errorText: "l'age doit etre numerique"),
                            FormBuilderValidators.max(90,
                                errorText: "l'age doit etre < 90 ans"),
                          ],
                        ),
                        SizedBox(height: 20.0),
                        FormBuilderDropdown(
                          attribute: "sexe",
                          decoration: theme("sexe"),
                          hint: Text('Selectionner sexe'),
                          validators: [],
                          items: ['Homme', 'Femme']
                              .map((gender) => DropdownMenuItem(
                                  value: gender, child: Text("$gender")))
                              .toList(),
                        ),
                        SizedBox(height: 20.0),
                        FormBuilderDropdown(
                          attribute: "profession",
                          decoration: theme("profession"),
                          hint: Text('Selectionner votre profession actuelle'),
                          validators: [],
                          items: ['Etudiant', 'Enseignant']
                              .map((p) =>
                                  DropdownMenuItem(value: p, child: Text("$p")))
                              .toList(),
                        ),
                      ],
                    )),
                SizedBox(height: 20.0),
                Row(
                  children: <Widget>[
                    Expanded(child: button(context, "Confirmer", confirm)),
                    SizedBox(width: 20),
                    Expanded(child: button(context, "reset", reset))
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
