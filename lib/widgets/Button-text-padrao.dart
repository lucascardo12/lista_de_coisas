import 'package:flutter/material.dart';
import 'package:listadecoisa/controller/global.dart' as global;

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
              onSurface: global.getSecondary(),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              backgroundColor: global.getPrimary(),
            ),
            onPressed: onPressed,
            child: Text(
              label,
              style: TextStyle(color: Colors.white),
            )));
  }
}
