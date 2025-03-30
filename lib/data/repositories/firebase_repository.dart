import 'dart:async';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/cagada_model.dart';

class FirebaseRepository {
  final _storage = FirebaseStorage.instance;
  final _firestore = FirebaseFirestore.instance;

  // Future<String?> uploadImagem(File file, String userId) async {
  //   // Verificação EXTRA do arquivo
  //   print("Verificando arquivo...");
  //   print("Caminho: ${file.path}");
  //   print("Tamanho: ${await file.length()} bytes");
  //   print("Existe? ${await file.exists()}");
  //
  //   if (!await file.exists() || (await file.length()) == 0) {
  //     throw Exception("Arquivo inválido ou vazio");
  //   }
  //
  //   try {
  //     // Crie uma estrutura de pastas mais organizada
  //     final storagePath = 'users/$userId/cagadas/${DateTime.now().toIso8601String()}.jpg';
  //     final ref = _storage.ref().child(storagePath);
  //
  //     print("Referência criada: ${ref.fullPath}");
  //
  //     // Adicione metadados explícitos
  //     final metadata = SettableMetadata(
  //       contentType: 'image/jpeg',
  //       customMetadata: {
  //         'uploadedBy': userId,
  //         'uploadedAt': DateTime.now().toIso8601String(),
  //       },
  //     );
  //
  //     // Upload com timeout e tratamento de progresso
  //     final uploadTask = ref.putFile(file, metadata);
  //
  //     uploadTask.snapshotEvents.listen((snapshot) {
  //       print('Progresso: ${(snapshot.bytesTransferred / snapshot.totalBytes) * 100}%');
  //     });
  //
  //     final snapshot = await uploadTask
  //         .timeout(const Duration(seconds: 30), onTimeout: () {
  //       uploadTask.cancel();
  //       throw TimeoutException("Upload excedeu 30 segundos");
  //     });
  //
  //     if (snapshot.state != TaskState.success) {
  //       throw Exception("Estado inesperado: ${snapshot.state}");
  //     }
  //
  //     final downloadUrl = await ref.getDownloadURL();
  //     print("Upload concluído com sucesso!");
  //     print("URL: $downloadUrl");
  //     return downloadUrl;
  //
  //   } on FirebaseException catch (e) {
  //     print("ERRO DO FIREBASE: ${e.code} - ${e.message}");
  //     print("Stack: ${e.stackTrace}");
  //     throw Exception("Falha no Firebase: ${e.code}");
  //   } catch (e) {
  //     print("ERRO INESPERADO: ${e.toString()}");
  //     rethrow;
  //   }
  // }

  Future<void> salvarCagada(String userId, CagadaModel cagada) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('cagadas')
          .doc(cagada.id)
          .set(cagada.toJson());
      print("Cagada salva com sucesso no Firestore!");
    } catch (e) {
      print("Erro ao salvar cagada no Firestore: $e");
      throw Exception("Erro ao salvar cagada: $e");
    }
  }

  Stream<List<CagadaModel>> getCagadasPublicas() {
    try {
      return _firestore
          .collectionGroup('cagadas')
          .where('publica', isEqualTo: true)
          .orderBy('dataHora', descending: true)
          .snapshots()
          .map((snapshot) => snapshot.docs.map((doc) => CagadaModel.fromJson(doc.data())).toList());
    } catch (e) {
      print("Erro na consulta: $e");
      return Stream.value([]);
    }
  }

  Stream<List<CagadaModel>> getCagadasParaRanking(String userId) {
    try {
      return _firestore
          .collectionGroup('cagadas')
          .where('publica', isEqualTo: true)
          .orderBy('dataHora', descending: true)
          .snapshots()
          .handleError((error) {
        print("Erro na consulta de ranking: $error");
        return Stream.value([]);
      }).map((snapshot) {
        final cagadas = snapshot.docs.map((doc) => CagadaModel.fromJson(doc.data())).toList();

        // Filtra as cagadas de outros usuários
        final cagadasOutrosUsuarios = cagadas.where((c) => c.usuarioId != userId).toList();

        print("Cagadas públicas para ranking: ${cagadasOutrosUsuarios.length}");
        return cagadasOutrosUsuarios;
      });
    } catch (e) {
      print("Erro fatal ao configurar stream: $e");
      return Stream.value([]);
    }
  }

  // Método para buscar o histórico de cagadas
  Future<List<CagadaModel>> buscarHistorico(String userId) async {
    try {
      final snapshot = await _firestore.collection('users').doc(userId).collection('cagadas').get();
      return snapshot.docs.map((doc) => CagadaModel.fromJson(doc.data())).toList();
    } catch (e) {
      print("Erro ao buscar histórico: $e");
      throw Exception("Erro ao buscar histórico: $e");
    }
  }

  // Método para buscar o histórico de cagadas em tempo real
  Stream<List<CagadaModel>> getCagadas(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('cagadas')
        .orderBy('dataHora', descending: true) // Ordena por data (opcional)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => CagadaModel.fromJson(doc.data())).toList());
  }
}
