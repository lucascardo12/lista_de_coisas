import 'dart:async';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:listadecoisa/controller/home-controller.dart';
import 'package:listadecoisa/model/coisas.dart';
import 'package:listadecoisa/view/listasPage.dart';
import 'package:listadecoisa/view/loginPage.dart';
import 'package:listadecoisa/controller/temas.dart';
import 'package:listadecoisa/controller/global.dart' as gb;
import 'package:listadecoisa/widgets/Button-text-padrao.dart';
import 'package:listadecoisa/widgets/loading-padrao.dart';
import 'package:scan/scan.dart';
import 'package:smart_select/smart_select.dart';
import 'package:uni_links/uni_links.dart';
import '../controller/temas.dart';
import '../model/coisas.dart';
import 'package:flutter/services.dart';

enum UniLinksType { string, uri }

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomeviewtate createState() => _MyHomeviewtate();
}

class _MyHomeviewtate extends State<MyHomePage> {
  GlobalKey<ScaffoldState> _scaffoldKe = new GlobalKey();
  bool isAnonimo = false;
  int tipo = 1;
  ScanController controller = ScanController();
  StreamSubscription sup;
  List<String> listaTipo = ["Texto Simples", "Check-List", "Lista de Compras"];

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
                style: theme.textTheme.subtitle1.copyWith(color: getWhiteOrBlack()),
              ),
              tileColor: getPrimary(),
            ),
            for (int i = 0; i < listaTipo.length; i++)
              ListTile(
                title: Text(
                  '${listaTipo[i]}',
                  style: Theme.of(context).textTheme.subtitle1.copyWith(color: Colors.black),
                ),
                leading: Radio(
                  value: i,
                  activeColor: getPrimary(),
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
                              style: theme.textTheme.subtitle1.copyWith(color: getWhiteOrBlack()),
                            ),
                            style: TextButton.styleFrom(backgroundColor: Colors.green)))
                  ],
                )),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    HomeController.initPlatformStateForStringUniLinks(context: context);
    gb.isLoading = true;
    HomeController.atualizaLista().then((value) => setState(() => gb.isLoading = false));
    isAnonimo = gb.prefs.getBool('isAnonimo') ?? false;
    super.initState();
  }

  @override
  void dispose() {
    if (sup != null) sup.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
        backgroundColor: getPrimary(),
        title: Text('Listas', style: TextStyle(color: Colors.white, fontSize: 25)),
      ),
      key: _scaffoldKe,
      body: WillPopScope(
          onWillPop: () => HomeController.showExit(context: context),
          child: Stack(
            children: [
              Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [getPrimary(), getSecondary()]))),
              gb.isLoading
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
                                    IconButton(
                                        icon: Icon(Icons.delete_forever),
                                        onPressed: () async {
                                          await HomeController.showAlertDialog2(
                                              coisas: gb.lisCoisa[index], context: context);
                                          setState(() {});
                                        }),
                                    IconButton(
                                        icon: Icon(Icons.delete_forever),
                                        onPressed: () => Navigator.pushNamed(context, '/comp')),
                                  ])),
                            ));
                      }),
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
                      colors: [getPrimary(), getSecondary()])),
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
                Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context) => Login()));
              },
              label: "Voltar",
            ),
            !isAnonimo
                ? ButtonTextPadrao(
                    label: "Redefina Senha",
                    onPressed: () {
                      gb.banco.resetarSenha(user: gb.usuario);
                    },
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
                        backgroundColor: getPrimary(),
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
    );
  }
}
