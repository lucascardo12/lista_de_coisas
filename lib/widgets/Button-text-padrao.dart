import 'package:flutter/material.dart';
import 'package:listadecoisa/controller/temas.dart';

class ButtonTextPadrao extends StatelessWidget {
  final Function onPressed;
  final String label;
  const ButtonTextPadrao({Key key, this.onPressed, this.label}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: TextButton(
            style: TextButton.styleFrom(
              onSurface: getSecondary(),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              backgroundColor: getPrimary(),
            ),
            onPressed: onPressed,
            child: Text(
              label,
              style: TextStyle(color: Colors.white),
            )));
  }
}
