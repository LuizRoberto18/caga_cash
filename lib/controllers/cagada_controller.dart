import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import '../data/models/cagada_model.dart';
import '../data/repositories/firebase_repository.dart';

class CagadaController extends GetxController {
  final FirebaseRepository _repository = FirebaseRepository();
  var imagemSelecionada = Rx<File?>(null);
  var isPublic = false.obs;
  var peso = 0.0.obs;
  var entupiu = false.obs;
  var listaCagadas = <CagadaModel>[].obs;

  var poops = <CagadaModel>[].obs;

  // Método para calcular o tempo total gasto
  int calculateTotalTime() {
    return poops.fold(0, (sum, poop) => sum + poop.duracaoMinutos);
  }

  // Método para calcular a média de tempo por cagada
  double calculateAverageTime() {
    if (poops.isEmpty) return 0.0;
    return calculateTotalTime() / poops.length;
  }

  // Método para calcular o número de vasos entupidos
  int calculateCloggedToilets() {
    return poops.where((poop) => poop.entupiu).length;
  }

  Future<void> selecionarImagem(bool fromCamera) async {
    final picker = ImagePicker();
    final pickedFile =
        await picker.pickImage(source: fromCamera ? ImageSource.camera : ImageSource.gallery);

    if (pickedFile != null) {
      imagemSelecionada.value = File(pickedFile.path);
    }
  }

  void adicionarCagada(String userId, DateTime data, int duracao, double salarioHora) async {
    double valor = (salarioHora / 60) * duracao;
    String? imagemUrl;

    if (imagemSelecionada.value != null) {
      imagemUrl = await _repository.uploadImagem(imagemSelecionada.value!, userId);
    }

    final novaCagada = CagadaModel(
      id: DateTime.now().toString(),
      dataHora: data,
      duracaoMinutos: duracao,
      valor: valor,
      imagemUrl: imagemUrl,
      publica: isPublic.value,
      peso: peso.value,
      entupiu: entupiu.value,
      usuarioNome: '',
    );

    await _repository.salvarCagada(userId, novaCagada);
  }

  void carregarCagadas(String userId) {
    listaCagadas.bindStream(_repository.getCagadas(userId));
  }
}
