import 'package:flutter/material.dart';

class ListSystemBorder {
  static OutlineInputBorder check() {
    return OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.white),
      borderRadius: borderRadius,
    );
  }

  static BorderRadius get borderRadius => BorderRadius.circular(12);
}
