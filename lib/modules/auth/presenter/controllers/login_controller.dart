import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:listadecoisa/core/interfaces/controller_interface.dart';
import 'package:listadecoisa/core/design_system/list_system_field.dart';
import 'package:listadecoisa/modules/auth/domain/services/auth_service.dart';
import 'package:listadecoisa/modules/home/presenter/ui/pages/home_page.dart';
import 'package:listadecoisa/core/services/global.dart';
import 'package:translator/translator.dart';

class LoginController extends IController {
  final Global gb;
  final AuthService authService;
  final translator = GoogleTranslator();
  var loginControler = TextEditingController();
  var senhaControler = TextEditingController();
  bool isVali = false;
  var lObescure = ValueNotifier(true);

  LoginController(this.gb, this.authService);

  @override
  void dispose() {}

  @override
  void init(BuildContext context) {
    loginControler.text = gb.box.get('login', defaultValue: '');
    senhaControler.text = gb.box.get('senha', defaultValue: '');
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
        fontSize: 18.0,
      );
      return false;
    }
  }

  void showAlertRedefinir({required BuildContext context}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Será encaminhado um e-mail para redefinição de senha, verifique sua caixa de spam.',
          ),
          content: ListSystemField(
            hintText: 'Email para redefinição',
            controller: loginControler,
          ),
          actions: [
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: const Text('Confirmar'),
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

  Future<void> signInWithEmailAndPassword(BuildContext context) async {
    try {
      gb.load(context);
      gb.box.put('login', loginControler.text);
      gb.box.put('senha', senhaControler.text);
      final value = await authService.signInWithEmailAndPassword(
        email: loginControler.text,
        password: senhaControler.text,
      );

      gb.usuario = value;
      gb.box.put('fezLogin', true);
      if (context.mounted) {
        await Navigator.pushNamedAndRemoveUntil(
          context,
          HomePage.route,
          (route) => false,
        );
      }
    } catch (e) {
      final dynamic error = e;
      final auxi = await translator.translate(
        error.message ?? '',
        from: 'en',
        to: 'pt',
      );
      Fluttertoast.showToast(
        msg: auxi.text,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 5,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 18.0,
      );
      rethrow;
    }
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      gb.load(context);
      final value = await authService.signInWithGoogle();
      gb.usuario = value;
      gb.box.put('fezLogin', true);
      if (context.mounted) {
        await Navigator.pushNamedAndRemoveUntil(
          context,
          HomePage.route,
          (route) => false,
        );
      }
    } catch (e) {
      final dynamic error = e;
      final auxi = await translator.translate(
        error.message ?? '',
        from: 'en',
        to: 'pt',
      );
      Fluttertoast.showToast(
        msg: auxi.text,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 5,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 18.0,
      );
      rethrow;
    }
  }
}
