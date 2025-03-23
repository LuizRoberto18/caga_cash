import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../models/cagada_model.dart';

class PdfRepository {
  Future<File> gerarCertificado(CagadaModel cagada) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Center(
          child: pw.Column(
            children: [
              pw.Text("Certificado de Cagada", style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 20),
              pw.Text("Usuário: ${cagada.usuarioNome}", style: pw.TextStyle(fontSize: 18)),
              pw.Text("Data: ${cagada.dataHora.toString()}", style: pw.TextStyle(fontSize: 16)),
              pw.Text("Duração: ${cagada.duracaoMinutos} minutos", style: pw.TextStyle(fontSize: 16)),
              pw.Text("Peso Eliminado: ${cagada.peso.toStringAsFixed(2)} kg", style: pw.TextStyle(fontSize: 16)),
              pw.Text("Valor ganho: R\$ ${cagada.valor.toStringAsFixed(2)}", style: pw.TextStyle(fontSize: 16, color: PdfColors.green)),
              pw.SizedBox(height: 20),
              pw.Text("Parabéns! Seu tempo foi bem aproveitado!", style: pw.TextStyle(fontSize: 14, fontStyle: pw.FontStyle.italic)),
            ],
          ),
        ),
      ),
    );

    final output = await getExternalStorageDirectory();
    final file = File("${output!.path}/certificado_${cagada.id}.pdf");
    await file.writeAsBytes(await pdf.save());

    return file;
  }
}
