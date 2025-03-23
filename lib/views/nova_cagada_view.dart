import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import '../controllers/cagada_controller.dart';

class NovaCagadaView extends StatelessWidget {
  final CagadaController controller = Get.find();
  final TextEditingController minutosController = TextEditingController();
  final TextEditingController pesoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Registrar Cagada")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: minutosController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "Duração (minutos)"),
            ),
            TextField(
              controller: pesoController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "Peso aproximado (kg)"),
            ),
            Obx(() => controller.imagemSelecionada.value != null
                ? Image.file(controller.imagemSelecionada.value!, height: 100)
                : Text("Nenhuma imagem selecionada")),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.camera_alt),
                  onPressed: () => controller.selecionarImagem(true),
                ),
                IconButton(
                  icon: Icon(Icons.photo),
                  onPressed: () => controller.selecionarImagem(false),
                ),
              ],
            ),
            Obx(() => CheckboxListTile(
                  title: Text("Deixar público"),
                  value: controller.isPublic.value,
                  onChanged: (value) {
                    controller.isPublic.value = value!;
                  },
                )),
            Obx(() => CheckboxListTile(
                  title: Text("Entupiu o vaso?"),
                  value: controller.entupiu.value,
                  onChanged: (value) {
                    controller.entupiu.value = value!;
                  },
                )),
            ElevatedButton(
              child: Text("Salvar"),
              onPressed: () {
                int minutos = int.parse(minutosController.text);
                double peso = double.tryParse(pesoController.text) ?? 0.0;
                controller.peso.value = peso;
                controller.adicionarCagada("userId123", DateTime.now(), minutos, 10.0);
                Get.back();
              },
            )
          ],
        ),
      ),
    );
  }
}
