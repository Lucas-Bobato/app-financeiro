import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/categoria_model.dart';
import 'auth_service.dart';

class CategoriaService {
  static const String baseUrl = "http://10.0.2.2:8080";
  final AuthService _authService = AuthService();

  // Listar categorias do usuário (incluindo padrões)
  Future<List<Categoria>> listarCategorias() async {
    final usuarioId = await _authService.obterUsuarioId();
    if (usuarioId == null) {
      throw Exception('Usuário não está logado');
    }

    final url = Uri.parse('$baseUrl/categorias/usuario/$usuarioId');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        return body.map((item) => Categoria.fromJson(item)).toList();
      } else {
        throw Exception('Falha ao carregar categorias');
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }

  // Criar nova categoria
  Future<bool> criarCategoria(String nome) async {
    final usuarioId = await _authService.obterUsuarioId();
    if (usuarioId == null) {
      debugPrint('Usuário não está logado');
      return false;
    }

    final url = Uri.parse('$baseUrl/categorias');

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "nome": nome,
          "usuario": {"id": usuarioId},
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        debugPrint("Erro API: ${response.body}");
        return false;
      }
    } catch (e) {
      debugPrint("Erro Conexão: $e");
      return false;
    }
  }

  // Deletar categoria
  Future<bool> deletarCategoria(int categoriaId) async {
    final url = Uri.parse('$baseUrl/categorias/$categoriaId');

    try {
      final response = await http.delete(url);

      if (response.statusCode == 200) {
        return true;
      } else {
        debugPrint("Erro API: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      debugPrint("Erro Conexão: $e");
      return false;
    }
  }
}
