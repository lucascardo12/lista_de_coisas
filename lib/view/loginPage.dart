import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:listadecoisa/controller/login-controller.dart';
import 'package:listadecoisa/services/global.dart';
import 'package:listadecoisa/widgets/borda-padrao.dart';
import 'package:listadecoisa/widgets/loading-padrao.dart';

class Login extends GetView {
  final gb = Get.find<Global>();
  final ct = Get.put(LoginController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: TextButton(
          style: TextButton.styleFrom(
            padding: EdgeInsets.all(0),
          ),
          child: Text(
            'Esqueceu sua senha?',
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () => ct.showAlertDialog2(context: context),
        ),
        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(begin: Alignment.topRight, end: Alignment.bottomLeft, colors: [
            gb.getPrimary(),
            gb.getSecondary(),
          ])),
          child: gb.isLoading
              ? LoadPadrao()
              : ListView(
                  padding: EdgeInsets.all(0),
                  children: [
                    Padding(
                        padding: EdgeInsets.only(top: 100, bottom: 100),
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
                    Column(
                      children: [
                        Padding(
                            padding: EdgeInsets.all(15),
                            child: TextFormField(
                              cursorColor: Colors.white,
                              style: TextStyle(color: Colors.white),
                              textAlign: TextAlign.left,
                              decoration: InputDecoration(
                                  suffixIcon: IconButton(
                                    color: Colors.transparent,
                                    icon: Icon(Icons.visibility_off),
                                    onPressed: () {},
                                  ),
                                  border: BordaPadrao.build(),
                                  enabledBorder: BordaPadrao.build(),
                                  focusedBorder: BordaPadrao.build(),
                                  hintStyle: TextStyle(color: Colors.white),
                                  hintText: 'E-mail'),
                              controller: ct.loginControler,
                            )),
                        Padding(
                            padding: EdgeInsets.all(15),
                            child: Obx(() => TextFormField(
                                  cursorColor: Colors.white,
                                  obscureText: ct.lObescure.value,
                                  style: TextStyle(color: Colors.white),
                                  textAlign: TextAlign.left,
                                  decoration: InputDecoration(
                                      suffixIcon: IconButton(
                                        color: Colors.white,
                                        icon: Icon(
                                            ct.lObescure.value ? Icons.visibility : Icons.visibility_off),
                                        onPressed: () {
                                          ct.lObescure.value = !ct.lObescure.value;
                                        },
                                      ),
                                      border: BordaPadrao.build(),
                                      enabledBorder: BordaPadrao.build(),
                                      focusedBorder: BordaPadrao.build(),
                                      hintStyle: TextStyle(color: Colors.white),
                                      hintText: 'Senha'),
                                  controller: ct.senhaControler,
                                ))),
                        Padding(
                            padding: EdgeInsets.all(15),
                            child: TextButton(
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.only(top: 10, bottom: 10),
                                minimumSize: Size(MediaQuery.of(context).size.width - 100, 2),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                backgroundColor: Colors.white,
                              ),
                              child: Text(
                                'Login',
                                style: TextStyle(color: gb.getPrimary()),
                              ),
                              onPressed: () {
                                gb.isLoading = true;

                                ct.logar(context: context);
                              },
                            )),
                        TextButton(
                          child: Text(
                            'Cadastrar-se',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () => Get.toNamed('/cadastro'),
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            backgroundColor: Colors.white,
                          ),
                          child: Text(
                            'Modo anônimo',
                            style: TextStyle(color: gb.getPrimary()),
                          ),
                          onPressed: () {
                            ct.loginAnonimo(context: context);
                          },
                        ),
                      ],
                    )
                  ],
                ),
        ));
  }
}
