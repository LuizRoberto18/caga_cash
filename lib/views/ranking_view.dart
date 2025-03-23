import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/models/cagada_model.dart';
import '../../controllers/cagada_controller.dart';
import '../../controllers/auth_controller.dart';

class RankingView extends StatelessWidget {
  final CagadaController cagadaController = Get.find();
  final AuthController authController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ranking de Entupimentos Públicos"),
        centerTitle: true,
      ),
      body: StreamBuilder<List<CagadaModel>>(
        stream: cagadaController.getCagadasPublicas(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("Nenhum entupimento público registrado."));
          }

          final cagadasPublicas = snapshot.data!;
          final ranking = _calcularRanking(cagadasPublicas);
          final sortedRanking = ranking.entries.toList()
            ..sort((a, b) => b.value.compareTo(a.value));

          final usuarioLogado = authController.user.value!.email;
          final posicaoUsuario = _calcularPosicaoUsuario(usuarioLogado, sortedRanking);

          return Column(
            children: [
              if (posicaoUsuario != null)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "Sua posição no ranking: #$posicaoUsuario",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              Expanded(
                child: ListView.builder(
                  itemCount: sortedRanking.length,
                  itemBuilder: (context, index) {
                    final entry = sortedRanking[index];
                    final usuarioNome = entry.key;
                    final totalEntupimentos = entry.value;
                    final pesoMedio = _calcularPesoMedio(usuarioNome, cagadasPublicas);

                    return _buildRankingItem(
                      context,
                      index + 1,
                      usuarioNome,
                      totalEntupimentos,
                      pesoMedio,
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // Método para calcular o ranking de usuários com base em entupimentos públicos
  Map<String, int> _calcularRanking(List<CagadaModel> cagadas) {
    final Map<String, int> ranking = {};

    for (var cagada in cagadas) {
      if (cagada.entupiu) {
        ranking[cagada.usuarioNome] = (ranking[cagada.usuarioNome] ?? 0) + 1;
      }
    }

    return ranking;
  }

  // Método para calcular a posição do usuário logado
  int? _calcularPosicaoUsuario(String? usuarioLogado, List<MapEntry<String, int>> sortedRanking) {
    if (usuarioLogado == null) return null;

    for (int i = 0; i < sortedRanking.length; i++) {
      if (sortedRanking[i].key == usuarioLogado) {
        return i + 1;
      }
    }
    return null;
  }

  // Método para calcular o peso médio das cagadas de um usuário
  double _calcularPesoMedio(String usuarioNome, List<CagadaModel> cagadas) {
    final cagadasUsuario = cagadas.where((c) => c.usuarioNome == usuarioNome && c.entupiu).toList();
    if (cagadasUsuario.isEmpty) return 0.0;

    final totalPeso = cagadasUsuario.fold(0.0, (sum, c) => sum + c.peso);
    return totalPeso / cagadasUsuario.length;
  }

  Widget _buildRankingItem(
    BuildContext context,
    int posicao,
    String usuarioNome,
    int totalEntupimentos,
    double pesoMedio,
  ) {
    IconData medalIcon;
    Color medalColor;

    // Define a medalha com base na posição
    if (posicao == 1) {
      medalIcon = Icons.emoji_events;
      medalColor = Colors.amber;
    } else if (posicao == 2) {
      medalIcon = Icons.emoji_events;
      medalColor = Colors.grey;
    } else if (posicao == 3) {
      medalIcon = Icons.emoji_events;
      medalColor = Colors.brown;
    } else {
      medalIcon = Icons.star;
      medalColor = Colors.blue;
    }

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: medalColor,
          child: Icon(medalIcon, color: Colors.white),
        ),
        title: Text(
          usuarioNome,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4),
            Text("Total de entupimentos: $totalEntupimentos"),
            Text("Peso médio: ${pesoMedio.toStringAsFixed(2)} kg"),
          ],
        ),
        trailing: Text("#$posicao", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
