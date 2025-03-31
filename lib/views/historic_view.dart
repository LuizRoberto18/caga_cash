import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../controllers/cagada_controller.dart';
import '../data/models/cagada_model.dart';
import '../core/app_colors.dart';
import '../core/app_text_styles.dart';
import '../core/widgets/app_bar.dart';

class HistoricoView extends StatelessWidget {
  final CagadaController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'Histórico',
        actions: [
          IconButton(
            icon: Icon(Icons.filter_alt_rounded, color: AppColors.text),
            onPressed: _showFilterDialog,
          ),
          IconButton(
            icon: Icon(Icons.refresh_rounded, color: AppColors.text),
            onPressed: () => controller.buscarHistorico(),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await controller.buscarHistorico();
        },
        child: Obx(() {
          // if (controller.carregando.value) {
          //   return Center(
          //     child: CircularProgressIndicator(
          //       valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
          //     ),
          //   );
          // }

          if (controller.cagadas.isEmpty) {
            return _buildEmptyState();
          }

          return CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final cagada = controller.cagadas[index];
                      return _buildCagadaCard(cagada);
                    },
                    childCount: controller.cagadas.length,
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildCagadaCard(CagadaModel cagada) {
    final dateFormat = DateFormat('dd MMM yyyy');
    final timeFormat = DateFormat('HH:mm');
    final duration = cagada.duracaoMinutos;
    final value = cagada.valor;
    final isClogged = cagada.entupiu;

    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 12),
      color: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _showDetailsDialog(cagada),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.emoji_objects_rounded,
                          color: AppColors.accent,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        dateFormat.format(cagada.diaCagada),
                        style: AppTextStyles.bodyLarge.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.text,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.primary.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      'R\$${value.toStringAsFixed(2)}',
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildInfoChip(
                    icon: Icons.timer_rounded,
                    value: '$duration min',
                    color: AppColors.accent,
                  ),
                  if (cagada.entupiu)
                    _buildInfoChip(
                      icon: MdiIcons.emoticonPoop,
                      value: 'Entupiu',
                      color: AppColors.text,
                    ),
                  if (!cagada.entupiu)
                    _buildInfoChip(
                      icon: MdiIcons.emoticonPoopOutline,
                      value: 'Não Entupiu',
                      color: AppColors.text,
                    ),
                  if (!cagada.publica)
                    _buildInfoChip(
                      icon: Icons.privacy_tip,
                      value: 'Privada',
                      color: AppColors.grey,
                    ),
                  if (cagada.publica)
                    _buildInfoChip(
                      icon: Icons.public_rounded,
                      value: 'Pública',
                      color: AppColors.success,
                    ),
                  if (cagada.peso > 0)
                    _buildInfoChip(
                      icon: Icons.fitness_center_rounded,
                      value: '${cagada.peso} kg',
                      color: AppColors.info,
                    ),
                ],
              ),
              if (cagada.imagemUrl != null) ...[
                const SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    cagada.imagemUrl!,
                    width: double.infinity,
                    height: 150,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        height: 150,
                        color: AppColors.lightGrey,
                        child: Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                            color: AppColors.primary,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: () => _confirmDelete(cagada),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.error.withOpacity(0.8),
                  ),
                  icon: Icon(Icons.delete_outline_rounded, size: 18, color: AppColors.error),
                  label: Text(
                    'Excluir',
                    style: AppTextStyles.bodySmall.copyWith(color: AppColors.error),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            value,
            style: AppTextStyles.bodySmall.copyWith(
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: Get.width,
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.assignment_outlined,
            size: 64,
            color: AppColors.textLighter,
          ),
          const SizedBox(height: 16),
          Text(
            'Nenhum registro encontrado',
            style: AppTextStyles.titleSmall.copyWith(
              color: AppColors.textLight,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Quando você registrar cagadas, elas aparecerão aqui',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textLighter,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Get.toNamed('/nova_cagada'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: Text(
              'Registrar Primeira Cagada',
              style: AppTextStyles.buttonMedium,
            ),
          ),
        ],
      ),
    );
  }

  void _showDetailsDialog(CagadaModel cagada) {
    final dateFormat = DateFormat('dd/MM/yyyy');
    final timeFormat = DateFormat('HH:mm');

    Get.dialog(
      Dialog(
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Detalhes da Cagada',
                      style: AppTextStyles.titleSmall.copyWith(
                        color: AppColors.text,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close_rounded, color: AppColors.textLight),
                      onPressed: () => Get.back(),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (cagada.imagemUrl != null) ...[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      cagada.imagemUrl!,
                      width: double.infinity,
                      height: 180,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                _buildDetailRow('Valor', 'R\$${cagada.valor.toStringAsFixed(2)}'),
                _buildDetailRow('Usuário', cagada.usuarioNome),
                _buildDetailRow('Data', dateFormat.format(cagada.diaCagada)),
                _buildDetailRow('Horário',
                    '${timeFormat.format(DateTime(2023, 1, 1, cagada.horaInicio.hour, cagada.horaInicio.minute))} - ${timeFormat.format(DateTime(2023, 1, 1, cagada.horaFim.hour, cagada.horaFim.minute))}'),
                _buildDetailRow('Duração', '${cagada.duracaoMinutos} minutos'),
                if (cagada.peso > 0) _buildDetailRow('Peso', '${cagada.peso} kg'),
                _buildDetailRow('Entupiu', cagada.entupiu ? 'Sim' : 'Não',
                    isClogged: cagada.entupiu),
                _buildDetailRow('Pública', cagada.publica ? 'Sim' : 'Não'),
                _buildDetailRow('Salário', 'R\$${cagada.salario.toStringAsFixed(2)}'),
                _buildDetailRow('Horas/semana', '${cagada.horasPorSemana}'),
                _buildDetailRow('Período pagamento', cagada.periodoPagamento),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => Get.back(),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      side: BorderSide(color: AppColors.primary),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Fechar',
                      style: AppTextStyles.buttonMedium.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isClogged = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textLight,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTextStyles.bodyMedium.copyWith(
                color: isClogged ? AppColors.error : AppColors.text,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(CagadaModel cagada) {
    Get.dialog(
      AlertDialog(
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'Confirmar exclusão',
          style: AppTextStyles.titleSmall.copyWith(
            color: AppColors.text,
          ),
        ),
        content: Text(
          'Tem certeza que deseja excluir este registro?',
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
          ElevatedButton(
            onPressed: () {
              Get.back();
              //controller.excluirCagada(cagada.id);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Excluir',
              style: AppTextStyles.buttonMedium,
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog() {
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Filtrar Histórico',
                  style: AppTextStyles.titleSmall.copyWith(
                    color: AppColors.text,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close_rounded, color: AppColors.textLight),
                  onPressed: () => Get.back(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Filtro por período
            Text(
              'Período',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.text,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            // Adicionar controles de filtro aqui
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Get.back(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Aplicar Filtros',
                style: AppTextStyles.buttonMedium,
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {
                // Resetar filtros
                Get.back();
              },
              child: Text(
                'Limpar filtros',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
