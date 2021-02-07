import 'dart:convert';
import 'dart:io';
import 'package:listadecoisa/controller/global.dart' as global;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:listadecoisa/model/coisas.dart';
import 'package:listadecoisa/view/homePage.dart';

Future<bool> verificarConexao() async {
  try {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      print('connected');
      return true;
    }
  } on SocketException catch (_) {
    Fluttertoast.showToast(
        msg: 'Sem Conexão',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 5,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 18.0);
    return false;
  }
  return null;
}

// GoogleSignIn _googleSignIn = GoogleSignIn(
//   scopes: <String>[
//     'email',
//     'https://www.googleapis.com/auth/contacts.readonly',
//   ],
// );

showAlertDialog2({BuildContext context, TextEditingController loginControler}) {
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

void logar(
    {TextEditingController loginControler,
    TextEditingController senhaControler,
    BuildContext context}) {
  global.banco
      .login(email: loginControler.text, password: senhaControler.text)
      .then((value) async {
    if (value != null) {
      global.usuario = value;
      List<dynamic> listCat =
          await global.banco.getCoisas(user: global.usuario);
      global.lisCoisa = listCat.map((i) => Coisas.fromSnapshot(i)).toList();

      var userCo = jsonEncode(value);
      global.prefs.setString('user', userCo);
      global.prefs.setBool("fezLogin", true);
      global.prefs.setString('login', loginControler.text);
      global.prefs.setString('senha', senhaControler.text);
      global.prefs.setBool('isAnonimo', false);

      global.isLoading = false;
      Navigator.push(
          context,
          new MaterialPageRoute(
              builder: (BuildContext context) =>
                  MyHomePage(title: 'Lista de Coisas')));
    }
  });
}

// Future<void> _handleSignIn() async {
//   try {
//     await _googleSignIn.signIn();
//   } catch (error) {
//     print(error);
//   }
// }

void loginAnonimo({BuildContext context}) {
  global.banco.criaUserAnonimo().then((value) async {
    global.usuario = value;
    global.isLoading = false;

    if (value != null) {
      List<dynamic> listCat =
          await global.banco.getCoisas(user: global.usuario);
      global.lisCoisa = listCat.map((i) => Coisas.fromSnapshot(i)).toList();

      var userCo = jsonEncode(value);
      global.prefs.setString('user', userCo);
      global.prefs.setBool("fezLogin", true);
      global.prefs.setBool('isAnonimo', true);

      Navigator.push(
          context,
          new MaterialPageRoute(
              builder: (BuildContext context) =>
                  MyHomePage(title: 'Lista de Coisas')));
    }
  });
}
