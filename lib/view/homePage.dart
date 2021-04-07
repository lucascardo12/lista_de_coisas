import 'package:admob_flutter/admob_flutter.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:listadecoisa/model/coisas.dart';
import 'package:listadecoisa/view/listasPage.dart';
import 'package:listadecoisa/view/loginPage.dart';
import 'package:listadecoisa/controller/temas.dart';
import 'package:listadecoisa/controller/global.dart' as global;
import 'package:smart_select/smart_select.dart';

import '../controller/temas.dart';
import '../controller/temas.dart';
import '../controller/temas.dart';
import '../controller/temas.dart';
import '../controller/temas.dart';
import '../model/coisas.dart';

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
  List<String> listaTipo = ["Texto Simples", "Check-List", "Lista de Compras"];

  void logoff() {
    global.prefs.setString('user', '');
    global.prefs.setBool("fezLogin", false);
    global.usuario = null;
  }

  void deleteList({Coisas coisa}) {
    global.banco.removeCoisas(user: global.usuario, cat: coisa);
    global.lisCoisa.remove(coisa);
    setState(() {});
  }

  showAlertDialog2({BuildContext context, Coisas coisas}) {
    Widget cancelaButton = FlatButton(
      child: Text("Cancelar"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continuaButton = FlatButton(
      child: Text("Continar"),
      onPressed: () {
        deleteList(coisa: coisas);
        Navigator.pop(context);
      },
    );
    //configura o AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Atenção !!!"),
      content: Text("Deseja deletar a lista ?"),
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

  showExit({
    BuildContext context,
  }) {
    Widget cancelaButton = FlatButton(
      child: Text("Sim"),
      onPressed: () {
        SystemNavigator.pop();
      },
    );
    Widget continuaButton = FlatButton(
      child: Text("Não"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    //configura o AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Atenção !!!"),
      content: Text("Deseja sair do app ?"),
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
                                      global.lisCoisa.add(value);
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
    isAnonimo = global.prefs.getBool('isAnonimo') ?? false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.light,
      statusBarColor: getPrimary(), // status bar color
    ));
    return Scaffold(
      appBar: AppBar(
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
          onWillPop: () => showExit(context: context),
          child: Stack(
            children: [
              Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [getPrimary(), getSecondary()]))),
              ListView.builder(
                  padding: EdgeInsets.only(
                    left: 10,
                    right: 10,
                    top: 10,
                  ),
                  shrinkWrap: true,
                  itemCount: global.lisCoisa.length,
                  itemBuilder: (context, index) {
                    var coisa = global.lisCoisa[index];
                    return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  builder: (BuildContext context) => ListasPage(
                                        coisa: coisa,
                                      ))).then((value) {
                            if (value != null)
                              setState(() {
                                global.lisCoisa[index] = value;
                              });
                          });
                        },
                        child: Card(
                          child: Padding(
                              padding: EdgeInsets.only(left: 10, right: 10),
                              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                Text(global.lisCoisa[index].nome),
                                IconButton(
                                    icon: Icon(Icons.delete_forever),
                                    onPressed: () {
                                      showAlertDialog2(coisas: global.lisCoisa[index], context: context);
                                    })
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
                    global.usuario.nome ?? '',
                    style: TextStyle(color: Colors.white, fontSize: 22),
                  )),
            ),
            !isAnonimo
                ? Padding(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: FlatButton(
                        splashColor: getSecondary(),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        color: getPrimary(),
                        onPressed: () {
                          logoff();
                          Navigator.push(
                              context, new MaterialPageRoute(builder: (BuildContext context) => Login()));
                        },
                        child: Text(
                          "Logout",
                          style: TextStyle(color: Colors.white),
                        )))
                : Container(),
            Padding(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: FlatButton(
                    splashColor: getSecondary(),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    color: getPrimary(),
                    onPressed: () {
                      Navigator.push(
                          context, new MaterialPageRoute(builder: (BuildContext context) => Login()));
                    },
                    child: Text(
                      "Voltar",
                      style: TextStyle(color: Colors.white),
                    ))),
            !isAnonimo
                ? Padding(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: FlatButton(
                        splashColor: getSecondary(),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        color: getPrimary(),
                        onPressed: () {
                          global.banco.resetarSenha(user: global.usuario);
                        },
                        child: Text(
                          "Redefina Senha",
                          style: TextStyle(color: Colors.white),
                        )))
                : Container(),
            Padding(
                padding: EdgeInsets.only(left: 5, right: 5),
                child: SmartSelect<String>.single(
                  title: 'Temas',
                  onChange: (selected) {
                    setState(() {
                      global.tema = selected.value;
                      global.prefs.setString("tema", selected.value);
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
                  value: global.tema,
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
