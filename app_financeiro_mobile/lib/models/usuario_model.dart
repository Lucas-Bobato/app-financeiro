class Usuario {
  final int id;
  final String nome;
  final String email;
  final String senha;
  final String tipoPlano;

  Usuario({
    required this.id,
    required this.nome,
    required this.email,
    required this.senha,
    required this.tipoPlano,
  });

  // Método para converter JSON em Objeto Usuario
  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'] ?? 0,
      nome: json['nome'] ?? '',
      email: json['email'] ?? '',
      senha: json['senha'] ?? '',
      tipoPlano: json['tipoPlano'] ?? 'FREE',
    );
  }

  // Método para converter Objeto Usuario em JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'email': email,
      'senha': senha,
      'tipoPlano': tipoPlano,
    };
  }
}
