import 'package:flutter/material.dart';
import 'package:listadecoisa/core/services/global.dart';
import 'package:listadecoisa/core/services/theme/theme_enum.dart';
import 'package:listadecoisa/core/services/theme/theme_service.dart';

class SelectTheme extends StatelessWidget {
  final Global gb;

  const SelectTheme({super.key, required this.gb});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Wrap(
          children: ThemeEnum.values.map((e) {
            final isSelected = ThemeService.instance.getCurrentTheme() == e;
            return GestureDetector(
              onTap: () async {
                await ThemeService.instance.setTheme(e);
                if (context.mounted) {
                  Navigator.pop(context);
                }
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.symmetric(vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: isSelected
                      ? ThemeService.instance.getPrimary().withValues(
                          alpha: 0.1,
                        )
                      : Colors.transparent,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: ThemeService.instance.getPrimary(),
                          width: 2,
                        ),
                        color: isSelected
                            ? ThemeService.instance.getPrimary()
                            : Colors.transparent,
                      ),
                      child: isSelected
                          ? const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 14,
                            )
                          : null,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      e.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
