import 'package:flutter/material.dart';
import 'package:listadecoisa/controller/temas.dart';

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
            'assets/tenor.gif',
            color: getPrimary(),
          ),
          Text(
            'Procurando coisas...',
            style: TextStyle(color: getPrimary(), fontSize: 28),
          )
        ]))),
  );
}
