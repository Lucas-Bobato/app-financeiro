import 'package:flutter/material.dart';
import 'screens/dashboard_screen.dart'; // Importa a tela que acabamos de criar

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
      home: const DashboardScreen(),

      // Tira aquela faixa vermelha de "DEBUG" no canto
      debugShowCheckedModeBanner: false,
    );
  }
}
