import 'package:flutter/material.dart';
import 'package:listadecoisa/main.dart';
import 'package:listadecoisa/core/services/global.dart';

class ButtonTextPadrao extends StatelessWidget {
  final gb = di.get<Global>();
  final Function()? onPressed;
  final String label;
  final Color? color;
  final Color? textColor;
  ButtonTextPadrao({
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
          onSurface: gb.getSecondary(),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          backgroundColor: color ?? gb.getPrimary(),
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
