import 'dart:ffi';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:listadecoisa/controller/custom-widget.dart';
import 'package:listadecoisa/model/coisas.dart';
import 'package:listadecoisa/model/user.dart';
import 'package:listadecoisa/controller/temas.dart';
import 'package:listadecoisa/controller/global.dart' as global;

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
  AdmobBannerSize bannerSize;
  Coisas coisa;
  var lista = [];
  TextEditingController tituloControler = TextEditingController();
  TextEditingController contentControler = TextEditingController();
  final FocusNode _nodeText1 = FocusNode();
  bool isCheck;
  AdmobInterstitial interstitialAd;
  _ListasPageState(this.coisas);
  KeyboardActionsConfig _buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      keyboardBarColor: getPrimary(),
      nextFocus: false,
      actions: [
        KeyboardActionsItem(
          focusNode: _nodeText1,
          toolbarButtons: [
            //button 1
            (node) {
              return IconButton(
                  splashColor: Colors.transparent,
                  padding: EdgeInsets.only(
                      right: MediaQuery.of(context).size.width / 2),
                  icon: Icon(
                    Icons.view_list,
                    color: Colors.white,
                    size: 32,
                  ),
                  onPressed: () => null);
            },
          ],
        ),
      ],
    );
  }

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
      // lista = this.coisas.checklist;
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
        persistentFooterButtons: [
          Container(
            width: MediaQuery.of(context).size.width,
            child: AdmobBanner(
              adUnitId: 'ca-app-pub-1205611887737485/8760342564',
              adSize: AdmobBannerSize.ADAPTIVE_BANNER(
                  width: MediaQuery.of(context).size.width.round()),
              listener: (AdmobAdEvent event, Map<String, dynamic> args) {},
              onBannerCreated: (AdmobBannerController controller) {
                //controller.dispose();
              },
            ),
          )
        ],
        floatingActionButton: Padding(
            padding: EdgeInsets.only(left: 20, right: 0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BackButton(
                    color: Colors.white,
                  ),
                  Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                    IconButton(
                      icon: Icon(
                        Icons.clear,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pop(
                            context, this.coisas != null ? this.coisas : null);
                      },
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.done,
                        color: Colors.white,
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
                  ])
                ])),
        floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
        body: KeyboardActions(
          enable: contentControler.text.isEmpty,
          config: _buildConfig(context),
          child: Container(
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [getPrimary(), getSecondary()])),
              child: Padding(
                  padding: EdgeInsets.all(10),
                  child: ListView(
                    padding: EdgeInsets.all(10),
                    shrinkWrap: true,
                    children: [
                      SizedBox(
                        height: 30,
                      ),
                      TextFormField(
                          style: TextStyle(color: Colors.white, fontSize: 20),
                          textAlign: TextAlign.center,
                          cursorColor: Colors.white,
                          controller: tituloControler,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            labelText: tituloControler.text.isEmpty
                                ? "Digite um Titulo"
                                : null,
                            labelStyle: TextStyle(
                              color: Colors.white,
                            ),
                          )),
                      SizedBox(
                        height: 5,
                      ),
                      // IconButton(
                      //     padding: EdgeInsets.all(0),
                      //     icon: Icon(
                      //       Icons.add_box_sharp,
                      //       color: Colors.white,
                      //     ),
                      //     onPressed: () => null),
                      // contentControler.text.isEmpty
                      //     ? listCheck(xwidth: MediaQuery.of(context).size.width)
                      TextFormField(
                        focusNode: _nodeText1,
                        autofocus: contentControler.text.isEmpty ? true : false,
                        maxLines: 300,
                        minLines: 20,
                        cursorColor: Colors.white,
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
                          alignLabelWithHint: true,
                          labelText: 'Conteudo da lista',
                          labelStyle:
                              TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        controller: contentControler,
                      )
                    ],
                  ))),
        ));
  }

  Widget listCheck({double xwidth}) {
    return ListView.builder(
      padding: EdgeInsets.all(10),
      shrinkWrap: true,
      itemCount: lista.length,
      itemBuilder: (context, i) {
        if (i != null) {
          return Card(
            color: Colors.transparent,
            child: Container(
                width: xwidth / 2 - 15,
                child: Row(
                  children: [
                    Flexible(
                        child: Checkbox(
                      onChanged: (bool value) {
                        setState(() {
                          lista[i].feito = !lista[i].feito;
                        });
                      },
                      value: lista[i].feito,
                      activeColor: primary,
                    )),
                    Flexible(
                        flex: 10,
                        child: TextField(
                          focusNode: _nodeText1,
                          cursorColor: Colors.white,
                          maxLines: 2,
                          minLines: 1,
                          autofocus: true,
                        ))
                  ],
                  mainAxisAlignment: MainAxisAlignment.start,
                )),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
