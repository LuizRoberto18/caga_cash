import 'dart:io';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import '../data/models/cagada_model.dart';
import '../data/repositories/pdf_repository.dart';

class PdfController extends GetxController {
  final PdfRepository _pdfRepository = PdfRepository();

  Future<void> baixarCertificado(CagadaModel cagada) async {
    File file = await _pdfRepository.gerarCertificado(cagada);
    OpenFile.open(file.path);
  }
}
