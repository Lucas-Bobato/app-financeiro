import 'package:flutter/material.dart';
import 'screens/dashboard_screen.dart'; // Importa a tela que acabamos de criar
import 'screens/login_screen.dart';
import 'services/auth_service.dart';

void main() {
  runApp(const AppFinanceiro());
}

class AppFinanceiro extends StatelessWidget {
  const AppFinanceiro({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Financeiro',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      // Aqui definimos qual é a primeira tela que o app abre
      home: const SplashScreen(),

      // Tira aquela faixa vermelha de "DEBUG" no canto
      debugShowCheckedModeBanner: false,
    );
  }
}

// Tela de Splash para verificar se o usuário está logado
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _verificarSessao();
  }

  Future<void> _verificarSessao() async {
    await Future.delayed(const Duration(seconds: 1)); // Pequeno delay para splash
    
    final estaLogado = await _authService.estaLogado();
    
    if (mounted) {
      if (estaLogado) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DashboardScreen()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF181A20),
      body: Center(
        child: CircularProgressIndicator(
          color: Color(0xFF1FDE82),
        ),
      ),
    );
  }
}

