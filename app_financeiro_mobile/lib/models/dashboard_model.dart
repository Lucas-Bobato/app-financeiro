class DashboardModel {
  final double totalReceitas;
  final double totalDespesas;
  final double saldo;

  DashboardModel({
    required this.totalReceitas,
    required this.totalDespesas,
    required this.saldo,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return DashboardModel(
      totalReceitas: (json['totalReceitas'] as num?)?.toDouble() ?? 0.0,
      totalDespesas: (json['totalDespesas'] as num?)?.toDouble() ?? 0.0,
      saldo: (json['saldo'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
