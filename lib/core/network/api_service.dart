import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static String get baseUrl {
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:5000';
    }
    return 'http://localhost:5000';
  }

  Future<bool> cadastrarUsuario({
    required String nome,
    required String email,
    required String senha,
    required String perguntaSeguranca,
    required String respostaSeguranca,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/cadastro'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'nome': nome,
          'email': email,
          'senha': senha,
          'pergunta_seguranca': perguntaSeguranca,
          'resposta_seguranca': respostaSeguranca,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = json.decode(response.body) as Map<String, dynamic>;
        return body['code'] == 201 || body['code'] == 200;
      }
    } catch (e) {
      debugPrint('Erro ao cadastrar usuario: $e');
    }
    return false;
  }

  Future<bool> loginUsuario({
    required String email,
    required String senha,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'senha': senha,
        }),
      );

      if (response.statusCode == 200) {
        final body = json.decode(response.body) as Map<String, dynamic>;
        return body['code'] == 200;
      }
    } catch (e) {
      debugPrint('Erro ao fazer login: $e');
    }
    return false;
  }

  Future<bool> validarRecuperacao({
    required String email,
    required String perguntaSeguranca,
    required String respostaSeguranca,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/recuperar/validar'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'pergunta_seguranca': perguntaSeguranca,
          'resposta_seguranca': respostaSeguranca,
        }),
      );

      if (response.statusCode == 200) {
        final body = json.decode(response.body) as Map<String, dynamic>;
        return body['code'] == 200;
      }
    } catch (e) {
      debugPrint('Erro ao validar recuperacao: $e');
    }
    return false;
  }

  Future<List<dynamic>> fetchEquipes() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/listaequipes'));
      if (response.statusCode == 200) {
        return json.decode(response.body) as List<dynamic>;
      }
    } catch (e) {
      debugPrint('Erro ao buscar equipes: $e');
    }
    return [];
  }

  Future<bool> cadastrarEquipe(String nome, String cidade) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/cadastraequipe'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'nomeEquipe': nome, 'cidadeEquipe': cidade}),
      );
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('Erro ao cadastrar equipe: $e');
      return false;
    }
  }

  Future<bool> atualizarEquipe(int idEquipe, String nome, String cidade) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/atualizaequipe'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'idEquipe': idEquipe,
          'nomeEquipe': nome,
          'cidadeEquipe': cidade,
        }),
      );
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('Erro ao atualizar equipe: $e');
      return false;
    }
  }

  Future<bool> deletarEquipe(int idEquipe) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/removeequipe'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'idEquipe': idEquipe}),
      );
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('Erro ao deletar equipe: $e');
      return false;
    }
  }

  Future<List<dynamic>> fetchJogadores({int? idSelecao}) async {
    try {
      final uri = Uri.parse('$baseUrl/listajogadores').replace(
        queryParameters: idSelecao == null
            ? null
            : {'idSelecao': idSelecao.toString()},
      );
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        return json.decode(response.body) as List<dynamic>;
      }
    } catch (e) {
      debugPrint('Erro ao buscar jogadores: $e');
    }
    return [];
  }

  Future<bool> cadastrarJogador(
    String nome,
    String posicao,
    int idEquipe,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/cadastrajogador'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'nomeJogador': nome,
          'posicaoJogador': posicao,
          'idTimeFk': idEquipe,
        }),
      );
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('Erro ao cadastrar jogador: $e');
      return false;
    }
  }

  Future<bool> atualizarJogador(
    int idJogador,
    String nome,
    String posicao,
    int idEquipe,
  ) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/atualizajogador'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'idJogador': idJogador,
          'nomeJogador': nome,
          'posicaoJogador': posicao,
          'idTimeFk': idEquipe,
        }),
      );
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('Erro ao atualizar jogador: $e');
      return false;
    }
  }

  Future<bool> deletarJogador(int idJogador) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/removejogador'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'idJogador': idJogador}),
      );
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('Erro ao deletar jogador: $e');
      return false;
    }
  }

  Future<List<dynamic>> fetchPartidas() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/listapartidas'));
      if (response.statusCode == 200) {
        return json.decode(response.body) as List<dynamic>;
      }
    } catch (e) {
      debugPrint('Erro ao buscar partidas: $e');
    }
    return [];
  }

  Future<bool> cadastrarPartida(
    String data,
    int placarCasa,
    int placarVisitante,
    int idEquipeCasa,
    int idEquipeVisitante,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/cadastrapartida'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'dataPartida': data,
          'placarEquipeCasa': placarCasa,
          'placarEquipeVisitante': placarVisitante,
          'idEquipeCasa': idEquipeCasa,
          'idEquipeVisitante': idEquipeVisitante,
        }),
      );
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('Erro ao cadastrar partida: $e');
      return false;
    }
  }

  Future<bool> atualizarPartida(
    int idPartida,
    String data,
    int placarCasa,
    int placarVisitante,
    int idEquipeCasa,
    int idEquipeVisitante,
  ) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/atualizapartida'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'idPartida': idPartida,
          'dataPartida': data,
          'placarEquipeCasa': placarCasa,
          'placarEquipeVisitante': placarVisitante,
          'idEquipeCasa': idEquipeCasa,
          'idEquipeVisitante': idEquipeVisitante,
        }),
      );
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('Erro ao atualizar partida: $e');
      return false;
    }
  }

  Future<bool> deletarPartida(int idPartida) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/removepartida'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'idPartida': idPartida}),
      );
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('Erro ao deletar partida: $e');
      return false;
    }
  }
}
