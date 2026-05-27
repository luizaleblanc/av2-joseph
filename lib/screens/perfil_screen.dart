import 'package:flutter/material.dart';
import '../models/perfil_usuario.dart';

class PerfilScreen extends StatelessWidget {
  final PerfilUsuario perfil;

  const PerfilScreen({super.key, required this.perfil});

  bool get _isAdmin => perfil == PerfilUsuario.administrador;

  @override
  Widget build(BuildContext context) {
    final itens = _isAdmin
        ? [
            'Editar selecoes, jogadores e partidas',
            'Atualizar placares e dados do chaveamento',
            'Publicar noticias administrativas',
          ]
        : [
            'Acompanhar selecoes e jogadores',
            'Visualizar partidas e eliminatorias',
            'Ler noticias da competicao',
          ];

    return Scaffold(
      appBar: AppBar(title: Text(_isAdmin ? 'Perfil ADM' : 'Perfil')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: _isAdmin
                        ? const Color(0xFFE61E4D)
                        : const Color(0xFF0B5FFF),
                    child: Icon(
                      _isAdmin ? Icons.admin_panel_settings : Icons.visibility,
                      color: Colors.white,
                      size: 34,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    _isAdmin ? 'Administrador da Copa 2026' : 'Telespectador',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF0B1F4D),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _isAdmin
                        ? 'Conta com acesso para manter os dados do torneio.'
                        : 'Conta de leitura para acompanhar o andamento do torneio.',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          ...itens.map(
            (item) => Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: ListTile(
                leading: const Icon(
                  Icons.check_circle,
                  color: Color(0xFF159947),
                ),
                title: Text(item),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
