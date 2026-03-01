import 'package:flutter/material.dart';

class ListSystemBorder {
  static OutlineInputBorder check() {
    return const OutlineInputBorder(
      borderSide: BorderSide(color: Colors.white),
      borderRadius: BorderRadius.all(Radius.circular(12)),
    );
  }

  static BorderRadius borderRadius() {
    return BorderRadius.circular(12);
  }
}
