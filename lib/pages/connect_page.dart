import 'package:eventapp/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:eventapp/auth.dart' as auth;

class ConnectPage extends StatefulWidget {
  ConnectPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  ConnectPageState createState() => ConnectPageState();
}

class ConnectPageState extends State<ConnectPage> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  void _reset() {
    _formKey.currentState.reset();
  }

  void _confirm() async {
    if (_formKey.currentState.saveAndValidate()) {
      print(_formKey.currentState.value);
      Map<String, String> c =
          Map<String, String>.from(_formKey.currentState.value);
      var a = await auth.getRequest('se_connecter', c);

      print(a);
    } else {
      print(_formKey.currentState.value);
      print("validation failed");
    }
  }

  // final snackBar = SnackBar(
  //   content: Text('Pas de connexion !'),
  //   action: SnackBarAction(
  //     label: 'voir historique',
  //     onPressed: () {
  //       Navigator.pushNamed(context, '/Non-connecte');
  //     },
  //   ),
  // );

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
                FormBuilder(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: 125.0),
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
                        validators: [
                          FormBuilderValidators.minLength(8,
                              errorText:
                                  "mot de passe doit etre > a 8 caracteres"),
                          FormBuilderValidators.required(
                              errorText: "Ce champs est obligatoire!")
                        ],
                      ),
                      SizedBox(height: 30.0),
                      Row(
                        children: <Widget>[
                          Expanded(
                              child: button(context, "Confirmer", _confirm)),
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
  }
}
