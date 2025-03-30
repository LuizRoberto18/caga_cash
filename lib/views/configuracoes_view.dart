import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../controllers/settings_controller.dart';
import '../core/app_colors.dart';
import '../core/app_text_styles.dart';
import '../core/app_theme.dart';
import '../core/widgets/app_bar.dart';
import '../core/widgets/profile_avatar.dart';
import '../core/widgets/settings_item.dart';
import '../core/widgets/gradient_button.dart';

class ConfiguracoesView extends StatelessWidget {
  final SettingsController controller = Get.find();
  final AuthController _authController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppThemes.lightTheme,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: CustomAppBar(
          title: 'Configurações',
          showBackButton: true,
          actions: [
            IconButton(
              icon: Icon(Icons.save_rounded, color: AppColors.primary),
              onPressed: () => _saveAllSettings(),
            ),
          ],
        ),
        body: Obx(() => Stack(
          children: [
            // Efeito de gradiente no fundo
            Positioned(
              top: -100,
              right: -100,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.primary.withOpacity(0.1),
                      Colors.transparent
                    ],
                    stops: [0.1, 1],
                  ),
                ),
              ),
            ),

            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                children: [
                  // Seção de Perfil com animação
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: _buildProfileSection(),
                  ),
                  const SizedBox(height: 24),

                  // Seções com expansão animada
                  _buildPreferencesSection(),
                  const SizedBox(height: 24),

                  _buildSecuritySection(),
                  const SizedBox(height: 24),

                  //_buildAppSettingsSection(),
                  //const SizedBox(height: 32),

                  // Botão de Logout com feedback visual
                  _buildLogoutButton(),
                  const SizedBox(height: 20),
                ],
              ),
            ),

            // Loading overlay com animação
            if (controller.carregando.value)
              AnimatedOpacity(
                opacity: controller.carregando.value ? 1 : 0,
                duration: const Duration(milliseconds: 200),
                child: Container(
                  color: Colors.black54,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(
                          strokeWidth: 3,
                          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Salvando configurações...',
                          style: AppTextStyles.bodyMedium.copyWith(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        )),
      ),
    );
  }

  Widget _buildProfileSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      shadowColor: AppColors.primary.withOpacity(0.2),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white,
              AppColors.secondary.withOpacity(0.3),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  ProfileAvatar(
                    imageUrl: controller.fotoPerfilUrl.value,
                    size: 100,
                    onTap: controller.atualizarFotoPerfil,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: IconButton(
                      icon: Icon(Icons.edit, color: Colors.white, size: 18),
                      onPressed: controller.atualizarFotoPerfil,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: controller.nomeController,
                decoration: InputDecoration(
                  labelText: "Nome de usuário",
                  labelStyle: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textLight,
                  ),
                  floatingLabelStyle: TextStyle(color: AppColors.primary),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.lightGrey),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.lightGrey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.primary, width: 1.5),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14),
                ),
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 16),
              GradientButton(
                text: 'ATUALIZAR PERFIL',
                onPressed: controller.atualizarNome,
                height: 48,
                borderRadius: 12,
                gradientColors: [AppColors.primary, AppColors.accent],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPreferencesSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      shadowColor: AppColors.primary.withOpacity(0.2),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 20),
          title: Text("PREFERÊNCIAS", style: AppTextStyles.titleSmall.copyWith(
            color: AppColors.accent,
            letterSpacing: 0.5,
          )),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  SettingsItem(
                    icon: Icons.attach_money_rounded,
                    iconColor: AppColors.primary,
                    title: "Salário por hora",
                    titleStyle: AppTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                    trailing: Container(
                      width: 120,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.lightGrey.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextField(
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        textAlign: TextAlign.center,
                        style: AppTextStyles.bodyLarge.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                        decoration: InputDecoration(
                          hintText: "R\$ 0,00",
                          hintStyle: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textLight.withOpacity(0.6),
                          ),
                          border: InputBorder.none,
                          prefix: Text("R\$ ", style: AppTextStyles.bodyMedium),
                        ),
                        onChanged: (value) {
                          controller.salarioPorHora.value = double.tryParse(value.replaceAll(',', '.')) ?? 0.0;
                        },
                      ),
                    ),
                  ),
                  const Divider(height: 24, thickness: 1, indent: 20, endIndent: 20),
                  Obx(() => SettingsItem(
                    icon: Icons.public_rounded,
                    iconColor: AppColors.primary,
                    title: "Cagadas públicas",
                    titleStyle: AppTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                    trailing: Transform.scale(
                      scale: 0.9,
                      child: Switch(
                        value: controller.exibirPublicas.value,
                        onChanged: controller.exibirPublicas,
                        activeColor: AppColors.primary,
                        activeTrackColor: AppColors.primary.withOpacity(0.3),
                        inactiveThumbColor: AppColors.textLight,
                        inactiveTrackColor: AppColors.lightGrey,
                      ),
                    ),
                  )),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _buildSecuritySection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      shadowColor: AppColors.primary.withOpacity(0.2),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 20),
          title: Text("SEGURANÇA", style: AppTextStyles.titleSmall.copyWith(
            color: AppColors.accent,
            letterSpacing: 0.5,
          )),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  SettingsItem(
                    icon: Icons.lock_reset_rounded,
                    iconColor: AppColors.primary,
                    title: "Alterar senha",
                    titleStyle: AppTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                    onTap: () => _showChangePasswordDialog(),
                    trailing: Icon(Icons.chevron_right_rounded,
                        color: AppColors.textLight),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget _buildAppSettingsSection() {
  //   return Card(
  //     elevation: 2,
  //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
  //     shadowColor: AppColors.primary.withOpacity(0.2),
  //     child: ClipRRect(
  //       borderRadius: BorderRadius.circular(20),
  //       child: ExpansionTile(
  //         tilePadding: const EdgeInsets.symmetric(horizontal: 20),
  //         title: Text("APLICATIVO", style: AppTextStyles.titleSmall.copyWith(
  //           color: AppColors.accent,
  //           letterSpacing: 0.5,
  //         )),
  //         children: [
  //           Padding(
  //             padding: const EdgeInsets.symmetric(horizontal: 20),
  //             child: Column(
  //               children: [
  //                 // SettingsItem(
  //                 //   icon: Icons.notifications_active_rounded,
  //                 //   iconColor: AppColors.primary,
  //                 //   title: "Notificações",
  //                 //   titleStyle: AppTextStyles.bodyLarge.copyWith(
  //                 //     fontWeight: FontWeight.w500,
  //                 //   ),
  //                 //   trailing: Obx(() => Transform.scale(
  //                 //     scale: 0.9,
  //                 //     child: Switch(
  //                 //       value: controller.notificacoesAtivadas.value,
  //                 //       onChanged: controller.toggleNotificacoes,
  //                 //       activeColor: AppColors.primary,
  //                 //       activeTrackColor: AppColors.primary.withOpacity(0.3),
  //                 //     ),
  //                 //   )),
  //                 // ),
  //                 const Divider(height: 24, thickness: 1, indent: 20, endIndent: 20),
  //                 SettingsItem(
  //                   icon: Icons.color_lens_rounded,
  //                   iconColor: AppColors.primary,
  //                   title: "Tema do aplicativo",
  //                   titleStyle: AppTextStyles.bodyLarge.copyWith(
  //                     fontWeight: FontWeight.w500,
  //                   ),
  //                   trailing: Obx(() => DropdownButton<String>(
  //                     value: controller.temaSelecionado.value,
  //                     icon: Icon(Icons.arrow_drop_down_rounded,
  //                         color: AppColors.primary),
  //                     underline: const SizedBox(),
  //                     items: ["Claro", "Escuro", "Sistema"].map((String value) {
  //                       return DropdownMenuItem<String>(
  //                         value: value,
  //                         child: Text(value, style: AppTextStyles.bodyMedium),
  //                       );
  //                     }).toList(),
  //                     onChanged: (newValue) {
  //                       if (newValue != null) {
  //                         controller.alterarTema(newValue);
  //                       }
  //                     },
  //                   )),
  //                 ),
  //               ],
  //             ),
  //           ),
  //           const SizedBox(height: 12),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _buildLogoutButton() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: () => _confirmLogout(),
          borderRadius: BorderRadius.circular(12),
          splashColor: Colors.red.withOpacity(0.1),
          highlightColor: Colors.red.withOpacity(0.05),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.red.withOpacity(0.3), width: 1),
            ),
            child: Center(
              child: Text(
                "SAIR DA CONTA",
                style: AppTextStyles.buttonMedium.copyWith(
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _saveAllSettings() {
    controller.atualizarNome();
    // Adicionar outras operações de salvamento se necessário
  }

  void _showChangePasswordDialog() {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Alterar Senha",
                style: AppTextStyles.titleMedium.copyWith(
                  color: AppColors.text,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: controller.senhaAtualController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Senha atual",
                  labelStyle: AppTextStyles.bodyMedium,
                  floatingLabelStyle: TextStyle(color: AppColors.primary),
                  prefixIcon: Icon(Icons.lock_outline_rounded,
                      color: AppColors.textLight),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: controller.novaSenhaController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Nova senha",
                  labelStyle: AppTextStyles.bodyMedium,
                  floatingLabelStyle: TextStyle(color: AppColors.primary),
                  prefixIcon: Icon(Icons.lock_reset_rounded,
                      color: AppColors.textLight),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: controller.confirmarSenhaController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Confirmar nova senha",
                  labelStyle: AppTextStyles.bodyMedium,
                  floatingLabelStyle: TextStyle(color: AppColors.primary),
                  prefixIcon: Icon(Icons.lock_rounded,
                      color: AppColors.textLight),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: BorderSide(color: AppColors.textLight.withOpacity(0.3)),
                      ),
                      child: Text(
                        "Cancelar",
                        style: AppTextStyles.buttonMedium.copyWith(
                          color: AppColors.textLight,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: GradientButton(
                      text: "Confirmar",
                      onPressed: () {
                        Get.back();
                        controller.alterarSenha();
                      },
                      height: 48,
                      borderRadius: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmLogout() {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(
                Icons.logout_rounded,
                size: 48,
                color: Colors.red,
              ),
              const SizedBox(height: 16),
              Text(
                "Sair da conta?",
                style: AppTextStyles.titleMedium.copyWith(
                  color: AppColors.text,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                "Você realmente deseja sair da sua conta?",
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textLight,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: BorderSide(color: AppColors.textLight.withOpacity(0.3)),
                      ),
                      child: Text(
                        "Cancelar",
                        style: AppTextStyles.buttonMedium.copyWith(
                          color: AppColors.textLight,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back();
                        _authController.logout();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        "Sair",
                        style: AppTextStyles.buttonMedium.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}