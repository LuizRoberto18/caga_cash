import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/models/cagada_model.dart';

class AvaliarCagadaView extends StatelessWidget {
  final CagadaModel cagada;

  AvaliarCagadaView({required this.cagada});

  final _formaController = TextEditingController();
  final _corController = TextEditingController();
  final _cheiroController = TextEditingController();
  final _consistenciaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Avaliar Cagada")),
      body: Column(
        children: [
          if (cagada.imagemUrl != null)
            Image.network(cagada.imagemUrl!, height: 150),
          TextField(controller: _formaController, decoration: InputDecoration(labelText: "Forma")),
          TextField(controller: _corController, decoration: InputDecoration(labelText: "Cor")),
          TextField(controller: _cheiroController, decoration: InputDecoration(labelText: "Cheiro")),
          TextField(controller: _consistenciaController, decoration: InputDecoration(labelText: "Consistência")),
          ElevatedButton(
            child: Text("Enviar Avaliação"),
            onPressed: () {
              // Aqui você pode enviar a avaliação para o Firebase
              Get.back();
            },
          ),
        ],
      ),
    );
  }
}
