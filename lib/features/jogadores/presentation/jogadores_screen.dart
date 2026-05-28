import 'package:flutter/material.dart';
import '../../../core/network/api_service.dart';
import '../../../core/widgets/copa_banner_header.dart';
import '../data/jogador_repository.dart';
import '../domain/jogador_model.dart';

class JogadoresScreen extends StatefulWidget {
  final bool canEdit;

  const JogadoresScreen({super.key, this.canEdit = true});

  @override
  State<JogadoresScreen> createState() => _JogadoresScreenState();
}

class _JogadoresScreenState extends State<JogadoresScreen> {
  late final JogadorRepository _repository;

  List<JogadorModel> _jogadores = [];
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _repository = JogadorRepository(ApiService());
    _buscarJogadores();
  }

  Future<void> _buscarJogadores() async {
    setState(() => _carregando = true);

    final jogadores = await _repository.obterJogadores();

    if (!mounted) return;
    setState(() {
      _jogadores = jogadores;
      _carregando = false;
    });
  }

  Future<void> _exibirFormulario({JogadorModel? jogador}) async {
    final editando = jogador != null;
    final nomeController = TextEditingController(text: jogador?.nome ?? '');
    final posicaoController = TextEditingController(
      text: jogador?.posicao ?? '',
    );
    final idTimeController = TextEditingController(
      text: editando ? jogador.idEquipe.toString() : '',
    );

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          top: 20,
          left: 20,
          right: 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              editando ? 'Editar Jogador' : 'Cadastrar Jogador',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: nomeController,
              decoration: const InputDecoration(labelText: 'Nome do Jogador'),
            ),
            TextField(
              controller: posicaoController,
              decoration: const InputDecoration(labelText: 'Posição'),
            ),
            TextField(
              controller: idTimeController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'ID da Equipe'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final nome = nomeController.text.trim();
                final posicao = posicaoController.text.trim();
                final idTime = int.tryParse(idTimeController.text.trim());

                if (nome.isEmpty || posicao.isEmpty || idTime == null) return;

                final sucesso = editando
                    ? await _repository.atualizarJogador(
                        jogador.id,
                        nome,
                        posicao,
                        idTime,
                      )
                    : await _repository.salvarJogador(nome, posicao, idTime);

                if (!context.mounted) return;
                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      sucesso
                          ? 'Jogador salvo com sucesso!'
                          : 'Erro ao salvar. Verifique o ID da equipe.',
                    ),
                  ),
                );

                if (sucesso) _buscarJogadores();
              },
              child: const Text('Salvar'),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmarExclusao(JogadorModel jogador) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir Jogador'),
        content: Text('Deseja excluir o jogador ${jogador.nome}?'),
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

    final sucesso = await _repository.removerJogador(jogador.id);
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(sucesso ? 'Jogador excluído!' : 'Erro ao excluir.'),
      ),
    );
    if (sucesso) _buscarJogadores();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CopaBannerHeader(
        title: widget.canEdit ? 'Gerir Jogadores' : 'Jogadores',
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            color: const Color(0xFF0B1F4D),
            onPressed: _buscarJogadores,
          ),
        ],
      ),
      body: _carregando
          ? const Center(child: CircularProgressIndicator())
          : _jogadores.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.person_off, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    'Nenhum jogador registado.',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: _jogadores.length,
              itemBuilder: (context, index) {
                final jogador = _jogadores[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: ListTile(
                    leading: const CircleAvatar(child: Icon(Icons.person)),
                    title: Text(jogador.nome),
                    subtitle: Text(
                      'Posição: ${jogador.posicao} | Equipe ID: ${jogador.idEquipe}',
                    ),
                    trailing: widget.canEdit
                        ? Wrap(
                            spacing: 4,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () =>
                                    _exibirFormulario(jogador: jogador),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () => _confirmarExclusao(jogador),
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
              onPressed: () => _exibirFormulario(),
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
