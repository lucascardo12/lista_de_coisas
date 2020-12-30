import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:listadecoisa/classes/coisas.dart';
import 'package:listadecoisa/classes/user.dart';
import 'package:listadecoisa/pages/cadastroPage.dart';
import 'package:listadecoisa/pages/homePage.dart';
import 'package:listadecoisa/services/global.dart' as global;

class Login extends StatefulWidget {
  Login();
  @override
  State<StatefulWidget> createState() => new _Login();
}

class _Login extends State<Login> {
  TextEditingController loginControler = TextEditingController();
  TextEditingController senhaControler = TextEditingController();
  bool isVali = false;
  bool lObescure = true;

  showAlertDialog2({BuildContext context}) {
    Widget cancelaButton = FlatButton(
      child: Text("Cancelar"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continuaButton = FlatButton(
      child: Text("Confirmar"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    //configura o AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Redefinir a senha do login abaixo"),
      content: TextField(
        controller: loginControler,
      ),
      actions: [
        cancelaButton,
        continuaButton,
      ],
    );
    //exibe o diálogo
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void _submit() {
    global.banco
        .login(email: loginControler.text, password: senhaControler.text)
        .then((value) async {
      setState(() {
        global.usuario = value;
        global.isLoading = false;
      });
      if (value != null) {
        List<dynamic> listCat =
            await global.banco.getCoisas(user: global.usuario);
        global.lisCoisa = listCat.map((i) => Coisas.fromSnapshot(i)).toList();
        setState(() {
          var userCo = jsonEncode(value);
          global.prefs.setString('user', userCo);
          global.prefs.setBool("fezLogin", true);
          global.prefs.setBool('isAnonimo', false);
          global.usuario = value;
        });
        Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (BuildContext context) =>
                    MyHomePage(title: 'Lista de Coisas')));
      }
    });
  }

  void _submitAnonimo() {
    global.banco.criaUserAnonimo().then((value) async {
      setState(() {
        global.usuario = value;
        global.isLoading = false;
      });
      if (value != null) {
        List<dynamic> listCat =
            await global.banco.getCoisas(user: global.usuario);
        global.lisCoisa = listCat.map((i) => Coisas.fromSnapshot(i)).toList();
        setState(() {
          var userCo = jsonEncode(value);
          global.prefs.setString('user', userCo);
          global.prefs.setBool("fezLogin", true);
          global.prefs.setBool('isAnonimo', true);
          global.usuario = value;
        });
        Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (BuildContext context) =>
                    MyHomePage(title: 'Lista de Coisas')));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        floatingActionButton: FlatButton(
          padding: EdgeInsets.all(0),
          child: Text(
            'Esqueceu sua senha?',
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () {
            showAlertDialog2(context: context);
          },
        ),
        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                Color.fromRGBO(255, 64, 111, 1),
                Color.fromRGBO(255, 128, 111, 1)
              ])),
          child: ListView(
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
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25)),
                                borderSide: BorderSide(
                                  color: Colors.white,
                                  width: 2,
                                )),
                            enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25)),
                                borderSide: BorderSide(
                                  color: Colors.white,
                                  width: 2,
                                )),
                            focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25)),
                                borderSide: BorderSide(
                                  color: Colors.white,
                                  width: 2,
                                )),
                            hintStyle: TextStyle(color: Colors.white),
                            hintText: 'E-mail'),
                        controller: loginControler,
                      )),
                  Padding(
                      padding: EdgeInsets.all(15),
                      child: TextFormField(
                        cursorColor: Colors.white,
                        obscureText: lObescure,
                        style: TextStyle(color: Colors.white),
                        textAlign: TextAlign.left,
                        decoration: InputDecoration(
                            suffixIcon: IconButton(
                              color: Colors.white,
                              icon: Icon(lObescure
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                              onPressed: () {
                                setState(() {
                                  lObescure = !lObescure;
                                });
                              },
                            ),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25)),
                                borderSide: BorderSide(
                                  color: Colors.white,
                                  width: 2,
                                )),
                            enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25)),
                                borderSide: BorderSide(
                                  color: Colors.white,
                                  width: 2,
                                )),
                            focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25)),
                                borderSide: BorderSide(
                                  color: Colors.white,
                                  width: 2,
                                )),
                            hintStyle: TextStyle(color: Colors.white),
                            hintText: 'Senha'),
                        controller: senhaControler,
                      )),
                  Padding(
                      padding: EdgeInsets.all(15),
                      child: FlatButton(
                        minWidth: MediaQuery.of(context).size.width - 100,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        color: Colors.white,
                        child: Padding(
                            padding: EdgeInsets.all(15),
                            child: Text(
                              'Login',
                              style: TextStyle(
                                  color: Color.fromRGBO(255, 64, 111, 1)),
                            )),
                        onPressed: () {
                          _submit();
                        },
                      )),
                  FlatButton(
                    child: Text(
                      'Cadastrar-se',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (BuildContext context) => Cadastro()));
                    },
                  ),
                  FlatButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    color: Colors.white,
                    child: Text(
                      'Modo anônimo',
                      style: TextStyle(color: Color.fromRGBO(255, 64, 111, 1)),
                    ),
                    onPressed: () {
                      _submitAnonimo();
                    },
                  )
                ],
              )
            ],
          ),
        ));
  }
}
