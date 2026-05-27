import 'package:flutter/material.dart';
import '../../../core/network/api_service.dart';
import '../../auth/domain/perfil_usuario.dart';
import '../../auth/presentation/login_screen.dart';
import '../../auth/presentation/perfil_screen.dart';
import '../../equipes/presentation/equipes_screen.dart';
import '../../jogadores/presentation/jogadores_screen.dart';
import '../../campeonato/presentation/partidas_screen.dart';
import '../../campeonato/presentation/eliminatorias_screen.dart';
import 'noticias_screen.dart';

class DashboardScreen extends StatefulWidget {
  final PerfilUsuario perfil;

  const DashboardScreen({super.key, required this.perfil});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final ApiService _apiService = ApiService();

  late PerfilUsuario _perfilAtual;
  int _totalEquipes = 0;
  int _totalJogadores = 0;
  int _totalPartidas = 0;
  int _totalGols = 0;
  final int _totalGrupos = 12;
  bool _carregando = true;

  bool get _isAdmin => _perfilAtual == PerfilUsuario.administrador;

  @override
  void initState() {
    super.initState();
    _perfilAtual = widget.perfil;
    _carregarDados();
  }

  Future<void> _carregarDados() async {
    setState(() => _carregando = true);

    final equipes = await _apiService.fetchEquipes();
    final jogadores = await _apiService.fetchJogadores();
    final partidas = await _apiService.fetchPartidas();

    if (!mounted) return;

    int somaGols = 0;
    for (var partida in partidas) {
      somaGols +=
          ((partida['placarCasa'] as int?) ?? 0) +
          ((partida['placarVisitante'] as int?) ?? 0);
    }

    setState(() {
      _totalEquipes = equipes.length;
      _totalJogadores = jogadores.length;
      _totalPartidas = partidas.length;
      _totalGols = somaGols;
      _carregando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      drawer: _buildDrawer(context),
      body: _carregando
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _carregarDados,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: double.infinity,
                          height: 140,
                          decoration: const BoxDecoration(
                            color: Color(0xFF4C0AD6),
                            image: DecorationImage(
                              image: AssetImage('assets/copa_banner.png'),
                              fit: BoxFit.fitHeight,
                              alignment: Alignment.centerRight,
                            ),
                          ),
                        ),
                        Positioned(
                          top: MediaQuery.of(context).padding.top > 0
                              ? MediaQuery.of(context).padding.top + 8
                              : 16,
                          left: 16,
                          child: Builder(
                            builder: (ctx) => Material(
                              color: Colors.white.withValues(alpha: 0.9),
                              shape: const CircleBorder(),
                              elevation: 2,
                              child: InkWell(
                                customBorder: const CircleBorder(),
                                hoverColor: const Color(
                                  0xFF0B5FFF,
                                ).withValues(alpha: 0.15),
                                onTap: () => Scaffold.of(ctx).openDrawer(),
                                child: const Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: Icon(
                                    Icons.menu,
                                    color: Color(0xFF0B1F4D),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: MediaQuery.of(context).padding.top > 0
                              ? MediaQuery.of(context).padding.top + 8
                              : 16,
                          right: 16,
                          child: Material(
                            color: Colors.white.withValues(alpha: 0.9),
                            shape: const CircleBorder(),
                            elevation: 2,
                            child: InkWell(
                              customBorder: const CircleBorder(),
                              hoverColor: const Color(
                                0xFF0B5FFF,
                              ).withValues(alpha: 0.15),
                              onTap: _carregarDados,
                              child: const Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Icon(
                                  Icons.refresh,
                                  color: Color(0xFF0B1F4D),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24.0,
                        vertical: 24.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: const Color(0xFF0B1F4D),
                                    elevation: 0,
                                    side: const BorderSide(
                                      color: Color(0xFFE2E8F0),
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                  ),
                                  child: const Text(
                                    'HOJE',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: TextButton(
                                  onPressed: () {},
                                  style: TextButton.styleFrom(
                                    backgroundColor: const Color(0xFFF1F5F9),
                                    foregroundColor: Colors.blueGrey,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                  ),
                                  child: const Text(
                                    'EM BREVE →',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          _buildMatchCard(
                            flagA: 'https://flagcdn.com/w80/br.png',
                            nameA: 'Brasil',
                            groupA: 'Grupo C',
                            flagB: 'https://flagcdn.com/w80/ma.png',
                            nameB: 'Marrocos',
                            groupB: 'Grupo C',
                            score: '2 - 1',
                            timeOrDate: '67\'',
                            statusText: 'ONLINE',
                            isLive: true,
                          ),
                          const SizedBox(height: 12),
                          _buildMatchCard(
                            flagA: 'https://flagcdn.com/w80/ar.png',
                            nameA: 'Argentina',
                            groupA: 'Grupo J',
                            flagB: 'https://flagcdn.com/w80/de.png',
                            nameB: 'Alemanha',
                            groupB: 'Grupo E',
                            score: '18.06',
                            timeOrDate: '18:00',
                            statusText: '',
                            isLive: false,
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Visão Geral',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                          const SizedBox(height: 16),
                          GridView.count(
                            crossAxisCount:
                                MediaQuery.of(context).size.width > 800 ? 4 : 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            shrinkWrap: true,
                            childAspectRatio:
                                MediaQuery.of(context).size.width > 800
                                ? 2.75
                                : 2.15,
                            physics: const NeverScrollableScrollPhysics(),
                            children: [
                              _buildEstatisticaCard(
                                'Seleções',
                                _totalEquipes.toString(),
                                const Color(0xFF3B82F6),
                                Icons.flag,
                              ),
                              _buildEstatisticaCard(
                                'Jogadores',
                                _totalJogadores.toString(),
                                const Color(0xFF10B981),
                                Icons.people,
                              ),
                              _buildEstatisticaCard(
                                'Partidas',
                                _totalPartidas.toString(),
                                const Color(0xFFF59E0B),
                                Icons.sports_soccer,
                              ),
                              _buildEstatisticaCard(
                                'Gols',
                                _totalGols.toString(),
                                const Color(0xFFEF4444),
                                Icons.sports_score,
                              ),
                              _buildEstatisticaCard(
                                'Grupos',
                                _totalGrupos.toString(),
                                const Color(0xFF8B5CF6),
                                Icons.table_chart,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildMatchCard({
    required String flagA,
    required String nameA,
    required String groupA,
    required String flagB,
    required String nameB,
    required String groupB,
    required String score,
    required String timeOrDate,
    required String statusText,
    required bool isLive,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Image.network(
                    flagA,
                    width: 32,
                    height: 22,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        nameA,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Color(0xFF0F172A),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        groupA,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              Text(
                score,
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: isLive ? 22 : 18,
                  color: const Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                timeOrDate,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: isLive
                      ? const Color(0xFFE61E4D)
                      : const Color(0xFF64748B),
                ),
              ),
              if (isLive) ...[
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE61E4D),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    statusText,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ],
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        nameB,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Color(0xFF0F172A),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        groupB,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Image.network(
                    flagB,
                    width: 32,
                    height: 22,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEstatisticaCard(
    String titulo,
    String valor,
    Color cor,
    IconData icone,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFF1F5F9)),
        boxShadow: [
          BoxShadow(
            color: cor.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -8,
            bottom: -10,
            child: Icon(icone, size: 52, color: cor.withValues(alpha: 0.045)),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: cor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: Icon(icone, color: cor, size: 17),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      valor,
                      style: const TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    Text(
                      titulo,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(
              top: 60,
              bottom: 24,
              left: 24,
              right: 24,
            ),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0B1F4D), Color(0xFF0B5FFF)],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.public, size: 36, color: Color(0xFF0B5FFF)),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Menu Principal',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  _isAdmin ? 'Perfil Administrador' : 'Perfil Espectador',
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                _buildDrawerItem(context, Icons.person_outline, 'Perfil', () {
                  Navigator.push<PerfilUsuario>(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PerfilScreen(perfil: _perfilAtual),
                    ),
                  ).then((novoPerfil) {
                    if (novoPerfil != null) {
                      setState(() {
                        _perfilAtual = novoPerfil;
                      });
                    }
                  });
                }),
                _buildDrawerItem(context, Icons.flag_outlined, 'Seleções', () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EquipesScreen(canEdit: _isAdmin),
                    ),
                  ).then((_) => _carregarDados());
                }),
                _buildDrawerItem(
                  context,
                  Icons.people_outline,
                  'Jogadores',
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => JogadoresScreen(canEdit: _isAdmin),
                      ),
                    ).then((_) => _carregarDados());
                  },
                ),
                _buildDrawerItem(context, Icons.sports_soccer, 'Partidas', () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PartidasScreen(canEdit: _isAdmin),
                    ),
                  ).then((_) => _carregarDados());
                }),
                _buildDrawerItem(
                  context,
                  Icons.account_tree_outlined,
                  'Chaveamento',
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const EliminatoriasScreen(),
                      ),
                    );
                  },
                ),
                _buildDrawerItem(
                  context,
                  Icons.article_outlined,
                  'Notícias',
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => NoticiasScreen(canEdit: _isAdmin),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          _buildDrawerItem(context, Icons.logout, 'Sair', () {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const LoginScreen()),
              (route) => false,
            );
          }, isDestructive: true),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context,
    IconData icon,
    String title,
    VoidCallback onTap, {
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isDestructive
            ? const Color(0xFFE61E4D)
            : const Color(0xFF0B1F4D),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: isDestructive
              ? const Color(0xFFE61E4D)
              : const Color(0xFF0B1F4D),
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 24),
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
    );
  }
}
