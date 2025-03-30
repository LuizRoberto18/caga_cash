import 'dart:typed_data';

import 'package:caga_cash/core/widgets/gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../controllers/cagada_controller.dart';
import '../core/app_colors.dart';
import '../core/app_text_styles.dart';
import '../core/widgets/auth_text_field.dart';

class NovaCagadaView extends StatefulWidget {
  @override
  _NovaCagadaViewState createState() => _NovaCagadaViewState();
}

class _NovaCagadaViewState extends State<NovaCagadaView> {
  final CagadaController _cagadaController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nova Cagada', style: AppTextStyles.titleLarge),
        backgroundColor: AppColors.primary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AuthTextField(
              controller: _cagadaController.salarioController,
              hint: '0.0',
              icon: MdiIcons.cash,
              keyboardType: TextInputType.number,
              label: 'Salário',
            ),
            SizedBox(height: 16),
            AuthTextField(
              controller: _cagadaController.horasPorSemanaController,
              label: 'Horas por Semana',
              hint: "44",
              icon: MdiIcons.hours24,
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _cagadaController.periodoPagamento,
              items: ['mensal', 'quinzenal'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _cagadaController.periodoPagamento = value!;
                });
              },
              decoration: InputDecoration(
                labelText: 'Período de Pagamento',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            AuthTextField(
              controller: _cagadaController.pesoController,
              label: 'Peso (opcional)',
              hint: '1.0',
              icon: MdiIcons.scaleBalance,
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            // Row(
            //   children: [
            //     Expanded(
            //       child: CustomButton(
            //         text: 'Tirar Foto',
            //         onPressed: () => _pickImage(ImageSource.camera),
            //       ),
            //     ),
            //     SizedBox(width: 16),
            //     Expanded(
            //       child: CustomButton(
            //         text: 'Escolher da Galeria',
            //         onPressed: () => _pickImage(ImageSource.gallery),
            //       ),
            //     ),
            //   ],
            // ),
            // SizedBox(height: 16),
            if (_cagadaController.imagem != null)
              Image.file(
                _cagadaController.imagem!,
                height: 150,
                fit: BoxFit.cover,
              ),
            SizedBox(height: 16),
            SwitchListTile(
              title: Text('Pública', style: AppTextStyles.bodyMedium),
              value: _cagadaController.isPublic,
              onChanged: (value) {
                setState(() {
                  _cagadaController.isPublic = value;
                });
              },
            ),
            SwitchListTile(
              title: Text('Entupiu o vaso?', style: AppTextStyles.bodyMedium),
              value: _cagadaController.cloggedToilet,
              onChanged: (value) {
                setState(() {
                  _cagadaController.cloggedToilet = value;
                });
              },
            ),
            SizedBox(height: 16),
            ListTile(
              title: Text(
                  'Dia da Cagada: ${_cagadaController.diaCagada.toLocal().toString().split(' ')[0]}'),
              trailing: Icon(Icons.calendar_today),
              onTap: () => _selectDate(context),
            ),
            SizedBox(height: 16),
            ListTile(
              title: Text('Hora de Início: ${_cagadaController.horaInicio.format(context)}'),
              trailing: Icon(Icons.access_time),
              onTap: () => _selectTime(context, true),
            ),
            SizedBox(height: 16),
            ListTile(
              title: Text('Hora de Fim: ${_cagadaController.horaFim.format(context)}'),
              trailing: Icon(Icons.access_time),
              onTap: () => _selectTime(context, false),
            ),
            SizedBox(height: 24),
            GradientButton(
              text: 'Registrar Cagada',
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }

  // // Método para selecionar imagem da câmera ou galeria
  // Future<void> _pickImage(ImageSource source) async {
  //   final pickedFile = await ImagePicker().pickImage(source: source);
  //   if (pickedFile != null) {
  //     setState(() {
  //       _cagadaController.imagem = File(pickedFile.path);
  //     });
  //   }
  // }

  // Método para calcular a duração em minutos
  int _calcularDuracao() {
    final inicio = DateTime(
        _cagadaController.diaCagada.year,
        _cagadaController.diaCagada.month,
        _cagadaController.diaCagada.day,
        _cagadaController.horaInicio.hour,
        _cagadaController.horaInicio.minute);
    final fim = DateTime(
        _cagadaController.diaCagada.year,
        _cagadaController.diaCagada.month,
        _cagadaController.diaCagada.day,
        _cagadaController.horaFim.hour,
        _cagadaController.horaFim.minute);
    final diferenca = fim.difference(inicio);
    return diferenca.inMinutes;
  }

  // Método para calcular o valor ganho pela cagada
  double _calcularValor() {
    final salario = double.tryParse(_cagadaController.salarioController.text) ?? 0.0;
    final horasPorSemana = int.tryParse(_cagadaController.horasPorSemanaController.text) ?? 0;
    final duracaoMinutos = _calcularDuracao();

    if (salario <= 0 || horasPorSemana <= 0 || duracaoMinutos <= 0) {
      return 0.0;
    }

    // Calcula o valor por minuto
    final horasPorMes =
        _cagadaController.periodoPagamento == 'mensal' ? horasPorSemana * 4 : horasPorSemana * 2;
    final valorPorMinuto = salario / (horasPorMes * 60);

    // Calcula o valor total
    return valorPorMinuto * duracaoMinutos;
  }

  // Método para validar e enviar os dados
  Future<void> _submit() async {
    if (_cagadaController.salarioController.text.isEmpty ||
        _cagadaController.horasPorSemanaController.text.isEmpty) {
      Get.snackbar('Erro', 'Salário e horas por semana são obrigatórios');
      return;
    }

    final duracaoMinutos = _calcularDuracao();
    if (duracaoMinutos <= 0) {
      Get.snackbar('Erro', 'A hora de fim deve ser maior que a hora de início');
      return;
    }

    try {
      // Mostra loading
      Get.dialog(Center(child: CircularProgressIndicator()), barrierDismissible: false);

      Uint8List? imageBytes;
      if (_cagadaController.imagem != null) {
        imageBytes = await _cagadaController.imagem!.readAsBytes();
        print("Imagem convertida para bytes: ${imageBytes.lengthInBytes} bytes");
      }

      final valor = _calcularValor();

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

      _exibirResumo(
        resumo?['valor'],
        resumo?['duracaoMinutos'],
        resumo?['diaCagada'],
        resumo?['horaInicio'],
        resumo?['horaFim'],
      );
    } catch (e) {
      Get.back(); // Fecha o loading em caso de erro
      Get.snackbar('Erro', 'Falha ao registrar cagada: ${e.toString()}');
    }
  }

  // Método para selecionar a data da cagada
  Future<void> _selectDate(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _cagadaController.diaCagada,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        _cagadaController.diaCagada = pickedDate;
      });
    }
  }

  // Método para selecionar a hora de início ou fim
  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: isStartTime ? _cagadaController.horaInicio : _cagadaController.horaFim,
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

  // Método para exibir o pop-up de resumo
  void _exibirResumo(double valor, int duracaoMinutos, DateTime diaCagada, TimeOfDay horaInicio,
      TimeOfDay horaFim) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Cagada Registrada!', style: AppTextStyles.titleLarge),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Você ganhou:', style: AppTextStyles.bodyMedium),
              Text('R\$ ${valor.toStringAsFixed(2)}', style: AppTextStyles.titleLarge),
              SizedBox(height: 16),
              Text('Duração: $duracaoMinutos minutos', style: AppTextStyles.bodyMedium),
              Text('Data: ${diaCagada.toLocal().toString().split(' ')[0]}',
                  style: AppTextStyles.bodyMedium),
              Text('Hora de Início: ${horaInicio.format(context)}',
                  style: AppTextStyles.bodyMedium),
              Text('Hora de Fim: ${horaFim.format(context)}', style: AppTextStyles.bodyMedium),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Limpa os campos e volta para a tela home
                _cagadaController.limparCampos();
                Get.back(); // Fecha o pop-up
                Get.back(); // Volta para a tela home
              },
              child: Text('OK', style: TextStyle(color: AppColors.accent)),
            ),
          ],
        );
      },
    );
  }
}
