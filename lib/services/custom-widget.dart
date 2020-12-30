import 'package:flutter/material.dart';

Widget loading() {
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
            'assets/icon.png',
            height: 100,
            width: 100,
          ),
          Text('Procurando coisas..')
        ]))),
  );
}
