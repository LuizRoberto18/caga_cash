import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import '../controllers/cagada_controller.dart';
import '../core/app_colors.dart';
import '../core/app_text_styles.dart';
import '../core/widgets/app_bar.dart';

class RelatoriosView extends StatelessWidget {
  final CagadaController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    // Dados para os relatórios
    final now = DateTime.now();
    final ultimoDiaDoMes = DateTime(now.year, now.month + 1, 0);

    // Cálculos dos dados
    final totalGanho = controller.cagadas.fold(0.0, (sum, item) => sum + item.valor);
    final totalPeso = controller.cagadas.fold(0.0, (sum, item) => sum + item.peso);
    final entupimentos = controller.cagadas.where((c) => c.entupiu).length;
    final cagadasPublicas = controller.cagadas.where((c) => c.publica).length;
    final cagadasPrivadas = controller.cagadas.length - cagadasPublicas;

    // Gráfico de barras (ganho por dia)
    final ganhoPorDia = _calcularGanhoPorDia(now, ultimoDiaDoMes);
    final barGroups = _buildBarGroups(ganhoPorDia);

    // Gráfico de pizza (públicas vs privadas)
    final pieChartSections = _buildPieChartSections(cagadasPublicas, cagadasPrivadas);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'Relatórios Mensais',
        actions: [
          IconButton(
            icon: Icon(Icons.calendar_month_rounded, color: AppColors.primary),
            onPressed: null,
            //onPressed: () => _showMonthSelector(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Cards de resumo
            _buildSummaryCards(totalGanho, totalPeso, entupimentos),
            const SizedBox(height: 24),

            // Gráfico de pizza
            _buildPieChartSection(pieChartSections, cagadasPublicas, cagadasPrivadas),
            const SizedBox(height: 24),

            // Gráfico de barras
            _buildBarChartSection(barGroups, ultimoDiaDoMes),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCards(double totalGanho, double totalPeso, int entupimentos) {
    return SizedBox(
      height: Get.height * .31,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: _buildSummaryCard(
                  title: 'Total Ganho',
                  value: 'R\$ ${totalGanho.toStringAsFixed(2)}',
                  icon: Icons.attach_money_rounded,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildSummaryCard(
                  title: 'Peso Total',
                  value: '${totalPeso.toStringAsFixed(1)} kg',
                  icon: Icons.fitness_center_rounded,
                  color: AppColors.accent,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildSummaryCard(
                  title: 'Entupimentos',
                  value: '$entupimentos',
                  icon: Icons.warning_amber_rounded,
                  color: AppColors.error,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textLight,
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
        ],
      ),
    );
  }

  Widget _buildPieChartSection(List<PieChartSectionData> sections, int publicas, int privadas) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Distribuição de Cagadas',
          style: AppTextStyles.titleSmall.copyWith(
            color: AppColors.text,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              SizedBox(
                height: 200,
                child: PieChart(
                  PieChartData(
                    sections: sections,
                    centerSpaceRadius: 40,
                    sectionsSpace: 2,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildChartLegend(
                    color: AppColors.primary,
                    label: 'Públicas ($publicas)',
                  ),
                  const SizedBox(width: 16),
                  _buildChartLegend(
                    color: AppColors.secondary,
                    label: 'Privadas ($privadas)',
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildChartLegend({required Color color, required String label}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.text,
          ),
        ),
      ],
    );
  }

  Widget _buildBarChartSection(List<BarChartGroupData> barGroups, DateTime ultimoDia) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Ganho Diário no Mês',
          style: AppTextStyles.titleSmall.copyWith(
            color: AppColors.text,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
          child: SizedBox(
            height: 300,
            child: BarChart(
              BarChartData(
                barGroups: barGroups,
                alignment: BarChartAlignment.spaceAround,
                borderData: FlBorderData(
                  show: true,
                  border: Border(
                    bottom: BorderSide(color: AppColors.lightGrey, width: 1),
                    left: BorderSide(color: AppColors.lightGrey, width: 1),
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: AppColors.lightGrey.withOpacity(0.5),
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            value.toInt().toString(),
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textLight,
                            ),
                          ),
                        );
                      },
                      reservedSize: 24,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          'R\$ ${value.toInt()}',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textLight,
                          ),
                        );
                      },
                      reservedSize: 40,
                      interval: _calculateInterval(barGroups),
                    ),
                  ),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    //tooltipBgColor: AppColors.text.withOpacity(0.9),
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      return BarTooltipItem(
                        'Dia ${group.x.toInt()}\nR\$ ${rod.toY.toStringAsFixed(2)}',
                        AppTextStyles.bodySmall.copyWith(
                          color: AppColors.white,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Map<int, double> _calcularGanhoPorDia(DateTime now, DateTime ultimoDia) {
    final ganhoPorDia = <int, double>{};

    // Inicializa todos os dias do mês
    for (int dia = 1; dia <= ultimoDia.day; dia++) {
      ganhoPorDia[dia] = 0.0;
    }

    // Calcula os valores
    for (final cagada in controller.cagadas) {
      final dataCagada = cagada.dataHora;
      if (dataCagada.year == now.year && dataCagada.month == now.month) {
        ganhoPorDia[dataCagada.day] = ganhoPorDia[dataCagada.day]! + cagada.valor;
      }
    }

    return ganhoPorDia;
  }

  List<BarChartGroupData> _buildBarGroups(Map<int, double> ganhoPorDia) {
    return ganhoPorDia.entries.map((entry) {
      return BarChartGroupData(
        x: entry.key,
        barRods: [
          BarChartRodData(
            toY: entry.value,
            color: AppColors.primary,
            width: 12,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(4),
            ),
          ),
        ],
      );
    }).toList();
  }

  List<PieChartSectionData> _buildPieChartSections(int publicas, int privadas) {
    final total = publicas + privadas;
    if (total == 0) return [];

    return [
      PieChartSectionData(
        color: AppColors.primary,
        value: publicas.toDouble(),
        title: '${((publicas / total) * 100).toStringAsFixed(0)}%',
        radius: 50,
        titleStyle: AppTextStyles.bodySmall.copyWith(
          color: AppColors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
      PieChartSectionData(
        color: AppColors.secondary,
        value: privadas.toDouble(),
        title: '${((privadas / total) * 100).toStringAsFixed(0)}%',
        radius: 50,
        titleStyle: AppTextStyles.bodySmall.copyWith(
          color: AppColors.text,
          fontWeight: FontWeight.w600,
        ),
      ),
    ];
  }

  double _calculateInterval(List<BarChartGroupData> barGroups) {
    final maxValue = barGroups.fold(0.0, (max, group) {
      return group.barRods.first.toY > max ? group.barRods.first.toY : max;
    });
    return (maxValue / 5).ceilToDouble();
  }

  void _showMonthSelector(BuildContext context) {
    // Implementar seletor de mês/ano
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Selecionar Período', style: AppTextStyles.titleSmall),
          content: SizedBox(
            width: double.maxFinite,
            child: YearPicker(
              currentDate: DateTime.now(),
              firstDate: DateTime(2020),
              lastDate: DateTime.now(),
              selectedDate: DateTime.now(),
              onChanged: (DateTime dateTime) {
                // Atualizar relatório para o mês/ano selecionado
                Navigator.pop(context);
              },
            ),
          ),
        );
      },
    );
  }
}
