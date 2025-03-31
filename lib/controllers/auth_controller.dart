import 'package:caga_cash/core/app_colors.dart';
import 'package:caga_cash/core/widgets/snackbar_app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../firebase_options.dart';
import 'cagada_controller.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Observável para armazenar o usuário logado
  var user = Rxn<User>();
  Rx<bool> isLoading = false.obs;
  var currentTab = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _auth.authStateChanges().listen((User? user) {
      this.user.value = user;
      if (user != null) {
        print("Usuário logado: ${user.uid}");
        Get.find<CagadaController>().cagadas.bindStream(
              Get.find<CagadaController>().getCagadasStream(),
            );
      } else {
        print("Nenhum usuário logado.");
        Get.find<CagadaController>().limparDados();
      }
    });
  }

  void changeTab(int index) {
    currentTab.value = index;
  }

  // Método para login com email e senha
// Método para login com email e senha
  Future<void> loginWithEmailAndPassword(String email, String password) async {
    try {
      isLoading.value = true;
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user == null) {
        throw FirebaseAuthException(
          code: 'user-not-found',
          message: 'Usuário não retornado pelo Firebase',
        );
      }

      user.value = userCredential.user;
      Get.offAllNamed('/home');
    } on FirebaseAuthException catch (e) {
      _handleFirebaseAuthError(e, isLogin: true);
    } on PlatformException catch (e) {
      snackBarError(e.message ?? 'Erro desconhecido no login');
    } catch (e) {
      snackBarError('Falha inesperada no login: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

// Método para registro com email e senha
  Future<void> registerWithEmailAndPassword(String email, String password) async {
    try {
      isLoading.value = true;
      final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user == null) {
        throw FirebaseAuthException(
          code: 'user-creation-failed',
          message: 'Falha ao criar usuário',
        );
      }

      user.value = userCredential.user;
      Get.offAllNamed('/home');
    } on FirebaseAuthException catch (e) {
      _handleFirebaseAuthError(e, isLogin: false);
    } on PlatformException catch (e) {
      snackBarError(
        e.message ?? 'Erro desconhecido no cadastro',
      );
    } catch (e) {
      snackBarError(
        'Falha inesperada no cadastro: ${e.toString()}',
      );
    } finally {
      isLoading.value = false;
    }
  }

// Tratamento centralizado de erros de autenticação
  void _handleFirebaseAuthError(FirebaseAuthException e, {required bool isLogin}) {
    String title = isLogin ? 'Erro no login' : 'Erro no cadastro';
    String message;

    switch (e.code) {
      case 'invalid-email':
        message = 'O formato do e-mail é inválido';
        break;
      case 'user-disabled':
        message = 'Esta conta foi desativada';
        break;
      case 'user-not-found':
        message = 'Nenhuma conta encontrada para este e-mail';
        break;
      case 'wrong-password':
        message = 'Senha incorreta';
        break;
      case 'email-already-in-use':
        message = 'Este e-mail já está em uso por outra conta';
        break;
      case 'operation-not-allowed':
        message = 'Login com email/senha não está habilitado';
        break;
      case 'weak-password':
        message = 'A senha é muito fraca (mínimo 6 caracteres)';
        break;
      case 'too-many-requests':
        message = 'Muitas tentativas. Tente novamente mais tarde';
        break;
      case 'network-request-failed':
        message = 'Falha na conexão. Verifique sua internet';
        break;
      default:
        message = 'Erro desconhecido: ${e.message ?? e.code}';
    }

    snackBarError(message);
  }

  // Método para login com Google
  Future<void> loginWithGoogle() async {
    try {
      // Força a desconexão de qualquer sessão anterior
      await _googleSignIn.signOut();

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        // Usuário cancelou o login
        return;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(credential);

      if (userCredential.user == null) {
        throw Exception("Usuário não retornado pelo Firebase");
      }

      user.value = userCredential.user;
      Get.offAllNamed('/home');
    } on FirebaseAuthException catch (e) {
      _handleFirebaseError(e);
    } on PlatformException catch (e) {
      snackBarError(e.message ?? 'Erro desconhecido no login com Google');
    } catch (e) {
      snackBarError('Falha no login: ${e.toString()}');
    }
  }

  void _handleFirebaseError(FirebaseAuthException e) {
    String message;

    switch (e.code) {
      case 'account-exists-with-different-credential':
        message = 'Já existe uma conta com este e-mail';
        break;
      case 'invalid-credential':
        message = 'Credencial inválida';
        break;
      case 'operation-not-allowed':
        message = 'Login com Google não habilitado';
        break;
      case 'user-disabled':
        message = 'Usuário desativado';
        break;
      case 'user-not-found':
        message = 'Usuário não encontrado';
        break;
      default:
        message = 'Erro desconhecido: ${e.code}';
    }

    snackBarError( message
        );
  }

  // Método para logout
  Future<void> logout() async {
    try {
      // 1. Pare todas as consultas ativas primeiro
      Get.find<CagadaController>().limparDados();

      // 2. Faça o logout dos serviços
      await _auth.signOut();
      await _googleSignIn.signOut();

      // 3. Atualize o estado
      user.value = null;

      // 4. Redirecione limpando toda a pilha de navegação
      Get.offAllNamed('/');
    } catch (e) {
      snackBarError( 'Falha no logout: ${e.toString()}');
    }
  }

  Future<void> reiniciarFirebase() async {
    try {
      print('Reiniciando Firebase...');

      // Fecha todas as instâncias
      await Firebase.apps
        ..forEach((app) => app.delete());

      // Re-inicializa
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      print('✅ Firebase reiniciado com sucesso');
    } catch (e) {
      print('❌ Falha ao reiniciar Firebase: $e');
      throw Exception('Reinicialização falhou: $e');
    }
  }

  // Método para obter o email do usuário logado
  String? get userEmail => user.value?.email;

  // Método para verificar se o usuário está logado
  bool get isLoggedIn => user.value != null;
}
