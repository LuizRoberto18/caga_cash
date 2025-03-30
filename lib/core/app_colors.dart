import 'package:flutter/material.dart';

class AppColors {
  // Cores principais
  static const primary = Color(0xFFD7B377); // Dourado principal
  static const secondary = Color(0xFFF5E6CA); // Bege claro
  static const accent = Color(0xFFC8963E); // Dourado escuro
  static const background = Color(0xFFF9F5F0); // Bege mais claro

  // Cores de texto
  static const text = Color(0xFF4E342E); // Marrom escuro
  static const textLight = Color(0xFF8D6E63); // Marrom mais claro
  static const textLighter = Color(0xFFBCAAA4); // Marrom muito claro

  // Cores de status
  static const success = Color(0xFF4CAF50); // Verde
  static const error = Color(0xFFF44336); // Vermelho
  static const warning = Color(0xFFFFC107); // Amarelo
  static const info = Color(0xFF2196F3); // Azul

  // Cores neutras
  static const white = Color(0xFFFFFFFF);
  static const black = Color(0xFF000000);
  static const grey = Color(0xFF9E9E9E);
  static const lightGrey = Color(0xFFEEEEEE);

  // Gradientes
  static LinearGradient primaryGradient = LinearGradient(
    colors: [primary, accent],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
