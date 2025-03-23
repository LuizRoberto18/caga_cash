import 'package:flutter/material.dart';

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
  double salario; // Novo campo: salário do usuário
  int horasPorSemana; // Novo campo: horas trabalhadas por semana
  String periodoPagamento; // Novo campo: quinzenal ou mensal
  DateTime diaCagada; // Novo campo: dia da cagada
  TimeOfDay horaInicio; // Novo campo: hora de início
  TimeOfDay horaFim; // Novo campo: hora de fim

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
    required this.salario,
    required this.horasPorSemana,
    required this.periodoPagamento,
    required this.diaCagada,
    required this.horaInicio,
    required this.horaFim,
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
        'salario': salario,
        'horasPorSemana': horasPorSemana,
        'periodoPagamento': periodoPagamento,
        'diaCagada': diaCagada.toIso8601String(),
        'horaInicio': '${horaInicio.hour}:${horaInicio.minute}',
        'horaFim': '${horaFim.hour}:${horaFim.minute}',
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
        salario: json['salario'],
        horasPorSemana: json['horasPorSemana'],
        periodoPagamento: json['periodoPagamento'],
        diaCagada: DateTime.parse(json['diaCagada']),
        horaInicio: TimeOfDay(
          hour: int.parse(json['horaInicio'].split(':')[0]),
          minute: int.parse(json['horaInicio'].split(':')[1]),
        ),
        horaFim: TimeOfDay(
          hour: int.parse(json['horaFim'].split(':')[0]),
          minute: int.parse(json['horaFim'].split(':')[1]),
        ),
      );
}
