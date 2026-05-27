class JogadorModel {
  final int id;
  final String nome;
  final String posicao;
  final int idEquipe;

  JogadorModel({
    required this.id,
    required this.nome,
    required this.posicao,
    required this.idEquipe,
  });

  factory JogadorModel.fromJson(Map<String, dynamic> json) {
    return JogadorModel(
      id: int.tryParse(json['idJogador']?.toString() ?? '0') ?? 0,
      nome: json['nomeJogador'] ?? 'Sem Nome',
      posicao: json['posicaoJogador'] ?? 'N/A',
      idEquipe: int.tryParse(json['idTimeFk']?.toString() ?? '0') ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idJogador': id,
      'nomeJogador': nome,
      'posicaoJogador': posicao,
      'idTimeFk': idEquipe,
    };
  }
}