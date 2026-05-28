class JogadorModel {
  final int id;
  final String nome;
  final String posicao;
  final int idEquipe;
  final String? nomeSelecao;

  JogadorModel({
    required this.id,
    required this.nome,
    required this.posicao,
    required this.idEquipe,
    this.nomeSelecao,
  });

  factory JogadorModel.fromJson(Map<String, dynamic> json) {
    return JogadorModel(
      id: int.tryParse(json['idJogador']?.toString() ?? '0') ?? 0,
      nome: json['nomeJogador'] ?? 'Sem Nome',
      posicao: json['posicaoJogador'] ?? 'N/A',
      idEquipe: int.tryParse(json['idTimeFk']?.toString() ?? '0') ?? 0,
      nomeSelecao: json['nomeSelecao'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idJogador': id,
      'nomeJogador': nome,
      'posicaoJogador': posicao,
      'idTimeFk': idEquipe,
      'nomeSelecao': nomeSelecao,
    };
  }
}