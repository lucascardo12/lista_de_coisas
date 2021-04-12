import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:listadecoisa/model/coisas.dart';
import 'package:listadecoisa/model/user.dart';
import 'package:listadecoisa/view/homePage.dart';
import 'package:listadecoisa/controller/temas.dart';
import 'package:listadecoisa/controller/global.dart' as global;
import 'package:listadecoisa/widgets/borda-padrao.dart';

class Cadastro extends StatefulWidget {
  Cadastro();
  @override
  State<StatefulWidget> createState() => new _Cadastro();
}

class _Cadastro extends State<Cadastro> {
  TextEditingController loginControler = TextEditingController();
  TextEditingController senhaControler = TextEditingController();
  TextEditingController nomeControler = TextEditingController();
  bool isVali = false;
  bool lObescure = true;
  void valida() {
    UserP us = new UserP(id: null, login: loginControler.text, senha: senhaControler.text);
    global.banco.criaUser(us).then((value) {
      if (value.isNotEmpty) {
        setState(() {
          global.isLoading = false;
        });
        _submit();
      } else {
        setState(() {
          global.isLoading = false;
        });
      }
    });
  }

  void _submit() {
    global.banco.login(email: loginControler.text, password: senhaControler.text).then((value) async {
      setState(() {
        global.usuario = value;
        global.isLoading = false;
      });
      if (value != null) {
        List<dynamic> listCat = await global.banco.getCoisas(user: global.usuario);
        global.lisCoisa = listCat.map((i) => Coisas.fromSnapshot(i)).toList();
        setState(() {
          var userCo = jsonEncode(value);
          global.prefs.setString('user', userCo);
          global.prefs.setBool("fezLogin", true);
        });
        Navigator.push(context,
            new MaterialPageRoute(builder: (BuildContext context) => MyHomePage(title: 'Lista de Coisas')));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topRight, end: Alignment.bottomLeft, colors: [getPrimary(), getSecondary()])),
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
                          style: TextStyle(color: getPrimary()),
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
                onPressed: () => Navigator.pop(context),
              )
            ],
          )
        ],
      ),
    ));
  }
}
