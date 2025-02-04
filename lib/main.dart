import 'package:flutter/material.dart';
import 'package:planter_demo/pages/splash_page.dart';
import 'package:planter_demo/pages/login_page.dart';
import 'package:planter_demo/pages/home_page.dart';
import 'package:planter_demo/theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '植物社区',
      theme: AppTheme.lightTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashPage(),
        '/login': (context) => const LoginPage(),
        '/home': (context) => const HomePage(),
      },
    );
  }
}
