import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:listadecoisa/controller/home-controller.dart';
import 'package:listadecoisa/model/coisas.dart';
import 'package:listadecoisa/controller/global.dart' as gb;
import 'package:listadecoisa/model/compartilha.dart';
import 'package:listadecoisa/model/user.dart';
import 'package:listadecoisa/view/listasPage.dart';
import 'package:listadecoisa/widgets/Button-text-padrao.dart';
import 'package:listadecoisa/widgets/loading-padrao.dart';

class CompartilhaPage extends StatefulWidget {
  CompartilhaPage();

  @override
  State<StatefulWidget> createState() => new _CompartilhaPage();
}

class _CompartilhaPage extends State<CompartilhaPage> {
  Coisas lista;
  UserP user;
  @override
  void initState() {
    gb.isLoading = true;
    getLista();
    super.initState();
  }

  getLista() async {
    await gb.banco.getCoisa(idLista: gb.codigoList, idUser: gb.codigoUser).then((value) {
      gb.isLoading = false;
      lista = Coisas.fromSnapshot(value);
    });
    await gb.banco.getUser(idUser: gb.codigoUser).then((value) {
      gb.isLoading = false;
      user = UserP.fromSnapshot(value);
      setState(() {});
    });
  }

  criaListaCompartilhada() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: gb.getSecondary(),
        bottomNavigationBar: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ButtonTextPadrao(
              label: '  Cancelar  ',
              onPressed: () => Navigator.pop(context),
            ),
            ButtonTextPadrao(
              label: '  Confirmar  ',
              onPressed: () async {
                var comp = Compartilha(
                    idLista: gb.codigoList,
                    idUser: gb.codigoUser,
                    isRead: gb.codigRead == 'true' ? true : false);

                if (gb.lisComp
                    .where((element) => element.idLista == comp.idLista && element.idUser == comp.idUser)
                    .isEmpty) {
                  gb.lisComp.add(comp);
                  await gb.banco.criaAlteraComp(user: gb.usuario, coisas: comp);
                  await HomeController.atualizaLista();
                } else {
                  await Fluttertoast.showToast(
                      msg: "A lista já foi salva!!",
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 5,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 18.0);
                }
                Navigator.pop(context);
              },
            )
          ],
        ),
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          actions: [],
          centerTitle: true,
          backgroundColor: gb.getPrimary(),
          title: Text('Lista Compartilhada', style: TextStyle(color: Colors.white, fontSize: 25)),
        ),
        body: Stack(children: [
          Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [gb.getPrimary(), gb.getSecondary()]))),
          gb.isLoading
              ? LoadPadrao()
              : ListView(
                  padding: EdgeInsets.all(30),
                  children: [
                    Text(
                      'Desejar anexar a seguinte lista?',
                      style: Theme.of(context).textTheme.headline5.copyWith(color: Colors.white),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ButtonTextPadrao(
                      label: "${lista.nome}",
                      onPressed: () => Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (BuildContext context) => ListasPage(
                                    coisa: lista,
                                    isComp: true,
                                  ))),
                    )
                  ],
                )
        ]));
  }
}
