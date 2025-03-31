import 'package:caga_cash/core/widgets/snackbar_app.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../controllers/settings_controller.dart';
import '../core/app_colors.dart';
import '../core/app_text_styles.dart';
import '../core/widgets/app_bar.dart';
import '../core/widgets/profile_avatar.dart';
import '../core/widgets/settings_item.dart';
import '../core/widgets/gradient_button.dart';

class ConfiguracoesView extends StatelessWidget {
  final SettingsController controller = Get.find();
  final AuthController authController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'Minha Conta',
        showBackButton: true,
        actions: [
          IconButton(
            tooltip: 'Salvar alterações',
            icon: Icon(Icons.save_rounded, color: AppColors.primary),
            onPressed: _saveAllSettings,
          ),
        ],
      ),
      body: Obx(() {
        return CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              sliver: SliverToBoxAdapter(
                child: Column(
                  children: [
                    // Seção de Perfil
                    _buildProfileSection(),
                    const SizedBox(height: 24),
                    //
                    // // Seção de Estatísticas
                    // _buildStatsSection(),
                  ],
                ),
              ),
            ),

            // Seção de Preferências
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              sliver: SliverToBoxAdapter(
                child: _buildPreferencesSection(),
              ),
            ),

            // Seção de Segurança
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              sliver: SliverToBoxAdapter(
                child: _buildSecuritySection(),
              ),
            ),

            // Seção de Sair
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
              sliver: SliverToBoxAdapter(
                child: _buildLogoutSection(),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildProfileSection() {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: AppColors.white,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                ProfileAvatar(
                  imageUrl:
                      authController.user.value?.photoURL ?? 'assets/images/default-avatar.png',
                  size: 100,
                  onTap: controller.atualizarFotoPerfil,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              authController.user.value?.displayName ?? 'Usuário',
              style: AppTextStyles.titleSmall.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              authController.user.value?.email ?? '',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textLight,
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: controller.nomeController,
              decoration: InputDecoration(
                labelText: "Nome de exibição",
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
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                suffixIcon: Icon(Icons.edit_rounded, size: 20, color: AppColors.textLight),
              ),
              style: AppTextStyles.bodyLarge,
            ),
            const SizedBox(height: 16),
            GradientButton(
              text: 'ATUALIZAR PERFIL',
              onPressed: controller.atualizarNome,
              height: 48,
              borderRadius: 12,
            ),
          ],
        ),
      ),
    );
  }

  // Widget _buildStatsSection() {
  //   return Card(
  //     elevation: 0,
  //     margin: EdgeInsets.zero,
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.circular(16),
  //     ),
  //     color: AppColors.white,
  //     child: Padding(
  //       padding: const EdgeInsets.all(20),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.stretch,
  //         children: [
  //           Row(
  //             children: [
  //               Icon(Icons.bar_chart_rounded, size: 20, color: AppColors.primary),
  //               const SizedBox(width: 8),
  //               Text(
  //                 'SUAS ESTATÍSTICAS',
  //                 style: AppTextStyles.bodySmall.copyWith(
  //                   color: AppColors.textLight,
  //                   fontWeight: FontWeight.w600,
  //                   letterSpacing: 0.5,
  //                 ),
  //               ),
  //             ],
  //           ),
  //           const SizedBox(height: 16),
  //           GridView.count(
  //             shrinkWrap: true,
  //             physics: const NeverScrollableScrollPhysics(),
  //             crossAxisCount: 3,
  //             childAspectRatio: 0.9,
  //             crossAxisSpacing: 8,
  //             children: [
  //               _buildStatItem(
  //                 icon: Icons.attach_money_rounded,
  //                 value: 'R\$ ${controller.totalGanho.toStringAsFixed(2)}',
  //                 label: 'Total Ganho',
  //               ),
  //               _buildStatItem(
  //                 icon: Icons.timer_rounded,
  //                 value: '${controller.totalMinutos} min',
  //                 label: 'Tempo Total',
  //               ),
  //               _buildStatItem(
  //                 icon: Icons.warning_amber_rounded,
  //                 value: controller.totalEntupimentos.toString(),
  //                 label: 'Entupimentos',
  //               ),
  //               _buildStatItem(
  //                 icon: Icons.work_history_rounded,
  //                 value: controller.totalCagadas.toString(),
  //                 label: 'Cagadas',
  //               ),
  //               _buildStatItem(
  //                 icon: Icons.public_rounded,
  //                 value: controller.totalPublicas.toString(),
  //                 label: 'Públicas',
  //               ),
  //               _buildStatItem(
  //                 icon: Icons.lock_rounded,
  //                 value: controller.totalPrivadas.toString(),
  //                 label: 'Privadas',
  //               ),
  //             ],
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _buildStatItem({required IconData icon, required String value, required String label}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: AppTextStyles.bodyLarge.copyWith(
            fontWeight: FontWeight.w700,
          ),
          textAlign: TextAlign.center,
        ),
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textLight,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildPreferencesSection() {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: AppColors.white,
      child: ExpansionTile(
        title: Row(
          children: [
            Icon(Icons.tune_rounded, size: 20, color: AppColors.primary),
            const SizedBox(width: 8),
            Text(
              'PREFERÊNCIAS',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textLight,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              children: [
                SettingsItem(
                  icon: Icons.attach_money_rounded,
                  iconColor: AppColors.primary,
                  title: 'Salário por hora',
                  subTitle: 'Usado para cálculo dos ganhos',
                  trailing: Container(
                    width: 120,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.lightGrey.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.lightGrey),
                    ),
                    child: Center(
                      child: TextField(
                        controller: TextEditingController(
                          text: controller.salarioPorHora.value.toStringAsFixed(2),
                        ),
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        textAlign: TextAlign.center,
                        style: AppTextStyles.bodyLarge.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                          isDense: true,
                        ),
                        onChanged: (value) {
                          controller.salarioPorHora.value =
                              double.tryParse(value.replaceAll(',', '.')) ?? 0.0;
                        },
                      ),
                    ),
                  ),
                ),
                const Divider(height: 1),
                Obx(() => SettingsItem(
                      icon: Icons.public_rounded,
                      iconColor: AppColors.primary,
                      title: 'Cagadas públicas',
                      subTitle: 'Aparecem no ranking geral',
                      trailing: Switch.adaptive(
                        value: controller.exibirPublicas.value,
                        onChanged: controller.exibirPublicas,
                        activeColor: AppColors.primary,
                        activeTrackColor: AppColors.primary.withOpacity(0.2),
                      ),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSecuritySection() {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: AppColors.white,
      child: ExpansionTile(
        title: Row(
          children: [
            Icon(Icons.security_rounded, size: 20, color: AppColors.primary),
            const SizedBox(width: 8),
            Text(
              'SEGURANÇA',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textLight,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              children: [
                SettingsItem(
                  icon: Icons.lock_reset_rounded,
                  iconColor: AppColors.primary,
                  title: 'Alterar senha',
                  subTitle: 'Atualize sua senha periodicamente',
                  onTap: _showChangePasswordDialog,
                  trailing: Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.textLight,
                  ),
                ),
                const Divider(height: 1),
                SettingsItem(
                  icon: Icons.email_rounded,
                  iconColor: AppColors.primary,
                  title: 'E-mail cadastrado',
                  subTitle: authController.user.value?.email ?? '',
                  trailing: Icon(
                    Icons.verified_rounded,
                    color: AppColors.success,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutSection() {
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Icon(Icons.help_rounded, color: AppColors.textLight),
          title: Text(
            'Ajuda e Suporte',
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.text,
            ),
          ),
          trailing: Icon(Icons.chevron_right_rounded, color: AppColors.textLight),
          onTap: () => Get.toNamed('/ajuda'),
        ),
        const SizedBox(height: 16),
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: _confirmLogout,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.error.withOpacity(0.2)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.logout_rounded, color: AppColors.error, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'SAIR DA CONTA',
                    style: AppTextStyles.buttonMedium.copyWith(
                      color: AppColors.error,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _saveAllSettings() {
    controller.atualizarNome();
    snackBarSuccess('Configurações salvas com sucesso');
  }

  void _showChangePasswordDialog() {
    Get.dialog(
      Dialog(
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        insetPadding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Alterar Senha',
                  style: AppTextStyles.titleSmall.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: controller.senhaAtualController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Senha atual',
                    prefixIcon: Icon(Icons.lock_outline_rounded),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: controller.novaSenhaController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Nova senha',
                    prefixIcon: Icon(Icons.lock_reset_rounded),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: controller.confirmarSenhaController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Confirmar nova senha',
                    prefixIcon: Icon(Icons.lock_rounded),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Get.back(),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text('Cancelar'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: GradientButton(
                        text: 'Confirmar',
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
      ),
    );
  }

  void _confirmLogout() {
    Get.dialog(
      AlertDialog(
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'Sair da conta?',
          style: AppTextStyles.titleSmall,
        ),
        content: Text(
          'Você será desconectado do aplicativo',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textLight,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancelar',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textLight,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              authController.logout();
            },
            child: Text(
              'Sair',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.error,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
