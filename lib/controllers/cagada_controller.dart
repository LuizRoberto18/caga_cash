import 'dart:io';
import 'package:path_provider/path_provider.dart'; // Adicione esta linha

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:typed_data';
import '../data/models/cagada_model.dart';
import '../data/repositories/firebase_repository.dart';
import 'auth_controller.dart';

class CagadaController extends GetxController {
  final FirebaseRepository _repository = FirebaseRepository();
  final TextEditingController salarioController = TextEditingController();
  final TextEditingController horasPorSemanaController = TextEditingController();
  final TextEditingController pesoController = TextEditingController();
  File? imagem;
  bool isPublic = true;
  bool cloggedToilet = false;
  String periodoPagamento = 'mensal'; // Padrão: mensal
  DateTime diaCagada = DateTime.now(); // Padrão: dia atual
  TimeOfDay horaInicio = TimeOfDay.now(); // Padrão: hora atual
  TimeOfDay horaFim = TimeOfDay.now(); // Padrão: hora atual

  var cagadas = <CagadaModel>[].obs;

  void limparDados() {
    cagadas.clear();
  }

  // Método para adicionar uma nova cagada
  Future addCagada({
    required double salario,
    required int horasPorSemana,
    required int duracaoMinutos,
    required double peso,
    required bool entupiu,
    required bool publica,
    required double valor,
    Uint8List? imagem,
    required String periodoPagamento,
    required DateTime diaCagada,
    required TimeOfDay horaInicio,
    required TimeOfDay horaFim,
  }) async {
    try {
      String? imageUrl;
      if (imagem != null) {
        // Obtém o diretório temporário do dispositivo
        final diretorioTemporario = await getTemporaryDirectory();
        final caminhoArquivo =
            '${diretorioTemporario.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';

        print("Caminho do arquivo temporário: $caminhoArquivo");

        // Cria o arquivo temporário
        final tempFile = File(caminhoArquivo);
        await tempFile.writeAsBytes(imagem);

        // Faz upload da imagem para o Firebase Storage
        imageUrl =
            await _repository.uploadImagem(tempFile, Get.find<AuthController>().user.value!.uid);
        print("Imagem enviada com sucesso. URL: $imageUrl");

        // Remove o arquivo temporário após o upload
        await tempFile.delete();
        print("Arquivo temporário excluído.");
      }

      final cagada = CagadaModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        usuarioNome: Get.find<AuthController>().user.value!.email ?? 'Usuário',
        dataHora: DateTime.now(),
        duracaoMinutos: duracaoMinutos,
        peso: peso,
        entupiu: entupiu,
        publica: publica,
        valor: valor,
        imagemUrl: imageUrl,
        salario: salario,
        horasPorSemana: horasPorSemana,
        periodoPagamento: periodoPagamento,
        diaCagada: diaCagada,
        horaInicio: horaInicio,
        horaFim: horaFim,
      );

      print("Enviando cagada para o Firestore: ${cagada.toJson()}");
      await _repository.salvarCagada(Get.find<AuthController>().user.value!.uid, cagada);
      cagadas.add(cagada);

      // Retorna o resumo da cagada para exibir no pop-up
      return {
        'valor': valor,
        'duracaoMinutos': duracaoMinutos,
        'diaCagada': diaCagada,
        'horaInicio': horaInicio,
        'horaFim': horaFim,
      };
    } catch (e) {
      print("Erro ao registrar cagada: $e");
      Get.snackbar('Erro', 'Falha ao registrar cagada: ${e.toString()}');
    }
  }

  // Método para buscar o histórico de cagadas
  Future<void> buscarHistorico() async {
    try {
      final userId = Get.find<AuthController>().user.value!.uid;
      final historico = await _repository.buscarHistorico(userId);
      cagadas.assignAll(historico);
      print(cagadas);
      print("Buscando histórico de cagadas");
    } catch (e) {
      Get.snackbar('Erro', 'Falha ao buscar histórico: ${e.toString()}');
    }
  }


  // Stream para obter cagadas em tempo real
  Stream<List<CagadaModel>> getCagadasStream() {
    final userId = Get.find<AuthController>().user.value!.uid;
    return _repository.getCagadas(userId);
  }
  // Método para calcular o tempo total gasto
  int calculateTotalTime() {
    return cagadas.fold(0, (sum, cagada) => sum + cagada.duracaoMinutos);
  }

  // Método para calcular a média de tempo por cagada
  double calculateAverageTime() {
    if (cagadas.isEmpty) return 0.0;
    return calculateTotalTime() / cagadas.length;
  }

  // Método para calcular o número de vasos entupidos
  int calculateCloggedToilets() {
    return cagadas.where((cagada) => cagada.entupiu).length;
  }

  // Método para limpar os campos
  void limparCampos() {
    salarioController.clear();
    horasPorSemanaController.clear();
    pesoController.clear();
    imagem = null;
    isPublic = true;
    cloggedToilet = false;
    diaCagada = DateTime.now();
    horaInicio = TimeOfDay.now();
    horaFim = TimeOfDay.now();
    // setState(() {
    // });
  }
}
