import 'package:flutter/material.dart';
import 'package:listadecoisa/core/services/theme/theme_service.dart';
import 'package:listadecoisa/modules/listas/domain/enums/type_list.dart';

class TypeListCard extends StatelessWidget {
  final TypeList type;
  final bool isSelected;
  final VoidCallback onTap;

  const TypeListCard({
    super.key,
    required this.type,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final icon = _getIconForType(type);
    final color = _getColorForType(type);
    
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected 
              ? color.withValues(alpha: 0.1)
              : ThemeService.instance.getSurfaceColor(),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected 
                ? color
                : ThemeService.instance.getSurfaceColor().withValues(alpha: 0.3),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isSelected 
                    ? color
                    : color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: isSelected 
                    ? ThemeService.instance.getWhiteOrBlack()
                    : color,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    type.value,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: ThemeService.instance.getTextColor(),
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _getDescriptionForType(type),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: ThemeService.instance.getSecondaryTextColor(),
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: color,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }

  IconData _getIconForType(TypeList type) {
    switch (type) {
      case TypeList.test:
        return Icons.text_fields;
      case TypeList.check:
        return Icons.checklist;
      case TypeList.checkout:
        return Icons.shopping_cart;
    }
  }

  Color _getColorForType(TypeList type) {
    switch (type) {
      case TypeList.test:
        return ThemeService.instance.getInfoColor();
      case TypeList.check:
        return ThemeService.instance.getSuccessColor();
      case TypeList.checkout:
        return ThemeService.instance.getWarningColor();
    }
  }

  String _getDescriptionForType(TypeList type) {
    switch (type) {
      case TypeList.test:
        return 'Crie listas de texto simples e anotações';
      case TypeList.check:
        return 'Listas de tarefas com marcação de conclusão';
      case TypeList.checkout:
        return 'Organize suas compras de forma prática';
    }
  }
}
