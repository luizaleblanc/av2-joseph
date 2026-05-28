import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/widgets/copa_banner_header.dart';

class NoticiasScreen extends StatefulWidget {
  final bool canEdit;

  const NoticiasScreen({super.key, required this.canEdit});

  @override
  State<NoticiasScreen> createState() => _NoticiasScreenState();
}

class _NoticiasScreenState extends State<NoticiasScreen> {
  static final List<_NoticiaCopa> _noticias = [
    _NoticiaCopa(
      titulo: 'Copa do Mundo de 2026 terá novo formato e total de 104 jogos',
      subtitulo:
          'A partir da Copa do Mundo de 2026, a FIFA implementará um novo formato que expande o torneio para 48 seleções. A mudança altera significativamente a estrutura da competição, que passará a ter 104 jogos distribuídos ao longo de 39 dias.',
      fonte: 'ge',
      link:
          'https://ge.globo.com/futebol/futebol-internacional/noticia/2023/03/14/copa-do-mundo-de-2026-tera-quatro-grupos-com-12-times-cada-e-atingira-total-de-104-jogos.ghtml',
      imagem: 'assets/brasil_campeao.jpg',
      cor: const Color(0xFF0B5FFF),
      imageFit: BoxFit.cover,
    ),
    _NoticiaCopa(
      titulo: 'Calendário do Brasil na Copa do Mundo de 2026',
      subtitulo:
          'A Seleção Brasileira terá uma trajetória marcada por datas decisivas, adversários definidos no Grupo C e uma preparação voltada para chegar forte ao mata-mata. O calendário ajuda o torcedor a acompanhar cada etapa da campanha.',
      fonte: 'CNN Brasil',
      link:
          'https://www.cnnbrasil.com.br/esportes/futebol/selecao-brasileira/calendario-do-brasil-na-copa-do-mundo-de-2026-veja-datas-e-adversarios/',
      imagem: 'assets/alegria_copa.webp',
      cor: const Color(0xFF00A650),
      imageFit: BoxFit.cover,
    ),
    _NoticiaCopa(
      titulo: 'Como funciona o formato da Copa do Mundo de 2026',
      subtitulo:
          'O Mundial terá fase de grupos ampliada, classificação dos melhores terceiros colocados e início do mata-mata nos 16-avos de final. O novo modelo aumenta o número de seleções e torna a disputa mais longa e estratégica.',
      fonte: 'CNN Brasil',
      link:
          'https://www.cnnbrasil.com.br/esportes/futebol/copa-do-mundo/como-funciona-o-formato-da-copa-do-mundo-de-2026-grupos-fases-e-mudancas/',
      imagem: 'assets/bola_copa.webp',
      cor: const Color(0xFFE61E4D),
      imageFit: BoxFit.cover,
    ),
    _NoticiaCopa(
      titulo: 'Quais cidades vão sediar os jogos da Copa do Mundo',
      subtitulo:
          'Estados Unidos, México e Canadá receberão partidas em diferentes cidades-sede, espalhando a competição pela América do Norte. A distribuição dos jogos amplia o alcance do torneio e aproxima públicos de várias regiões.',
      fonte: 'g1',
      link:
          'https://g1.globo.com/mundo/noticia/2026/05/27/copa-do-mundo-quais-cidades-vao-sediar-os-jogos.ghtml',
      cor: const Color(0xFFFF5A00),
    ),
  ];

  Future<void> _recarregarNoticias() async {
    setState(() {});
  }

