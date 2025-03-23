import 'package:caga_cash/views/home_view.dart';
import 'package:caga_cash/views/nova_cagada_view.dart';
import 'package:flutter/material.dart';

import '../views/login_view.dart';
import '../views/register_view.dart';

class Routes {
  static String? initial = '/';
  static Map<String, Widget Function(BuildContext)> setRoute = {
    '/': (context) => LoginView(),
    '/home': (context) => HomeView(),
    '/nova_cagada': (context) => NovaCagadaView(),
    '/register': (context) => RegisterView(),
    //'/history': (context) => HistoryView(),
    //'/ranking': (context) => RankingView(),
    //'/reports': (context) => ReportsView(),
    //'/settings': (context) => SettingsView(),
  };
}
