import 'package:flutter/material.dart';
import 'package:listadecoisa/core/services/theme/theme_service.dart';

class BottomSheetActions extends StatelessWidget {
  final VoidCallback onCancel;
  final VoidCallback onContinue;
  final bool canContinue;

  const BottomSheetActions({
    super.key,
    required this.onCancel,
    required this.onContinue,
    required this.canContinue,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Expanded(
            child: TextButton(
              onPressed: onCancel,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: ThemeService.of.backgroundColor.withValues(
                      alpha: 0.5,
                    ),
                  ),
                ),
              ),
              child: Text(
                'Cancelar',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: ThemeService.of.textColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: canContinue ? onContinue : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: ThemeService.of.primary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: Text(
                'Continuar',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: ThemeService.of.whiteOrBlack,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
