import 'package:flutter/material.dart';
import '../services/api_service.dart';

class JogadoresScreen extends StatefulWidget {
  final bool canEdit;

  const JogadoresScreen({super.key, this.canEdit = true});

  @override
  State<JogadoresScreen> createState() => _JogadoresScreenState();
}

class _JogadoresScreenState extends State<JogadoresScreen> {
  final ApiService _apiService = ApiService();
  List<dynamic> _jogadores = [];
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _buscarJogadores();
  }

  Future<void> _buscarJogadores() async {
    setState(() {
      _carregando = true;
    });

    final dados = await _apiService.fetchJogadores();
    if (!mounted) return;

    setState(() {
      _jogadores = dados;
      _carregando = false;
    });
  }

  int _idJogador(dynamic jogador) {
    return int.tryParse('${jogador['idJogador']}') ?? 0;
  }

  int _idTime(dynamic jogador) {
    return int.tryParse('${jogador['idTimeFk']}') ?? 0;
  }

  Future<void> _exibirFormulario({dynamic jogador}) async {
    final editando = jogador != null;
    final nomeController = TextEditingController(
      text: editando ? '${jogador['nomeJogador'] ?? ''}' : '',
    );
    final posicaoController = TextEditingController(
      text: editando ? '${jogador['posicaoJogador'] ?? ''}' : '',
    );
    final idTimeController = TextEditingController(
      text: editando ? '${jogador['idTimeFk'] ?? ''}' : '',
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
              decoration: const InputDecoration(labelText: 'Posicao'),
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
                    ? await _apiService.atualizarJogador(
                        _idJogador(jogador),
                        nome,
                        posicao,
                        idTime,
                      )
                    : await _apiService.cadastrarJogador(nome, posicao, idTime);

                if (!context.mounted) return;
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      sucesso
                          ? 'Jogador salvo com sucesso!'
                          : 'Erro ao salvar. Verifique se o ID da equipe existe.',
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

  Future<void> _confirmarExclusao(dynamic jogador) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir Jogador'),
        content: Text(
          'Deseja excluir ${jogador['nomeJogador'] ?? 'este jogador'}?',
        ),
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

    final sucesso = await _apiService.deletarJogador(_idJogador(jogador));
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          sucesso
              ? 'Jogador excluido com sucesso!'
              : 'Erro ao excluir jogador.',
        ),
      ),
    );
    if (sucesso) _buscarJogadores();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.canEdit ? 'Gerenciar Jogadores' : 'Jogadores'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
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
                    'Nenhum jogador registrado no banco de dados.',
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
                    title: Text(jogador['nomeJogador'] ?? 'Sem Nome'),
                    subtitle: Text(
                      'Posicao: ${jogador['posicaoJogador'] ?? 'N/A'} | Equipe ID: ${_idTime(jogador)}',
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
