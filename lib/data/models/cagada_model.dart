class CagadaModel {
  String id;
  String usuarioNome;
  DateTime dataHora;
  int duracaoMinutos;
  double peso;
  bool entupiu;
  bool publica;
  double valor;
  String? imagemUrl;

  CagadaModel({
    required this.id,
    required this.usuarioNome,
    required this.dataHora,
    required this.duracaoMinutos,
    required this.peso,
    required this.entupiu,
    required this.publica,
    required this.valor,
    this.imagemUrl,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'usuarioNome': usuarioNome,
    'dataHora': dataHora.toIso8601String(),
    'duracaoMinutos': duracaoMinutos,
    'peso': peso,
    'entupiu': entupiu,
    'publica': publica,
    'valor': valor,
    'imagemUrl': imagemUrl,
  };

  factory CagadaModel.fromJson(Map<String, dynamic> json) => CagadaModel(
    id: json['id'],
    usuarioNome: json['usuarioNome'],
    dataHora: DateTime.parse(json['dataHora']),
    duracaoMinutos: json['duracaoMinutos'],
    peso: json['peso'],
    entupiu: json['entupiu'],
    publica: json['publica'],
    valor: json['valor'],
    imagemUrl: json['imagemUrl'],
  );
}
