import 'package:flutter/material.dart';

import '../../../core/widgets/copa_banner_header.dart';

class EliminatoriasScreen extends StatelessWidget {
  const EliminatoriasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFF4F7FB),
      appBar: CopaBannerHeader(title: 'Chaveamento'),
      body: BracketDiagram(),
    );
  }
}

class BracketDiagram extends StatefulWidget {
  const BracketDiagram({super.key});

  @override
  State<BracketDiagram> createState() => _BracketDiagramState();
}

class _BracketDiagramState extends State<BracketDiagram> {
  static const double _diagramWidth = 1440;
  static const double _diagramHeight = 760;

  late final TransformationController _transformationController;
  Size? _lastViewportSize;

  @override
  void initState() {
    super.initState();
    _transformationController = TransformationController();
  }

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dezesseisAvos = [
      ['2º Grupo A', '2º Grupo B'],
      ['1º Grupo E', '3º A/B/C/D/F'],
      ['1º Grupo F', '2º Grupo C'],
      ['1º Grupo C', '2º Grupo F'],
      ['1º Grupo I', '3º C/D/F/G/H'],
      ['2º Grupo E', '2º Grupo I'],
      ['1º Grupo A', '3º C/E/F/H/I'],
      ['1º Grupo L', '3º E/H/I/J/K'],
      ['1º Grupo D', '3º B/E/F/I/J'],
      ['1º Grupo G', '3º A/E/H/I/J'],
      ['2º Grupo K', '2º Grupo L'],
      ['1º Grupo H', '2º Grupo J'],
      ['1º Grupo B', '3º E/F/G/I/J'],
      ['1º Grupo J', '2º Grupo H'],
      ['1º Grupo K', '3º D/E/I/J/L'],
      ['2º Grupo D', '2º Grupo G'],
    ];

    final oitavas = List.generate(
      8,
      (i) => ['Vencedor ${i * 2 + 1}', 'Vencedor ${i * 2 + 2}'],
    );
    final quartas = List.generate(
      4,
      (i) => ['Vencedor Oitavas ${i * 2 + 1}', 'Vencedor Oitavas ${i * 2 + 2}'],
    );
    final semis = List.generate(
      2,
      (i) => ['Vencedor Quartas ${i * 2 + 1}', 'Vencedor Quartas ${i * 2 + 2}'],
    );
    final finalMatch = [
      ['Vencedor Semifinal 1', 'Vencedor Semifinal 2'],
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final viewportSize = Size(constraints.maxWidth, constraints.maxHeight);
        if (_lastViewportSize != viewportSize) {
          _lastViewportSize = viewportSize;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) return;
            _centerDiagram(viewportSize);
          });
        }

        return InteractiveViewer(
          transformationController: _transformationController,
          constrained: false,
          boundaryMargin: const EdgeInsets.all(240),
          minScale: 0.35,
          maxScale: 1.6,
          child: SizedBox(
            width: _diagramWidth,
            height: _diagramHeight,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildSplitPhaseColumn('16-AVOS DE FINAL', dezesseisAvos),
                _buildPhaseColumn('OITAVAS DE FINAL', oitavas),
                _buildPhaseColumn('QUARTAS DE FINAL', quartas),
                _buildPhaseColumn('SEMIFINAIS', semis),
                _buildPhaseColumn('GRANDE FINAL', finalMatch, isFinal: true),
              ],
            ),
          ),
        );
      },
    );
  }

  void _centerDiagram(Size viewportSize) {
    final widthScale = (viewportSize.width - 48) / _diagramWidth;
    final heightScale = (viewportSize.height - 48) / _diagramHeight;
    final fitScale = (widthScale < heightScale ? widthScale : heightScale)
        .clamp(0.35, 0.82)
        .toDouble();
    final dx = (viewportSize.width - (_diagramWidth * fitScale)) / 2;
    final dy = (viewportSize.height - (_diagramHeight * fitScale)) / 2;

    _transformationController.value = Matrix4.identity()
      ..translateByDouble(dx, dy, 0.0, 1.0)
      ..scaleByDouble(fitScale, fitScale, fitScale, 1.0);
  }

  Widget _buildPhaseColumn(
    String title,
    List<List<String>> matches, {
    bool isFinal = false,
  }) {
    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 32),
      child: Column(
        children: [
          _buildPhaseHeader(title, isFinal: isFinal),
          const SizedBox(height: 22),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: matches
                  .map((match) => _buildMatchCard(match[0], match[1], isFinal))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSplitPhaseColumn(String title, List<List<String>> matches) {
    final firstGroup = matches.take(8).toList();
    final secondGroup = matches.skip(8).toList();

    return Container(
      width: 430,
      margin: const EdgeInsets.only(right: 32),
      child: Column(
        children: [
          _buildPhaseHeader(title),
          const SizedBox(height: 22),
          Expanded(
            child: Row(
              children: [
                Expanded(child: _buildMatchGroup(firstGroup)),
                const SizedBox(width: 14),
                Expanded(child: _buildMatchGroup(secondGroup)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMatchGroup(List<List<String>> matches) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: matches
          .map((match) => _buildMatchCard(match[0], match[1], false))
          .toList(),
    );
  }

  Widget _buildPhaseHeader(String title, {bool isFinal = false}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      decoration: BoxDecoration(
        color: isFinal ? const Color(0xFFE61E4D) : const Color(0xFF0B1F4D),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w900,
          fontSize: 11,
          letterSpacing: 0.8,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildMatchCard(String team1, String team2, bool isFinal) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isFinal
              ? const Color(0xFFE61E4D).withValues(alpha: 0.5)
              : const Color(0xFFE2E8F0),
          width: isFinal ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isFinal
                ? const Color(0xFFE61E4D).withValues(alpha: 0.1)
                : Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildTeamRow(team1),
          Divider(height: 1, thickness: 1, color: Colors.grey.shade100),
          _buildTeamRow(team2),
        ],
      ),
    );
  }

  Widget _buildTeamRow(String teamName) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
        children: [
          Icon(Icons.shield_outlined, color: Colors.grey.shade400, size: 14),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              teamName,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: Color(0xFF0F172A),
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
