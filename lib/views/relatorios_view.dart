import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/cagada_controller.dart';

class RelatoriosView extends StatelessWidget {
  final CagadaController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    double totalGanho = controller.cagadas.fold(0, (sum, item) => sum + item.valor);
    double totalPeso = controller.cagadas.fold(0, (sum, item) => sum + item.peso);
    int entupimentos = controller.cagadas.where((c) => c.entupiu).length;

    return Scaffold(
      appBar: AppBar(title: Text("Relatórios Mensais")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text("Total ganho no mês: R\$ ${totalGanho.toStringAsFixed(2)}"),
            Text("Peso acumulado: ${totalPeso.toStringAsFixed(2)} kg"),
            Text("Entupimentos: $entupimentos vezes"),
          ],
        ),
      ),
    );
  }
}
