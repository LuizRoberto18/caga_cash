import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../app_colors.dart';
import '../app_text_styles.dart';

class CustomDrawer extends StatelessWidget {
  final AuthController _authController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: AppColors.primary,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Cagada App',
                  style: AppTextStyles.title.copyWith(color: Colors.white),
                ),
                SizedBox(height: 8),
                Text(
                  'Bem-vindo, ${_authController.userEmail ?? 'Usuário'}',
                  style: AppTextStyles.body.copyWith(color: Colors.white),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.history, color: AppColors.text),
            title: Text('Histórico', style: AppTextStyles.body),
            onTap: () {
              Get.toNamed('/history');
            },
          ),
          ListTile(
            leading: Icon(Icons.leaderboard, color: AppColors.text),
            title: Text('Ranking', style: AppTextStyles.body),
            onTap: () {
              Get.toNamed('/ranking');
            },
          ),
          ListTile(
            leading: Icon(Icons.analytics, color: AppColors.text),
            title: Text('Relatórios', style: AppTextStyles.body),
            onTap: () {
              Get.toNamed('/reports');
            },
          ),
          ListTile(
            leading: Icon(Icons.settings, color: AppColors.text),
            title: Text('Configurações', style: AppTextStyles.body),
            onTap: () {
              Get.toNamed('/settings');
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.logout, color: AppColors.text),
            title: Text('Sair', style: AppTextStyles.body),
            onTap: () async {
              await _authController.logout();
            },
          ),
        ],
      ),
    );
  }
}
