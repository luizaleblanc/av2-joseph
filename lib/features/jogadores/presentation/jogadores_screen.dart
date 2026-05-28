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

  static const List<_PaisCopa> _paisesCopa = [
    _PaisCopa(1, 'México', 'mx'),
    _PaisCopa(2, 'África do Sul', 'za'),
    _PaisCopa(3, 'Coreia do Sul', 'kr'),
    _PaisCopa(4, 'República Tcheca', 'cz'),
    _PaisCopa(5, 'Canadá', 'ca'),
    _PaisCopa(6, 'Bósnia e Herzegovina', 'ba'),
    _PaisCopa(7, 'Catar', 'qa'),
    _PaisCopa(8, 'Suíça', 'ch'),
    _PaisCopa(9, 'Brasil', 'br'),
    _PaisCopa(10, 'Marrocos', 'ma'),
    _PaisCopa(11, 'Haiti', 'ht'),
    _PaisCopa(12, 'Escócia', 'gb-sct'),
    _PaisCopa(13, 'Estados Unidos', 'us'),
    _PaisCopa(14, 'Paraguai', 'py'),
    _PaisCopa(15, 'Austrália', 'au'),
    _PaisCopa(16, 'Turquia', 'tr'),
    _PaisCopa(17, 'Alemanha', 'de'),
    _PaisCopa(18, 'Curaçao', 'cw'),
    _PaisCopa(19, 'Costa do Marfim', 'ci'),
    _PaisCopa(20, 'Equador', 'ec'),
    _PaisCopa(21, 'Holanda', 'nl'),
    _PaisCopa(22, 'Japão', 'jp'),
    _PaisCopa(23, 'Suécia', 'se'),
    _PaisCopa(24, 'Tunísia', 'tn'),
    _PaisCopa(25, 'Bélgica', 'be'),
    _PaisCopa(26, 'Egito', 'eg'),
    _PaisCopa(27, 'Irã', 'ir'),
    _PaisCopa(28, 'Nova Zelândia', 'nz'),
    _PaisCopa(29, 'Espanha', 'es'),
    _PaisCopa(30, 'Cabo Verde', 'cv'),
    _PaisCopa(31, 'Arábia Saudita', 'sa'),
    _PaisCopa(32, 'Uruguai', 'uy'),
    _PaisCopa(33, 'França', 'fr'),
    _PaisCopa(34, 'Senegal', 'sn'),
    _PaisCopa(35, 'Iraque', 'iq'),
    _PaisCopa(36, 'Noruega', 'no'),
    _PaisCopa(37, 'Argentina', 'ar'),
    _PaisCopa(38, 'Argélia', 'dz'),
    _PaisCopa(39, 'Áustria', 'at'),
    _PaisCopa(40, 'Jordânia', 'jo'),
    _PaisCopa(41, 'Portugal', 'pt'),
    _PaisCopa(42, 'RD Congo', 'cd'),
    _PaisCopa(43, 'Uzbequistão', 'uz'),
    _PaisCopa(44, 'Colômbia', 'co'),
    _PaisCopa(45, 'Inglaterra', 'gb-eng'),
    _PaisCopa(46, 'Croácia', 'hr'),
    _PaisCopa(47, 'Gana', 'gh'),
    _PaisCopa(48, 'Panamá', 'pa'),
  ];

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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cancelColor = isDark ? Colors.white : Colors.black;
    final dialogColor = isDark ? const Color(0xFF26272D) : Colors.white;
    final fieldBorder = OutlineInputBorder(
      borderSide: BorderSide(color: isDark ? Colors.white : Colors.black54),
    );
    final fieldDecoration = InputDecoration(
      filled: isDark,
      fillColor: isDark ? dialogColor : null,
      border: fieldBorder,
      enabledBorder: fieldBorder,
      focusedBorder: fieldBorder,
    );
    final editando = jogador != null;
    var paisSelecionado = _paisesCopa.firstWhere(
      (pais) => pais.id == jogador?.idEquipe,
      orElse: () => _paisesCopa.first,
    );
    var jogadoresDoPais = await _repository.obterJogadoresPorEquipe(
      paisSelecionado.id,
    );
    var jogadorSelecionado = _jogadorInicial(jogadoresDoPais, jogador);
    var carregandoJogadores = false;

    if (!mounted) return;
    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            Future<void> carregarJogadores(_PaisCopa pais) async {
              setModalState(() {
                paisSelecionado = pais;
                jogadoresDoPais = [];
                jogadorSelecionado = null;
                carregandoJogadores = true;
              });

              final jogadores = await _repository.obterJogadoresPorEquipe(
                pais.id,
              );
              if (!context.mounted) return;

              setModalState(() {
                jogadoresDoPais = jogadores;
                jogadorSelecionado = jogadores.isEmpty ? null : jogadores.first;
                carregandoJogadores = false;
              });
            }

            return AlertDialog(
              title: Text(editando ? 'Editar Jogador' : 'Cadastrar Jogador'),
              content: SizedBox(
                width: 380,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField<_PaisCopa>(
                      initialValue: paisSelecionado,
                      dropdownColor: isDark ? dialogColor : null,
                      decoration: fieldDecoration.copyWith(
                        labelText: 'País',
                      ),
                      items: _paisesCopa
                          .map(
                            (pais) => DropdownMenuItem<_PaisCopa>(
                              value: pais,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  _FlagImage(pais: pais, width: 28, height: 20),
                                  const SizedBox(width: 10),
                                  Flexible(
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
                      onChanged: (pais) {
                        if (pais != null) carregarJogadores(pais);
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<JogadorModel>(
                      initialValue: jogadorSelecionado,
                      dropdownColor: isDark ? dialogColor : null,
                      decoration: fieldDecoration.copyWith(
                        labelText: 'Jogador',
                      ),
                      items: jogadoresDoPais
                          .map(
                            (item) => DropdownMenuItem<JogadorModel>(
                              value: item,
                              child: Text(
                                '${item.nome} - ${item.posicao}',
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: carregandoJogadores
                          ? null
                          : (valor) {
                              setModalState(() => jogadorSelecionado = valor);
                            },
                    ),
                    if (carregandoJogadores)
                      const Padding(
                        padding: EdgeInsets.only(top: 16),
                        child: CircularProgressIndicator(),
                      ),
                    if (!carregandoJogadores && jogadoresDoPais.isEmpty)
                      const Padding(
                        padding: EdgeInsets.only(top: 12),
                        child: Text('Nenhum jogador encontrado nesse país.'),
                      ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(foregroundColor: cancelColor),
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE61E4D),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: jogadorSelecionado == null
                      ? null
                      : () async {
                          final selecionado = jogadorSelecionado!;
                          bool sucesso;

                          if (editando) {
                            final jogadorEditado = jogador;
                            sucesso = selecionado.id == jogadorEditado.id
                                ? true
                                : await _salvarOutroJogador(
                                    jogadorEditado,
                                    selecionado,
                                  );
                          } else {
                            sucesso = await _repository.salvarJogador(
                              selecionado.nome,
                              selecionado.posicao,
                              selecionado.idEquipe,
                            );
                          }

                          if (!context.mounted) return;
                          Navigator.pop(context);

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                sucesso
                                    ? 'Jogador salvo com sucesso!'
                                    : 'Erro ao salvar jogador.',
                              ),
                            ),
                          );

                          if (sucesso) _buscarJogadores();
                        },
                  child: const Text(
                    'Salvar',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  JogadorModel? _jogadorInicial(
    List<JogadorModel> jogadores,
    JogadorModel? jogador,
  ) {
    if (jogadores.isEmpty) return null;
    if (jogador == null) return jogadores.first;

    for (final item in jogadores) {
      if (item.id == jogador.id) return item;
    }
    return jogadores.first;
  }

  Future<bool> _salvarOutroJogador(
    JogadorModel anterior,
    JogadorModel selecionado,
  ) async {
    await _repository.removerJogador(anterior.id);
    return _repository.salvarJogador(
      selecionado.nome,
      selecionado.posicao,
      selecionado.idEquipe,
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
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black,
            ),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE61E4D),
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Excluir',
              style: TextStyle(color: Colors.white),
            ),
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
                final pais = _paisDoJogador(jogador);
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: ListTile(
                    leading: _FlagImage(pais: pais, width: 46, height: 32),
                    title: Text(jogador.nome),
                    subtitle: Text(
                      'Posição: ${jogador.posicao} | Seleção: ${jogador.nomeSelecao ?? jogador.idEquipe}',
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

  _PaisCopa _paisDoJogador(JogadorModel jogador) {
    for (final pais in _paisesCopa) {
      if (pais.id == jogador.idEquipe) return pais;
    }

    final nomeSelecao = jogador.nomeSelecao?.toLowerCase().trim();
    if (nomeSelecao != null && nomeSelecao.isNotEmpty) {
      for (final pais in _paisesCopa) {
        if (pais.nome.toLowerCase() == nomeSelecao) return pais;
      }
    }

    return _PaisCopa(jogador.idEquipe, jogador.nomeSelecao ?? 'Seleção', '');
  }
}

class _PaisCopa {
  final int id;
  final String nome;
  final String codigo;

  const _PaisCopa(this.id, this.nome, this.codigo);
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
