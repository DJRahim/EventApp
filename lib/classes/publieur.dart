class Publieur {
  String nom;
  String email;
  String organisme;
  int idPub;

  Publieur(this.nom, this.email, this.organisme, this.idPub);

  Publieur.fromJson(Map<String, dynamic> json)
      : idPub = json['id_num'],
        nom = json['nom'],
        email = json['email'],
        organisme = json['nom_organis'].toString();

  Map<String, dynamic> toJson() =>
      {'nom': nom, 'email': email, 'organisme': organisme};

  Publieur.fromMap(Map<String, dynamic> json)
      : nom = json['nom'],
        email = json['email'],
        organisme = json['organisme'];

  Map<String, dynamic> toMap() =>
      {'nom': nom, 'email': email, 'organisme': organisme};
}
