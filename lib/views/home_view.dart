import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../controllers/cagada_controller.dart';
import '../core/app_colors.dart';
import '../core/app_text_styles.dart';
import '../core/widgets/custom_drawer.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final CagadaController _poopController = Get.find();

  final AuthController _authController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home', style: AppTextStyles.title),
        backgroundColor: AppColors.primary,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await _authController.logout();
            },
          ),
        ],
      ),
      drawer: CustomDrawer(), // Usando o Drawer reutilizável
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildAnalyticsCard(
              title: 'Total de Cagadas',
              value: _poopController.poops.length.toString(),
              icon: Icons.assignment,
            ),
            SizedBox(height: 16),
            _buildAnalyticsCard(
              title: 'Tempo Total Gasto',
              value: '${_poopController.calculateTotalTime()} min',
              icon: Icons.timer,
            ),
            SizedBox(height: 16),
            _buildAnalyticsCard(
              title: 'Média por Cagada',
              value: '${_poopController.calculateAverageTime().toStringAsFixed(2)} min',
              icon: Icons.timelapse,
            ),
            SizedBox(height: 16),
            _buildAnalyticsCard(
              title: 'Vasos Entupidos',
              value: _poopController.calculateCloggedToilets().toString(),
              icon: Icons.warning,
            ),
          ],
        ),
      ),
    );
  }

  // Widget para criar cards analíticos
  Widget _buildAnalyticsCard(
      {required String title, required String value, required IconData icon}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon, size: 40, color: AppColors.accent),
            SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.body),
                Text(value, style: AppTextStyles.title),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
