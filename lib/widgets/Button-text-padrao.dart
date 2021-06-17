import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:listadecoisa/services/global.dart';

class ButtonTextPadrao extends GetView {
  final gb = Get.find<Global>();
  final Function()? onPressed;
  final String label;
  final Color? color;
  final Color? textColor;
  ButtonTextPadrao({
    this.onPressed,
    required this.label,
    this.color,
    this.textColor,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(left: 20, right: 20),
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
            )));
  }
}
