import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:listadecoisa/controller/login-controller.dart';
import 'package:listadecoisa/services/global.dart';
import 'package:listadecoisa/widgets/Button-text-padrao.dart';
import 'package:listadecoisa/widgets/compo-padrao.dart';
import 'package:listadecoisa/widgets/loading-padrao.dart';

class Login extends GetView {
  final gb = Get.find<Global>();
  final ct = Get.put(LoginController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            gb.getPrimary(),
            gb.getSecondary(),
          ],
        ),
      ),
      child: ListView(
        padding: EdgeInsets.all(20),
        children: [
          Padding(
              padding: EdgeInsets.only(top: 50, bottom: 50),
              child: Align(
                alignment: Alignment.topCenter,
                child: Text(
                  'Lista de coisas',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1,
                    fontStyle: FontStyle.normal,
                  ),
                ),
              )),
          CampoPadrao(
            hintText: 'E-mail',
            controller: ct.loginControler,
          ),
          SizedBox(height: 10),
          Obx(() => CampoPadrao(
                lObescure: ct.lObescure.value,
                suffixIcon: IconButton(
                  color: Colors.white,
                  icon: Icon(ct.lObescure.value ? Icons.visibility : Icons.visibility_off),
                  onPressed: () => ct.lObescure.value = !ct.lObescure.value,
                ),
                hintText: 'Senha',
                controller: ct.senhaControler,
              )),
          ButtonTextPadrao(
            label: 'Esqueceu sua senha?',
            color: Colors.transparent,
            onPressed: () => ct.showAlertRedefinir(context: context),
          ),
          ButtonTextPadrao(
            label: 'Login',
            color: gb.getWhiteOrBlack(),
            textColor: gb.getPrimary(),
            onPressed: () => ct.logar(context: context),
          ),
          ButtonTextPadrao(
            color: gb.getWhiteOrBlack(),
            label: 'Modo anônimo',
            textColor: gb.getPrimary(),
            onPressed: () => ct.loginAnonimo(),
          ),
          ButtonTextPadrao(
            color: gb.getWhiteOrBlack(),
            label: 'Google',
            textColor: gb.getPrimary(),
            onPressed: () => ct.loginGoogle(),
          ),
          ButtonTextPadrao(
            label: 'Cadastrar-se',
            onPressed: () => Get.toNamed('/cadastro'),
            color: Colors.transparent,
          ),
        ],
      ),
    ));
  }
}
