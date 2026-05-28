import 'package:flutter/material.dart';

import '../../../core/network/api_service.dart';
import '../../../core/widgets/copa_banner_header.dart';
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

  static const List<_PaisCopa> _paisesCopa = [
    _PaisCopa('México', 'mx'),
    _PaisCopa('África do Sul', 'za'),
    _PaisCopa('Coreia do Sul', 'kr'),
    _PaisCopa('República Tcheca', 'cz'),
    _PaisCopa('Canadá', 'ca'),
    _PaisCopa('Bósnia e Herzegovina', 'ba'),
    _PaisCopa('Catar', 'qa'),
    _PaisCopa('Suíça', 'ch'),
    _PaisCopa('Brasil', 'br'),
    _PaisCopa('Marrocos', 'ma'),
    _PaisCopa('Haiti', 'ht'),
    _PaisCopa('Escócia', 'gb-sct'),
    _PaisCopa('Estados Unidos', 'us'),
    _PaisCopa('Paraguai', 'py'),
    _PaisCopa('Austrália', 'au'),
    _PaisCopa('Turquia', 'tr'),
    _PaisCopa('Alemanha', 'de'),
    _PaisCopa('Curaçao', 'cw'),
    _PaisCopa('Costa do Marfim', 'ci'),
    _PaisCopa('Equador', 'ec'),
    _PaisCopa('Holanda', 'nl'),
    _PaisCopa('Japão', 'jp'),
    _PaisCopa('Suécia', 'se'),
    _PaisCopa('Tunísia', 'tn'),
    _PaisCopa('Bélgica', 'be'),
    _PaisCopa('Egito', 'eg'),
    _PaisCopa('Irã', 'ir'),
    _PaisCopa('Nova Zelândia', 'nz'),
    _PaisCopa('Espanha', 'es'),
    _PaisCopa('Cabo Verde', 'cv'),
    _PaisCopa('Arábia Saudita', 'sa'),
    _PaisCopa('Uruguai', 'uy'),
    _PaisCopa('França', 'fr'),
    _PaisCopa('Senegal', 'sn'),
    _PaisCopa('Iraque', 'iq'),
    _PaisCopa('Noruega', 'no'),
    _PaisCopa('Argentina', 'ar'),
    _PaisCopa('Argélia', 'dz'),
    _PaisCopa('Áustria', 'at'),
    _PaisCopa('Jordânia', 'jo'),
    _PaisCopa('Portugal', 'pt'),
    _PaisCopa('RD Congo', 'cd'),
    _PaisCopa('Uzbequistão', 'uz'),
    _PaisCopa('Colômbia', 'co'),
    _PaisCopa('Inglaterra', 'gb-eng'),
    _PaisCopa('Croácia', 'hr'),
    _PaisCopa('Gana', 'gh'),
    _PaisCopa('Panamá', 'pa'),
  ];

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
    String paisSelecionado = _paisesCopa
        .firstWhere(
          (pais) => pais.nome == equipe?.nome,
          orElse: () => _paisesCopa.first,
        )
        .nome;

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return AlertDialog(
              title: Text(editando ? 'Editar Equipe' : 'Cadastrar Nova Equipe'),
              content: DropdownButtonFormField<String>(
                initialValue: paisSelecionado,
                decoration: const InputDecoration(
                  labelText: 'País',
                  border: OutlineInputBorder(),
                ),
                items: _paisesCopa
                    .map(
                      (pais) => DropdownMenuItem<String>(
                        value: pais.nome,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _FlagImage(pais: pais, width: 28, height: 20),
                            const SizedBox(width: 10),
                            ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 220),
                              child: Text(
                                pais.nome,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (valor) {
                  if (valor != null) {
                    setModalState(() => paisSelecionado = valor);
                  }
                },
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final sucesso = editando
                        ? await _repository.atualizarEquipe(
                            equipe.id,
                            paisSelecionado,
                            paisSelecionado,
                          )
                        : await _repository.salvarEquipe(
                            paisSelecionado,
                            paisSelecionado,
                          );

                    if (!context.mounted) return;
                    Navigator.pop(context);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          sucesso
                              ? 'Equipe salva com sucesso!'
                              : 'Erro ao salvar.',
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
      },
    );
  }

  Future<void> _confirmarExclusao(EquipeModel equipe) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir Equipe'),
        content: Text('Deseja excluir a equipe ${equipe.nome}?'),
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
      SnackBar(
        content: Text(sucesso ? 'Equipe excluída!' : 'Erro ao excluir.'),
      ),
    );
    if (sucesso) _buscarEquipes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CopaBannerHeader(
        title: widget.canEdit ? 'Gerenciar Seleções' : 'Seleções',
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            color: const Color(0xFF0B1F4D),
            onPressed: _buscarEquipes,
          ),
        ],
      ),
      body: _carregando
          ? const Center(child: CircularProgressIndicator())
          : _equipes.isEmpty
          ? const Center(child: Text('Nenhuma equipe registrada ainda.'))
          : ListView.builder(
              itemCount: _equipes.length,
              itemBuilder: (context, index) {
                final equipe = _equipes[index];
                final pais = _paisPorNome(equipe.nome);

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: ListTile(
                    leading: _FlagImage(pais: pais, width: 46, height: 32),
                    title: Text(equipe.nome),
                    subtitle: Text('País: ${equipe.cidade} | ID: ${equipe.id}'),
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

  _PaisCopa _paisPorNome(String nome) {
    return _paisesCopa.firstWhere(
      (pais) => pais.nome.toLowerCase() == nome.toLowerCase(),
      orElse: () => _PaisCopa(nome, ''),
    );
  }
}

class _PaisCopa {
  final String nome;
  final String codigo;

  const _PaisCopa(this.nome, this.codigo);
}

class _FlagImage extends StatelessWidget {
  final _PaisCopa pais;
  final double width;
  final double height;

  const _FlagImage({
    required this.pais,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    if (pais.codigo.isEmpty) {
      return SizedBox(
        width: width,
        height: height,
        child: const Icon(Icons.flag, color: Color(0xFF64748B)),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: Image.network(
        'https://flagcdn.com/w80/${pais.codigo}.png',
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => SizedBox(
          width: width,
          height: height,
          child: const Icon(Icons.flag, color: Color(0xFF64748B)),
        ),
      ),
    );
  }
}
