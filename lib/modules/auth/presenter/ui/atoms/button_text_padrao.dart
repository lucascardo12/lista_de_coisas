import 'package:flutter/material.dart';
import 'package:listadecoisa/core/services/theme/theme_service.dart';

class ButtonTextPadrao extends StatelessWidget {
  final Function()? onPressed;
  final String label;
  final Color? color;
  final Color? textColor;
  const ButtonTextPadrao({
    super.key,
    this.onPressed,
    required this.label,
    this.color,
    this.textColor,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: TextButton(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          disabledForegroundColor: ThemeService.instance
              .getSecondary()
              .withValues(alpha: 0.38),
          backgroundColor: color ?? ThemeService.instance.getPrimary(),
        ),
        onPressed: onPressed,
        child: Text(
          label,
          textAlign: TextAlign.end,
          style: TextStyle(color: textColor ?? Colors.white),
        ),
      ),
    );
  }
}
