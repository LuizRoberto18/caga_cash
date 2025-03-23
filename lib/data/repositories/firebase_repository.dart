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
    await _firestore.collection('users/$userId/cagadas').doc(cagada.id).set(cagada.toJson());
  }

  Future<List<CagadaModel>> buscarHistorico(String userId) async {
    final snapshot = await _firestore.collection('users/$userId/cagadas').get();
    return snapshot.docs.map((doc) => CagadaModel.fromJson(doc.data())).toList();
  }
  Stream<List<CagadaModel>> getCagadas(String userId) {
    return _firestore.collection('users/$userId/cagadas').snapshots().map(
          (snapshot) => snapshot.docs
          .map((doc) => CagadaModel.fromJson(doc.data()))
          .toList(),
    );
  }
}
