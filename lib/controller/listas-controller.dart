import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:listadecoisa/model/coisas.dart';
import 'package:listadecoisa/controller/global.dart' as gb;

class ListasController {
  static Future<void> criaCoisa({Coisas coisa}) async {
    await gb.banco.criaAlteraCoisas(coisas: coisa, user: gb.usuario);
    Fluttertoast.showToast(
        msg: coisa != null ? "Alterado com Sucesso!!" : "Criado com Sucesso!!",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 5,
        backgroundColor: gb.getPrimary(),
        textColor: Colors.white,
        fontSize: 18.0);
  }
}
