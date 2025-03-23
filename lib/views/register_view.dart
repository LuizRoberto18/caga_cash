import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../core/app_colors.dart';
import '../core/widgets/custom_button.dart';
import '../core/widgets/custom_text_form_field.dart';

class RegisterView extends StatelessWidget {
  final AuthController _authController = Get.put(AuthController());
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro'),
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
              text: 'Cadastrar',
              onPressed: () async {
                await _authController.registerWithEmailAndPassword(
                  _emailController.text.trim(),
                  _passwordController.text.trim(),
                );
              },
            ),
            SizedBox(height: 16),
            TextButton(
              onPressed: () {
                Get.back(); // Volta para a tela de login
              },
              child: Text(
                'Já tem uma conta? Faça login',
                style: TextStyle(color: AppColors.accent),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
