import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // Para formatação de datas e horas
import '../controllers/cagada_controller.dart';
import '../data/models/cagada_model.dart';

class HistoricoView extends StatelessWidget {
  final CagadaController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Histórico de Cagadas"),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () => controller.buscarHistorico(),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.cagadas.isEmpty) {
          return Center(
            child: Text("Nenhuma cagada registrada ainda."),
          );
        }

        return ListView.builder(
          itemCount: controller.cagadas.length,
          itemBuilder: (context, index) {
            final cagada = controller.cagadas[index];
            return _buildCagadaItem(cagada);
          },
        );
      }),
    );
  }

  Widget _buildCagadaItem(CagadaModel cagada) {
    final dateFormat = DateFormat('dd/MM/yyyy');
    final timeFormat = DateFormat('HH:mm');

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        leading: cagada.imagemUrl != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  cagada.imagemUrl!,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
              )
            : Icon(Icons.warning, size: 50),
        title: Text(
          "Valor ganho: R\$ ${cagada.valor.toStringAsFixed(2)}",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4),
            Text("Usuário: ${cagada.usuarioNome}"),
            Text("Data: ${dateFormat.format(cagada.diaCagada)}"),
            Text(
                "Horário: ${timeFormat.format(DateTime(2023, 1, 1, cagada.horaInicio.hour, cagada.horaInicio.minute))} - ${timeFormat.format(DateTime(2023, 1, 1, cagada.horaFim.hour, cagada.horaFim.minute))}"),
            Text("Duração: ${cagada.duracaoMinutos} minutos"),
            Text("Peso: ${cagada.peso} kg"),
            Text("Entupiu: ${cagada.entupiu ? 'Sim' : 'Não'}"),
            Text("Pública: ${cagada.publica ? 'Sim' : 'Não'}"),
            Text("Salário: R\$ ${cagada.salario.toStringAsFixed(2)}"),
            Text("Horas por semana: ${cagada.horasPorSemana}"),
            Text("Período de pagamento: ${cagada.periodoPagamento}"),
          ],
        ),
        trailing: IconButton(
          icon: Icon(Icons.delete, color: Colors.red),
          onPressed: () {
            // Adicionar lógica para deletar a cagada
            Get.defaultDialog(
              title: "Deletar Cagada",
              middleText: "Tem certeza que deseja deletar esta cagada?",
              textConfirm: "Sim",
              textCancel: "Não",
              onConfirm: () {
                // Implementar a lógica de deleção
                Get.back();
              },
            );
          },
        ),
      ),
    );
  }
}
