import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKe,
      body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                Color.fromRGBO(255, 64, 111, 1),
                Color.fromRGBO(255, 128, 111, 1)
              ])),
          child: Column(
            children: [
              SizedBox(
                height: 50,
              ),
              Align(
                  alignment: Alignment.topCenter,
                  child: Text('Listas',
                      style: TextStyle(color: Colors.white, fontSize: 28))),
              Padding(
                  padding: EdgeInsets.all(10),
                  child: global.lisCoisa != null
                      ? ListView.builder(
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
                                                icon:
                                                    Icon(Icons.delete_forever),
                                                onPressed: () {
                                                  showAlertDialog2(
                                                      coisas: global
                                                          .lisCoisa[index],
                                                      context: context);
                                                })
                                          ])),
                                ));
                          })
                      : SizedBox())
            ],
          )),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButton: Padding(
          padding: EdgeInsets.only(top: 5),
          child: IconButton(
            icon: Icon(
              Icons.list,
              size: 36,
              color: Colors.white,
            ),
            onPressed: () {
              _scaffoldKe.currentState.openEndDrawer();
            },
          )),
      endDrawerEnableOpenDragGesture: true,
      endDrawer: Drawer(
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
            Padding(
                padding: EdgeInsets.all(20),
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
                    ))),
          ],
        ),
      ),
      persistentFooterButtons: [
        Container(
          color: Colors.white,
          width: MediaQuery.of(context).copyWith().size.width,
          child: Row(
            children: [
              Expanded(
                child: FlatButton(
                  child: Text(
                    'Criar Nova Lista',
                    style: TextStyle(color: Color.fromRGBO(255, 64, 111, 1)),
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (BuildContext context) =>
                                ListasPage())).then((value) {
                      if (value != null) {
                        setState(() {
                          global.lisCoisa.add(value);
                        });
                      }
                    });
                  },
                ),
              )
            ],
          ),
        )
      ], // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
