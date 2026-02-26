import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:listadecoisa/core/configs/app_helps.dart';
import 'package:listadecoisa/core/interfaces/controller_interface.dart';
import 'package:listadecoisa/modules/auth/domain/services/auth_service.dart';
import 'package:listadecoisa/modules/home/presenter/ui/pages/home_page.dart';
import 'package:listadecoisa/core/services/global.dart';

class LoginController extends IController {
  final Global gb;
  final AuthService authService;

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
          content: TextField(controller: loginControler),
          actions: [
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: const Text('Confirmar'),
              onPressed: () {
                authService.resetarSenha(email: loginControler.text);
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
      if (context.mounted) {
        Navigator.pop(context);
        AppHelps.showErrorDialog(context, e);
      }
      if (e is! FirebaseAuthException) {
        rethrow;
      }
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
      if (context.mounted) {
        Navigator.pop(context);
        AppHelps.showErrorDialog(context, e);
      }
      if (e is! FirebaseAuthException) {
        rethrow;
      }
    }
  }
}
