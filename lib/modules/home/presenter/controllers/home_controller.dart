import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:listadecoisa/core/interfaces/controller_interface.dart';
import 'package:listadecoisa/core/interfaces/local_database_inter.dart';
import 'package:listadecoisa/core/services/global.dart';
import 'package:listadecoisa/modules/auth/domain/services/auth_service.dart';
import 'package:listadecoisa/modules/home/domain/models/compartilha_params.dart';
import 'package:listadecoisa/modules/home/domain/repositories/compartilha_repository_inter.dart';
import 'package:listadecoisa/modules/listas/domain/models/coisas.dart';
import 'package:listadecoisa/modules/home/domain/models/compartilha.dart';
import 'package:listadecoisa/modules/home/presenter/ui/pages/compartilha_page.dart';
import 'package:listadecoisa/modules/listas/domain/repositories/coisas_repository_inter.dart';
import 'package:listadecoisa/modules/listas/presenter/ui/pages/listas_page.dart';
import 'package:listadecoisa/core/services/admob.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:scan/scan.dart';
import 'package:share/share.dart';
import 'package:uni_links/uni_links.dart';

class HomeController extends IController {
  final ILocalDatabase localDatabase;
  final ICoisasRepository coisasRepository;
  final ICompartilhaRepository compartilhaRepository;
  final AuthService authService;
  final Global global;
  final AdMob admob;
  var lisCoisa = ValueNotifier(<Coisas>[]);
  var lisCoisaComp = ValueNotifier(<Coisas>[]);
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
    required this.coisasRepository,
    required this.admob,
    required this.localDatabase,
    required this.global,
    required this.compartilhaRepository,
    required this.authService,
  });

  @override
  void dispose() {}

  @override
  void init(BuildContext context) {
    localDatabase.get(id: 'isAnonimo').then((value) => isAnonimo = value ?? false);
    atualizaLista();
  }

  Future<void> atualizaLista() async {
    lisCoisaComp.value.clear();
    lisCoisa.value = await coisasRepository.list(idUser: global.usuario!.id!);

    List<Compartilha> listcomp = await compartilhaRepository.list(idUser: global.usuario!.id!);
    for (var element in listcomp) {
      var coisaComp = await coisasRepository.get(idUser: element.idUser, idDoc: element.idLista);
      if (coisaComp != null) {
        lisCoisaComp.value.add(coisaComp);
      } else {
        await compartilhaRepository.remove(idUser: global.usuario!.id!, idDoc: element.idFire!);
      }
    }
  }

  void logoff() async {
    await localDatabase.update(id: 'user', objeto: '');
    await localDatabase.update(id: "fezLogin", objeto: false);
    global.usuario = null;
  }

  Future<void> deleteList({required Coisas coisa}) async {
    await coisasRepository.remove(idUser: global.usuario!.id!, idDoc: coisa.idFire!);
    await atualizaLista();
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
        var codigoList = initialLink.substring(33, initialLink.indexOf('@'));
        var codigoUser = initialLink.substring(initialLink.indexOf('@') + 1, initialLink.indexOf('*'));
        var codigRead = initialLink.substring(initialLink.indexOf('*') + 1, initialLink.length);
        Navigator.pushNamed(
          context,
          CompartilhaPage.route,
          arguments: CompartilharParams(
            codigoList: codigoList,
            codigoUser: codigoUser,
            codigRead: codigRead,
          ),
        );
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
                  style: Theme.of(context).textTheme.subtitle1!.copyWith(color: global.primary),
                ),
                Switch(
                  value: isread,
                  activeColor: global.getPrimary(),
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
                  'http://lcm.listadecoisas.com/comp${lisCoisa.value[index].idFire}@${global.usuario!.id}*$isread',
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
                  disabledForegroundColor: global.getSecondary().withOpacity(0.38),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  backgroundColor: global.getPrimary(),
                ),
                onPressed: () => Share.share(
                    'http://lcm.listadecoisas.com/comp${lisCoisa.value[index].idFire}@${global.usuario!.id}*$isread'),
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
                style: theme.textTheme.subtitle1!.copyWith(color: global.getWhiteOrBlack()),
              ),
              tileColor: global.getPrimary(),
            ),
            for (int i = 0; i < listaTipo.length; i++)
              ListTile(
                title: Text(
                  listaTipo[i],
                  style: Theme.of(context).textTheme.subtitle1!.copyWith(color: Colors.black),
                ),
                leading: Radio(
                  value: i,
                  activeColor: global.getPrimary(),
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
                              creatAp: DateTime.now(),
                              updatAp: DateTime.now(),
                              tipo: tipo,
                              checkCompras: [],
                              checklist: [],
                              descricao: '',
                              nome: '',
                            ),
                            false
                          ],
                        ).then((value) => atualizaLista());
                      },
                      style: TextButton.styleFrom(backgroundColor: Colors.green),
                      child: Text(
                        "Continuar",
                        style: theme.textTheme.subtitle1!.copyWith(color: global.getWhiteOrBlack()),
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
                authService.resetarSenha(user: global.usuario!);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
