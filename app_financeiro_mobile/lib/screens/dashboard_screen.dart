import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minhas Finanças'),
        backgroundColor: Colors.green, // Cor de dinheiro! 💲
      ),
      body: const Center(
        child: Text(
          'O Dashboard vai aparecer aqui!',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
