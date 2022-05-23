import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:listadecoisa/core/interfaces/controller_interface.dart';
import 'package:listadecoisa/modules/listas/domain/models/coisas.dart';
import 'package:listadecoisa/modules/home/domain/models/compartilha.dart';
import 'package:listadecoisa/modules/home/presenter/ui/pages/compartilha_page.dart';
import 'package:listadecoisa/modules/listas/presenter/ui/pages/listas_page.dart';
import 'package:listadecoisa/core/services/admob.dart';
import 'package:listadecoisa/core/services/banco.dart';
import 'package:listadecoisa/core/services/global.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:scan/scan.dart';
import 'package:share/share.dart';
import 'package:uni_links/uni_links.dart';

class HomeController extends IController {
  final Global gb;
  final BancoFire banco;
  final AdMob admob;
  var scaffoldKe = GlobalKey<ScaffoldState>();
  var isAnonimo = false;
  var isread = false;
  var tipo = 1;
  var controller = ScanController();
  var listaTipo = [
    "Texto Simples",
    "Check-List",
    "Lista de Compras",
  ];

  HomeController({
    required this.gb,
    required this.banco,
    required this.admob,
  });

  @override
  void dispose() {}

  @override
  void init(BuildContext context) {
    isAnonimo = gb.box.get('isAnonimo', defaultValue: false);
    atualizaLista();
  }

  Future<void> atualizaLista() async {
    gb.lisCoisaComp.value.clear();
    List<dynamic> listCat = await banco.getCoisas(user: gb.usuario!);
    if (listCat.isNotEmpty) {
      gb.lisCoisa.value = listCat.map((e) => Coisas.fromSnapshot(e)).toList();
    }

    List<dynamic> listcomp = await banco.getComps(user: gb.usuario!);
    if (listcomp.isNotEmpty) {
      gb.lisComp.value = listcomp.map((e) => Compartilha.fromSnapshot(e)).toList();
    }
    if (gb.lisComp.value.isNotEmpty) {
      for (var i = 0; i < gb.lisComp.value.length; i++) {
        var auxi = await banco.getCoisa(
          idUser: gb.lisComp.value[i].idUser ?? '',
          idLista: gb.lisComp.value[i].idLista ?? '',
        );
        if (auxi.exists) {
          gb.lisCoisaComp.value.add(Coisas.fromSnapshot(auxi));
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
    gb.lisCoisa.value.remove(coisa);
  }

  Future showAlertDialog2({required BuildContext context, required Coisas coisas}) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Atenção !!!"),
          content: const Text("Deseja deletar a lista ?"),
          actions: [
            TextButton(
              child: const Text("Cancelar"),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: const Text("Continar"),
              onPressed: () async {
                await deleteList(coisa: coisas);
                Navigator.pop(context);
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
      if (initialLink != null) {
        gb.codigoList = initialLink.substring(33, initialLink.indexOf('@'));
        gb.codigoUser = initialLink.substring(initialLink.indexOf('@') + 1, initialLink.indexOf('*'));
        gb.codigRead = initialLink.substring(initialLink.indexOf('*') + 1, initialLink.length);
        var rota = initialLink.substring(28, 33);
        return Navigator.pushNamed(context, CompartilhaPage.route);
      }
    } on PlatformException {
      initialLink = 'Failed to get initial link.';
    } on FormatException {
      initialLink = 'Failed to parse the initial link as Uri.';
    }
  }

  Future<bool> showExit({
    required BuildContext context,
  }) async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Atenção !!!"),
              content: const Text("Deseja sair do app ?"),
              actions: [
                TextButton(
                  child: const Text("Sim"),
                  onPressed: () {
                    SystemNavigator.pop();
                  },
                ),
                TextButton(
                  child: const Text("Não"),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  void showCompartilha({required BuildContext context, required int index}) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          children: [
            Text(
              'Mostre o QR code ou compartilhe o link',
              style: Theme.of(context).textTheme.headline5,
            ),
            Text(
              'Quem for receber a lista precisa abri com o app o link ou escanear o QRcode',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Somente visualização?',
                  style: Theme.of(context).textTheme.subtitle1!.copyWith(color: gb.primary),
                ),
                Switch(
                  value: isread,
                  activeColor: gb.getPrimary(),
                  onChanged: (bool value) {
                    isread = value;
                    Navigator.pop(context);
                    showCompartilha(context: context, index: index);
                  },
                ),
              ],
            ),
            Center(
                child: QrImage(
              data:
                  'http://lcm.listadecoisas.com/comp${gb.lisCoisa.value[index].idFire}@${gb.usuario!.id}*$isread',
              version: QrVersions.auto,
              size: 200.0,
            )),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 60, right: 60),
              child: TextButton(
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.only(top: 15, bottom: 15),
                  onSurface: gb.getSecondary(),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  backgroundColor: gb.getPrimary(),
                ),
                onPressed: () => Share.share(
                    'http://lcm.listadecoisas.com/comp${gb.lisCoisa.value[index].idFire}@${gb.usuario!.id}*$isread'),
                child: const Text(
                  "Compartilhar link",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )
          ],
        );
      },
    );
  }

  void showCria({
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
                  listaTipo[i],
                  style: Theme.of(context).textTheme.subtitle1!.copyWith(color: Colors.black),
                ),
                leading: Radio(
                  value: i,
                  activeColor: gb.getPrimary(),
                  onChanged: (int? value) {
                    tipo = value ?? 1;
                    Navigator.pop(context);
                    showCria(context: context);
                  },
                  groupValue: tipo,
                ),
              ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                      child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(backgroundColor: Colors.white),
                    child: Text(
                      "Cancelar",
                      style: theme.textTheme.subtitle1!.copyWith(color: Colors.black),
                    ),
                  )),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(
                          context,
                          ListasPage.route,
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
                      style: TextButton.styleFrom(backgroundColor: Colors.green),
                      child: Text(
                        "Continuar",
                        style: theme.textTheme.subtitle1!.copyWith(color: gb.getWhiteOrBlack()),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  void showAlertRedefinir({required BuildContext context}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirma redefinição de senha!!"),
          content: const Text(
              'Será encaminhado um e-mail para redefinição de senha, verifique sua caixa de spam.'),
          actions: [
            TextButton(
              child: const Text("Cancelar"),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: const Text("Confirmar"),
              onPressed: () {
                banco.resetarSenha(user: gb.usuario!);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
