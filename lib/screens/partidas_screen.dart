import 'package:flutter/material.dart';
import '../services/api_service.dart';

class PartidasScreen extends StatefulWidget {
  final bool canEdit;

  const PartidasScreen({super.key, this.canEdit = true});

  @override
  State<PartidasScreen> createState() => _PartidasScreenState();
}

class _PartidasScreenState extends State<PartidasScreen> {
  final ApiService _apiService = ApiService();
  List<dynamic> _partidas = [];
  List<dynamic> _equipes = [];
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _buscarDados();
  }

  Future<void> _buscarDados() async {
    setState(() {
      _carregando = true;
    });

    final resultados = await Future.wait([
      _apiService.fetchPartidas(),
      _apiService.fetchEquipes(),
    ]);

    if (!mounted) return;

    setState(() {
      _partidas = resultados[0];
      _equipes = resultados[1];
      _carregando = false;
    });
  }

  int _idEquipe(dynamic equipe) {
    return int.tryParse('${equipe['idTime'] ?? equipe['id_equipe']}') ?? 0;
  }

  int _idPartida(dynamic partida) {
    return int.tryParse('${partida['idPartida']}') ?? 0;
  }

  int _idEquipeCasa(dynamic partida) {
    return int.tryParse('${partida['idEquipeCasa']}') ?? 0;
  }

  int _idEquipeVisitante(dynamic partida) {
    return int.tryParse('${partida['idEquipeVisitante']}') ?? 0;
  }

  String _nomeEquipe(int idEquipe) {
    for (final equipe in _equipes) {
      if (_idEquipe(equipe) == idEquipe) {
        return equipe['nome'] ?? 'Equipe $idEquipe';
      }
    }
    return 'Equipe $idEquipe';
  }

  Future<void> _abrirFormulario({dynamic partida}) async {
    if (_equipes.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cadastre pelo menos duas equipes antes da partida.'),
        ),
      );
      return;
    }

    final editando = partida != null;
    final dataController = TextEditingController(
      text: editando ? '${partida['dataPartida'] ?? ''}' : '',
    );
    final placarCasaController = TextEditingController(
      text: editando ? '${partida['placarCasa'] ?? 0}' : '0',
    );
    final placarVisitanteController = TextEditingController(
      text: editando ? '${partida['placarVisitante'] ?? 0}' : '0',
    );

    int idCasa = editando ? _idEquipeCasa(partida) : _idEquipe(_equipes.first);
    int idVisitante = editando
        ? _idEquipeVisitante(partida)
        : _idEquipe(_equipes[1]);
    final idsEquipes = _equipes.map(_idEquipe).toSet();
    if (!idsEquipes.contains(idCasa)) {
      idCasa = _idEquipe(_equipes.first);
    }
    if (!idsEquipes.contains(idVisitante) || idVisitante == idCasa) {
      idVisitante = _equipes
          .map(_idEquipe)
          .firstWhere(
            (id) => id != idCasa,
            orElse: () => _idEquipe(_equipes.last),
          );
    }

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return AlertDialog(
              title: Text(editando ? 'Editar Partida' : 'Cadastrar Partida'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: dataController,
                      decoration: const InputDecoration(
                        labelText: 'Data da Partida',
                        hintText: 'AAAA-MM-DD',
                      ),
                    ),
                    DropdownButtonFormField<int>(
                      initialValue: idCasa,
                      decoration: const InputDecoration(
                        labelText: 'Equipe da Casa',
                      ),
                      items: _equipes.map((equipe) {
                        final id = _idEquipe(equipe);
                        return DropdownMenuItem<int>(
                          value: id,
                          child: Text('${equipe['nome']} (ID $id)'),
                        );
                      }).toList(),
                      onChanged: (valor) {
                        if (valor != null) {
                          setModalState(() => idCasa = valor);
                        }
                      },
                    ),
                    DropdownButtonFormField<int>(
                      initialValue: idVisitante,
                      decoration: const InputDecoration(
                        labelText: 'Equipe Visitante',
                      ),
                      items: _equipes.map((equipe) {
                        final id = _idEquipe(equipe);
                        return DropdownMenuItem<int>(
                          value: id,
                          child: Text('${equipe['nome']} (ID $id)'),
                        );
                      }).toList(),
                      onChanged: (valor) {
                        if (valor != null) {
                          setModalState(() => idVisitante = valor);
                        }
                      },
                    ),
                    TextField(
                      controller: placarCasaController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Placar Casa',
                      ),
                    ),
                    TextField(
                      controller: placarVisitanteController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Placar Visitante',
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final data = dataController.text.trim();
                    final placarCasa = int.tryParse(
                      placarCasaController.text.trim(),
                    );
                    final placarVisitante = int.tryParse(
                      placarVisitanteController.text.trim(),
                    );

                    if (data.isEmpty ||
                        placarCasa == null ||
                        placarVisitante == null ||
                        idCasa == idVisitante) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Preencha os dados e escolha equipes diferentes.',
                          ),
                        ),
                      );
                      return;
                    }

                    final sucesso = editando
                        ? await _apiService.atualizarPartida(
                            _idPartida(partida),
                            data,
                            placarCasa,
                            placarVisitante,
                            idCasa,
                            idVisitante,
                          )
                        : await _apiService.cadastrarPartida(
                            data,
                            placarCasa,
                            placarVisitante,
                            idCasa,
                            idVisitante,
                          );

                    if (!context.mounted) return;
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          sucesso
                              ? 'Partida salva com sucesso!'
                              : 'Erro ao salvar partida.',
                        ),
                      ),
                    );
                    if (sucesso) _buscarDados();
                  },
                  child: const Text('Salvar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _confirmarExclusao(dynamic partida) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir Partida'),
        content: const Text('Deseja excluir esta partida?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );

    if (confirmar != true) return;

    final sucesso = await _apiService.deletarPartida(_idPartida(partida));
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          sucesso
              ? 'Partida excluida com sucesso!'
              : 'Erro ao excluir partida.',
        ),
      ),
    );
    if (sucesso) _buscarDados();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.canEdit ? 'Gerenciar Partidas' : 'Partidas'),
        backgroundColor: const Color(0xFF0B1F4D),
        foregroundColor: Colors.white,
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _buscarDados),
        ],
      ),
      body: _carregando
          ? const Center(child: CircularProgressIndicator())
          : _partidas.isEmpty
          ? const Center(child: Text('Nenhuma partida cadastrada ainda.'))
          : ListView.builder(
              itemCount: _partidas.length,
              itemBuilder: (context, index) {
                final partida = _partidas[index];
                final casa = _idEquipeCasa(partida);
                final visitante = _idEquipeVisitante(partida);
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: ListTile(
                    leading: const Icon(
                      Icons.sports_soccer,
                      color: Colors.orange,
                      size: 40,
                    ),
                    title: Text(
                      '${_nomeEquipe(casa)} ${partida['placarCasa']} x ${partida['placarVisitante']} ${_nomeEquipe(visitante)}',
                    ),
                    subtitle: Text(
                      'Data: ${partida['dataPartida']} | ID: ${_idPartida(partida)}',
                    ),
                    trailing: widget.canEdit
                        ? Wrap(
                            spacing: 4,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () =>
                                    _abrirFormulario(partida: partida),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () => _confirmarExclusao(partida),
                              ),
                            ],
                          )
                        : null,
                  ),
                );
              },
            ),
      floatingActionButton: widget.canEdit
          ? FloatingActionButton(
              onPressed: () => _abrirFormulario(),
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
