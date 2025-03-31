import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../views/configuracoes_view.dart';
import '../../views/historic_view.dart';
import '../../views/home_view.dart';
import '../../views/ranking_view.dart';
import '../../views/relatorios_view.dart';
import '../app_colors.dart';
import '../app_text_styles.dart';

class MainWrapper extends StatelessWidget {
  MainWrapper({super.key});

  final AuthController _authController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => IndexedStack(
            index: _authController.currentTab.value,
            children: [
              HomeView(),
              HistoricoView(),
              RankingView(),
              RelatoriosView(),
              ConfiguracoesView(),
            ],
          )),
      bottomNavigationBar: _buildCustomBottomBar(context),
    );
  }

  Widget _buildCustomBottomBar(BuildContext context) {
    return Obx(
      () => Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 2,
            )
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          child: BottomNavigationBar(
            currentIndex: _authController.currentTab.value,
            onTap: (index) => _authController.changeTab(index),
            type: BottomNavigationBarType.fixed,
            backgroundColor: AppColors.primary,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white.withOpacity(0.6),
            selectedLabelStyle: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w600),
            unselectedLabelStyle: AppTextStyles.bodySmall,
            items: [
              BottomNavigationBarItem(
                icon: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: _authController.currentTab.value == 0
                        ? AppColors.text
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.home_rounded, size: 24),
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: _authController.currentTab.value == 1
                        ? AppColors.text
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.history_rounded, size: 24),
                ),
                label: 'Histórico',
              ),
              BottomNavigationBarItem(
                icon: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: _authController.currentTab.value == 2
                        ? AppColors.text
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.leaderboard_rounded, size: 24),
                ),
                label: 'Ranking',
              ),
              BottomNavigationBarItem(
                icon: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: _authController.currentTab.value == 3
                        ? AppColors.text
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.analytics_rounded, size: 24),
                ),
                label: 'Relatórios',
              ),
              BottomNavigationBarItem(
                icon: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: _authController.currentTab.value == 4
                        ? AppColors.text
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.settings_rounded, size: 24),
                ),
                label: 'Configurações',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
