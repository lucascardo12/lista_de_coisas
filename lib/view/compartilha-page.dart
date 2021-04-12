import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:listadecoisa/model/coisas.dart';
import 'package:listadecoisa/controller/temas.dart';
import 'package:listadecoisa/controller/global.dart' as gb;
import 'package:listadecoisa/widgets/loading-padrao.dart';

class CompartilhaPage extends StatefulWidget {
  CompartilhaPage();

  @override
  State<StatefulWidget> createState() => new _CompartilhaPage();
}

class _CompartilhaPage extends State<CompartilhaPage> {
  Coisas lista;
  @override
  void initState() {
    gb.isLoading = true;
    getLista();
    super.initState();
  }

  getLista() async {
    await gb.banco
        .getCoisa(idLista: 'RbVCHXYskgFGQ2JTY56O', idUser: 'rqO4YVq37UO9vsVpnbXAGlndzW33')
        .then((value) {
      gb.isLoading = false;
      lista = Coisas.fromSnapshot(value);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          actions: [],
          centerTitle: true,
          backgroundColor: getPrimary(),
          title: Text('Lista Compartilhada', style: TextStyle(color: Colors.white, fontSize: 25)),
        ),
        body: Stack(children: [
          Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [getPrimary(), getSecondary()]))),
          gb.isLoading
              ? LoadPadrao()
              : ListView(
                  children: [Text(lista.nome), Text(lista.nome)],
                )
        ]));
  }
}
