import 'dart:async';

import 'package:app_review/app_review.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:listadecoisa/model/coisas.dart';
import 'package:listadecoisa/model/compartilha.dart';
import 'package:listadecoisa/services/banco.dart';
import 'package:listadecoisa/services/global.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:scan/scan.dart';
import 'package:share/share.dart';
import 'package:uni_links/uni_links.dart';

class HomeController extends GetxController {
  final gb = Get.find<Global>();
  final banco = Get.find<BancoFire>();
  GlobalKey<ScaffoldState> scaffoldKe = GlobalKey();
  bool isAnonimo = false;
  bool isread = false;
  int tipo = 1;
  ScanController controller = ScanController();
  List<String> listaTipo = ["Texto Simples", "Check-List", "Lista de Compras"];
  @override
  void onInit() {
    isAnonimo = gb.box.get('isAnonimo', defaultValue: false);
    atualizaLista();
    avaliaApp();
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void avaliaApp() {
    Timer(
      Duration(milliseconds: 500),
      () => AppReview.requestReview.then(
        (onValue) {
          print(onValue);
        },
      ),
    );
  }

  Future<void> atualizaLista() async {
    gb.lisCoisa.clear();
    gb.lisCoisaComp.clear();
    gb.lisComp.clear();
    List<dynamic> listCat = await banco.getCoisas(user: gb.usuario!);
    if (listCat.isNotEmpty) {
      listCat.forEach((element) => gb.lisCoisa.add(Coisas.fromSnapshot(element)));
    }

    List<dynamic> listcomp = await banco.getComps(user: gb.usuario!);
    if (listcomp.isNotEmpty) {
      listcomp.forEach((element) => gb.lisComp.add(Compartilha.fromSnapshot(element)));
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

  showCompartilha({required BuildContext context, required int index}) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ListView(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          children: [
            Text(
              'Mostre o QR code ou compartilhe o link',
              style: Get.textTheme.headline5,
            ),
            Text(
              'Quem for receber a lista precisa abri com o app o link ou escanear o QRcode',
              style: Get.textTheme.bodyText1,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Somente visualização?',
                  style: Get.textTheme.subtitle1!.copyWith(color: gb.primary),
                ),
                Switch(
                  value: isread,
                  activeColor: gb.getPrimary(),
                  onChanged: (bool value) {
                    isread = value;
                    Get.back();
                    showCompartilha(context: context, index: index);
                  },
                ),
              ],
            ),
            Center(
                child: QrImage(
              data: 'http://lcm.listadecoisas.com/comp${gb.lisCoisa[index].idFire}@${gb.usuario!.id}*$isread',
              version: QrVersions.auto,
              size: 200.0,
            )),
            SizedBox(
              height: 10,
            ),
            Padding(
                padding: EdgeInsets.only(left: 60, right: 60),
                child: TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.only(top: 15, bottom: 15),
                      onSurface: gb.getSecondary(),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      backgroundColor: gb.getPrimary(),
                    ),
                    onPressed: () => Share.share(
                        'http://lcm.listadecoisas.com/comp${gb.lisCoisa[index].idFire}@${gb.usuario!.id}*$isread'),
                    child: Text(
                      "Compartilhar link",
                      style: TextStyle(color: Colors.white),
                    )))
          ],
        );
      },
    );
  }

  showCria({
    required BuildContext context,
  }) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        final theme = Theme.of(context);
        return Wrap(
          children: [
            ListTile(
              title: Text(
                'Escolha o tipo de Lista',
                style: theme.textTheme.subtitle1!.copyWith(color: gb.getWhiteOrBlack()),
              ),
              tileColor: gb.getPrimary(),
            ),
            for (int i = 0; i < listaTipo.length; i++)
              ListTile(
                title: Text(
                  '${listaTipo[i]}',
                  style: Get.textTheme.subtitle1!.copyWith(color: Colors.black),
                ),
                leading: Radio(
                  value: i,
                  activeColor: gb.getPrimary(),
                  onChanged: (int? value) {
                    tipo = value ?? 1;

                    Get.back();
                    showCria(context: context);
                  },
                  groupValue: tipo,
                ),
              ),
            Padding(
                padding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                        child: TextButton(
                      onPressed: () => Get.back(),
                      child: Text(
                        "Cancelar",
                        style: theme.textTheme.subtitle1!.copyWith(color: Colors.black),
                      ),
                      style: TextButton.styleFrom(backgroundColor: Colors.white),
                    )),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          Get.back();
                          Get.toNamed(
                            '/listas',
                            arguments: [
                              Coisas(
                                tipo: tipo,
                                checkCompras: [],
                                checklist: [],
                                descricao: '',
                                nome: '',
                              ),
                              false
                            ],
                          );
                        },
                        child: Text(
                          "Continuar",
                          style: theme.textTheme.subtitle1!.copyWith(color: gb.getWhiteOrBlack()),
                        ),
                        style: TextButton.styleFrom(backgroundColor: Colors.green),
                      ),
                    )
                  ],
                )),
          ],
        );
      },
    );
  }

  showAlertRedefinir({required BuildContext context}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirma redefinição de senha!!"),
          content: Text('Será encaminhado um e-mail para redefinição de senha, verifique sua caixa de spam.'),
          actions: [
            TextButton(
              child: Text("Cancelar"),
              onPressed: () {
                Get.back();
              },
            ),
            TextButton(
              child: Text("Confirmar"),
              onPressed: () {
                banco.resetarSenha(user: gb.usuario!);
                Get.back();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> lembrarAvaliacao() async {
    if (gb.box.get('lembrarDia', defaultValue: 1) != DateTime.now().day &&
        gb.box.get('lembrarAva', defaultValue: true)) {
      Timer(
        Duration(milliseconds: 500),
        () => Get.defaultDialog(
          title: 'Avaliação do Aplicativo',
          radius: 20,
          content: Text(
            'Gostaria de avaliar o App ?',
            style: Get.textTheme.subtitle1,
          ),
          actions: [
            TextButton(
              onPressed: () {
                gb.box.put('lembrarAva', false);
                Get.back();
              },
              child: Text('Não Mostrar'),
            ),
            TextButton(
              onPressed: () {
                gb.box.put('lembrarDia', DateTime.now().day);
                Get.back();
              },
              child: Text('Depois'),
            ),
            TextButton(
              onPressed: () => null,
              child: Text('Agora'),
            ),
          ],
        ),
      );
    }
  }
}
