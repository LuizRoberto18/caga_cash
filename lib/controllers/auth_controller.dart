import 'package:firebase_core/firebase_core.dart';
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

  // Método para login com email e senha
  Future<void> loginWithEmailAndPassword(String email, String password) async {
    try {
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      user.value = userCredential.user;
      Get.offAllNamed('/home'); // Redireciona para a tela principal
    } catch (e) {
      Get.snackbar('Erro', 'Falha no login: ${e.toString()}');
    }
  }

  // Método para registro com email e senha
  Future<void> registerWithEmailAndPassword(String email, String password) async {
    try {
      final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      user.value = userCredential.user;
      Get.offAllNamed('/home'); // Redireciona para a tela principal
    } catch (e) {
      Get.snackbar('Erro', 'Falha no cadastro: ${e.toString()}');
    }
  }

  // Método para login com Google
  Future<void> loginWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        final UserCredential userCredential = await _auth.signInWithCredential(credential);
        user.value = userCredential.user;
        Get.offAllNamed('/home'); // Redireciona para a tela principal
      }
    } catch (e) {
      Get.snackbar('Erro', 'Falha no login com Google: ${e.toString()}');
    }
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
      Get.snackbar('Erro', 'Falha no logout: ${e.toString()}');
    }
  }

  Future<void> reiniciarFirebase() async {
    try {
      print('Reiniciando Firebase...');

      // Fecha todas as instâncias
      await Firebase.apps..forEach((app) => app.delete());

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
