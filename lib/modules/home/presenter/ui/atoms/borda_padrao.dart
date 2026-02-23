import 'package:flutter/material.dart';

class BordaPadrao {
  static OutlineInputBorder build() {
    return const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(25)),
      borderSide: BorderSide(
        color: Colors.white,
        width: 2,
      ),
    );
  }

  static OutlineInputBorder check() {
    return const OutlineInputBorder(
      borderSide: BorderSide(color: Colors.white),
    );
  }
}
