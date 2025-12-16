import 'dart:convert'; // Para converter JSON
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/dashboard_model.dart';
import '../models/transacao_model.dart';
import 'auth_service.dart';

class ApiService {
  // ATENÇÃO: Se usares emulador Android, usa 10.0.2.2
  // Se fosses rodar no iOS (Simulador), seria localhost
  static const String baseUrl = "http://10.0.2.2:8080";
  final AuthService _authService = AuthService();

  // Busca os dados do Dashboard do usuário logado
  Future<DashboardModel> getDashboard() async {
    final usuarioId = await _authService.obterUsuarioId();
    if (usuarioId == null) {
      throw Exception('Usuário não está logado');
    }

    final url = Uri.parse('$baseUrl/transacoes/dashboard/$usuarioId');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // Sucesso! Converte o texto JSON para Objeto
        final Map<String, dynamic> dados = jsonDecode(response.body);
        return DashboardModel.fromJson(dados);
      } else {
        throw Exception('Erro ao carregar dashboard: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }

  // Novo método para buscar a lista
  Future<List<TransacaoModel>> getTransacoes() async {
    final usuarioId = await _authService.obterUsuarioId();
    if (usuarioId == null) {
      throw Exception('Usuário não está logado');
    }

    final url = Uri.parse('$baseUrl/transacoes/usuario/$usuarioId');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // O JSON aqui é uma Lista [...] e não um Objeto {...}
        List<dynamic> body = jsonDecode(response.body);
        
        // Transforma cada item da lista em um TransacaoModel
        List<TransacaoModel> transacoes = body
            .map((dynamic item) => TransacaoModel.fromJson(item))
            .toList();
            
        return transacoes;
      } else {
        throw Exception('Falha ao carregar transações');
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }

  // Novo método para SALVAR (POST)
  Future<bool> cadastrarTransacao({
    required String descricao,
    required double valor,
    required String tipo, // "RECEITA" ou "DESPESA"
  }) async {
    final usuarioId = await _authService.obterUsuarioId();
    if (usuarioId == null) {
      debugPrint('Usuário não está logado');
      return false;
    }

    final url = Uri.parse('$baseUrl/transacoes');

    // Pega a data de hoje formatada (yyyy-MM-dd)
    String dataHoje = DateTime.now().toIso8601String().split('T')[0];

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "descricao": descricao,
          "valor": valor,
          "tipo": tipo,
          "data": dataHoje,
          "usuario": {"id": usuarioId}, // Usa o ID do usuário logado
          "categoria": {"id": 1}, // Fixo no MVP (Categoria Padrão)
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true; // Deu certo!
      } else {
        debugPrint("Erro API: ${response.body}");
        return false;
      }
    } catch (e) {
      debugPrint("Erro Conexão: $e");
      return false;
    }
  }
}
