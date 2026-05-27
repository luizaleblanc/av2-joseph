import 'package:flutter/material.dart';
import '../../../core/network/api_service.dart';
import '../../equipes/data/equipe_repository.dart';
import '../../equipes/domain/equipe_model.dart';
import '../data/partida_repository.dart';
import '../domain/partida_model.dart';

class PartidasScreen extends StatefulWidget {
  final bool canEdit;

  const PartidasScreen({super.key, this.canEdit = true});

  @override
  State<PartidasScreen> createState() => _PartidasScreenState();
}

class _PartidasScreenState extends State<PartidasScreen> {
  late final PartidaRepository _partidaRepository;
  late final EquipeRepository _equipeRepository;

  List<PartidaModel> _partidas = [];
  List<EquipeModel> _equipes = [];
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    final apiService = ApiService();
    _partidaRepository = PartidaRepository(apiService);
    _equipeRepository = EquipeRepository(apiService);
    _buscarDados();
  }

  Future<void> _buscarDados() async {
    setState(() => _carregando = true);

    final resultados = await Future.wait([
      _partidaRepository.obterPartidas(),
      _equipeRepository.obterEquipes(),
    ]);

    if (!mounted) return;

    setState(() {
      _partidas = resultados[0] as List<PartidaModel>;
      _equipes = resultados[1] as List<EquipeModel>;
      _carregando = false;
    });
  }

  String _nomeEquipe(int idEquipe) {
    try {
      return _equipes.firstWhere((e) => e.id == idEquipe).nome;
    } catch (_) {
      return 'Desconhecida';
    }
  }

  Future<void> _abrirFormulario({PartidaModel? partida}) async {
    if (_equipes.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cadastre pelo menos duas seleções primeiro.'),
        ),
      );
      return;
    }

    final editando = partida != null;
    final dataController = TextEditingController(text: partida?.data ?? '');
    final placarCasaController = TextEditingController(
      text: partida?.placarCasa.toString() ?? '0',
    );
    final placarVisitanteController = TextEditingController(
      text: partida?.placarVisitante.toString() ?? '0',
    );

    int idCasa = editando ? partida.idEquipeCasa : _equipes.first.id;
    int idVisitante = editando ? partida.idEquipeVisitante : _equipes[1].id;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                top: 24,
                left: 24,
                right: 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    editando ? 'Editar Partida' : 'Nova Partida',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0B1F4D),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: dataController,
                    decoration: InputDecoration(
                      labelText: 'Data (AAAA-MM-DD)',
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<int>(
                          initialValue: _equipes.any((e) => e.id == idCasa)
                              ? idCasa
                              : null,
                          decoration: InputDecoration(
                            labelText: 'Casa',
                            filled: true,
                            fillColor: Colors.grey.shade100,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          items: _equipes
                              .map(
                                (e) => DropdownMenuItem(
                                  value: e.id,
                                  child: Text(e.nome),
                                ),
                              )
                              .toList(),
                          onChanged: (v) => setModalState(() => idCasa = v!),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'X',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      Expanded(
                        child: DropdownButtonFormField<int>(
                          initialValue: _equipes.any((e) => e.id == idVisitante)
                              ? idVisitante
                              : null,
                          decoration: InputDecoration(
                            labelText: 'Visitante',
                            filled: true,
                            fillColor: Colors.grey.shade100,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          items: _equipes
                              .map(
                                (e) => DropdownMenuItem(
                                  value: e.id,
                                  child: Text(e.nome),
                                ),
                              )
                              .toList(),
                          onChanged: (v) =>
                              setModalState(() => idVisitante = v!),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: placarCasaController,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                          decoration: InputDecoration(
                            labelText: 'Gols Casa',
                            filled: true,
                            fillColor: Colors.grey.shade100,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextField(
                          controller: placarVisitanteController,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                          decoration: InputDecoration(
                            labelText: 'Gols Fora',
                            filled: true,
                            fillColor: Colors.grey.shade100,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE61E4D),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () async {
                      final data = dataController.text.trim();
                      final placarCasa =
                          int.tryParse(placarCasaController.text.trim()) ?? 0;
                      final placarVisitante =
                          int.tryParse(placarVisitanteController.text.trim()) ??
                          0;

                      if (data.isEmpty || idCasa == idVisitante) return;

                      final sucesso = editando
                          ? await _partidaRepository.atualizarPartida(
                              partida.id,
                              data,
                              placarCasa,
                              placarVisitante,
                              idCasa,
                              idVisitante,
                            )
                          : await _partidaRepository.salvarPartida(
                              data,
                              placarCasa,
                              placarVisitante,
                              idCasa,
                              idVisitante,
                            );

                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            sucesso
                                ? 'Partida salva com sucesso!'
                                : 'Erro ao salvar partida.',
                          ),
                        ),
                      );
                      if (!sucesso) return;
                      Navigator.pop(context);
                      _buscarDados();
                    },
                    child: const Text(
                      'Confirmar',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _confirmarExclusao(PartidaModel partida) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Remover Partida'),
        content: const Text(
          'Tem certeza que deseja apagar o registro desta partida?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Remover', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirmar != true) return;

    await _partidaRepository.removerPartida(partida.id);
    _buscarDados();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      appBar: AppBar(
        title: Text(widget.canEdit ? 'Gestão de Partidas' : 'Tabela de Jogos'),
        backgroundColor: const Color(0xFF0B1F4D),
        elevation: 0,
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _buscarDados),
        ],
      ),
      body: _carregando
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _partidas.length,
              itemBuilder: (context, index) {
                final partida = _partidas[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: const BoxDecoration(
                          color: Color(0xFFE5E9F2),
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(16),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.calendar_today,
                              size: 14,
                              color: Color(0xFF0B1F4D),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              partida.data,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0B1F4D),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                _nomeEquipe(partida.idEquipeCasa),
                                textAlign: TextAlign.right,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF0B5FFF),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '${partida.placarCasa} - ${partida.placarVisitante}',
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                _nomeEquipe(partida.idEquipeVisitante),
                                textAlign: TextAlign.left,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (widget.canEdit)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12, right: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.grey,
                                ),
                                onPressed: () =>
                                    _abrirFormulario(partida: partida),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete_outline,
                                  color: Colors.redAccent,
                                ),
                                onPressed: () => _confirmarExclusao(partida),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: widget.canEdit
          ? FloatingActionButton.extended(
              onPressed: () => _abrirFormulario(),
              backgroundColor: const Color(0xFFE61E4D),
              icon: const Icon(Icons.add),
              label: const Text(
                'Nova Partida',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            )
          : null,
    );
  }
}
