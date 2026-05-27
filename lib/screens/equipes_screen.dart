import 'package:flutter/material.dart';
import '../services/api_service.dart';

class EquipesScreen extends StatefulWidget {
  final bool canEdit;

  const EquipesScreen({super.key, this.canEdit = true});

  @override
  State<EquipesScreen> createState() => _EquipesScreenState();
}

class _EquipesScreenState extends State<EquipesScreen> {
  final ApiService _apiService = ApiService();
  List<dynamic> _equipes = [];
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _buscarEquipes();
  }

  Future<void> _buscarEquipes() async {
    setState(() {
      _carregando = true;
    });

    final equipes = await _apiService.fetchEquipes();
    if (!mounted) return;

    setState(() {
      _equipes = equipes;
      _carregando = false;
    });
  }

  int _idEquipe(dynamic equipe) {
    return int.tryParse('${equipe['idTime'] ?? equipe['id_equipe']}') ?? 0;
  }

  Future<void> _abrirFormulario({dynamic equipe}) async {
    final editando = equipe != null;
    final nomeController = TextEditingController(
      text: editando ? '${equipe['nome'] ?? ''}' : '',
    );
    final cidadeController = TextEditingController(
      text: editando ? '${equipe['cidade'] ?? ''}' : '',
    );

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(editando ? 'Editar Equipe' : 'Cadastrar Nova Equipe'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nomeController,
                decoration: const InputDecoration(labelText: 'Nome da Equipe'),
              ),
              TextField(
                controller: cidadeController,
                decoration: const InputDecoration(labelText: 'Cidade'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                final nome = nomeController.text.trim();
                final cidade = cidadeController.text.trim();
                if (nome.isEmpty || cidade.isEmpty) return;

                final sucesso = editando
                    ? await _apiService.atualizarEquipe(
                        _idEquipe(equipe),
                        nome,
                        cidade,
                      )
                    : await _apiService.cadastrarEquipe(nome, cidade);

                if (!context.mounted) return;
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      sucesso
                          ? 'Equipe salva com sucesso!'
                          : 'Erro ao salvar equipe.',
                    ),
                  ),
                );
                if (sucesso) _buscarEquipes();
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _confirmarExclusao(dynamic equipe) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir Equipe'),
        content: Text('Deseja excluir ${equipe['nome'] ?? 'esta equipe'}?'),
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

    final sucesso = await _apiService.deletarEquipe(_idEquipe(equipe));
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          sucesso
              ? 'Equipe excluida com sucesso!'
              : 'Erro ao excluir. Verifique se ela possui jogadores ou partidas.',
        ),
      ),
    );
    if (sucesso) _buscarEquipes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.canEdit ? 'Gerenciar Selecoes' : 'Selecoes'),
        backgroundColor: const Color(0xFF0B1F4D),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _buscarEquipes,
          ),
        ],
      ),
      body: _carregando
          ? const Center(child: CircularProgressIndicator())
          : _equipes.isEmpty
          ? const Center(child: Text('Nenhuma equipe cadastrada ainda.'))
          : ListView.builder(
              itemCount: _equipes.length,
              itemBuilder: (context, index) {
                final equipe = _equipes[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: ListTile(
                    leading: const Icon(
                      Icons.shield,
                      color: Colors.green,
                      size: 40,
                    ),
                    title: Text(equipe['nome'] ?? 'Sem nome'),
                    subtitle: Text(
                      'Cidade: ${equipe['cidade'] ?? 'Sem cidade'} | ID: ${_idEquipe(equipe)}',
                    ),
                    trailing: widget.canEdit
                        ? Wrap(
                            spacing: 4,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () =>
                                    _abrirFormulario(equipe: equipe),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () => _confirmarExclusao(equipe),
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
