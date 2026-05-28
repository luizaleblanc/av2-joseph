import '../../../core/network/api_service.dart';
import '../domain/jogador_model.dart';

class JogadorRepository {
  final ApiService _apiService;

  JogadorRepository(this._apiService);

  Future<List<JogadorModel>> obterJogadores() async {
    try {
      final dadosBrutos = await _apiService.fetchJogadores();
      return dadosBrutos
          .map((json) => JogadorModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<JogadorModel>> obterJogadoresPorEquipe(int idEquipe) async {
    try {
      final dadosBrutos = await _apiService.fetchJogadores(idSelecao: idEquipe);
      return dadosBrutos
          .map((json) => JogadorModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<bool> salvarJogador(String nome, String posicao, int idEquipe) {
    return _apiService.cadastrarJogador(nome, posicao, idEquipe);
  }

  Future<bool> atualizarJogador(
    int id,
    String nome,
    String posicao,
    int idEquipe,
  ) {
    return _apiService.atualizarJogador(id, nome, posicao, idEquipe);
  }

  Future<bool> removerJogador(int id) {
    return _apiService.deletarJogador(id);
  }
}
