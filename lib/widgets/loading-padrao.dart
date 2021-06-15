import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoadPadrao extends GetView {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
          child: Container(
              child: Wrap(
                  alignment: WrapAlignment.center,
                  direction: Axis.vertical,
                  runAlignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
            Image.asset(
              'assets/tenor.gif',
            ),
            Text(
              'Procurando coisas...',
              style: TextStyle(color: Colors.black, fontSize: 28),
            )
          ]))),
    );
  }
}
