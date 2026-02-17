import 'package:flutter/material.dart';
import 'package:flutter_application_1/theme/theme_manager.dart';

class CustomHeaderWidget extends StatelessWidget implements PreferredSizeWidget {
  final ThemeManager themeManager;
  final bool isDark;

  const CustomHeaderWidget({
    super.key,
    required this.themeManager,
    required this.isDark,
  });
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.fromLTRB(32, 56, 42, 32),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32.0),
          bottomRight: Radius.circular(32.0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text("Randomizer", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              Text("Hello there,", style: TextStyle(fontSize: 32, fontWeight: FontWeight.w600)),
            ],
          ),
          Column(
            children: [
              GestureDetector(
                onTap: () => themeManager.setMode(),
                child: CircleAvatar(
                  radius: 20.0,
                  backgroundColor: theme.colorScheme.onPrimary,
                  child: Icon(
                    isDark ? Icons.dark_mode : Icons.light_mode,
                    color: theme.colorScheme.primary,
                    size: 26.0,
                  ),
                ),
              ),
              const SizedBox(height: 6.0),
              Text("Theme", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight * 2.5);
}