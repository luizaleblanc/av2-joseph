import 'package:flutter/material.dart';

class CopaBannerHeader extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget> actions;
  final VoidCallback? onBack;

  const CopaBannerHeader({
    super.key,
    required this.title,
    this.actions = const [],
    this.onBack,
  });

  @override
  Size get preferredSize => const Size.fromHeight(140);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFF4C0AD6),
      elevation: 0,
      child: SizedBox(
        width: double.infinity,
        height: preferredSize.height,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Container(
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
              child: _HeaderCircleButton(
                tooltip: 'Voltar',
                icon: Icons.arrow_back,
                onTap: onBack ?? () => Navigator.maybePop(context),
              ),
            ),
            if (actions.isNotEmpty)
              Positioned(
                top: MediaQuery.of(context).padding.top > 0
                    ? MediaQuery.of(context).padding.top + 8
                    : 16,
                right: 16,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: actions
                      .map(
                        (action) => Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: SizedBox.square(
                            dimension: 44,
                            child: Material(
                              color: Colors.white.withValues(alpha: 0.9),
                              shape: const CircleBorder(),
                              elevation: 2,
                              child: IconTheme(
                                data: const IconThemeData(
                                  color: Color(0xFF0B1F4D),
                                  size: 24,
                                ),
                                child: Center(child: action),
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            Positioned(
              left: 24,
              right: 24,
              bottom: 18,
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  shadows: [
                    Shadow(
                      color: Colors.black54,
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderCircleButton extends StatelessWidget {
  final String tooltip;
  final IconData icon;
  final VoidCallback onTap;

  const _HeaderCircleButton({
    required this.tooltip,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: 44,
      child: Material(
        color: Colors.white.withValues(alpha: 0.9),
        shape: const CircleBorder(),
        elevation: 2,
        child: IconButton(
          tooltip: tooltip,
          onPressed: onTap,
          icon: Icon(icon, color: const Color(0xFF0B1F4D)),
        ),
      ),
    );
  }
}
