import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../models/dashboard_model.dart';
import '../models/transacao_model.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';
import 'add_transacao_screen.dart';
import 'categorias_screen.dart';
import 'login_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final ApiService apiService = ApiService();
  final AuthService authService = AuthService();
  late Future<DashboardModel> _dashboardFuture;
  late Future<List<TransacaoModel>> _transacoesFuture;

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  void _carregarDados() {
    setState(() {
      _dashboardFuture = apiService.getDashboard();
      _transacoesFuture = apiService.getTransacoes();
    });
  }

  void _navegarParaCadastro(String tipo) async {
    final resultado = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddTransacaoScreen(tipoTransacao: tipo),
      ),
    );

    if (resultado == true) {
      _carregarDados();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        // Importante para rolar a tela toda
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. O SALDO (FutureBuilder do Dashboard)
            FutureBuilder<DashboardModel>(
              future: _dashboardFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError || !snapshot.hasData) {
                  // Se der erro, mostra 0.00 pra não ficar feio
                  return _buildBalanceCard(
                    DashboardModel(
                      totalReceitas: 0,
                      totalDespesas: 0,
                      saldo: 0,
                    ),
                  );
                }
                return _buildBalanceCard(snapshot.data!);
              },
            ),

            const SizedBox(height: 24),
            _buildActionButtons(),
            const SizedBox(height: 24),

            const Text(
              "Transações Recentes",
              style: TextStyle(
                color: AppColors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16),

            // 2. A LISTA (Novo FutureBuilder para Transações)
            FutureBuilder<List<TransacaoModel>>(
              future: _transacoesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text(
                      "Nenhuma transação ainda.",
                      style: TextStyle(color: Colors.grey),
                    ),
                  );
                }

                final transacoes = snapshot.data!;

                // Cria a lista visualmente
                return ListView.builder(
                  shrinkWrap: true, // Importante: Ocupa só o espaço necessário
                  physics:
                      const NeverScrollableScrollPhysics(), // Quem rola é a tela inteira, não a lista interna
                  itemCount: transacoes.length,
                  itemBuilder: (context, index) {
                    final transacao = transacoes[index];
                    return _buildTransactionItem(
                      icon: transacao.tipo == "RECEITA"
                          ? Icons.arrow_upward
                          : Icons.fastfood, // Ícone simples por enquanto
                      title: transacao.descricao,
                      date: transacao.data,
                      amount: "R\$ ${transacao.valor.toStringAsFixed(2)}",
                      isExpense: transacao.tipo == "DESPESA",
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // --- PEDAÇOS DA TELA (Widgets Separados para organizar) ---

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent, // Transparente
      elevation: 0, // Sem sombra
      title: Row(
        children: [
          const CircleAvatar(
            backgroundImage: NetworkImage(
              'https://i.pravatar.cc/150?img=11',
            ), // Foto aleatória
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                "Olá, Lucas 👋",
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
              Text(
                "Bem-vindo de volta",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert, color: Colors.white),
          color: AppColors.darkGrey,
          onSelected: (value) async {
            if (value == 'categorias') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CategoriasScreen()),
              );
            } else if (value == 'logout') {
              await authService.logout();
              if (mounted) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              }
            }
          },
          itemBuilder: (BuildContext context) {
            return [
              const PopupMenuItem<String>(
                value: 'categorias',
                child: Row(
                  children: [
                    Icon(Icons.category, color: AppColors.white),
                    SizedBox(width: 8),
                    Text('Categorias', style: TextStyle(color: AppColors.white)),
                  ],
                ),
              ),
              const PopupMenuItem<String>(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.exit_to_app, color: AppColors.white),
                    SizedBox(width: 8),
                    Text('Sair', style: TextStyle(color: AppColors.white)),
                  ],
                ),
              ),
            ];
          },
        ),
      ],
    );
  }

  Widget _buildBalanceCard(DashboardModel dados) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [Color(0xFF00C6FB), Color(0xFF005BEA)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Saldo Total",
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(
            "R\$ ${dados.saldo.toStringAsFixed(2)}",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Receitas: R\$ ${dados.totalReceitas.toStringAsFixed(2)}",
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
              Text(
                "Despesas: R\$ ${dados.totalDespesas.toStringAsFixed(2)}",
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Botão Receita (Entrada)
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => _navegarParaCadastro("RECEITA"),
            icon: const Icon(Icons.arrow_upward, color: Colors.black),
            label: const Text("Entrada"),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryGreen,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        // Botão Despesa (Saída)
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => _navegarParaCadastro("DESPESA"),
            icon: const Icon(Icons.arrow_downward, color: Colors.white),
            label: const Text("Saída"),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2A2D3E),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionItem({
    required IconData icon,
    required String title,
    required String date,
    required String amount,
    required bool isExpense,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.darkGrey, // Fundo do item
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          // Ícone Redondo
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.black,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 16),
          // Textos
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  date,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
          // Valor
          Text(
            amount,
            style: TextStyle(
              color: isExpense ? AppColors.expense : AppColors.income,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}