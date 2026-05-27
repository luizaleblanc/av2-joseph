import 'package:flutter/material.dart';
import '../../../core/network/api_service.dart';
import '../data/equipe_repository.dart';
import '../domain/equipe_model.dart';

class EquipesScreen extends StatefulWidget {
  final bool canEdit;

  const EquipesScreen({super.key, this.canEdit = true});

  @override
  State<EquipesScreen> createState() => _EquipesScreenState();
}

class _EquipesScreenState extends State<EquipesScreen> {
  late final EquipeRepository _repository;
  
  List<EquipeModel> _equipes = [];
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _repository = EquipeRepository(ApiService());
    _buscarEquipes();
  }

  Future<void> _buscarEquipes() async {
    setState(() => _carregando = true);

    final equipes = await _repository.obterEquipes();
    
    if (!mounted) return;
    setState(() {
      _equipes = equipes;
      _carregando = false;
    });
  }

  Future<void> _abrirFormulario({EquipeModel? equipe}) async {
    final editando = equipe != null;
    final nomeController = TextEditingController(text: equipe?.nome ?? '');
    final cidadeController = TextEditingController(text: equipe?.cidade ?? '');

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(editando ? 'Editar Equipa' : 'Cadastrar Nova Equipa'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nomeController,
                decoration: const InputDecoration(labelText: 'Nome da Equipa'),
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
                    ? await _repository.atualizarEquipe(equipe.id, nome, cidade)
                    : await _repository.salvarEquipe(nome, cidade);

                if (!context.mounted) return;
                Navigator.pop(context);
                
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(sucesso ? 'Guardado com sucesso!' : 'Erro ao guardar.')),
                );
                
                if (sucesso) _buscarEquipes();
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _confirmarExclusao(EquipeModel equipe) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir Equipa'),
        content: Text('Deseja excluir a equipa ${equipe.nome}?'),
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

    final sucesso = await _repository.removerEquipe(equipe.id);
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(sucesso ? 'Equipa excluída!' : 'Erro ao excluir.')),
    );
    if (sucesso) _buscarEquipes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.canEdit ? 'Gerir Seleções' : 'Seleções'),
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
              ? const Center(child: Text('Nenhuma equipa registada ainda.'))
              : ListView.builder(
                  itemCount: _equipes.length,
                  itemBuilder: (context, index) {
                    final equipe = _equipes[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: ListTile(
                        leading: const Icon(Icons.shield, color: Colors.green, size: 40),
                        title: Text(equipe.nome),
                        subtitle: Text('Cidade: ${equipe.cidade} | ID: ${equipe.id}'),
                        trailing: widget.canEdit
                            ? Wrap(
                                spacing: 4,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () => _abrirFormulario(equipe: equipe),
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