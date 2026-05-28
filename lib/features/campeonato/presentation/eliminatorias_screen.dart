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
  static const double _diagramWidth = 1540;
  static const double _diagramHeight = 1020;

  late final TransformationController _transformationController;
  Size? _lastViewportSize;

  final List<_MatchSlot> _secondPhase = const [
    _MatchSlot('Jogo 1', '2º Grupo A', '2º Grupo B'),
    _MatchSlot('Jogo 2', '1º Grupo E', '3º A/B/C/D/F'),
    _MatchSlot('Jogo 3', '1º Grupo F', '2º Grupo C'),
    _MatchSlot('Jogo 4', '1º Grupo C', '2º Grupo F'),
    _MatchSlot('Jogo 5', '1º Grupo I', '3º C/D/F/G/H'),
    _MatchSlot('Jogo 6', '2º Grupo E', '2º Grupo I'),
    _MatchSlot('Jogo 7', '1º Grupo A', '3º C/E/F/H/I'),
    _MatchSlot('Jogo 8', '1º Grupo L', '3º E/H/I/J/K'),
    _MatchSlot('Jogo 9', '1º Grupo D', '3º B/E/F/I/J'),
    _MatchSlot('Jogo 10', '1º Grupo G', '3º A/E/H/I/J'),
    _MatchSlot('Jogo 11', '2º Grupo K', '2º Grupo L'),
    _MatchSlot('Jogo 12', '1º Grupo H', '2º Grupo J'),
    _MatchSlot('Jogo 13', '1º Grupo B', '3º E/F/G/I/J'),
    _MatchSlot('Jogo 14', '1º Grupo J', '2º Grupo H'),
    _MatchSlot('Jogo 15', '1º Grupo K', '3º D/E/I/J/L'),
    _MatchSlot('Jogo 16', '2º Grupo D', '2º Grupo G'),
  ];

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
    final layout = _BracketLayout();
    final leftSecond = _secondPhase.take(8).toList();
    final rightSecond = _secondPhase.skip(8).toList();

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
          boundaryMargin: const EdgeInsets.all(280),
          minScale: 0.35,
          maxScale: 1.8,
          child: SizedBox(
            width: _diagramWidth,
            height: _diagramHeight,
            child: Stack(
              children: [
                Positioned.fill(
                  child: CustomPaint(painter: _BracketPainter(layout)),
                ),
                _buildPhaseTitle(
                  'segunda fase',
                  '32 seleções',
                  layout.leftTitle1,
                ),
                _buildPhaseTitle(
                  'oitavas de final',
                  '16 seleções',
                  layout.leftTitle2,
                ),
                _buildPhaseTitle(
                  'quartas de final',
                  '8 seleções',
                  layout.leftTitle3,
                ),
                _buildPhaseTitle('semifinal', '4 seleções', layout.leftTitle4),
                _buildPhaseTitle('semifinal', '4 seleções', layout.rightTitle4),
                _buildPhaseTitle(
                  'quartas de final',
                  '8 seleções',
                  layout.rightTitle3,
                ),
                _buildPhaseTitle(
                  'oitavas de final',
                  '16 seleções',
                  layout.rightTitle2,
                ),
                _buildPhaseTitle(
                  'segunda fase',
                  '32 seleções',
                  layout.rightTitle1,
                ),
                ..._buildRoundCards(
                  leftSecond,
                  layout.leftSecond,
                  isRightSide: false,
                ),
                ..._buildPlaceholderCards(
                  'Vencedor',
                  layout.leftOitavas,
                  startIndex: 1,
                ),
                ..._buildPlaceholderCards(
                  'Vencedor Oitavas',
                  layout.leftQuartas,
                  startIndex: 1,
                ),
                _buildPositionedMatch(
                  layout.leftSemi,
                  const _MatchSlot(
                    'Semifinal 1',
                    'Vencedor Quartas 1',
                    'Vencedor Quartas 2',
                  ),
                  accent: true,
                ),
                ..._buildRoundCards(
                  rightSecond,
                  layout.rightSecond,
                  isRightSide: true,
                ),
                ..._buildPlaceholderCards(
                  'Vencedor',
                  layout.rightOitavas,
                  startIndex: 9,
                ),
                ..._buildPlaceholderCards(
                  'Vencedor Oitavas',
                  layout.rightQuartas,
                  startIndex: 5,
                ),
                _buildPositionedMatch(
                  layout.rightSemi,
                  const _MatchSlot(
                    'Semifinal 2',
                    'Vencedor Quartas 3',
                    'Vencedor Quartas 4',
                  ),
                  accent: true,
                ),
                _buildFinalCard(layout.finalCard),
                _buildThirdPlaceCard(layout.thirdPlaceCard),
                _buildLegend(layout.legend),
              ],
            ),
          ),
        );
      },
    );
  }

  void _centerDiagram(Size viewportSize) {
    final widthScale = (viewportSize.width - 12) / _diagramWidth;
    final heightScale = (viewportSize.height - 12) / _diagramHeight;
    final fitScale = (widthScale < heightScale ? widthScale : heightScale)
        .clamp(0.35, 1.0)
        .toDouble();
    final dx = (viewportSize.width - (_diagramWidth * fitScale)) / 2;
    final dy = (viewportSize.height - (_diagramHeight * fitScale)) / 2;

    _transformationController.value = Matrix4.identity()
      ..translateByDouble(dx, dy, 0.0, 1.0)
      ..scaleByDouble(fitScale, fitScale, fitScale, 1.0);
  }

  List<Widget> _buildRoundCards(
    List<_MatchSlot> matches,
    List<Rect> rects, {
    required bool isRightSide,
  }) {
    return [
      for (var i = 0; i < matches.length; i++)
        _buildPositionedMatch(rects[i], matches[i], isRightSide: isRightSide),
    ];
  }

  List<Widget> _buildPlaceholderCards(
    String label,
    List<Rect> rects, {
    required int startIndex,
  }) {
    return [
      for (var i = 0; i < rects.length; i++)
        _buildPositionedMatch(
          rects[i],
          _MatchSlot(
            '$label ${startIndex + i}',
            'Classificado ${startIndex + i}',
            'Classificado ${startIndex + i + 1}',
          ),
          compact: true,
        ),
    ];
  }

  Widget _buildPhaseTitle(String title, String subtitle, Rect rect) {
    return Positioned.fromRect(
      rect: rect,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF0B3F7A),
              fontSize: 14,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: const TextStyle(
              color: Color(0xFFFF4B00),
              fontSize: 11,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPositionedMatch(
    Rect rect,
    _MatchSlot match, {
    bool isRightSide = false,
    bool compact = false,
    bool accent = false,
  }) {
    return Positioned.fromRect(
      rect: rect,
      child: _MatchCard(
        match: match,
        isRightSide: isRightSide,
        compact: compact,
        accent: accent,
      ),
    );
  }

  Widget _buildFinalCard(Rect rect) {
    return Positioned.fromRect(
      rect: rect,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF173F73),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.18),
              blurRadius: 18,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        padding: const EdgeInsets.all(18),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'FINAL',
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.w900,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 26),
            Container(
              width: 108,
              height: 108,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.08),
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFBFEFFF), width: 4),
              ),
              child: const Icon(
                Icons.emoji_events,
                color: Color(0xFFFFC24B),
                size: 64,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThirdPlaceCard(Rect rect) {
    return Positioned.fromRect(
      rect: rect,
      child: Column(
        children: [
          const Text(
            '3º Lugar',
            style: TextStyle(
              color: Color(0xFFFF4B00),
              fontSize: 13,
              fontWeight: FontWeight.w900,
            ),
          ),
          const Text(
            'Disputado pelos perdedores das semifinais',
            style: TextStyle(
              color: Color(0xFF1F2937),
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          _smallFinalLine('Perdedor Semifinal 1'),
          const SizedBox(height: 10),
          _smallFinalLine('Perdedor Semifinal 2'),
        ],
      ),
    );
  }

  Widget _smallFinalLine(String text) {
    return Row(
      children: [
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          width: 92,
          height: 18,
          decoration: BoxDecoration(
            color: const Color(0xFFDDF6FF),
            borderRadius: BorderRadius.circular(5),
          ),
        ),
      ],
    );
  }

  Widget _buildLegend(Rect rect) {
    return Positioned.fromRect(
      rect: rect,
      child: const Text(
        'Como funciona: avançam 1º e 2º de cada grupo, mais os 8 melhores terceiros. '
        'A partir da segunda fase, cada confronto é eliminatório em jogo único.',
        style: TextStyle(
          color: Color(0xFF334155),
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _MatchCard extends StatelessWidget {
  final _MatchSlot match;
  final bool isRightSide;
  final bool compact;
  final bool accent;

  const _MatchCard({
    required this.match,
    this.isRightSide = false,
    this.compact = false,
    this.accent = false,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = accent
        ? const Color(0xFFFF4B00)
        : const Color(0xFFD5E2EC);

    return Column(
      crossAxisAlignment: isRightSide
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Text(
          match.label,
          style: TextStyle(
            color: accent ? const Color(0xFFFF4B00) : const Color(0xFF0B3F7A),
            fontSize: compact ? 10 : 11,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 2),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(7),
            border: Border.all(color: borderColor),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              _TeamLine(text: match.home, compact: compact),
              Divider(height: 1, color: Colors.grey.shade100),
              _TeamLine(text: match.away, compact: compact),
            ],
          ),
        ),
      ],
    );
  }
}

class _TeamLine extends StatelessWidget {
  final String text;
  final bool compact;

  const _TeamLine({required this.text, required this.compact});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: compact ? 21 : 23,
      child: Row(
        children: [
          Container(
            width: 18,
            height: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xFFE0F7FF),
              borderRadius: BorderRadius.horizontal(left: Radius.circular(6)),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: const Color(0xFF111827),
                fontSize: compact ? 10 : 11,
                fontWeight: FontWeight.w700,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }
}

class _BracketPainter extends CustomPainter {
  final _BracketLayout layout;

  const _BracketPainter(this.layout);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF9FB8CA)
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;

    _connectRounds(canvas, paint, layout.leftSecond, layout.leftOitavas, true);
    _connectRounds(canvas, paint, layout.leftOitavas, layout.leftQuartas, true);
    _connectRounds(canvas, paint, layout.leftQuartas, [layout.leftSemi], true);
    _connectToFinal(canvas, paint, layout.leftSemi, layout.finalCard, true);

    _connectRounds(
      canvas,
      paint,
      layout.rightSecond,
      layout.rightOitavas,
      false,
    );
    _connectRounds(
      canvas,
      paint,
      layout.rightOitavas,
      layout.rightQuartas,
      false,
    );
    _connectRounds(canvas, paint, layout.rightQuartas, [
      layout.rightSemi,
    ], false);
    _connectToFinal(canvas, paint, layout.rightSemi, layout.finalCard, false);
  }

  void _connectRounds(
    Canvas canvas,
    Paint paint,
    List<Rect> from,
    List<Rect> to,
    bool leftToRight,
  ) {
    for (var i = 0; i < to.length; i++) {
      final first = from[i * 2];
      final second = from[i * 2 + 1];
      final target = to[i];
      final startX = leftToRight ? first.right : first.left;
      final targetX = leftToRight ? target.left : target.right;
      final midX = (startX + targetX) / 2;
      final firstY = first.center.dy;
      final secondY = second.center.dy;
      final targetY = target.center.dy;

      final path = Path()
        ..moveTo(startX, firstY)
        ..lineTo(midX, firstY)
        ..lineTo(midX, secondY)
        ..lineTo(startX, secondY)
        ..moveTo(midX, targetY)
        ..lineTo(targetX, targetY);

      canvas.drawPath(path, paint);
    }
  }

  void _connectToFinal(
    Canvas canvas,
    Paint paint,
    Rect semifinal,
    Rect finalCard,
    bool leftToRight,
  ) {
    final start = Offset(
      leftToRight ? semifinal.right : semifinal.left,
      semifinal.center.dy,
    );
    final end = Offset(
      leftToRight ? finalCard.left : finalCard.right,
      finalCard.center.dy,
    );
    final midX = (start.dx + end.dx) / 2;
    final path = Path()
      ..moveTo(start.dx, start.dy)
      ..lineTo(midX, start.dy)
      ..lineTo(midX, end.dy)
      ..lineTo(end.dx, end.dy);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _BracketPainter oldDelegate) => false;
}

class _BracketLayout {
  static const double cardW = 190;
  static const double cardH = 78;

  final Rect leftTitle1 = const Rect.fromLTWH(32, 28, 190, 44);
  final Rect leftTitle2 = const Rect.fromLTWH(256, 28, 170, 44);
  final Rect leftTitle3 = const Rect.fromLTWH(456, 28, 170, 44);
  final Rect leftTitle4 = const Rect.fromLTWH(642, 390, 120, 44);

  final Rect rightTitle4 = const Rect.fromLTWH(778, 390, 120, 44);
  final Rect rightTitle3 = const Rect.fromLTWH(914, 28, 170, 44);
  final Rect rightTitle2 = const Rect.fromLTWH(1114, 28, 170, 44);
  final Rect rightTitle1 = const Rect.fromLTWH(1320, 28, 190, 44);

  final Rect finalCard = const Rect.fromLTWH(660, 64, 220, 220);
  final Rect thirdPlaceCard = const Rect.fromLTWH(630, 730, 280, 132);
  final Rect legend = const Rect.fromLTWH(560, 906, 420, 52);

  late final List<Rect> leftSecond = List.generate(
    8,
    (i) => Rect.fromLTWH(32, 86 + (i * 96), cardW, cardH),
  );

  late final List<Rect> leftOitavas = List.generate(
    4,
    (i) => Rect.fromLTWH(256, 134 + (i * 192), 170, 76),
  );

  late final List<Rect> leftQuartas = List.generate(
    2,
    (i) => Rect.fromLTWH(456, 230 + (i * 384), 170, 76),
  );

  final Rect leftSemi = const Rect.fromLTWH(642, 442, 170, 78);

  late final List<Rect> rightSecond = List.generate(
    8,
    (i) => Rect.fromLTWH(1320, 86 + (i * 96), cardW, cardH),
  );

  late final List<Rect> rightOitavas = List.generate(
    4,
    (i) => Rect.fromLTWH(1114, 134 + (i * 192), 170, 76),
  );

  late final List<Rect> rightQuartas = List.generate(
    2,
    (i) => Rect.fromLTWH(914, 230 + (i * 384), 170, 76),
  );

  final Rect rightSemi = const Rect.fromLTWH(728, 542, 170, 78);
}

class _MatchSlot {
  final String label;
  final String home;
  final String away;

  const _MatchSlot(this.label, this.home, this.away);
}