  Future<void> _abrirLink(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: CopaBannerHeader(
        title: 'Notícias da Copa',
        leadingIcon: Icons.menu,
        leadingTooltip: 'Menu',
        actions: [
          IconButton(
            tooltip: 'Atualizar notícias',
            onPressed: _recarregarNoticias,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _recarregarNoticias,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(24, 10, 24, 2),
              sliver: SliverToBoxAdapter(
                child: _NewsLead(
                  noticia: _noticias.first,
                  onTap: () => _abrirLink(_noticias.first.link),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 12),
              sliver: SliverToBoxAdapter(
                child: _NewsCardsSection(
                  noticias: _noticias.skip(1).toList(),
                  onTap: _abrirLink,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NewsLead extends StatelessWidget {
  final _NoticiaCopa noticia;
  final VoidCallback onTap;

  const _NewsLead({required this.noticia, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width >= 900;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: isWide
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 3, child: _LeadText(notic: noticia)),
                const SizedBox(width: 28),
                Expanded(
                  flex: 2,
                  child: _NewsImage(noticia: noticia, height: 190),
                ),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _NewsImage(noticia: noticia, height: 190),
                const SizedBox(height: 14),
                _LeadText(notic: noticia),
              ],
            ),
    );
  }
}

class _LeadText extends StatelessWidget {
  final _NoticiaCopa notic;

  const _LeadText({required this.notic});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          notic.fonte,
          style: TextStyle(
            color: notic.cor,
            fontSize: 15,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          notic.titulo,
          style: TextStyle(
            color: notic.cor,
            fontSize: MediaQuery.sizeOf(context).width >= 900 ? 31 : 25,
            fontWeight: FontWeight.w900,
            height: 1.08,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          notic.subtitulo,
          style: TextStyle(
            color: isDark ? const Color(0xFFD7E3FF) : const Color(0xFF334155),
            fontSize: 15,
            fontWeight: FontWeight.w700,
            height: 1.3,
          ),
          maxLines: 4,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

class _NewsCard extends StatelessWidget {
  final _NoticiaCopa noticia;
  final VoidCallback onTap;
  final bool featured;

  const _NewsCard({
    required this.noticia,
    required this.onTap,
    this.featured = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (noticia.imagem != null) ...[
            _NewsImage(noticia: noticia, height: featured ? 320 : 170),
            SizedBox(height: featured ? 8 : 6),
          ],
          Text(
            noticia.titulo,
            style: TextStyle(
              color: noticia.cor,
              fontSize: featured ? 18 : 16,
              fontWeight: FontWeight.w900,
              height: 1.12,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 5),
          Text(
            '• ${noticia.subtitulo}',
            style: TextStyle(
              color: isDark
                  ? const Color(0xFFD7E3FF)
                  : const Color(0xFF334155),
              fontSize: 12,
              fontWeight: FontWeight.w600,
              height: 1.15,
            ),
            maxLines: featured ? 2 : 3,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _NewsCardsSection extends StatelessWidget {
  final List<_NoticiaCopa> noticias;
  final Future<void> Function(String url) onTap;

  const _NewsCardsSection({required this.noticias, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width >= 900;
    if (!isWide) {
      return Column(
        children: [
          for (var i = 0; i < noticias.length; i++) ...[
            _NewsCard(
              noticia: noticias[i],
              featured: i == 1,
              onTap: () => onTap(noticias[i].link),
            ),
            if (i != noticias.length - 1) const SizedBox(height: 18),
          ],
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 10,
          child: _NewsCard(
            noticia: noticias[0],
            onTap: () => onTap(noticias[0].link),
          ),
        ),
        const SizedBox(width: 28),
        Expanded(
          flex: 12,
          child: _NewsCard(
            noticia: noticias[1],
            featured: true,
            onTap: () => onTap(noticias[1].link),
          ),
        ),
        const SizedBox(width: 28),
        Expanded(
          flex: 10,
          child: _NewsCard(
            noticia: noticias[2],
            onTap: () => onTap(noticias[2].link),
          ),
        ),
      ],
    );
  }
}

class _NewsImage extends StatelessWidget {
  final _NoticiaCopa noticia;
  final double height;

  const _NewsImage({required this.noticia, required this.height});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: SizedBox(
        width: double.infinity,
        height: height,
        child: Image.asset(
          noticia.imagem!,
          fit: noticia.imageFit,
          width: double.infinity,
          height: height,
        ),
      ),
    );
  }
}

class _NoticiaCopa {
  final String titulo;
  final String subtitulo;
  final String fonte;
  final String link;
  final String? imagem;
  final Color cor;
  final BoxFit imageFit;

  const _NoticiaCopa({
    required this.titulo,
    required this.subtitulo,
    required this.fonte,
    required this.link,
    required this.cor,
    this.imagem,
    this.imageFit = BoxFit.cover,
  });
}
