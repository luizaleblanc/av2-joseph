import 'package:flutter/material.dart';

import 'theme_mode_button.dart';

class CopaBannerHeader extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget> actions;
  final VoidCallback? onBack;
  final IconData leadingIcon;
  final String leadingTooltip;

  const CopaBannerHeader({
    super.key,
    required this.title,
    this.actions = const [],
    this.onBack,
    this.leadingIcon = Icons.arrow_back,
    this.leadingTooltip = 'Voltar',
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
                tooltip: leadingTooltip,
                icon: leadingIcon,
                onTap: onBack ?? () => Navigator.maybePop(context),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).padding.top > 0
                  ? MediaQuery.of(context).padding.top + 8
                  : 16,
              right: 16,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: HeaderCircleIconButton(child: ThemeModeButton()),
                  ),
                  ...actions.map(
                    (action) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: HeaderCircleIconButton(child: action),
                    ),
                  ),
                ],
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

class HeaderCircleIconButton extends StatelessWidget {
  final Widget child;

  const HeaderCircleIconButton({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: 44,
      child: Material(
        color: Colors.white.withValues(alpha: 0.9),
        shape: const CircleBorder(),
        elevation: 2,
        child: IconTheme(
          data: const IconThemeData(color: Color(0xFF0B1F4D), size: 24),
          child: Center(child: child),
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
          constraints: const BoxConstraints.tightFor(width: 44, height: 44),
          padding: EdgeInsets.zero,
          splashRadius: 22,
          icon: Icon(icon, color: const Color(0xFF0B1F4D)),
        ),
      ),
    );
  }
}
