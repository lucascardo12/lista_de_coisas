import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:listadecoisa/controller/login-controller.dart';
import 'package:listadecoisa/model/coisas.dart';
import 'package:listadecoisa/view/cadastroPage.dart';
import 'package:listadecoisa/controller/global.dart' as global;
import 'package:listadecoisa/widgets/borda-padrao.dart';
import 'package:listadecoisa/widgets/loading-padrao.dart';

class Login extends StatefulWidget {
  Login({
    Key key,
    this.coisas,
  }) : super(key: key);
  final Coisas coisas;
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController loginControler = TextEditingController(text: global.prefs.getString('login') ?? "");
  TextEditingController senhaControler = TextEditingController(text: global.prefs.getString('senha') ?? "");
  bool isVali = false;
  bool lObescure = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        floatingActionButton: TextButton(
          style: TextButton.styleFrom(
            padding: EdgeInsets.all(0),
          ),
          child: Text(
            'Esqueceu sua senha?',
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () => showAlertDialog2(context: context, loginControler: loginControler),
        ),
        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [global.getPrimary(), global.getSecondary()])),
          child: global.isLoading
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
                                style: TextStyle(color: global.getPrimary()),
                              ),
                              onPressed: () {
                                setState(() {
                                  global.isLoading = true;
                                });
                                logar(
                                    context: context,
                                    loginControler: loginControler,
                                    senhaControler: senhaControler);
                              },
                            )),
                        TextButton(
                          child: Text(
                            'Cadastrar-se',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            Navigator.push(context,
                                new MaterialPageRoute(builder: (BuildContext context) => Cadastro()));
                          },
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
                            style: TextStyle(color: global.getPrimary()),
                          ),
                          onPressed: () {
                            loginAnonimo(context: context);
                          },
                        ),
                      ],
                    )
                  ],
                ),
        ));
  }
}
