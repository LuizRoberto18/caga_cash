import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import '../controllers/cagada_controller.dart';
import '../data/models/cagada_model.dart';

class RankingView extends StatelessWidget {
  final CagadaController _controller = Get.find();
  final AuthController _authController = Get.find();

  @override
  Widget build(BuildContext context) {
    final userId = _authController.user.value!.uid;
    final userEmail = _authController.user.value!.email;

    return Scaffold(
      appBar: AppBar(title: Text("Ranking de Cagadas Públicas")),
      body: StreamBuilder<List<CagadaModel>>(
        stream: _controller.getTodasCagadasPublicas(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Erro ao carregar ranking"));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("Nenhuma cagada pública encontrada"));
          }

          final todasCagadas = snapshot.data!;
          final ranking = _calcularRanking(todasCagadas);
          final rankingOrdenado = ranking.entries.toList()
            ..sort((a, b) => b.value.compareTo(a.value));

          final posicaoUsuario = rankingOrdenado.indexWhere((entry) => entry.key == userEmail) + 1;

          return Column(
            children: [
              if (posicaoUsuario > 0)
                _buildUserPositionCard(posicaoUsuario, ranking[userEmail] ?? 0),
              Expanded(
                child: ListView.builder(
                  itemCount: rankingOrdenado.length,
                  itemBuilder: (context, index) {
                    final entry = rankingOrdenado[index];
                    return _buildRankingItem(
                      index + 1,
                      entry.key,
                      entry.value,
                      entry.key == userEmail,
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

  Widget _buildUserPositionCard(int position, int count) {
    return Card(
      margin: EdgeInsets.all(12),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text("SUA POSIÇÃO NO RANKING", style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text("#$position", style: TextStyle(fontSize: 24)),
            SizedBox(height: 8),
            Text("$count entupimentos registrados"),
          ],
        ),
      ),
    );
  }

  Widget _buildRankingItem(int position, String email, int count, bool isCurrentUser) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      color: isCurrentUser ? Colors.blue[50] : null,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getMedalColor(position),
          child: Text(position.toString()),
        ),
        title: Text(email),
        trailing: Text("$count", style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }

  Color _getMedalColor(int position) {
    switch (position) {
      case 1:
        return Colors.amber;
      case 2:
        return Colors.grey;
      case 3:
        return Colors.brown;
      default:
        return Colors.blue;
    }
  }

  Map<String, int> _calcularRanking(List<CagadaModel> cagadas) {
    final ranking = <String, int>{};
    for (final cagada in cagadas.where((c) => c.entupiu)) {
      ranking[cagada.usuarioNome] = (ranking[cagada.usuarioNome] ?? 0) + 1;
    }
    return ranking;
  }
}
