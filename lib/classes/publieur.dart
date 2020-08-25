class Publieur {
  String nom;
  String email;
  String registerId;
  String organisme;

  Publieur(this.nom, this.email, this.registerId, this.organisme);

  Publieur.fromJson(Map<String, dynamic> json)
      : nom = json['nom'],
        email = json['email'],
        organisme = json['organisme'];

  Map<String, dynamic> toJson() =>
      {'nom': nom, 'email': email, 'organisme': organisme};

  Publieur.fromMap(Map<String, dynamic> json)
      : nom = json['nom'],
        email = json['email'],
        organisme = json['organisme'];

  Map<String, dynamic> toMap() =>
      {'nom': nom, 'email': email, 'organisme': organisme};
}
