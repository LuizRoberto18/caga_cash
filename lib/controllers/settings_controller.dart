import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class SettingsController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Configurações existentes
  final exibirPublicas = true.obs;
  final salarioPorHora = 0.0.obs;

  // Novos campos para perfil
  final nomeUsuario = ''.obs;
  final fotoPerfilUrl = ''.obs;
  final carregando = false.obs;

  final TextEditingController nomeController = TextEditingController();
  final TextEditingController senhaAtualController = TextEditingController();
  final TextEditingController novaSenhaController = TextEditingController();
  final TextEditingController confirmarSenhaController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    _carregarDadosUsuario();
  }

  Future<void> _carregarDadosUsuario() async {
    final user = _auth.currentUser;
    if (user != null) {
      nomeUsuario.value = user.displayName ?? '';
      fotoPerfilUrl.value = user.photoURL ?? '';
      nomeController.text = nomeUsuario.value;
    }
  }

  Future<void> atualizarNome() async {
    try {
      carregando.value = true;
      await _auth.currentUser?.updateDisplayName(nomeController.text);
      nomeUsuario.value = nomeController.text;
      Get.snackbar('Sucesso', 'Nome atualizado com sucesso');
    } catch (e) {
      Get.snackbar('Erro', 'Falha ao atualizar nome: ${e.toString()}');
    } finally {
      carregando.value = false;
    }
  }

  Future<void> atualizarFotoPerfil() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        carregando.value = true;
        final file = File(pickedFile.path);
        final user = _auth.currentUser;
        final ref = _storage.ref().child('perfis/${user?.uid}.jpg');

        await ref.putFile(file);
        final url = await ref.getDownloadURL();

        await user?.updatePhotoURL(url);
        fotoPerfilUrl.value = url;

        Get.snackbar('Sucesso', 'Foto de perfil atualizada');
      }
    } catch (e) {
      Get.snackbar('Erro', 'Falha ao atualizar foto: ${e.toString()}');
    } finally {
      carregando.value = false;
    }
  }

  Future<void> alterarSenha() async {
    if (novaSenhaController.text != confirmarSenhaController.text) {
      Get.snackbar('Erro', 'As senhas não coincidem');
      return;
    }

    try {
      carregando.value = true;
      final user = _auth.currentUser;
      final cred = EmailAuthProvider.credential(
        email: user?.email ?? '',
        password: senhaAtualController.text,
      );

      await user?.reauthenticateWithCredential(cred);
      await user?.updatePassword(novaSenhaController.text);

      Get.snackbar('Sucesso', 'Senha alterada com sucesso');
      senhaAtualController.clear();
      novaSenhaController.clear();
      confirmarSenhaController.clear();
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Erro', 'Falha ao alterar senha: ${e.message}');
    } catch (e) {
      Get.snackbar('Erro', 'Erro inesperado: ${e.toString()}');
    } finally {
      carregando.value = false;
    }
  }

  Future<void> salvarPreferencias(double salario) async {
    salarioPorHora.value = salario;
    // Adicione aqui a lógica para salvar no Firestore se necessário
    Get.snackbar('Sucesso', 'Preferências salvas');
  }
}