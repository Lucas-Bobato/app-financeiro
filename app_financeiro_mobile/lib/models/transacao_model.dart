class TransacaoModel {
  final int id;
  final String descricao;
  final double valor;
  final String tipo; // "RECEITA" ou "DESPESA"
  final String data; // Vem como "2025-12-15"

  TransacaoModel({
    required this.id,
    required this.descricao,
    required this.valor,
    required this.tipo,
    required this.data,
  });

  factory TransacaoModel.fromJson(Map<String, dynamic> json) {
    return TransacaoModel(
      id: json['id'],
      descricao: json['descricao'],
      valor: (json['valor'] as num).toDouble(),
      tipo: json['tipo'],
      data: json['data'],
    );
  }
}
