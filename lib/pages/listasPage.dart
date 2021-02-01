import 'dart:ffi';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:listadecoisa/classes/coisas.dart';
import 'package:listadecoisa/classes/user.dart';
import 'package:listadecoisa/services/temas.dart';
import 'package:listadecoisa/services/global.dart' as global;

class ListasPage extends StatefulWidget {
  ListasPage({
    Key key,
    this.coisas,
  }) : super(key: key);
  final Coisas coisas;
  @override
  _ListasPageState createState() => _ListasPageState(this.coisas);
}

class _ListasPageState extends State<ListasPage> {
  final Coisas coisas;
  Coisas coisa;
  TextEditingController tituloControler = TextEditingController();
  TextEditingController contentControler = TextEditingController();
  AdmobInterstitial interstitialAd;
  _ListasPageState(this.coisas);
  @override
  void initState() {
    interstitialAd = AdmobInterstitial(
      adUnitId: 'ca-app-pub-1205611887737485/8086429884',
      listener: (AdmobAdEvent event, Map<String, dynamic> args) {
        if (event == AdmobAdEvent.closed) interstitialAd.load();
      },
    );

    if (this.coisas != null) {
      contentControler.text = this.coisas.descricao ?? '';
      tituloControler.text = this.coisas.nome ?? '';
    }
    interstitialAd.load();
    super.initState();
  }

  void criaCoisa() {
    coisa = new Coisas(
        idFire: this.coisas != null ? this.coisas.idFire : null,
        descricao: contentControler.text,
        nome: tituloControler.text);

    global.banco.criaAlteraCoisas(coisas: coisa, user: global.usuario);
    Fluttertoast.showToast(
        msg: this.coisas != null
            ? "Alterado com Sucesso!!"
            : "Criado com Sucesso!!",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 5,
        backgroundColor: getPrimary(),
        textColor: Colors.white,
        fontSize: 18.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [getPrimary(), getSecondary()])),
          child: Center(
              child: Padding(
                  padding: EdgeInsets.all(10),
                  child: ListView(
                    padding: EdgeInsets.all(10),
                    shrinkWrap: true,
                    children: [
                      SizedBox(
                        height: 40,
                      ),
                      Align(
                          alignment: Alignment.topCenter,
                          child: Text(
                              this.coisas != null
                                  ? this.coisas.nome
                                  : 'Criando Lista de Coisas',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold))),
                      TextFormField(
                        style: TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25)),
                                borderSide: BorderSide(
                                  color: Colors.white,
                                  width: 2,
                                )),
                            enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25)),
                                borderSide: BorderSide(
                                  color: Colors.white,
                                  width: 2,
                                )),
                            focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25)),
                                borderSide: BorderSide(
                                  color: Colors.white,
                                  width: 2,
                                )),
                            hintStyle: TextStyle(color: Colors.white),
                            hintText: 'Titulo da lista'),
                        controller: tituloControler,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                        maxLines: 200,
                        minLines: 20,
                        style: TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25)),
                                borderSide: BorderSide(
                                  color: Colors.white,
                                  width: 2,
                                )),
                            enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25)),
                                borderSide: BorderSide(
                                  color: Colors.white,
                                  width: 2,
                                )),
                            focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25)),
                                borderSide: BorderSide(
                                  color: Colors.white,
                                  width: 2,
                                )),
                            hintStyle: TextStyle(color: Colors.white),
                            hintText: 'Conteudo da lista'),
                        controller: contentControler,
                      )
                    ],
                  )))),
      persistentFooterButtons: [
        Container(
          color: Colors.white,
          width: MediaQuery.of(context).copyWith().size.width,
          child: Row(
            children: [
              Expanded(
                child: FlatButton(
                  child: Text(
                    'Cancelar',
                    style: TextStyle(color: getPrimary()),
                  ),
                  onPressed: () {
                    Navigator.pop(
                        context, this.coisas != null ? this.coisas : null);
                  },
                ),
              ),
              Expanded(
                child: FlatButton(
                  child: Text(
                    this.coisas != null ? 'Alterar' : 'Salvar',
                    style: TextStyle(color: getPrimary()),
                  ),
                  onPressed: () async {
                    var day = global.prefs.getInt('day');
                    if (await interstitialAd.isLoaded &&
                        (day != DateTime.now().day || day == null)) {
                      global.prefs.setInt('day', DateTime.now().day);
                      interstitialAd.show();
                    }
                    if (tituloControler.text.isNotEmpty) {
                      criaCoisa();
                      Navigator.pop(context, coisa);
                    } else {
                      Fluttertoast.showToast(
                          msg: "Atenção o titulo não pode ta vazio!!",
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 5,
                          backgroundColor: getPrimary(),
                          textColor: Colors.white,
                          fontSize: 18.0);
                    }
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
