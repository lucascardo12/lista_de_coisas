import 'package:flutter/material.dart';
import 'package:listadecoisa/core/services/theme/theme_service.dart';

enum ListTypography {
  giga(true, 36),
  title(true, 24),
  button(true, 16),
  body(false, 14),
  tiny(false, 10);

  final bool isBold;
  final double size;
  const ListTypography(this.isBold, this.size);
}

class ListText extends StatelessWidget {
  final String text;
  final ListTypography typography;
  final Color? color;
  final int? maxLines;
  final TextOverflow? overflow;
  final double? maskFilter;
  final TextAlign? textAlign;

  const ListText({
    super.key,
    required this.text,
    this.typography = ListTypography.body,
    this.color,
    this.maxLines,
    this.overflow,
    this.maskFilter,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: maxLines,
      overflow: overflow,
      style: Theme.of(context).textTheme.bodySmall!.copyWith(
        fontSize: typography.size,
        fontWeight: typography.isBold ? FontWeight.bold : FontWeight.normal,
        foreground: Paint()
          ..style = PaintingStyle.fill
          ..color = color ?? ThemeService.of.whiteOrBlack
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, maskFilter ?? 0),
      ),
      textAlign: textAlign,
    );
  }
}
