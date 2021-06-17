import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:listadecoisa/model/coisas.dart';
import 'package:listadecoisa/model/compartilha.dart';
import 'package:listadecoisa/services/banco.dart';
import 'package:listadecoisa/services/global.dart';
import 'package:uni_links/uni_links.dart';

class HomeController {
  final gb = Get.find<Global>();
  final banco = Get.find<BancoFire>();
  Future<void> atualizaLista() async {
    List<dynamic> listCat = await banco.getCoisas(user: gb.usuario!);
    if (listCat.isNotEmpty) {
      gb.lisCoisa = listCat.map((i) => Coisas.fromSnapshot(i)).toList();
    }

    List<dynamic> listcomp = await banco.getComps(user: gb.usuario!);
    if (listcomp.isNotEmpty) {
      gb.lisComp = listcomp.map((i) => Compartilha.fromSnapshot(i)).toList();
    }
    if (gb.lisComp.isNotEmpty) {
      for (var i = 0; i < gb.lisComp.length; i++) {
        var auxi =
            await banco.getCoisa(idUser: gb.lisComp[i].idUser ?? '', idLista: gb.lisComp[i].idLista ?? '');
        if (auxi.exists) {
          gb.lisCoisaComp.add(Coisas.fromSnapshot(auxi));
        }
      }
    }
  }

  void logoff() {
    gb.box.put('user', '');
    gb.box.put("fezLogin", false);
    gb.usuario = null;
  }

  Future<void> deleteList({required Coisas coisa}) async {
    await banco.removeCoisas(user: gb.usuario!, cat: coisa);
    gb.lisCoisa.remove(coisa);
  }

  Future showAlertDialog2({required BuildContext context, required Coisas coisas}) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Atenção !!!"),
          content: Text("Deseja deletar a lista ?"),
          actions: [
            TextButton(
              child: Text("Cancelar"),
              onPressed: () => Get.back(),
            ),
            TextButton(
              child: Text("Continar"),
              onPressed: () async {
                await deleteList(coisa: coisas);
                Get.back();
              },
            ),
          ],
        );
      },
    );
  }

  Future initPlatformStateForStringUniLinks({required BuildContext context}) async {
    String? initialLink;

    try {
      initialLink = (await getInitialLink());
      print('initial link: $initialLink');
      if (initialLink != null) {
        gb.codigoList = initialLink.substring(33, initialLink.indexOf('@'));
        gb.codigoUser = initialLink.substring(initialLink.indexOf('@') + 1, initialLink.indexOf('*'));
        gb.codigRead = initialLink.substring(initialLink.indexOf('*') + 1, initialLink.length);
        var rota = initialLink.substring(28, 33);
        return Get.toNamed(rota);
      }
    } on PlatformException {
      initialLink = 'Failed to get initial link.';
    } on FormatException {
      initialLink = 'Failed to parse the initial link as Uri.';
    }
  }

  showExit({
    required BuildContext context,
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
              onPressed: () => Get.back(),
            ),
          ],
        );
      },
    );
  }
}
