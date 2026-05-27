import 'package:flutter/material.dart';
import '../models/perfil_usuario.dart';
import '../services/api_service.dart';
import 'equipes_screen.dart';
import 'eliminatorias_screen.dart';
import 'jogadores_screen.dart';
import 'noticias_screen.dart';
import 'partidas_screen.dart';
import 'perfil_screen.dart';

class DashboardScreen extends StatefulWidget {
  final PerfilUsuario perfil;

  const DashboardScreen({super.key, required this.perfil});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final ApiService _apiService = ApiService();

  int totalEquipes = 0;
  int totalJogadores = 0;
  int totalPartidas = 0;
  int totalGols = 0;
  final int totalGrupos = 12;
  bool carregando = true;

  bool get _isAdmin => widget.perfil == PerfilUsuario.administrador;

  @override
  void initState() {
    super.initState();
    _carregarDadosDoBanco();
  }

  Future<void> _carregarDadosDoBanco() async {
    setState(() {
      carregando = true;
    });

    final equipes = await _apiService.fetchEquipes();
    final jogadores = await _apiService.fetchJogadores();
    final partidas = await _apiService.fetchPartidas();
    if (!mounted) return;

    int somaGols = 0;
    for (var partida in partidas) {
      int golsCasa = partida['placarCasa'] ?? 0;
      int golsVisitante = partida['placarVisitante'] ?? 0;
      somaGols += (golsCasa + golsVisitante);
    }

    setState(() {
      totalEquipes = equipes.length;
      totalJogadores = jogadores.length;
      totalPartidas = partidas.length;
      totalGols = somaGols;
      carregando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Copa do Mundo 2026'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _carregarDadosDoBanco,
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF0B1F4D), Color(0xFF0B5FFF)],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.public, color: Colors.white, size: 40),
                  const Spacer(),
                  const Text(
                    'Menu da Copa',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                  Text(
                    _isAdmin ? 'Perfil ADM' : 'Perfil telespectador',
                    style: const TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.dashboard),
              title: const Text('Dashboard'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.person_pin),
              title: Text(_isAdmin ? 'Perfil / ADM' : 'Perfil'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PerfilScreen(perfil: widget.perfil),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.flag),
              title: const Text('Selecoes'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EquipesScreen(canEdit: _isAdmin),
                  ),
                ).then((_) => _carregarDadosDoBanco());
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Jogadores'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => JogadoresScreen(canEdit: _isAdmin),
                  ),
                ).then((_) => _carregarDadosDoBanco());
              },
            ),
            ListTile(
              leading: const Icon(Icons.sports_soccer),
              title: const Text('Partidas / Eliminatorias'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PartidasScreen(canEdit: _isAdmin),
                  ),
                ).then((_) => _carregarDadosDoBanco());
              },
            ),
            ListTile(
              leading: const Icon(Icons.account_tree),
              title: const Text('Chaveamento'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EliminatoriasScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.article),
              title: const Text('Noticias'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NoticiasScreen(canEdit: _isAdmin),
                  ),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Sair'),
              onTap: () {
                Navigator.of(
                  context,
                ).pushNamedAndRemoveUntil('/', (route) => false);
              },
            ),
          ],
        ),
      ),
      body: carregando
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.count(
                crossAxisCount: MediaQuery.of(context).size.width > 820 ? 4 : 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildCard(
                    'Selecoes',
                    totalEquipes.toString(),
                    const Color(0xFF0B5FFF),
                    Icons.flag,
                  ),
                  _buildCard(
                    'Jogadores',
                    totalJogadores.toString(),
                    const Color(0xFF159947),
                    Icons.person,
                  ),
                  _buildCard(
                    'Partidas',
                    totalPartidas.toString(),
                    const Color(0xFFFF9F1C),
                    Icons.sports_soccer,
                  ),
                  _buildCard(
                    'Gols',
                    totalGols.toString(),
                    const Color(0xFFE61E4D),
                    Icons.emoji_events,
                  ),
                  _buildCard(
                    'Grupos',
                    totalGrupos.toString(),
                    const Color(0xFF6C2BD9),
                    Icons.table_chart,
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildCard(String titulo, String valor, Color cor, IconData icone) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          gradient: LinearGradient(
            colors: [cor.withValues(alpha: 0.8), cor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icone, size: 40, color: Colors.white),
            const SizedBox(height: 10),
            Text(
              titulo,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 5),
            Text(
              valor,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
