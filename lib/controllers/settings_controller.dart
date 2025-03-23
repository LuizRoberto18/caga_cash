import 'package:get/get.dart';

class SettingsController extends GetxController {
  // Configuração de preferência se as cagadas serão públicas por padrão
  RxBool isCagadaPublicaPorPadrao = false.obs;

  // Tema do app (escuro/claro)
  RxBool isDarkMode = false.obs;
  RxBool exibirPublicas = false.obs;

  // Inicializa as configurações carregando do armazenamento local
  @override
  void onInit() {
    super.onInit();
    _loadSettings();
  }

// Método para carregar configura
  _loadSettings() {}

  salvarPreferencias(double salario) {}
}
