import 'package:caga_cash/views/nova_cagada_view.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'controllers/cagada_controller.dart';
import 'controllers/settings_controller.dart';
import 'core/routes.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Get.put(CagadaController());
  Get.put(SettingsController());
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
      initialRoute: Routes.initial,
      routes: Routes.setRoute,
    );
  }
}
