import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:listadecoisa/services/global.dart';

class ButtonTextPadrao extends GetView {
  final gb = Get.find<Global>();
  final Function()? onPressed;
  final String label;
  ButtonTextPadrao({
    this.onPressed,
    required this.label,
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
              backgroundColor: gb.getPrimary(),
            ),
            onPressed: onPressed,
            child: Text(
              label,
              style: TextStyle(color: Colors.white),
            )));
  }
}
