import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:listadecoisa/controller/custom-widget.dart';
import 'package:listadecoisa/controller/login-controller.dart';
import 'package:listadecoisa/model/coisas.dart';
import 'package:listadecoisa/view/cadastroPage.dart';
import 'package:listadecoisa/controller/temas.dart';
import 'package:listadecoisa/controller/global.dart' as global;

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
  TextEditingController loginControler = TextEditingController();
  TextEditingController senhaControler = TextEditingController();
  // GoogleSignInAccount _currentUser;
  bool isVali = false;
  bool lObescure = true;

  @override
  void initState() {
    super.initState();
    loginControler.text = global.prefs.getString('login') ?? "";
    senhaControler.text = global.prefs.getString('senha') ?? "";
    // _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
    //   setState(() {
    //     _currentUser = account;
    //   });
    //   if (_currentUser != null) {
    //     // _handleGetContact();
    //   }
    // });
    // _googleSignIn.signInSilently();
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
            showAlertDialog2(context: context, loginControler: loginControler);
          },
        ),
        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [getPrimary(), getSecondary()])),
          child: global.isLoading
              ? loading()
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
                                    style: TextStyle(color: getPrimary()),
                                  )),
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
                        FlatButton(
                          child: Text(
                            'Cadastrar-se',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                new MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        Cadastro()));
                          },
                        ),
                        FlatButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          color: Colors.white,
                          child: Text(
                            'Modo anônimo',
                            style: TextStyle(color: getPrimary()),
                          ),
                          onPressed: () {
                            loginAnonimo(context: context);
                          },
                        ),
                        // FlatButton(
                        //   shape: RoundedRectangleBorder(
                        //     borderRadius: BorderRadius.circular(25),
                        //   ),
                        //   color: Colors.white,
                        //   child: Text(
                        //     'Google',
                        //     style: TextStyle(color: getPrimary()),
                        //   ),
                        //   onPressed: () {
                        //     global.banco.signInWithGoogle();
                        //   },
                        // )
                      ],
                    )
                  ],
                ),
        ));
  }
}
