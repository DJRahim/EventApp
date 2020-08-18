class Publieur {
  String nom;
  String email;
  String registerId;
  int numtel;
  String nomSociete;

  Publieur(this.nom, this.email, this.numtel, this.registerId, this.nomSociete);

  Publieur.fromJson(Map<String, dynamic> json)
      : registerId = json['registerId'],
        nom = json['nom'],
        email = json['email'],
        numtel = json['numtel'],
        nomSociete = json['nomSociete'];

  Map<String, dynamic> toJson() => {
        'registerId': registerId,
        'nom': nom,
        'email': email,
        'numtel': numtel,
        'nomSociete': nomSociete
      };

  Publieur.fromMap(Map<String, dynamic> json)
      : registerId = json['registerId'],
        nom = json['nom'],
        email = json['email'],
        numtel = json['numtel'],
        nomSociete = json['nomSociete'];

  Map<String, dynamic> toMap() => {
        'registerId': registerId,
        'nom': nom,
        'email': email,
        'numtel': numtel,
        'nomSociete': nomSociete
      };
}
