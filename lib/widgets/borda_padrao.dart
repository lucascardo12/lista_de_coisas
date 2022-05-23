import 'package:flutter/material.dart';

class BordaPadrao {
  static build() {
    return const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(25)),
      borderSide: BorderSide(
        color: Colors.white,
        width: 2,
      ),
    );
  }

  static check() {
    return const OutlineInputBorder(
      borderSide: BorderSide(color: Colors.white),
    );
  }
}
