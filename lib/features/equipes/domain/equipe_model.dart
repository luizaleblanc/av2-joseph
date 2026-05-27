class EquipeModel {
  final int id;
  final String nome;
  final String cidade;

  EquipeModel({
    required this.id,
    required this.nome,
    required this.cidade,
  });

  factory EquipeModel.fromJson(Map<String, dynamic> json) {
    return EquipeModel(
      id: int.tryParse(json['idTime']?.toString() ?? json['id_equipe']?.toString() ?? '0') ?? 0,
      nome: json['nome'] ?? 'Sem nome',
      cidade: json['cidade'] ?? 'Sem cidade',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idTime': id,
      'nomeEquipe': nome,
      'cidadeEquipe': cidade,
    };
  }
}