import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../core/app_colors.dart';
import '../core/widgets/custom_button.dart';
import '../core/widgets/custom_text_form_field.dart';

class LoginScreen extends StatelessWidget {
  final AuthController _authController = Get.put(AuthController());
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomTextField(
              controller: _emailController,
              label: 'Email',
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 16),
            CustomTextField(
              controller: _passwordController,
              label: 'Senha',
              isObscure: true,
            ),
            SizedBox(height: 24),
            CustomButton(
              text: 'Entrar',
              onPressed: () async {
                await _authController.loginWithEmailAndPassword(
                  _emailController.text.trim(),
                  _passwordController.text.trim(),
                );
              },
            ),
            SizedBox(height: 16),
            Text('ou', style: TextStyle(color: AppColors.text)),
            SizedBox(height: 16),
            CustomButton(
              text: 'Entrar com Google',
              onPressed: () async {
                await _authController.loginWithGoogle();
              },
            ),
            SizedBox(height: 24),
            TextButton(
              onPressed: () {
                Get.toNamed('/register'); // Navega para a tela de cadastro
              },
              child: Text(
                'Não tem uma conta? Cadastre-se',
                style: TextStyle(color: AppColors.accent),
              ),
            ),
          ],
        ),
      ),
    );
  }
}