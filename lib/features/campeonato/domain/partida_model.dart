class PartidaModel {
  final int id;
  final String data;
  final int placarCasa;
  final int placarVisitante;
  final int idEquipeCasa;
  final int idEquipeVisitante;

  PartidaModel({
    required this.id,
    required this.data,
    required this.placarCasa,
    required this.placarVisitante,
    required this.idEquipeCasa,
    required this.idEquipeVisitante,
  });

  factory PartidaModel.fromJson(Map<String, dynamic> json) {
    return PartidaModel(
      id: int.tryParse(json['idPartida']?.toString() ?? '0') ?? 0,
      data: json['dataPartida'] ?? '',
      placarCasa: int.tryParse(json['placarEquipeCasa']?.toString() ?? '0') ?? 0,
      placarVisitante: int.tryParse(json['placarEquipeVisitante']?.toString() ?? '0') ?? 0,
      idEquipeCasa: int.tryParse(json['idEquipeCasa']?.toString() ?? '0') ?? 0,
      idEquipeVisitante: int.tryParse(json['idEquipeVisitante']?.toString() ?? '0') ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idPartida': id,
      'dataPartida': data,
      'placarEquipeCasa': placarCasa,
      'placarEquipeVisitante': placarVisitante,
      'idEquipeCasa': idEquipeCasa,
      'idEquipeVisitante': idEquipeVisitante,
    };
  }
}