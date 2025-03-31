import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/cagada_controller.dart';
import '../core/app_colors.dart';
import '../core/app_text_styles.dart';
import '../core/widgets/app_bar.dart';
import '../core/widgets/custom_drawer.dart';
import '../core/widgets/gradient_button.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final CagadaController _cagadaController = Get.find();

  @override
  void initState() {
    super.initState();
    _cagadaController.buscarHistorico();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'Visão Geral',
        actions: [
          IconButton(
            icon: Icon(Icons.refresh_rounded, color: AppColors.textLight),
            onPressed: () => _cagadaController.buscarHistorico(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed('/nova_cagada'),
        backgroundColor: AppColors.primary,
        elevation: 4,
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            // shape: BoxShape.circle,
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              colors: [AppColors.primary, AppColors.accent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Icon(Icons.add_rounded, color: Colors.white, size: 28),
        ),
      ),
      drawer: CustomDrawer(),
      body: RefreshIndicator(
        color: AppColors.text,
        backgroundColor: AppColors.background,
        onRefresh: () async {
          await _cagadaController.buscarHistorico();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Obx(() {
            final cagadas = _cagadaController.cagadas;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Saudação e resumo
                _buildWelcomeHeader(),
                const SizedBox(height: 8),

                // Grid de métricas
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 1.1,
                  children: [
                    _buildMetricCard(
                      title: 'Total',
                      value: cagadas.length.toString(),
                      subtitle: 'Cagadas',
                      icon: Icons.assignment_turned_in_rounded,
                      color: AppColors.accent,
                    ),
                    _buildMetricCard(
                      title: 'Tempo Total',
                      value: _cagadaController.calculateTotalTime().toString(),
                      subtitle: 'Minutos',
                      icon: Icons.timer_rounded,
                      color: AppColors.accent,
                    ),
                    _buildMetricCard(
                      title: 'Média',
                      value: _cagadaController.calculateAverageTime().toStringAsFixed(1),
                      subtitle: 'Min/Cagada',
                      icon: Icons.timelapse_rounded,
                      color: AppColors.accent,
                    ),
                    _buildMetricCard(
                      title: 'Entupidos',
                      value: _cagadaController.calculateCloggedToilets().toString(),
                      subtitle: 'Vasos',
                      icon: Icons.warning_amber_rounded,
                      color: AppColors.accent,
                    ),
                  ],
                ),

                // Seção de histórico recente
                _buildRecentHistorySection(),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _buildWelcomeHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Bem-vindo de volta!',
          style: AppTextStyles.titleLarge.copyWith(
            fontWeight: FontWeight.w800,
            color: AppColors.text,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Aqui está seu resumo atual',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textLight,
          ),
        ),
      ],
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: AppColors.primary,
          // gradient: LinearGradient(
          //   begin: Alignment.topLeft,
          //   end: Alignment.bottomRight,
          //   colors: [
          //     AppColors.primary,
          //     AppColors.accent,
          //   ],
          // ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.secondary,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.background,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: AppTextStyles.titleLarge.copyWith(
                      color: AppColors.text,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.background,
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

  Widget _buildRecentHistorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Histórico Recente',
                style: AppTextStyles.titleSmall.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextButton(
                onPressed: () => Get.toNamed('/historico'),
                child: Text(
                  'Ver Todos',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        ..._cagadaController.cagadas.take(3).map((cagada) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Card(
                elevation: 0,
                color: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () => Get.toNamed('/detalhe_cagada', arguments: cagada),
                  child: Container(
                    // decoration: BoxDecoration(
                    //   borderRadius: BorderRadius.circular(16),
                    //   gradient: LinearGradient(
                    //     begin: Alignment.topLeft,
                    //     end: Alignment.bottomRight,
                    //     colors: [
                    //       AppColors.primary,
                    //       AppColors.accent,
                    //     ],
                    //   ),
                    // ),
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.secondary,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            cagada.entupiu
                                ? Icons.warning_amber_rounded
                                : Icons.check_circle_rounded,
                            color: AppColors.accent,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${cagada.duracaoMinutos} minutos',
                                style: AppTextStyles.bodyLarge.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                DateFormat("dd/MM/yy HH:mm").format(cagada.diaCagada),
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.background,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.chevron_right_rounded,
                          color: AppColors.background,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )),
        if (_cagadaController.cagadas.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Column(
              children: [
                Icon(
                  Icons.assignment_outlined,
                  size: 48,
                  color: AppColors.textLight.withOpacity(0.3),
                ),
                const SizedBox(height: 16),
                Text(
                  'Nenhuma cagada registrada ainda',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textLight,
                  ),
                ),
                const SizedBox(height: 16),
                GradientButton(
                  text: 'Registrar Primeira Cagada',
                  onPressed: () => Get.toNamed('/nova_cagada'),
                  height: 48,
                  borderRadius: 12,
                ),
              ],
            ),
          ),
      ],
    );
  }
}
