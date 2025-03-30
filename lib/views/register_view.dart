import 'package:caga_cash/core/widgets/gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../core/app_colors.dart';
import '../core/widgets/app_bar.dart';
import '../core/widgets/auth_text_field.dart';
import '../core/app_text_styles.dart';

class RegisterView extends StatelessWidget {
  final AuthController _authController = Get.put(AuthController());
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      // appBar: CustomAppBar(title: 'Cadastro', showBackButton: true),
      body: Stack(
        children: [
          // Fundo decorativo
          Positioned(
            top: -50,
            right: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withOpacity(0.1),
              ),
            ),
          ),

          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: Get.height * 0.1),

                    // Logo e título
                    Hero(
                      tag: 'app-logo',
                      child: Image.asset(
                        'assets/images/icon-login.png',
                        height: 150,
                        width: 150,
                      ),
                    ),
                    const SizedBox(height: 16),

                    Text(
                      'Bem-vindo ao\nCaga Cash',
                      style: AppTextStyles.titleLarge.copyWith(
                        height: 1.3,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),

                    Text(
                      'Controle seus ganhos de forma inteligente',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textLight,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 48),

                    AuthTextField(
                      controller: _emailController,
                      label: 'Email',
                      hint: 'seu@email.com',
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira seu email';
                        }
                        if (!value.contains('@')) {
                          return 'Email inválido';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    AuthTextField(
                      controller: _passwordController,
                      label: 'Senha',
                      hint: '••••••••',
                      icon: Icons.lock_outline,
                      isObscure: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira sua senha';
                        }
                        if (value.length < 6) {
                          return 'Senha deve ter pelo menos 6 caracteres';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 24),
                    Obx(
                      () => GradientButton(
                        text: 'Cadastrar',
                        onPressed: _authController.isLoading.value
                            ? null
                            : () async {
                                await _authController.registerWithEmailAndPassword(
                                  _emailController.text.trim(),
                                  _passwordController.text.trim(),
                                );
                              },
                        isLoading: _authController.isLoading.value,
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Já tem uma conta?', style: AppTextStyles.bodyMedium),
                        TextButton(
                          onPressed: () {
                            Get.back();
                          },
                          child: Text(
                            'Faça login',
                            style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
