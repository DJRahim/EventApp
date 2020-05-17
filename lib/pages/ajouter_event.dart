import 'package:eventapp/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:form_builder_map_field/form_builder_map_field.dart';

class AjouterEvent extends StatefulWidget {
  AjouterEvent({Key key, this.title}) : super(key: key);

  final String title;

  @override
  AjouterEventState createState() => AjouterEventState();
}

class AjouterEventState extends State<AjouterEvent> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  final _cont1 = TextEditingController();
  final _cont2 = TextEditingController();
  final _cont3 = TextEditingController();
  final _cont4 = TextEditingController();
  final _cont5 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 8,
      ),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(),
            child: FormBuilder(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    FormBuilderTextField(
                      // controller: _cont1,
                      attribute: "nom",
                      decoration: theme("nom"),
                      validators: [
                        FormBuilderValidators.required(
                            errorText: "Ce champs est obligatoire")
                      ],
                    ),
                    SizedBox(height: 15),
                    FormBuilderTextField(
                      // controller: _cont2,
                      attribute: "nom_organisateur",
                      decoration: theme("nom de l'organisateur"),
                      validators: [
                        FormBuilderValidators.required(
                            errorText: "Ce champs est obligatoire")
                      ],
                    ),
                    SizedBox(height: 15),
                    FormBuilderDateTimePicker(
                      attribute: "heure_debut",
                      inputType: InputType.time,
                      decoration: InputDecoration(
                        labelText: "Heure debut de l'evenement",
                      ),
                      validator: (val) => null,
                      initialTime: TimeOfDay(hour: 8, minute: 0),
                      initialValue: DateTime.now(),
                    ),
                    SizedBox(height: 15),
                    FormBuilderDateTimePicker(
                      attribute: "heur_fin",
                      inputType: InputType.time,
                      decoration: InputDecoration(
                        labelText: "Heure fin de l'evenement",
                      ),
                      validator: (val) => null,
                      initialTime: TimeOfDay(hour: 17, minute: 0),
                      initialValue: DateTime.now(),
                    ),
                    SizedBox(height: 15),
                    FormBuilderDateRangePicker(
                      attribute: "date_range",
                      firstDate: DateTime(1970),
                      lastDate: DateTime(2030),
                      format: DateFormat("dd-MM-yyyy"),
                      decoration: InputDecoration(
                        labelText: "Date Range",
                        helperText: "Helper text",
                        hintText: "Hint text",
                      ),
                    ),
                    SizedBox(height: 15),
                    FormBuilderMapField(
                      attribute: 'lieu',
                      decoration:
                          InputDecoration(labelText: 'Selectinner le lieu'),
                      markerIconColor: Colors.red,
                      markerIconSize: 50,
                    ),
                    SizedBox(height: 15),
                    FormBuilderTextField(
                      // controller: _cont3,
                      keyboardType: TextInputType.number,
                      attribute: "nb_place_dispo",
                      decoration: theme("Nembre de place disponible"),
                      validators: [
                        FormBuilderValidators.numeric(
                            errorText: "Ce champs doit etre numerique"),
                      ],
                    ),
                    SizedBox(height: 15),
                    FormBuilderTextField(
                      // controller: _cont3,
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: false),
                      attribute: "prix",
                      decoration: theme("Prix"),
                      validators: [
                        FormBuilderValidators.numeric(
                            errorText: "Ce champs doit etre numerique"),
                      ],
                    ),
                    SizedBox(height: 15),
                    Text("Contact"),
                    SizedBox(height: 15),
                    FormBuilderTextField(
                      // controller: _cont4,
                      attribute: "e-mail",
                      decoration: theme("e-mail"),
                      validators: [
                        FormBuilderValidators.email(
                            errorText: "e-mail non valide"),
                        FormBuilderValidators.required(
                            errorText: "Ce champs est obligatoire")
                      ],
                    ),
                    SizedBox(height: 15),
                    FormBuilderTextField(
                      // controller: _cont4,
                      attribute: "numero",
                      keyboardType: TextInputType.number,
                      decoration: theme("numero de telephone"),
                      validators: [
                        FormBuilderValidators.numeric(
                            errorText: "Ce champs doit etre numerique"),
                      ],
                    ),
                    SizedBox(height: 15),
                    FormBuilderTextField(
                      // controller: _cont4,
                      attribute: "url",
                      decoration: theme("lien"),
                      validators: [
                        FormBuilderValidators.url(
                            errorText: "Ce champs doit etre un url")
                      ],
                    ),
                    SizedBox(height: 15),
                    FormBuilderRangeSlider(
                      attribute: "age_cible",
                      validators: [FormBuilderValidators.min(6)],
                      min: 0.0,
                      max: 100.0,
                      initialValue: RangeValues(18, 30),
                      divisions: 50,
                      activeColor: Colors.red,
                      inactiveColor: Colors.pink[100],
                      decoration: InputDecoration(
                        labelText: "Age cibles",
                      ),
                    ),
                    SizedBox(height: 15),
                    button(context, "Confirmer", _confirm),
                  ],
                )),
          ),
        ),
      ),
    );
  }

  void _confirm() {
    if (_formKey.currentState.saveAndValidate()) {
      Map<String, dynamic> c = Map.from(_formKey.currentState.value);

      print(c);
    }
  }
}
