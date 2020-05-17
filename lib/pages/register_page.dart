import 'package:eventapp/auth.dart' as auth;
import 'package:eventapp/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  RegisterPageState createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  final _cont1 = TextEditingController();
  final _cont2 = TextEditingController();

  var value = "Utilisateur normale";
  int a = 0;

  void _reset() {
    _formKey.currentState.reset();
    _cont1.clear();
    _cont2.clear();
  }

  void _confirm() async {
    if (_formKey.currentState.saveAndValidate()) {
      Map<String, String> c = Map<String, String>();

      c.addAll({'type': '$a', 'email': _cont1.text, 'password': _cont2.text});

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
    _cont1.dispose();
    _cont2.dispose();
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
                              value: "Utilisateur normal",
                              child: Text("Utilisateur normal"),
                            ),
                            FormBuilderFieldOption(
                                value: "publieur d'evenements",
                                child: Text("publieur d'evenements")),
                          ],
                          validators: [
                            FormBuilderValidators.required(
                                errorText: "Svp selectionnez un type")
                          ],
                          onChanged: (b) {
                            setState(() {
                              if (b == "Utilisateur normale") {
                                a = 0;
                              } else {
                                a = 1;
                              }
                            });
                          },
                        ),
                        SizedBox(height: 20.0),
                        FormBuilderTextField(
                          controller: _cont1,
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
                          controller: _cont2,
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
