import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../controllers/cagada_controller.dart';
import '../core/app_colors.dart';
import '../core/app_text_styles.dart';
import '../core/widgets/gradient_button.dart';
import '../core/widgets/auth_text_field.dart';

class NovaCagadaView extends StatefulWidget {
  @override
  _NovaCagadaViewState createState() => _NovaCagadaViewState();
}

class _NovaCagadaViewState extends State<NovaCagadaView> {
  final CagadaController _cagadaController = Get.find();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Registrar Cagada', style: AppTextStyles.titleMedium),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: AppColors.text),
          onPressed: () => Get.back(),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Informações Básicas',
                style: AppTextStyles.titleSmall.copyWith(
                  color: AppColors.text,
                ),
              ),
              const SizedBox(height: 16),
              AuthTextField(
                controller: _cagadaController.salarioController,
                hint: 'Ex: 2500.00',
                icon: MdiIcons.cash,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                label: 'Salário (R\$)',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe seu salário';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Valor inválido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              AuthTextField(
                controller: _cagadaController.horasPorSemanaController,
                label: 'Horas por Semana',
                hint: "Ex: 44",
                icon: MdiIcons.clockOutline,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe as horas semanais';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Valor inválido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _cagadaController.periodoPagamento,
                decoration: InputDecoration(
                  labelText: 'Período de Pagamento',
                  labelStyle: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textLight,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.lightGrey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.primary, width: 1.5),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
                items: ['mensal', 'quinzenal'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value == 'mensal' ? 'Mensal' : 'Quinzenal',
                      style: AppTextStyles.bodyMedium,
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _cagadaController.periodoPagamento = value!;
                  });
                },
              ),
              const SizedBox(height: 24),
              Text(
                'Detalhes da Cagada',
                style: AppTextStyles.titleSmall.copyWith(
                  color: AppColors.text,
                ),
              ),
              const SizedBox(height: 16),
              AuthTextField(
                controller: _cagadaController.pesoController,
                label: 'Peso (kg) - Opcional',
                hint: 'Ex: 1.5',
                icon: MdiIcons.scaleBalance,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
              const SizedBox(height: 16),
              _buildDateTimeSection(),
              const SizedBox(height: 24),
              _buildSwitchOptions(),
              const SizedBox(height: 32),
              GradientButton(
                text: 'Registrar Cagada',
                onPressed: _submit,
                height: 50,
                borderRadius: 12,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateTimeSection() {
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.calendar_today_rounded, color: AppColors.primary, size: 20),
          ),
          title: Text(
            'Data',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textLight,
            ),
          ),
          subtitle: Text(
            _formatDate(_cagadaController.diaCagada),
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.text,
            ),
          ),
          trailing: Icon(Icons.chevron_right_rounded, color: AppColors.textLight),
          onTap: () => _selectDate(context),
        ),
        const Divider(height: 1),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.access_time_rounded, color: AppColors.primary, size: 20),
          ),
          title: Text(
            'Hora de Início',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textLight,
            ),
          ),
          subtitle: Text(
            _cagadaController.horaInicio.format(context),
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.text,
            ),
          ),
          trailing: Icon(Icons.chevron_right_rounded, color: AppColors.textLight),
          onTap: () => _selectTime(context, true),
        ),
        const Divider(height: 1),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.access_time_rounded, color: AppColors.primary, size: 20),
          ),
          title: Text(
            'Hora de Fim',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textLight,
            ),
          ),
          subtitle: Text(
            _cagadaController.horaFim.format(context),
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.text,
            ),
          ),
          trailing: Icon(Icons.chevron_right_rounded, color: AppColors.textLight),
          onTap: () => _selectTime(context, false),
        ),
      ],
    );
  }

  Widget _buildSwitchOptions() {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              SwitchListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                title: Text(
                  'Cagada Pública',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.text,
                  ),
                ),
                subtitle: Text(
                  'Aparecerá no ranking geral',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textLight,
                  ),
                ),
                value: _cagadaController.isPublic,
                activeColor: AppColors.primary,
                onChanged: (value) {
                  setState(() {
                    _cagadaController.isPublic = value;
                  });
                },
              ),
              const Divider(height: 1, indent: 16),
              SwitchListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                title: Text(
                  'Entupiu o vaso?',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.text,
                  ),
                ),
                subtitle: Text(
                  'Conta pontos no ranking',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textLight,
                  ),
                ),
                value: _cagadaController.cloggedToilet,
                activeColor: AppColors.primary,
                onChanged: (value) {
                  setState(() {
                    _cagadaController.cloggedToilet = value;
                  });
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      final duracaoMinutos = _calcularDuracao();
      if (duracaoMinutos <= 0) {
        Get.snackbar(
          'Atenção',
          'A hora de fim deve ser maior que a hora de início',
          backgroundColor: AppColors.error.withOpacity(0.9),
          colorText: Colors.white,
        );
        return;
      }

      try {
        Get.dialog(
          Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ),
          barrierDismissible: false,
        );

        final valor = _calcularValor();
        Uint8List? imageBytes;

        final resumo = await _cagadaController.addCagada(
          salario: double.parse(_cagadaController.salarioController.text),
          horasPorSemana: int.parse(_cagadaController.horasPorSemanaController.text),
          duracaoMinutos: duracaoMinutos,
          peso: _cagadaController.pesoController.text.isNotEmpty
              ? double.parse(_cagadaController.pesoController.text)
              : 0.0,
          entupiu: _cagadaController.cloggedToilet,
          publica: _cagadaController.isPublic,
          valor: valor.toPrecision(2),
          imagem: imageBytes,
          periodoPagamento: _cagadaController.periodoPagamento,
          diaCagada: _cagadaController.diaCagada,
          horaInicio: _cagadaController.horaInicio,
          horaFim: _cagadaController.horaFim,
        );

        Get.back(); // Fecha o loading
        _exibirResumo(resumo);
      } catch (e) {
        Get.back(); // Fecha o loading em caso de erro
        Get.snackbar(
          'Erro',
          'Falha ao registrar cagada: ${e.toString()}',
          backgroundColor: AppColors.error.withOpacity(0.9),
          colorText: Colors.white,
        );
      }
    }
  }

  int _calcularDuracao() {
    final inicio = DateTime(
      _cagadaController.diaCagada.year,
      _cagadaController.diaCagada.month,
      _cagadaController.diaCagada.day,
      _cagadaController.horaInicio.hour,
      _cagadaController.horaInicio.minute,
    );
    final fim = DateTime(
      _cagadaController.diaCagada.year,
      _cagadaController.diaCagada.month,
      _cagadaController.diaCagada.day,
      _cagadaController.horaFim.hour,
      _cagadaController.horaFim.minute,
    );
    return fim.difference(inicio).inMinutes;
  }

  double _calcularValor() {
    final salario = double.parse(_cagadaController.salarioController.text);
    final horasPorSemana = int.parse(_cagadaController.horasPorSemanaController.text);
    final duracaoMinutos = _calcularDuracao();

    final horasPorMes =
        _cagadaController.periodoPagamento == 'mensal' ? horasPorSemana * 4 : horasPorSemana * 2;
    final valorPorMinuto = salario / (horasPorMes * 60);

    return valorPorMinuto * duracaoMinutos;
  }

  Future<void> _selectDate(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _cagadaController.diaCagada,
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              onSurface: AppColors.text,
            ),
          ),
          child: child!,
        );
      },
    );
    if (pickedDate != null) {
      setState(() {
        _cagadaController.diaCagada = pickedDate;
      });
    }
  }

  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: isStartTime ? _cagadaController.horaInicio : _cagadaController.horaFim,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              onSurface: AppColors.text,
            ),
          ),
          child: child!,
        );
      },
    );
    if (pickedTime != null) {
      setState(() {
        if (isStartTime) {
          _cagadaController.horaInicio = pickedTime;
        } else {
          _cagadaController.horaFim = pickedTime;
        }
      });
    }
  }

  void _exibirResumo(Map<String, dynamic>? resumo) {
    if (resumo == null) return;

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.check_circle_rounded,
                  size: 60,
                  color: AppColors.success,
                ),
                const SizedBox(height: 16),
                Text(
                  'Cagada Registrada!',
                  style: AppTextStyles.titleMedium.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 24),
                _buildResumoItem('Valor Ganho', 'R\$ ${resumo['valor'].toStringAsFixed(2)}'),
                _buildResumoItem('Duração', '${resumo['duracaoMinutos']} minutos'),
                _buildResumoItem('Data', _formatDate(resumo['diaCagada'])),
                _buildResumoItem('Hora Início', resumo['horaInicio'].format(context)),
                _buildResumoItem('Hora Fim', resumo['horaFim'].format(context)),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      _cagadaController.limparCampos();
                      Get.back(); // Fecha o pop-up
                      Get.back(); // Volta para a tela anterior
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: Text(
                      'Concluir',
                      style: AppTextStyles.buttonMedium,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildResumoItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textLight,
            ),
          ),
          Text(
            value,
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.text,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
