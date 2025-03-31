import 'package:caga_cash/controllers/auth_controller.dart';
import 'package:caga_cash/core/widgets/main_wrapper.dart';
import 'package:caga_cash/views/configuracoes_view.dart';
import 'package:caga_cash/views/historic_view.dart';
import 'package:caga_cash/views/nova_cagada_view.dart';
import 'package:caga_cash/views/ranking_view.dart';
import 'package:caga_cash/views/register_view.dart';
import 'package:caga_cash/views/relatorios_view.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'controllers/auth_middleware.dart';
import 'controllers/cagada_controller.dart';
import 'controllers/settings_controller.dart';
import 'firebase_options.dart';
import 'views/home_view.dart';
import 'views/login_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Get.put(CagadaController());
  Get.put(SettingsController());
  Get.put(AuthController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Salário Cagado',
      theme: ThemeData(primarySwatch: Colors.brown),
      initialRoute: '/',
      //routes: Routes.setRoute,
      getPages: [
        GetPage(
          name: '/',
          page: () => LoginView(),
        ),
        GetPage(
          name: '/register',
          page: () => RegisterView(),
        ),
        GetPage(
          name: '/home',
          page: () => MainWrapper(),
          middlewares: [AuthMiddleware()],
        ),
        GetPage(
          name: '/nova_cagada',
          page: () => NovaCagadaView(),
          middlewares: [AuthMiddleware()],
        ),
        GetPage(
          name: '/relatorios',
          page: () => RelatoriosView(),
          middlewares: [AuthMiddleware()],
        ),
        GetPage(
          name: '/historico',
          page: () => HistoricoView(),
          middlewares: [AuthMiddleware()],
        ),
        GetPage(
          name: '/ranking',
          page: () => RankingView(),
          middlewares: [AuthMiddleware()],
        ),
        GetPage(
          name: '/settings',
          page: () => ConfiguracoesView(),
          middlewares: [AuthMiddleware()],
        ),
      ],
    );
  }
}
