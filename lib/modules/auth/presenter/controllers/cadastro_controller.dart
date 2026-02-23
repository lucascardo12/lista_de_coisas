import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:listadecoisa/core/interfaces/controller_interface.dart';
import 'package:listadecoisa/core/interfaces/remote_database_inter.dart';
import 'package:listadecoisa/modules/auth/domain/services/auth_service.dart';
import 'package:listadecoisa/modules/auth/domain/models/user.dart';
import 'package:listadecoisa/modules/home/presenter/ui/pages/home_page.dart';
import 'package:listadecoisa/core/services/global.dart';
import 'package:translator/translator.dart';

class CadastroController extends IController {
  final Global gb;
  final IRemoteDataBase banco;
  final AuthService authService;
  final translator = GoogleTranslator();
  var loginControler = TextEditingController();
  var senhaControler = TextEditingController();
  var nomeControler = TextEditingController();
  var isVali = false;
  var lObescure = ValueNotifier(true);

  CadastroController({
    required this.gb,
    required this.banco,
    required this.authService,
  });

  @override
  void dispose() {
    lObescure.dispose();
  }

  @override
  void init(BuildContext context) {}

  Future<void> valida(bool mounted, BuildContext context) async {
    try {
      gb.load(context);
      final UserP us = UserP(
        id: null,
        login: loginControler.text.trim(),
        senha: senhaControler.text.trim(),
      );
      if (!mounted) return;
      final value = await authService.criaUser(us);

      if (value.isNotEmpty) {
        await submit();
        if (!mounted) return;
        await Navigator.pushNamedAndRemoveUntil(
          context,
          HomePage.route,
          (route) => false,
        );
      }
      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      final dynamic error = e;
      final auxi =
          await translator.translate(error.message ?? '', from: 'en', to: 'pt');
      Fluttertoast.showToast(
        msg: auxi.text,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 5,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 18.0,
      );
    }
  }

  Future<void> submit() async {
    final value = await authService.login(
      email: loginControler.text.trim(),
      password: senhaControler.text.trim(),
    );

    gb.usuario = value;
    if (value != null) {
      final userCo = jsonEncode(value);
      gb.box.put('user', userCo);
      gb.box.put('fezLogin', true);
    }
  }
}
