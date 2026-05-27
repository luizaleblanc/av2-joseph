import 'package:flutter/material.dart';
import '../../../core/widgets/copa_banner_header.dart';

class EliminatoriasScreen extends StatelessWidget {
  const EliminatoriasScreen({super.key});

  static const fases = [
    {
      'nome': 'Fase de Grupos',
      'descricao':
          '12 grupos. Avancam os dois melhores de cada grupo e os oito melhores terceiros.',
    },
    {
      'nome': 'Dezesseis-avos de Final',
      'descricao': '32 selecoes em jogo unico no primeiro mata-mata.',
    },
    {
      'nome': 'Oitavas de Final',
      'descricao': '16 vencedores seguem no chaveamento.',
    },
    {
      'nome': 'Quartas de Final',
      'descricao': '8 selecoes disputam vaga nas semifinais.',
    },
    {
      'nome': 'Semifinal',
      'descricao': '4 selecoes; vencedores vao para a final.',
    },
    {
      'nome': 'Disputa do 3o Lugar',
      'descricao': 'Derrotados das semifinais decidem o terceiro lugar.',
    },
    {
      'nome': 'Final',
      'descricao': 'Partida decisiva para definir a campea do torneio.',
    },
  ];

  static const confrontos = [
    '2A x 2B',
    '1E x 3A/B/C/D/F',
    '1F x 2C',
    '1C x 2F',
    '1I x 3C/D/F/G/H',
    '2E x 2I',
    '1A x 3C/E/F/H/I',
    '1L x 3E/H/I/J/K',
    '1D x 3B/E/F/I/J',
    '1G x 3A/E/H/I/J',
    '2K x 2L',
    '1H x 2J',
    '1B x 3E/F/G/I/J',
    '1J x 2H',
    '1K x 3D/E/I/J/L',
    '2D x 2G',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CopaBannerHeader(title: 'Eliminatórias 2026'),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Estrutura de classificacao',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: Color(0xFF0B1F4D),
            ),
          ),
          const SizedBox(height: 12),
          ...fases.map(
            (fase) => Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: ListTile(
                leading: const Icon(
                  Icons.emoji_events,
                  color: Color(0xFFFF9F1C),
                ),
                title: Text(fase['nome']!),
                subtitle: Text(fase['descricao']!),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Chaveamento dos dezesseis-avos',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xFF0B1F4D),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: confrontos
                .map(
                  (confronto) => Chip(
                    avatar: const Icon(Icons.sports_soccer, size: 18),
                    label: Text(confronto),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
