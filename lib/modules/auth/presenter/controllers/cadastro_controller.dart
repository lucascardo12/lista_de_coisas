import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:listadecoisa/core/configs/app_helps.dart';
import 'package:listadecoisa/core/interfaces/controller_interface.dart';
import 'package:listadecoisa/modules/auth/domain/services/auth_service.dart';
import 'package:listadecoisa/modules/home/presenter/ui/pages/home_page.dart';
import 'package:listadecoisa/core/services/global.dart';
import 'package:translator/translator.dart';

class CadastroController extends IController {
  final Global gb;
  final AuthService authService;
  final translator = GoogleTranslator();
  var loginControler = TextEditingController();
  var senhaControler = TextEditingController();
  var nomeControler = TextEditingController();
  var isVali = false;
  var lObescure = ValueNotifier(true);

  CadastroController(this.gb, this.authService);

  @override
  void dispose() {
    lObescure.dispose();
  }

  @override
  void init(BuildContext context) {}

  Future<void> createUserWithEmailAndPassword(BuildContext context) async {
    try {
      gb.load(context);

      final value = await authService.createUserWithEmailAndPassword(
        email: loginControler.text.trim(),
        password: senhaControler.text.trim(),
        nome: nomeControler.text.trim(),
      );

      gb.usuario = value;
      gb.box.put('fezLogin', true);

      if (context.mounted) {
        Navigator.pushNamedAndRemoveUntil(
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
