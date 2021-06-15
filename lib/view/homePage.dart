import 'dart:async';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:listadecoisa/controller/home-controller.dart';
import 'package:listadecoisa/model/coisas.dart';
import 'package:listadecoisa/view/listasPage.dart';
import 'package:listadecoisa/view/loginPage.dart';
import 'package:listadecoisa/controller/global.dart' as gb;
import 'package:listadecoisa/widgets/Button-text-padrao.dart';
import 'package:listadecoisa/widgets/loading-padrao.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:scan/scan.dart';
import 'package:smart_select/smart_select.dart';
import '../model/coisas.dart';
import 'package:share/share.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomeviewtate createState() => _MyHomeviewtate();
}

class _MyHomeviewtate extends State<MyHomePage> {
  GlobalKey<ScaffoldState> scaffoldKe = new GlobalKey();
  bool isAnonimo = false;
  bool isLoading = false;
  bool isread = false;
  int tipo = 1;
  ScanController controller = ScanController();
  StreamSubscription sup;
  List<String> listaTipo = ["Texto Simples", "Check-List", "Lista de Compras"];
  showCompartilha({BuildContext context, int index}) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ListView(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
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
                  style: Theme.of(context).textTheme.subtitle1.copyWith(color: gb.primary),
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
              data: 'http://lcm.listadecoisas.com/comp${gb.lisCoisa[index].idFire}@${gb.usuario.id}*$isread',
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
                        'http://lcm.listadecoisas.com/comp${gb.lisCoisa[index].idFire}@${gb.usuario.id}*$isread'),
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
    BuildContext context,
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
                style: theme.textTheme.subtitle1.copyWith(color: gb.getWhiteOrBlack()),
              ),
              tileColor: gb.getPrimary(),
            ),
            for (int i = 0; i < listaTipo.length; i++)
              ListTile(
                title: Text(
                  '${listaTipo[i]}',
                  style: Theme.of(context).textTheme.subtitle1.copyWith(color: Colors.black),
                ),
                leading: Radio(
                  value: i,
                  activeColor: gb.getPrimary(),
                  onChanged: (int value) {
                    setState(() {
                      tipo = value;
                    });
                    Navigator.pop(context);
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
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        "Cancelar",
                        style: theme.textTheme.subtitle1.copyWith(color: Colors.black),
                      ),
                      style: TextButton.styleFrom(backgroundColor: Colors.white),
                    )),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                        child: TextButton(
                            onPressed: () => Navigator.push(
                                    context,
                                    new MaterialPageRoute(
                                        builder: (BuildContext context) => ListasPage(
                                              coisa: Coisas(
                                                  tipo: tipo,
                                                  checkCompras: [],
                                                  checklist: [],
                                                  descricao: '',
                                                  nome: ''),
                                            ))).then((value) {
                                  if (value != null) {
                                    setState(() {
                                      gb.lisCoisa.add(value);
                                    });
                                  }
                                  Navigator.pop(context);
                                }),
                            child: Text(
                              "Continuar",
                              style: theme.textTheme.subtitle1.copyWith(color: gb.getWhiteOrBlack()),
                            ),
                            style: TextButton.styleFrom(backgroundColor: Colors.green)))
                  ],
                )),
          ],
        );
      },
    );
  }

  showAlertRedefinir({BuildContext context}) {
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
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text("Confirmar"),
              onPressed: () {
                gb.banco.resetarSenha(user: gb.usuario);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    isLoading = true;
    isAnonimo = gb.prefs.getBool('isAnonimo') ?? false;
    HomeController.atualizaLista().then((value) => setState(() {
          isLoading = false;
        }));
    HomeController.initPlatformStateForStringUniLinks(context: context).then((value) {
      setState(() => isLoading = false);
    });
    super.initState();
  }

  @override
  void dispose() {
    if (sup != null) sup.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: WillPopScope(
          onWillPop: () => HomeController.showExit(context: context),
          child: Scaffold(
            appBar: AppBar(
              bottom: TabBar(
                tabs: [
                  Tab(
                    icon: Icon(
                      Icons.list_alt,
                      color: Colors.white,
                    ),
                  ),
                  Tab(
                      icon: Icon(
                    Icons.share_outlined,
                    color: Colors.white,
                  )),
                ],
              ),
              iconTheme: IconThemeData(color: Colors.white),
              actions: [
                Padding(
                    padding: EdgeInsets.only(
                      left: 10,
                      right: 10,
                    ),
                    child: IconButton(
                      color: Colors.white,
                      icon: Icon(
                        Icons.add_circle,
                        size: 32,
                      ),
                      onPressed: () => showCria(context: context),
                    ))
              ],
              centerTitle: true,
              backgroundColor: gb.getPrimary(),
              title: Text('Listas', style: TextStyle(color: Colors.white, fontSize: 25)),
            ),
            body: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [gb.getPrimary(), gb.getSecondary()])),
                child: TabBarView(
                  children: [
                    listasNormais(),
                    listasComp(),
                  ],
                )),
            drawer: Drawer(
              elevation: 8,
              child: ListView(
                children: [
                  DrawerHeader(
                    margin: EdgeInsets.all(0),
                    padding: EdgeInsets.all(0),
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                            colors: [gb.getPrimary(), gb.getSecondary()])),
                    child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          gb.usuario.nome ?? '',
                          style: TextStyle(color: Colors.white, fontSize: 22),
                        )),
                  ),
                  !isAnonimo
                      ? ButtonTextPadrao(
                          onPressed: () {
                            HomeController.logoff();
                            Navigator.push(
                                context, new MaterialPageRoute(builder: (BuildContext context) => Login()));
                          },
                          label: "Logout",
                        )
                      : Container(),
                  ButtonTextPadrao(
                    onPressed: () {
                      Navigator.push(
                          context, new MaterialPageRoute(builder: (BuildContext context) => Login()));
                    },
                    label: "Voltar",
                  ),
                  !isAnonimo
                      ? ButtonTextPadrao(
                          label: "Redefina Senha",
                          onPressed: () => showAlertRedefinir(context: context),
                        )
                      : Container(),
                  Padding(
                      padding: EdgeInsets.only(left: 5, right: 5),
                      child: SmartSelect<String>.single(
                        title: 'Temas',
                        onChange: (selected) {
                          setState(() {
                            gb.tema = selected.value;
                            gb.prefs.setString("tema", selected.value);
                          });
                        },
                        choiceType: S2ChoiceType.radios,
                        choiceItems: [
                          S2Choice(title: 'Original', value: 'Original'),
                          S2Choice(title: 'Dark', value: 'Dark'),
                          S2Choice(title: 'Azul', value: 'Azul'),
                          S2Choice(title: 'Roxo', value: 'Roxo')
                        ],
                        modalType: S2ModalType.popupDialog,
                        modalHeader: false,
                        modalConfig: const S2ModalConfig(
                          style: S2ModalStyle(
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(20.0)),
                            ),
                          ),
                        ),
                        tileBuilder: (context, state) {
                          return S2Tile.fromState(
                            state,
                            isTwoLine: false,
                            leading: CircleAvatar(
                              backgroundColor: gb.getPrimary(),
                              child: Text(
                                '',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          );
                        },
                        value: gb.tema,
                      ))
                ],
              ),
            ),
            bottomNavigationBar: Container(
              child: AdmobBanner(
                adUnitId: 'ca-app-pub-1205611887737485/2150742777',
                adSize: AdmobBannerSize.ADAPTIVE_BANNER(width: MediaQuery.of(context).size.width.round()),
                listener: (AdmobAdEvent event, Map<String, dynamic> args) {},
                onBannerCreated: (AdmobBannerController controller) {
                  //controller.dispose();
                },
              ),
            ),
          ),
        ));
  }

  Widget listasNormais() {
    return isLoading
        ? LoadPadrao()
        : ListView.builder(
            padding: EdgeInsets.only(
              left: 10,
              right: 10,
              top: 10,
            ),
            shrinkWrap: true,
            itemCount: gb.lisCoisa.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (BuildContext context) => ListasPage(
                                  coisa: gb.lisCoisa[index],
                                ))).then((value) {
                      if (value != null)
                        setState(() {
                          gb.lisCoisa[index] = value;
                        });
                    });
                  },
                  child: Card(
                    child: Padding(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          Text(gb.lisCoisa[index].nome),
                          PopupMenuButton(
                            icon: Icon(Icons.more_vert),
                            itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                              PopupMenuItem(
                                value: 0,
                                child: ListTile(
                                  leading: Icon(
                                    Icons.qr_code_scanner_rounded,
                                    color: gb.getPrimary(),
                                  ),
                                  title: Text('Compartilhar'),
                                ),
                              ),
                              PopupMenuItem(
                                value: 1,
                                child: ListTile(
                                  leading: Icon(
                                    Icons.delete,
                                    color: gb.getPrimary(),
                                  ),
                                  title: Text('Excluir'),
                                ),
                              ),
                            ],
                            onSelected: (value) async {
                              switch (value) {
                                case 0:
                                  showCompartilha(context: context, index: index);
                                  break;
                                case 1:
                                  await HomeController.showAlertDialog2(
                                      coisas: gb.lisCoisa[index], context: context);
                                  setState(() {});
                                  break;
                                default:
                              }
                            },
                          ),
                        ])),
                  ));
            });
  }

  Widget listasComp() {
    return isLoading
        ? LoadPadrao()
        : ListView.builder(
            padding: EdgeInsets.only(
              left: 10,
              right: 10,
              top: 10,
            ),
            shrinkWrap: true,
            itemCount: gb.lisCoisaComp.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (BuildContext context) => ListasPage(
                                  coisa: gb.lisCoisaComp[index],
                                ))).then((value) {
                      if (value != null)
                        setState(() {
                          gb.lisCoisaComp[index] = value;
                        });
                    });
                  },
                  child: Card(
                    child: Padding(
                        padding: EdgeInsets.only(left: 10, right: 10, top: 15, bottom: 15),
                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          Text(gb.lisCoisaComp[index].nome),
                        ])),
                  ));
            });
  }
}
