import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/settings_controller.dart';

class ConfiguracoesView extends StatelessWidget {
  final SettingsController controller = Get.find();
  final TextEditingController salarioController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Configurações")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: salarioController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "Salário por hora"),
            ),
            Obx(() => SwitchListTile(
              title: Text("Exibir cagadas públicas"),
              value: controller.exibirPublicas.value,
              onChanged: (value) => controller.exibirPublicas.value = value,
            )),
            ElevatedButton(
              child: Text("Salvar"),
              onPressed: () {
                double salario = double.tryParse(salarioController.text) ?? 0.0;
                controller.salvarPreferencias(salario);
              },
            ),
          ],
        ),
      ),
    );
  }
}
