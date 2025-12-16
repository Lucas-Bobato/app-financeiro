import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../models/categoria_model.dart';
import '../services/categoria_service.dart';
import 'add_categoria_screen.dart';

class CategoriasScreen extends StatefulWidget {
  const CategoriasScreen({super.key});

  @override
  State<CategoriasScreen> createState() => _CategoriasScreenState();
}

class _CategoriasScreenState extends State<CategoriasScreen> {
  final CategoriaService _categoriaService = CategoriaService();
  late Future<List<Categoria>> _categoriasFuture;

  @override
  void initState() {
    super.initState();
    _carregarCategorias();
  }

  void _carregarCategorias() {
    setState(() {
      _categoriasFuture = _categoriaService.listarCategorias();
    });
  }

  Future<void> _deletarCategoria(Categoria categoria) async {
    if (categoria.isPadrao) {
      _mostrarMensagem('Não é possível deletar categorias padrão', isErro: true);
      return;
    }

    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.darkGrey,
        title: const Text('Confirmar', style: TextStyle(color: AppColors.white)),
        content: Text(
          'Deseja deletar a categoria "${categoria.nome}"?',
          style: const TextStyle(color: AppColors.grey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar', style: TextStyle(color: AppColors.grey)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Deletar', style: TextStyle(color: AppColors.expense)),
          ),
        ],
      ),
    );

    if (confirmar == true) {
      final sucesso = await _categoriaService.deletarCategoria(categoria.id);
      if (sucesso) {
        _mostrarMensagem('Categoria deletada');
        _carregarCategorias();
      } else {
        _mostrarMensagem('Erro ao deletar categoria', isErro: true);
      }
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
          'Categorias',
          style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FutureBuilder<List<Categoria>>(
        future: _categoriasFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primaryGreen),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Erro: ${snapshot.error}',
                style: const TextStyle(color: AppColors.expense),
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'Nenhuma categoria cadastrada',
                style: TextStyle(color: AppColors.grey),
              ),
            );
          }

          final categorias = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: categorias.length,
            itemBuilder: (context, index) {
              final categoria = categorias[index];
              return _buildCategoriaItem(categoria);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final resultado = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddCategoriaScreen()),
          );
          if (resultado == true) {
            _carregarCategorias();
          }
        },
        backgroundColor: AppColors.primaryGreen,
        child: const Icon(Icons.add, color: AppColors.background),
      ),
    );
  }

  Widget _buildCategoriaItem(Categoria categoria) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.darkGrey,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primaryGreen.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.category,
              color: AppColors.primaryGreen,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  categoria.nome,
                  style: const TextStyle(
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                if (categoria.isPadrao)
                  const Text(
                    'Categoria padrão',
                    style: TextStyle(color: AppColors.grey, fontSize: 12),
                  ),
              ],
            ),
          ),
          if (!categoria.isPadrao)
            IconButton(
              icon: const Icon(Icons.delete_outline, color: AppColors.expense),
              onPressed: () => _deletarCategoria(categoria),
            ),
        ],
      ),
    );
  }
}
