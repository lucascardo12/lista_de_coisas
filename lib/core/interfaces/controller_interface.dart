import 'package:flutter/material.dart';

abstract class IController {
  void dispose();

  void init(BuildContext context);
}
