import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:listadecoisa/core/interfaces/controller_interface.dart';
import 'package:listadecoisa/model/coisas.dart';
import 'package:listadecoisa/model/user.dart';
import 'package:listadecoisa/modules/home/presenter/ui/pages/home_page.dart';
import 'package:listadecoisa/services/banco.dart';
import 'package:listadecoisa/services/global.dart';

class CadastroController extends IController {
  final Global gb;
  final BancoFire banco;
  var loginControler = TextEditingController();
  var senhaControler = TextEditingController();
  var nomeControler = TextEditingController();
  var isVali = false;
  var lObescure = ValueNotifier(true);

  CadastroController({required this.gb, required this.banco});

  @override
  void dispose() {
    lObescure.dispose();
  }

  @override
  void init(BuildContext context) {}

  Future<void> valida(bool mounted, BuildContext context) async {
    gb.load(context);
    UserP us = UserP(
      id: null,
      login: loginControler.text.trim(),
      senha: senhaControler.text.trim(),
    );
    if (!mounted) return;
    var value = await banco.criaUser(us);

    if (value.isNotEmpty) {
      await submit();
      if (!mounted) return;
      Navigator.pushNamedAndRemoveUntil(
        context,
        HomePage.route,
        (route) => false,
      );
    }
    if (!mounted) return;
    Navigator.pop(context, true);
  }

  Future<void> submit() async {
    var value = await banco.login(
      email: loginControler.text.trim(),
      password: senhaControler.text.trim(),
    );

    gb.usuario = value;
    if (value != null) {
      List<dynamic> listCat = await banco.getCoisas(user: gb.usuario!);
      for (var element in listCat) {
        gb.lisCoisa.value.add(Coisas.fromSnapshot(element));
      }
      var userCo = jsonEncode(value);
      gb.box.put('user', userCo);
      gb.box.put("fezLogin", true);
    }
  }
}
