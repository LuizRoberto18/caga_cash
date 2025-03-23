import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/pdf_controller.dart';
import '../data/models/cagada_model.dart';

class CertificadoView extends StatelessWidget {
  final PdfController pdfController = Get.put(PdfController());
  final CagadaModel cagada;

  CertificadoView({required this.cagada});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Certificado")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Deseja baixar o certificado desta cagada?", style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => pdfController.baixarCertificado(cagada),
              child: Text("Baixar Certificado"),
            ),
          ],
        ),
      ),
    );
  }
}
