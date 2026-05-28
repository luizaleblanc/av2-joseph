import '../../../core/network/api_service.dart';
import '../domain/partida_model.dart';

class PartidaRepository {
  final ApiService _apiService;

  PartidaRepository(this._apiService);

  Future<List<PartidaModel>> obterPartidas() async {
    try {
      final dadosBrutos = await _apiService.fetchPartidas();
      return dadosBrutos
          .map((json) => PartidaModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<bool> salvarPartida(String data, int placarCasa, int placarVisitante, int idCasa, int idVisitante) {
    return _apiService.cadastrarPartida(data, placarCasa, placarVisitante, idCasa, idVisitante);
  }

  Future<bool> atualizarPartida(int id, String data, int placarCasa, int placarVisitante, int idCasa, int idVisitante) {
    return _apiService.atualizarPartida(id, data, placarCasa, placarVisitante, idCasa, idVisitante);
  }

  Future<bool> removerPartida(int id) {
    return _apiService.deletarPartida(id);
  }
}