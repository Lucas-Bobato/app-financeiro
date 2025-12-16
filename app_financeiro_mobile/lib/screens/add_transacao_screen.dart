import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../services/api_service.dart';

class AddTransacaoScreen extends StatefulWidget {
  final String tipoTransacao; // Vamos receber "RECEITA" ou "DESPESA"

  const AddTransacaoScreen({super.key, required this.tipoTransacao});

  @override
  State<AddTransacaoScreen> createState() => _AddTransacaoScreenState();
}

class _AddTransacaoScreenState extends State<AddTransacaoScreen> {
  final _valorController = TextEditingController();
  final _descricaoController = TextEditingController();
  bool _isLoading = false;

  // Define a cor baseada no tipo (Verde para receita, Vermelho para despesa)
  Color get _corPrincipal => widget.tipoTransacao == 'RECEITA'
      ? AppColors.primaryGreen
      : AppColors.expense;

  Future<void> _salvar() async {
    if (_valorController.text.isEmpty || _descricaoController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Preencha todos os campos!")),
      );
      return;
    }

    setState(() => _isLoading = true);

    // Substitui vírgula por ponto para o Java entender (ex: 50,00 -> 50.00)
    double valor = double.parse(_valorController.text.replaceAll(',', '.'));

    final sucesso = await ApiService().cadastrarTransacao(
      descricao: _descricaoController.text,
      valor: valor,
      tipo: widget.tipoTransacao,
    );

    setState(() => _isLoading = false);

    if (!mounted) return;

    if (sucesso) {
      // Volta para o Dashboard avisando que salvou
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erro ao salvar. Tente novamente.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          widget.tipoTransacao == 'RECEITA' ? "Nova Receita" : "Nova Despesa",
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Valor",
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
            const SizedBox(height: 10),

            // INPUT DE VALOR GIGANTE (Estilo Finzo)
            TextField(
              controller: _valorController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              style: TextStyle(
                color: _corPrincipal,
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
              decoration: InputDecoration(
                prefixText: "R\$ ",
                prefixStyle: TextStyle(color: _corPrincipal, fontSize: 40),
                border: InputBorder.none, // Sem borda para ficar clean
                hintText: "0.00",
                hintStyle: TextStyle(color: Colors.grey.withValues(alpha: 0.5)),
              ),
            ),

            const SizedBox(height: 40),

            // INPUT DE DESCRIÇÃO
            const Text(
              "Descrição",
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _descricaoController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.darkGrey, // Fundo cinza escuro
                hintText: "Ex: Almoço, Salário...",
                hintStyle: const TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const Spacer(), // Empurra o botão para o final da tela
            // BOTÃO DE SALVAR
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _salvar,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _corPrincipal,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "Salvar",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
