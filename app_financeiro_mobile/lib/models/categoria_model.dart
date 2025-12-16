class Categoria {
  final int id;
  final String nome;
  final int? usuarioId;

  Categoria({
    required this.id,
    required this.nome,
    this.usuarioId,
  });

  factory Categoria.fromJson(Map<String, dynamic> json) {
    return Categoria(
      id: json['id'] ?? 0,
      nome: json['nome'] ?? '',
      usuarioId: json['usuario'] != null ? json['usuario']['id'] : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      if (usuarioId != null) 'usuario': {'id': usuarioId},
    };
  }

  // Se é categoria padrão do sistema
  bool get isPadrao => usuarioId == null;
}
