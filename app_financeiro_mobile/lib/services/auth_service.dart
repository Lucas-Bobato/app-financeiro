import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/usuario_model.dart';

class AuthService {
  static const String baseUrl = "http://10.0.2.2:8080";

  // Login
  Future<Map<String, dynamic>> login(String email, String senha) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/usuarios/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'senha': senha}),
      );

      if (response.statusCode == 200) {
        final usuario = Usuario.fromJson(jsonDecode(response.body));
        await salvarSessao(usuario.id);
        return {'success': true, 'usuario': usuario};
      } else {
        final erro = jsonDecode(response.body);
        return {'success': false, 'message': erro['erro'] ?? 'Erro ao fazer login'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Erro de conexão: $e'};
    }
  }

  // Registro
  Future<Map<String, dynamic>> registrar(
      String nome, String email, String senha, String tipoPlano) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/usuarios/registrar'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'nome': nome,
          'email': email,
          'senha': senha,
          'tipoPlano': tipoPlano,
        }),
      );

      if (response.statusCode == 200) {
        final usuario = Usuario.fromJson(jsonDecode(response.body));
        await salvarSessao(usuario.id);
        return {'success': true, 'usuario': usuario};
      } else {
        final erro = jsonDecode(response.body);
        return {'success': false, 'message': erro['erro'] ?? 'Erro ao registrar'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Erro de conexão: $e'};
    }
  }

  // Salvar sessão (ID do usuário)
  Future<void> salvarSessao(int usuarioId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('usuarioId', usuarioId);
  }

  // Obter ID do usuário logado
  Future<int?> obterUsuarioId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('usuarioId');
  }

  // Verificar se está logado
  Future<bool> estaLogado() async {
    final usuarioId = await obterUsuarioId();
    return usuarioId != null;
  }

  // Logout
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('usuarioId');
  }
}
