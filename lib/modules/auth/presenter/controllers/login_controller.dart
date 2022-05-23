import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:listadecoisa/core/interfaces/controller_interface.dart';
import 'package:listadecoisa/model/coisas.dart';
import 'package:listadecoisa/modules/home/presenter/ui/pages/home_page.dart';
import 'package:listadecoisa/services/banco.dart';
import 'package:listadecoisa/services/global.dart';

class LoginController extends IController {
  final Global gb;
  final BancoFire banco;
  var loginControler = TextEditingController();
  var senhaControler = TextEditingController();
  bool isVali = false;
  var lObescure = ValueNotifier(true);

  LoginController({required this.gb, required this.banco});

  @override
  void dispose() {}

  @override
  void init(BuildContext context) {
    loginControler.text = gb.box.get('login', defaultValue: "");
    senhaControler.text = gb.box.get('senha', defaultValue: "");
  }

  Future<bool> verificarConexao() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } on SocketException catch (_) {
      Fluttertoast.showToast(
          msg: 'Sem Conexão',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 5,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 18.0);
      return false;
    }
  }

  void showAlertRedefinir({required BuildContext context}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
              "Será encaminhado um e-mail para redefinição de senha, verifique sua caixa de spam."),
          content: TextField(
            controller: loginControler,
          ),
          actions: [
            TextButton(
              child: const Text("Cancelar"),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: const Text("Confirmar"),
              onPressed: () {
                banco.resetarSenha(user: gb.usuario!);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> logar(bool mounted, BuildContext context) async {
    gb.load(context);
    var value = await banco.login(email: loginControler.text, password: senhaControler.text);
    if (value != null) {
      gb.usuario = value;
      List<dynamic> listCat = await banco.getCoisas(user: gb.usuario!);
      for (var element in listCat) {
        gb.lisCoisa.value.add(Coisas.fromSnapshot(element));
      }
      var userCo = jsonEncode(value);
      gb.box.put('user', userCo);
      gb.box.put("fezLogin", true);
      gb.box.put('login', loginControler.text);
      gb.box.put('senha', senhaControler.text);
      gb.box.put('isAnonimo', false);
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

  Future<void> loginAnonimo(bool mounted, BuildContext context) async {
    gb.load(context);
    var value = await banco.criaUserAnonimo();
    gb.usuario = value;
    if (value != null) {
      List<dynamic> listCat = await banco.getCoisas(user: gb.usuario!);
      for (var element in listCat) {
        gb.lisCoisa.value.add(Coisas.fromSnapshot(element));
      }
      var userCo = jsonEncode(value);
      gb.box.put('user', userCo);
      gb.box.put("fezLogin", true);
      gb.box.put('isAnonimo', true);
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

  Future<void> loginGoogle(bool mounted, BuildContext context) async {
    gb.load(context);
    var value = await banco.criaUserGoogle();
    gb.usuario = value;
    if (value != null) {
      List<dynamic> listCat = await banco.getCoisas(user: gb.usuario!);
      for (var element in listCat) {
        gb.lisCoisa.value.add(Coisas.fromSnapshot(element));
      }
      var userCo = jsonEncode(value);
      gb.box.put('user', userCo);
      gb.box.put("fezLogin", true);
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
}
