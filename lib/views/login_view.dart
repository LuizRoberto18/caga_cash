import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../core/app_colors.dart';
import '../core/app_text_styles.dart';
import '../core/widgets/custom_button.dart';
import '../core/widgets/custom_text_form_field.dart';

class LoginView extends StatelessWidget {
  final AuthController _authController = Get.put(AuthController());
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/icon-login.png',
                height: 300,
                width: 300,
              ),
              Text(
                'Caga Cash',
                style: AppTextStyles.title.copyWith(fontSize: 50),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: Get.width * .8,
                child: CustomTextField(
                  controller: _emailController,
                  label: 'Email',
                  keyboardType: TextInputType.emailAddress,
                  icon: Icons.email,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: Get.width * .8,
                child: CustomTextField(
                  controller: _passwordController,
                  label: 'Senha',
                  isObscure: true,
                  icon: Icons.lock,
                ),
              ),
              const SizedBox(height: 24),
              CustomButton(
                text: 'Entrar',
                onPressed: () async {
                  await _authController.loginWithEmailAndPassword(
                    _emailController.text.trim(),
                    _passwordController.text.trim(),
                  );
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: Divider(color: AppColors.text)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text('ou', style: AppTextStyles.body),
                  ),
                  Expanded(child: Divider(color: AppColors.text)),
                ],
              ),
              const SizedBox(height: 16),
              CustomButton(
                text: 'Entrar com Google',
                icon: Icons.email,
                onPressed: () async {
                  await _authController.loginWithGoogle();
                },
                color: Colors.redAccent,
              ),
              const SizedBox(height: 24),
              TextButton(
                onPressed: () {
                  Get.toNamed('/register');
                },
                child: Text(
                  'Não tem uma conta? Cadastre-se',
                  style: AppTextStyles.body.copyWith(color: AppColors.accent),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
