import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:listadecoisa/model/coisas.dart';
import 'package:listadecoisa/controller/global.dart' as gb;
import 'package:uni_links/uni_links.dart';

class HomeController {
  static Future atualizaLista() async {
    List<dynamic> listCat = await gb.banco.getCoisas(user: gb.usuario);
    if (listCat != null) {
      gb.lisCoisa = listCat.map((i) => Coisas.fromSnapshot(i)).toList();
    }
  }

  static void logoff() {
    gb.prefs.setString('user', '');
    gb.prefs.setBool("fezLogin", false);
    gb.usuario = null;
  }

  static Future<void> deleteList({Coisas coisa}) async {
    await gb.banco.removeCoisas(user: gb.usuario, cat: coisa);
    gb.lisCoisa.remove(coisa);
  }

  static Future showAlertDialog2({BuildContext context, Coisas coisas}) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Atenção !!!"),
          content: Text("Deseja deletar a lista ?"),
          actions: [
            TextButton(
              child: Text("Cancelar"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text("Continar"),
              onPressed: () async {
                await HomeController.deleteList(coisa: coisas);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  static Future initPlatformStateForStringUniLinks({BuildContext context}) async {
    String initialLink;

    try {
      initialLink = await getInitialLink();
      print('initial link: $initialLink');
      if (initialLink != null) {
        gb.codigoList = initialLink.substring(33, initialLink.indexOf('@'));
        gb.codigoUser = initialLink.substring(initialLink.indexOf('@') + 1, initialLink.length);
        var rota = initialLink.substring(28, 33);
        return Navigator.pushNamed(context, rota);
      }
    } on PlatformException {
      initialLink = 'Failed to get initial link.';
    } on FormatException {
      initialLink = 'Failed to parse the initial link as Uri.';
    }
  }

  static showExit({
    BuildContext context,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Atenção !!!"),
          content: Text("Deseja sair do app ?"),
          actions: [
            TextButton(
              child: Text("Sim"),
              onPressed: () {
                SystemNavigator.pop();
              },
            ),
            TextButton(
              child: Text("Não"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
