import 'package:flutter/material.dart';
import 'package:flutter_campeonato_flutter/features/auth/presentation/login_screen.dart';

void main() {
  runApp(const CopaDoMundoApp());
}

class CopaDoMundoApp extends StatelessWidget {
  const CopaDoMundoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Copa do Mundo 2026',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0B5FFF),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF4F7FB),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0B1F4D),
          foregroundColor: Colors.white,
          centerTitle: false,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFFE61E4D),
          foregroundColor: Colors.white,
        ),
      ),
      initialRoute: '/',
      routes: {'/': (context) => const LoginScreen()},
    );
  }
}
