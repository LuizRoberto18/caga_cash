import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import '../controllers/cagada_controller.dart';
import '../core/app_colors.dart';
import '../core/app_text_styles.dart';

class RelatoriosView extends StatelessWidget {
  final CagadaController controller = Get.find();

  RelatoriosView({super.key});

  @override
  Widget build(BuildContext context) {
    // Dados para os relatórios
    double totalGanho = controller.cagadas.fold(0, (sum, item) => sum + item.valor);
    double totalPeso = controller.cagadas.fold(0, (sum, item) => sum + item.peso);
    int entupimentos = controller.cagadas.where((c) => c.entupiu).length;
    int cagadasPublicas = controller.cagadas.where((c) => c.publica).length;
    int cagadasPrivadas = controller.cagadas.where((c) => !c.publica).length;
    // Obtém a data atual
    final now = DateTime.now();
    final ultimoDiaDoMes = DateTime(now.year, now.month + 1, 0); // Último dia do mês

// Inicializa o mapa de ganho por dia com todos os dias do mês
    final Map<int, double> ganhoPorDia = {
      for (int dia = 1; dia <= ultimoDiaDoMes.day; dia++) dia: 0.0
    };

// Popula os valores com as cagadas registradas no mês atual
    for (var cagada in controller.cagadas) {
      final dataCagada = cagada.dataHora;
      if (dataCagada.year == now.year && dataCagada.month == now.month) {
        final dia = dataCagada.day;
        ganhoPorDia[dia] = ganhoPorDia[dia]! + cagada.valor; // Usa o valor existente e soma
      }
    }

// Converte o mapa em uma lista de BarChartGroupData
    final List<BarChartGroupData> barGroups = ganhoPorDia.entries.map((entry) {
      return BarChartGroupData(
        x: entry.key,
        barRods: [
          BarChartRodData(
            toY: entry.value, // Valor total acumulado no dia
            color: AppColors.accent,
            width: 16,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      );
    }).toList();

    // Dados para o gráfico de pizza (cagadas públicas vs privadas)
    final List<PieChartSectionData> pieChartSections = [
      PieChartSectionData(
        color: AppColors.primary,
        value: cagadasPublicas.toDouble(),
        title: '${((cagadasPublicas / controller.cagadas.length) * 100).toStringAsFixed(1)}%',
        radius: 60,
        titleStyle: AppTextStyles.body.copyWith(color: Colors.white),
      ),
      PieChartSectionData(
        color: AppColors.secondary,
        value: cagadasPrivadas.toDouble(),
        title: '${((cagadasPrivadas / controller.cagadas.length) * 100).toStringAsFixed(1)}%',
        radius: 60,
        showTitle: true,
        titlePositionPercentageOffset: 0.5,
        badgePositionPercentageOffset: 2,
        badgeWidget: SizedBox(
          width: 100,
          height: 50,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    margin: EdgeInsets.only(right: 8, top: 8),
                    color: AppColors.secondary,
                    width: 20,
                    height: 20,
                  ),
                  Text(
                    "Privada",
                    style: AppTextStyles.body.copyWith(color: Colors.black),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    margin: EdgeInsets.only(right: 8),
                    color: AppColors.primary,
                    width: 20,
                    height: 20,
                  ),
                  Text(
                    "Publica",
                    style: AppTextStyles.body.copyWith(color: Colors.black),
                  ),
                ],
              ),
            ],
          ),
        ),
        titleStyle: AppTextStyles.body.copyWith(color: Colors.white),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text("Relatórios Mensais", style: AppTextStyles.title.copyWith(color: Colors.white)),
        backgroundColor: AppColors.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Card para o total ganho no mês
            Card(
              elevation: 4,
              color: AppColors.secondary,
              child: ListTile(
                title: Text("Total Ganho no Mês", style: AppTextStyles.title),
                subtitle: Text("R\$ ${totalGanho.toStringAsFixed(2)}",
                    style: AppTextStyles.title.copyWith(color: AppColors.accent)),
                leading: Icon(Icons.attach_money, color: AppColors.accent),
              ),
            ),
            SizedBox(height: 16),

            // Card para o peso acumulado
            Card(
              elevation: 4,
              color: AppColors.secondary,
              child: ListTile(
                title: Text("Peso Acumulado", style: AppTextStyles.title),
                subtitle: Text("${totalPeso.toStringAsFixed(2)} kg",
                    style: AppTextStyles.title.copyWith(color: AppColors.accent)),
                leading: Icon(Icons.fitness_center, color: AppColors.accent),
              ),
            ),
            SizedBox(height: 16),

            // Card para entupimentos
            Card(
              elevation: 4,
              color: AppColors.secondary,
              child: ListTile(
                title: Text("Entupimentos", style: AppTextStyles.title),
                subtitle: Text("$entupimentos vezes",
                    style: AppTextStyles.title.copyWith(color: AppColors.accent)),
                leading: Icon(Icons.warning, color: AppColors.accent),
              ),
            ),
            SizedBox(height: 24),

            // Gráfico de pizza (cagadas públicas vs privadas)
            Text("Cagadas Públicas vs Privadas", style: AppTextStyles.title),
            SizedBox(height: 16),
            SizedBox(
              height: 260,
              child: PieChart(
                PieChartData(
                  sections: pieChartSections,
                  centerSpaceRadius: 40,
                ),
              ),
            ),

            // Gráfico de barras (ganho por dia no mês)
            Text("Ganho por Dia no Mês", style: AppTextStyles.title),
            SizedBox(height: 16),
            Container(
              height: 300,
              child: BarChart(
                BarChartData(
                  barGroups: barGroups,
                  borderData: FlBorderData(
                    show: true,
                    border: Border(
                      bottom: BorderSide(color: AppColors.text, width: 1),
                      left: BorderSide(color: AppColors.text, width: 1),
                    ),
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: AppColors.text.withOpacity(0.2),
                        strokeWidth: 1,
                      );
                    },
                  ),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          int dia = value.toInt();
                          return dia >= 1 && dia <= ultimoDiaDoMes.day
                              ? Text(
                                  '$dia',
                                  style: AppTextStyles.body.copyWith(color: AppColors.text),
                                )
                              : const SizedBox.shrink();
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            'R\$ ${value.toInt()}',
                            style: AppTextStyles.body.copyWith(color: AppColors.text),
                          );
                        },
                        interval: 50, // Ajuste do intervalo de valores no eixo Y
                      ),
                    ),
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        final dia = group.x.toInt();
                        return BarTooltipItem(
                          'Dia $dia\nR\$ ${rod.toY.toStringAsFixed(2)}',
                          AppTextStyles.body.copyWith(color: Colors.white),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
