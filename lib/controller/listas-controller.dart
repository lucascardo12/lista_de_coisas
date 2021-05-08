import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:listadecoisa/model/coisas.dart';
import 'package:listadecoisa/controller/global.dart' as gb;
import 'package:listadecoisa/model/user.dart';

class ListasController {
  static Future<void> criaCoisa({Coisas coisa}) async {
    var auxi = gb.lisComp.indexWhere((element) => element.idLista == coisa.idFire);
    if (auxi >= 0) {
      await gb.banco.criaAlteraCoisas(
          coisas: coisa,
          user: UserP(id: gb.lisComp.firstWhere((element) => element.idLista == coisa.idFire).idUser));
    } else {
      await gb.banco.criaAlteraCoisas(coisas: coisa, user: gb.usuario);
    }
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
