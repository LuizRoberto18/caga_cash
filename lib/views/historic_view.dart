import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/cagada_controller.dart';

class HistoricoView extends StatelessWidget {
  final CagadaController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Histórico de Cagadas")),
      body: Obx(() => ListView.builder(
            itemCount: controller.cagadas.length,
            itemBuilder: (context, index) {
              final cagada = controller.cagadas[index];
              return ListTile(
                leading: cagada.imagemUrl != null
                    ? Image.network(cagada.imagemUrl!, width: 50, height: 50, fit: BoxFit.cover)
                    : Icon(Icons.warning),
                title: Text("Valor ganho: R\$ ${cagada.valor.toStringAsFixed(2)}"),
                subtitle: Text("Duração: ${cagada.duracaoMinutos} min"),
              );
            },
          )),
    );
  }
}
