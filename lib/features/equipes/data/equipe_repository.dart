import '../../../core/network/api_service.dart';
import '../domain/equipe_model.dart';

class EquipeRepository {
  final ApiService _apiService;

  EquipeRepository(this._apiService);

  Future<List<EquipeModel>> obterEquipes() async {
    try {
      final dadosBrutos = await _apiService.fetchEquipes();
      return dadosBrutos
          .map((json) => EquipeModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<bool> salvarEquipe(String nome, String cidade) {
    return _apiService.cadastrarEquipe(nome, cidade);
  }

  Future<bool> atualizarEquipe(int id, String nome, String cidade) {
    return _apiService.atualizarEquipe(id, nome, cidade);
  }

  Future<bool> removerEquipe(int id) {
    return _apiService.deletarEquipe(id);
  }
}

