import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../services/categoria_service.dart';

class AddCategoriaScreen extends StatefulWidget {
  const AddCategoriaScreen({super.key});

  @override
  State<AddCategoriaScreen> createState() => _AddCategoriaScreenState();
}

class _AddCategoriaScreenState extends State<AddCategoriaScreen> {
  final _nomeController = TextEditingController();
  final _categoriaService = CategoriaService();
  bool _isLoading = false;

  Future<void> _salvarCategoria() async {
    if (_nomeController.text.trim().isEmpty) {
      _mostrarMensagem('Digite o nome da categoria', isErro: true);
      return;
    }

    setState(() => _isLoading = true);

    final sucesso = await _categoriaService.criarCategoria(_nomeController.text.trim());

    setState(() => _isLoading = false);

    if (sucesso) {
      _mostrarMensagem('Categoria criada com sucesso');
      if (mounted) {
        Navigator.pop(context, true);
      }
    } else {
      _mostrarMensagem('Erro ao criar categoria', isErro: true);
    }
  }

  void _mostrarMensagem(String mensagem, {bool isErro = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensagem),
        backgroundColor: isErro ? AppColors.expense : AppColors.income,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Nova Categoria',
          style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            TextField(
              controller: _nomeController,
              style: const TextStyle(color: AppColors.white),
              decoration: InputDecoration(
                labelText: 'Nome da Categoria',
                labelStyle: const TextStyle(color: AppColors.grey),
                hintText: 'Ex: Lazer, Transporte, Educação',
                hintStyle: const TextStyle(color: AppColors.grey),
                prefixIcon: const Icon(Icons.category, color: AppColors.grey),
                filled: true,
                fillColor: AppColors.darkGrey,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _isLoading ? null : _salvarCategoria,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
                foregroundColor: AppColors.background,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.background,
                      ),
                    )
                  : const Text(
                      'Salvar Categoria',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nomeController.dispose();
    super.dispose();
  }
}
