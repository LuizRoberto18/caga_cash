import 'package:flutter/material.dart';
import '../../data/models/cagada_model.dart';

class RankingView extends StatelessWidget {
  final List<CagadaModel> cagadas;

  RankingView({required this.cagadas});

  @override
  Widget build(BuildContext context) {
    final entupimentos = cagadas.where((c) => c.entupiu).toList();
    entupimentos.sort((a, b) => b.peso.compareTo(a.peso));

    return Scaffold(
      appBar: AppBar(title: Text("Ranking de Entupimentos")),
      body: ListView.builder(
        itemCount: entupimentos.length,
        itemBuilder: (context, index) {
          final cagada = entupimentos[index];
          return ListTile(
            leading: CircleAvatar(child: Text("${index + 1}")),
            title: Text("Peso: ${cagada.peso.toStringAsFixed(2)} kg"),
            subtitle: Text("Data: ${cagada.dataHora.toString()}"),
          );
        },
      ),
    );
  }
}
