import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:listadecoisa/classes/coisas.dart';
import 'package:listadecoisa/pages/listasPage.dart';
import 'package:listadecoisa/pages/loginPage.dart';
import 'package:listadecoisa/services/global.dart' as global;

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  GlobalKey<ScaffoldState> _scaffoldKe = new GlobalKey();
  AdmobBannerSize bannerSize;

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

  String getBannerAdUnitId() {
    return 'ca-app-pub-1205611887737485/2150742777';
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bannerSize = AdmobBannerSize.ADAPTIVE_BANNER(
        width: MediaQuery.of(context).size.width.round());
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
              padding: EdgeInsets.only(
                left: 10,
                right: 10,
                top: 10,
              ),
              child: IconButton(
                color: Colors.white,
                icon: Icon(
                  Icons.add_circle,
                  size: 32,
                ),
                onPressed: () {
                  Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (BuildContext context) => ListasPage()))
                      .then((value) {
                    if (value != null) {
                      setState(() {
                        global.lisCoisa.add(value);
                      });
                    }
                  });
                },
              ))
        ],
        centerTitle: true,
        backgroundColor: Color.fromRGBO(255, 64, 111, 1),
        title:
            Text('Listas', style: TextStyle(color: Colors.white, fontSize: 25)),
      ),
      key: _scaffoldKe,
      body: WillPopScope(
          onWillPop: () => showExit(context: context),
          child: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                  Color.fromRGBO(255, 64, 111, 1),
                  Color.fromRGBO(255, 128, 111, 1)
                ])),
            child: Padding(
                padding: EdgeInsets.only(
                  left: 10,
                  right: 10,
                  top: 10,
                ),
                child: Container(
                    height: MediaQuery.of(context).size.height,
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: global.lisCoisa.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    new MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            ListasPage(
                                              coisas: global.lisCoisa[index],
                                            ))).then((value) {
                                  setState(() {
                                    global.lisCoisa[index] =
                                        value ?? global.lisCoisa[index];
                                  });
                                });
                              },
                              child: Card(
                                child: Padding(
                                    padding:
                                        EdgeInsets.only(left: 10, right: 10),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(global.lisCoisa[index].nome),
                                          IconButton(
                                              icon: Icon(Icons.delete_forever),
                                              onPressed: () {
                                                showAlertDialog2(
                                                    coisas:
                                                        global.lisCoisa[index],
                                                    context: context);
                                              })
                                        ])),
                              ));
                        }))),
          )),
      endDrawerEnableOpenDragGesture: true,
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
                      colors: [
                    Color.fromRGBO(255, 64, 111, 1),
                    Color.fromRGBO(255, 128, 111, 1)
                  ])),
              child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    global.usuario.nome ?? '',
                    style: TextStyle(color: Colors.white, fontSize: 22),
                  )),
            ),
            !global.prefs.getBool('isAnonimo') ?? false
                ? Padding(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: FlatButton(
                        splashColor: Color.fromRGBO(255, 128, 111, 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        color: Color.fromRGBO(255, 64, 111, 1),
                        onPressed: () {
                          logoff();
                          Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  builder: (BuildContext context) => Login()));
                        },
                        child: Text(
                          "Logout",
                          style: TextStyle(color: Colors.white),
                        )))
                : Container(),
            Padding(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: FlatButton(
                    splashColor: Color.fromRGBO(255, 128, 111, 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    color: Color.fromRGBO(255, 64, 111, 1),
                    onPressed: () {
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (BuildContext context) => Login()));
                    },
                    child: Text(
                      "Voltar",
                      style: TextStyle(color: Colors.white),
                    ))),
            !global.prefs.getBool('isAnonimo') ?? false
                ? Padding(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: FlatButton(
                        splashColor: Color.fromRGBO(255, 128, 111, 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        color: Color.fromRGBO(255, 64, 111, 1),
                        onPressed: () {
                          global.banco.resetarSenha(user: global.usuario);
                        },
                        child: Text(
                          "Redefina Senha",
                          style: TextStyle(color: Colors.white),
                        )))
                : Container(),
          ],
        ),
      ),
      persistentFooterButtons: [
        Container(
          width: MediaQuery.of(context).size.width,
          child: AdmobBanner(
            adUnitId: getBannerAdUnitId(),
            adSize: bannerSize,
            listener: (AdmobAdEvent event, Map<String, dynamic> args) {},
            onBannerCreated: (AdmobBannerController controller) {
              // controller.dispose();
            },
          ),
        )
      ],
    );
  }
}
