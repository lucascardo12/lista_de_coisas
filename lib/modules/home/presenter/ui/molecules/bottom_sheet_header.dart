import 'package:flutter/material.dart';
import 'package:listadecoisa/core/services/theme/theme_service.dart';

class BottomSheetHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const BottomSheetHeader({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: ThemeService.of.textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: ThemeService.of.secondaryTextColor,
            ),
          ),
        ],
      ),
    );
  }
}
