import 'package:flutter/material.dart';

import '../theme/theme_controller.dart';

class ThemeModeButton extends StatelessWidget {
  const ThemeModeButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: themeModeController,
      builder: (context, isDark, _) {
        return Tooltip(
          message: isDark ? 'Ativar modo claro' : 'Ativar modo escuro',
          child: SizedBox.square(
            dimension: 44,
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: () => themeModeController.value = !isDark,
              child: Icon(
                isDark ? Icons.dark_mode : Icons.wb_sunny,
                color: const Color(0xFF0B1F4D),
                size: 24,
              ),
            ),
          ),
        );
      },
    );
  }
}
