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
      somaGols += ((partida['placarCasa'] as int?) ?? 0) + ((partida['placarVisitante'] as int?) ?? 0);
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
      backgroundColor: const Color(0xFFF4F7FB),
      appBar: AppBar(
        title: const Text('Copa do Mundo 2026', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF0B1F4D),
        elevation: 0,
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _carregarDados),
        ],
      ),
      drawer: _buildDrawer(context),
      body: _carregando
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _carregarDados,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Visão Geral',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: Colors.blueGrey.shade900),
                    ),
                    const SizedBox(height: 24),
                    GridView.count(
                      crossAxisCount: MediaQuery.of(context).size.width > 800 ? 4 : 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        _buildEstatisticaCard('Seleções', _totalEquipes.toString(), const Color(0xFF0B5FFF), Icons.flag),
                        _buildEstatisticaCard('Jogadores', _totalJogadores.toString(), const Color(0xFF159947), Icons.people),
                        _buildEstatisticaCard('Partidas', _totalPartidas.toString(), const Color(0xFFFF9F1C), Icons.sports_soccer),
                        _buildEstatisticaCard('Gols', _totalGols.toString(), const Color(0xFFE61E4D), Icons.sports_score),
                        _buildEstatisticaCard('Grupos', _totalGrupos.toString(), const Color(0xFF6C2BD9), Icons.table_chart),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildEstatisticaCard(String titulo, String valor, Color cor, IconData icone) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: cor.withValues(alpha: 0.15),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -10,
            bottom: -10,
            child: Icon(icone, size: 100, color: cor.withValues(alpha: 0.05)),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: cor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                  child: Icon(icone, color: cor, size: 28),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(valor, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: Color(0xFF0B1F4D))),
                    Text(titulo, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.grey.shade600)),
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
            padding: const EdgeInsets.only(top: 60, bottom: 24, left: 24, right: 24),
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [Color(0xFF0B1F4D), Color(0xFF0B5FFF)]),
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
                const Text('Menu Principal', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                Text(_isAdmin ? 'Perfil Administrador' : 'Perfil Espectador', style: const TextStyle(color: Colors.white70)),
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
                    MaterialPageRoute(builder: (_) => PerfilScreen(perfil: _perfilAtual)),
                  ).then((novoPerfil) {
                    if (novoPerfil != null) {
                      setState(() {
                        _perfilAtual = novoPerfil;
                      });
                    }
                  });
                }),
                _buildDrawerItem(context, Icons.flag_outlined, 'Seleções', () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => EquipesScreen(canEdit: _isAdmin))).then((_) => _carregarDados());
                }),
                _buildDrawerItem(context, Icons.people_outline, 'Jogadores', () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => JogadoresScreen(canEdit: _isAdmin))).then((_) => _carregarDados());
                }),
                _buildDrawerItem(context, Icons.sports_soccer, 'Partidas', () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => PartidasScreen(canEdit: _isAdmin))).then((_) => _carregarDados());
                }),
                _buildDrawerItem(context, Icons.account_tree_outlined, 'Chaveamento', () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const EliminatoriasScreen()));
                }),
                _buildDrawerItem(context, Icons.article_outlined, 'Notícias', () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => NoticiasScreen(canEdit: _isAdmin)));
                }),
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

  Widget _buildDrawerItem(BuildContext context, IconData icon, String title, VoidCallback onTap, {bool isDestructive = false}) {
    return ListTile(
      leading: Icon(icon, color: isDestructive ? const Color(0xFFE61E4D) : const Color(0xFF0B1F4D)),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.w600, color: isDestructive ? const Color(0xFFE61E4D) : const Color(0xFF0B1F4D))),
      contentPadding: const EdgeInsets.symmetric(horizontal: 24),
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
    );
  }
}