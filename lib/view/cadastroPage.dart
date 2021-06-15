import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:listadecoisa/model/coisas.dart';
import 'package:listadecoisa/model/user.dart';
import 'package:listadecoisa/services/banco.dart';
import 'package:listadecoisa/services/global.dart';
import 'package:listadecoisa/widgets/borda-padrao.dart';

class Cadastro extends StatefulWidget {
  Cadastro();
  @override
  State<StatefulWidget> createState() => _Cadastro();
}

class _Cadastro extends State<Cadastro> {
  final gb = Get.find<Global>();
  final banco = Get.find<BancoFire>();
  TextEditingController loginControler = TextEditingController();
  TextEditingController senhaControler = TextEditingController();
  TextEditingController nomeControler = TextEditingController();
  bool isVali = false;
  bool lObescure = true;
  void valida() {
    UserP us = UserP(id: null, login: loginControler.text.trim(), senha: senhaControler.text.trim());
    banco.criaUser(us).then((value) {
      if (value.isNotEmpty) {
        setState(() {
          gb.isLoading = false;
        });
        _submit();
      } else {
        setState(() {
          gb.isLoading = false;
        });
      }
    });
  }

  void _submit() {
    banco
        .login(
      email: loginControler.text.trim(),
      password: senhaControler.text.trim(),
    )
        .then((value) async {
      setState(() {
        gb.usuario = value;
        gb.isLoading = false;
      });
      if (value != null) {
        List<dynamic> listCat = await banco.getCoisas(user: gb.usuario!);
        gb.lisCoisa = listCat.map((i) => Coisas.fromSnapshot(i)).toList();
        setState(() {
          var userCo = jsonEncode(value);
          gb.box.put('user', userCo);
          gb.box.put("fezLogin", true);
        });
        Get.offAllNamed('/home');
      }
    });
  }

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
        padding: EdgeInsets.all(15),
        children: [
          Padding(
              padding: EdgeInsets.only(top: 100, bottom: 100),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  'Cadastro',
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
                    controller: loginControler,
                  )),
              Padding(
                  padding: EdgeInsets.all(15),
                  child: TextFormField(
                    obscureText: lObescure,
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.left,
                    decoration: InputDecoration(
                        suffixIcon: IconButton(
                          color: Colors.white,
                          icon: Icon(lObescure ? Icons.visibility : Icons.visibility_off),
                          onPressed: () {
                            setState(() {
                              lObescure = !lObescure;
                            });
                          },
                        ),
                        border: BordaPadrao.build(),
                        enabledBorder: BordaPadrao.build(),
                        focusedBorder: BordaPadrao.build(),
                        hintStyle: TextStyle(color: Colors.white),
                        hintText: 'Senha'),
                    controller: senhaControler,
                  )),
              Padding(
                  padding: EdgeInsets.all(15),
                  child: TextFormField(
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
                        hintText: 'Nome'),
                    controller: nomeControler,
                  )),
              Padding(
                  padding: EdgeInsets.all(15),
                  child: TextButton(
                    style: TextButton.styleFrom(
                      minimumSize: Size(MediaQuery.of(context).size.width - 100, 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      backgroundColor: Colors.white,
                    ),
                    child: Padding(
                        padding: EdgeInsets.all(15),
                        child: Text(
                          'Cadastro',
                          style: TextStyle(color: gb.getPrimary()),
                        )),
                    onPressed: () {
                      valida();
                    },
                  )),
              TextButton(
                child: Text(
                  'Voltar',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () => Get.back(),
              )
            ],
          )
        ],
      ),
    ));
  }
}
