import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:listadecoisa/core/interfaces/controller_interface.dart';
import 'package:listadecoisa/core/interfaces/remote_database_inter.dart';
import 'package:listadecoisa/modules/auth/domain/services/auth_service.dart';
import 'package:listadecoisa/modules/home/presenter/ui/pages/home_page.dart';
import 'package:listadecoisa/core/services/global.dart';
import 'package:translator/translator.dart';

class LoginController extends IController {
  final Global gb;
  final IRemoteDataBase banco;
  final AuthService authService;
  final translator = GoogleTranslator();
  var loginControler = TextEditingController();
  var senhaControler = TextEditingController();
  bool isVali = false;
  var lObescure = ValueNotifier(true);

  LoginController({
    required this.gb,
    required this.banco,
    required this.authService,
  });

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
                authService.resetarSenha(user: gb.usuario!);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> logar(bool mounted, BuildContext context) async {
    try {
      gb.load(context);
      var value = await authService.login(email: loginControler.text, password: senhaControler.text);
      if (value != null) {
        gb.usuario = value;
        var userCo = jsonEncode(value);
        gb.box.put('user', userCo);
        gb.box.put("fezLogin", true);
        gb.box.put('login', loginControler.text);
        gb.box.put('senha', senhaControler.text);
        gb.box.put('isAnonimo', false);
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
      dynamic error = e;
      var auxi = await translator.translate(error.message ?? '', from: 'en', to: 'pt');
      Fluttertoast.showToast(
          msg: auxi.text,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 5,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 18.0);
    }
  }

  Future<void> loginAnonimo(bool mounted, BuildContext context) async {
    try {
      gb.load(context);
      var value = await authService.criaUserAnonimo();
      gb.usuario = value;
      if (value != null) {
        var userCo = jsonEncode(value);
        gb.box.put('user', userCo);
        gb.box.put("fezLogin", true);
        gb.box.put('isAnonimo', true);
        if (!mounted) return;
        await Navigator.of(context).pushNamedAndRemoveUntil(
          HomePage.route,
          (Route<dynamic> route) => false,
        );
      }
      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      dynamic error = e;
      var auxi = await translator.translate(error.message ?? '', from: 'en', to: 'pt');
      Fluttertoast.showToast(
          msg: auxi.text,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 5,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 18.0);
    }
  }

  Future<void> loginGoogle(bool mounted, BuildContext context) async {
    try {
      gb.load(context);
      var value = await authService.criaUserGoogle();
      gb.usuario = value;
      if (value != null) {
        var userCo = jsonEncode(value);
        gb.box.put('user', userCo);
        gb.box.put("fezLogin", true);
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
      dynamic error = e;
      var auxi = await translator.translate(error.message ?? '', from: 'en', to: 'pt');
      Fluttertoast.showToast(
          msg: auxi.text,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 5,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 18.0);
    }
  }
}
