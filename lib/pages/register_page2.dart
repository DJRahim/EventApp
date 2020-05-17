import 'package:eventapp/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class RegisterPage2 extends StatefulWidget {
  RegisterPage2({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _RegisterPage2State createState() => _RegisterPage2State();
}

class _RegisterPage2State extends State<RegisterPage2> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  final _cont1 = TextEditingController();
  final _cont2 = TextEditingController();
  final _cont3 = TextEditingController();

  void reset() {
    _cont1.clear();
    _cont2.clear();
    _cont3.clear();
  }

  void confirm() {
    if (_formKey.currentState.saveAndValidate()) {
      var c = Map<String, String>.from(_formKey.currentState.value);

      c.remove('nom');
      c.remove('prenom');
      c.remove('age');
      c.addAll({'nom': _cont1.text, 'prenom': _cont2.text, 'age': _cont3.text});

      print(c);
    } else {
      print(_formKey.currentState.value);
      print("validation failed");
    }
  }

  @override
  void dispose() {
    super.dispose();
    _cont1.dispose();
    _cont2.dispose();
    _cont3.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
      ),
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
                          controller: _cont1,
                          attribute: "nom",
                          decoration: theme("Nom"),
                          validators: [
                            FormBuilderValidators.required(
                                errorText: "Ce champs est obligatoire")
                          ],
                        ),
                        SizedBox(height: 20.0),
                        FormBuilderTextField(
                          controller: _cont2,
                          attribute: "prenom",
                          decoration: theme("Prenom"),
                          validators: [
                            FormBuilderValidators.required(
                                errorText: "Ce champs est obligatoire")
                          ],
                        ),
                        SizedBox(height: 20.0),
                        FormBuilderTextField(
                          controller: _cont3,
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
