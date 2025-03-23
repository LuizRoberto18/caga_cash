import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/cagada_model.dart';

class FirebaseRepository {
  final _storage = FirebaseStorage.instance;
  final _firestore = FirebaseFirestore.instance;

  Future<String?> uploadImagem(File file, String userId) async {
    try {
      var ref = _storage.ref().child("cagadas/$userId/${DateTime.now()}.jpg");
      await ref.putFile(file);
      return await ref.getDownloadURL();
    } catch (e) {
      print("Erro ao fazer upload da imagem: $e");
      return null;
    }
  }

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

  // Stream<List<CagadaModel>> getCagadas(String userId) {
  //   return _firestore
  //       .collection('users')
  //       .doc(userId)
  //       .collection('cagadas')
  //       .snapshots()
  //       .map((snapshot) => snapshot.docs.map((doc) => CagadaModel.fromJson(doc.data())).toList());
  // }
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
