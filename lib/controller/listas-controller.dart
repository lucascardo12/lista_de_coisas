import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:listadecoisa/model/coisas.dart';
import 'package:listadecoisa/model/user.dart';
import 'package:listadecoisa/services/banco.dart';
import 'package:listadecoisa/services/global.dart';

class ListasController {
  final gb = Get.find<Global>();
  final banco = Get.find<BancoFire>();

  Future<void> criaCoisa({required Coisas coisa}) async {
    var auxi = gb.lisComp.indexWhere((element) => element.idLista == coisa.idFire);
    if (auxi >= 0) {
      await banco.criaAlteraCoisas(
          coisas: coisa,
          user: UserP(id: gb.lisComp.firstWhere((element) => element.idLista == coisa.idFire).idUser));
    } else {
      await banco.criaAlteraCoisas(coisas: coisa, user: gb.usuario!);
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
