import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'auth_controller.dart';

class AuthMiddleware extends GetMiddleware {
  final AuthController _authController = Get.find();

  @override
  RouteSettings? redirect(String? route) {
    // Verifica se o usuário está autenticado
    if (_authController.user.value == null) {
      return RouteSettings(name: '/'); // Redireciona para a tela de login
    }
    return null; // Permite o acesso à rota
  }
}
