import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

import '../../controllers/auth_controller.dart';
import '../repositories/firebase_repository.dart';

class FirebaseTestService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseRepository _repository = FirebaseRepository();

  // Teste de conexão com o Storage
  Future<void> testarConexaoStorage() async {
    try {
      final ref = _storage.ref().child('test_connection.txt');
      await ref.putString(DateTime.now().toString());
      print('✅ Conexão com Storage OK');
    } catch (e) {
      print('❌ Erro na conexão com Storage: $e');
    }
  }

  // Teste de permissões do Firestore
  Future<void> testarPermissoesFirestore() async {
    try {
      final userId = Get.find<AuthController>().user.value?.uid ?? 'test';
      await _firestore.collection('test_permissions').doc(userId).set({
        'test': DateTime.now().toString(),
      });
      print('✅ Permissões do Firestore OK');
    } catch (e) {
      print('❌ Erro nas permissões do Firestore: $e');
    }
  }

  // Teste completo de upload
  Future<void> testarUploadCompleto() async {
    try {
      // Cria arquivo de teste
      final tempDir = await getTemporaryDirectory();
      final testFile = File('${tempDir.path}/test_upload.jpg');
      await testFile.writeAsBytes(Uint8List.fromList(List.generate(100, (i) => i)));

      // Faz upload
      //final url = await _repository.uploadImagem(testFile, 'test_user');
      //print('✅ Upload teste bem-sucedido. URL: $url');
    } catch (e) {
      print('❌ Falha no teste de upload: $e');
    }
  }
}
