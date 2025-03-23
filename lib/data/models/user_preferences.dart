class UserPreferences {
  double salarioHora;
  bool exibirPublicas;

  UserPreferences({required this.salarioHora, required this.exibirPublicas});

  Map<String, dynamic> toJson() => {
    'salarioHora': salarioHora,
    'exibirPublicas': exibirPublicas,
  };

  factory UserPreferences.fromJson(Map<String, dynamic> json) => UserPreferences(
    salarioHora: json['salarioHora'],
    exibirPublicas: json['exibirPublicas'],
  );
}
