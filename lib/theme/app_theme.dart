import 'package:flutter/material.dart';

class AppTheme {
  // 定义自定义颜色
  static const Color customGreen = Color(0xFF46B380);
  static const Color customGreenWithOpacity = Color(0x8046B380); // AD 透明度约等于 0x80

  static ThemeData lightTheme = ThemeData(
    primaryColor: customGreen,
    scaffoldBackgroundColor: customGreenWithOpacity,
    appBarTheme: AppBarTheme(
      backgroundColor: customGreen,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: customGreen,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white70,
    ),
  );
}
