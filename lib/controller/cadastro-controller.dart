import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:listadecoisa/model/coisas.dart';
import 'package:listadecoisa/model/user.dart';
import 'package:listadecoisa/services/banco.dart';
import 'package:listadecoisa/services/global.dart';

class CadastroController extends GetxController {
  final gb = Get.find<Global>();
  final banco = Get.find<BancoFire>();
  TextEditingController loginControler = TextEditingController();
  TextEditingController senhaControler = TextEditingController();
  TextEditingController nomeControler = TextEditingController();
  bool isVali = false;
  RxBool lObescure = true.obs;
  Future<void> valida() async {
    gb.load();
    UserP us = UserP(id: null, login: loginControler.text.trim(), senha: senhaControler.text.trim());
    await banco.criaUser(us).then((value) async {
      if (value.isNotEmpty) {
        await submit();
      }
    });
    Get.back();
  }

  Future<void> submit() async {
    await banco
        .login(email: loginControler.text.trim(), password: senhaControler.text.trim())
        .then((value) async {
      gb.usuario = value;
      if (value != null) {
        List<dynamic> listCat = await banco.getCoisas(user: gb.usuario!);
        gb.lisCoisa = listCat.map((i) => Coisas.fromSnapshot(i)).toList();

        var userCo = jsonEncode(value);
        gb.box.put('user', userCo);
        gb.box.put("fezLogin", true);

        Get.offAllNamed('/home');
      }
    });
  }
}
