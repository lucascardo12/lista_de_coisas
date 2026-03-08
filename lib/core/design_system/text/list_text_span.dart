import 'package:flutter/material.dart';
import 'package:listadecoisa/core/design_system/text/list_text.dart';
import 'package:listadecoisa/core/services/theme/theme_service.dart';

class ListTextSpan extends TextSpan {
  final ListTypography typography;
  final Color? color;

  const ListTextSpan({
    this.typography = ListTypography.body,
    this.color,
    super.text,
    super.children,
  });
  @override
  TextStyle? get style => ThemeService.of.getTheme.textTheme.bodySmall!.copyWith(
    fontSize: typography.size,
    fontWeight: typography.isBold ? FontWeight.bold : FontWeight.normal,
  );
}
