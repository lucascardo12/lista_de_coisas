import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:listadecoisa/model/coisas.dart';
import 'package:listadecoisa/controller/temas.dart';
import 'package:listadecoisa/controller/global.dart' as global;

import '../controller/temas.dart';
import '../controller/temas.dart';
import '../model/coisas.dart';
import '../model/coisas.dart';

class ListasPage extends StatefulWidget {
  ListasPage({
    Key key,
    this.coisas,
  }) : super(key: key);
  final Coisas coisas;
  @override
  _ListasPageState createState() => _ListasPageState();
}

class _ListasPageState extends State<ListasPage> {
  AdmobBannerSize bannerSize;
  final formKey = GlobalKey<FormState>();
  Coisas coisas;
  FocusScopeNode node;
  final FocusNode _nodeText1 = FocusNode();
  AdmobInterstitial interstitialAd;
  @override
  void initState() {
    coisas = widget.coisas;
    interstitialAd = AdmobInterstitial(
      adUnitId: 'ca-app-pub-1205611887737485/8086429884',
      listener: (AdmobAdEvent event, Map<String, dynamic> args) {
        if (event == AdmobAdEvent.closed) interstitialAd.load();
      },
    );
    interstitialAd.load();
    super.initState();
  }

  void criaCoisa() {
    global.banco.criaAlteraCoisas(coisas: coisas, user: global.usuario);
    Fluttertoast.showToast(
        msg: coisas != null ? "Alterado com Sucesso!!" : "Criado com Sucesso!!",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 5,
        backgroundColor: getPrimary(),
        textColor: Colors.white,
        fontSize: 18.0);
  }

  @override
  Widget build(BuildContext context) {
    node = FocusScope.of(context);
    return Scaffold(
      persistentFooterButtons: [
        Container(
          width: MediaQuery.of(context).size.width,
          child: AdmobBanner(
            adUnitId: 'ca-app-pub-1205611887737485/8760342564',
            adSize: AdmobBannerSize.ADAPTIVE_BANNER(width: MediaQuery.of(context).size.width.round()),
            listener: (AdmobAdEvent event, Map<String, dynamic> args) {},
            onBannerCreated: (AdmobBannerController controller) {
              //controller.dispose();
            },
          ),
        )
      ],
      floatingActionButton: Padding(
          padding: EdgeInsets.only(left: 20, right: 0),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
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
                  Navigator.pop(context, coisas != null ? coisas : null);
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
                  if (formKey.currentState.validate()) {
                    var day = global.prefs.getInt('day');
                    if (await interstitialAd.isLoaded && (day != DateTime.now().day || day == null)) {
                      global.prefs.setInt('day', DateTime.now().day);
                      interstitialAd.show();
                    }
                    criaCoisa();
                    Navigator.pop(context, coisas);
                  }
                },
              ),
            ])
          ])),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [getPrimary(), getSecondary()])),
        child: retornaBody(tipo: coisas.tipo),
      ),
    );
  }

  Widget retornaBody({int tipo}) {
    tipo = tipo != null ? tipo : 0;
    switch (tipo) {
      case 0:
        return contentText();
        break;
      case 1:
        return contentCheckList();
        break;
      case 2:
        return contentCheckCompra();
        break;
      default:
        return Container();
    }
  }

  Widget contentText() {
    return Padding(
        padding: EdgeInsets.all(10),
        child: Form(
            key: formKey,
            child: ListView(
              padding: EdgeInsets.all(10),
              shrinkWrap: true,
              children: [
                SizedBox(
                  height: 30,
                ),
                TextFormField(
                    validator: (value) {
                      if (value.isEmpty) return "Titulo não pode ser vazio";
                      return null;
                    },
                    style: TextStyle(color: Colors.white, fontSize: 20),
                    initialValue: coisas.nome ?? '',
                    textAlign: TextAlign.center,
                    cursorColor: Colors.white,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      labelText: coisas.nome.isEmpty ? "Digite um Titulo" : null,
                      labelStyle: TextStyle(
                        color: Colors.white,
                      ),
                    )),
                SizedBox(
                  height: 5,
                ),
                TextFormField(
                  validator: (value) {
                    if (value.isEmpty) return "Conteudo não pode ser vazio";
                    return null;
                  },
                  focusNode: _nodeText1,
                  autofocus: coisas.descricao.isEmpty ? true : false,
                  maxLines: 300,
                  initialValue: coisas.descricao ?? '',
                  minLines: 20,
                  cursorColor: Colors.white,
                  style: TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25)),
                        borderSide: BorderSide(
                          color: Colors.white,
                          width: 2,
                        )),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25)),
                        borderSide: BorderSide(
                          color: Colors.white,
                          width: 2,
                        )),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25)),
                        borderSide: BorderSide(
                          color: Colors.white,
                          width: 2,
                        )),
                    hintStyle: TextStyle(color: Colors.white),
                    alignLabelWithHint: true,
                    labelText: 'Conteudo da lista',
                    labelStyle: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                )
              ],
            )));
  }

  Widget contentCheckList() {
    return Form(
        key: formKey,
        child: ListView(
          children: [
            Padding(
                padding: EdgeInsets.all(10),
                child: ListView(padding: EdgeInsets.all(10), shrinkWrap: true, children: [
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                      validator: (value) {
                        coisas.nome = value;
                        if (value.isEmpty) return "Titulo não pode ser vazio";
                        return null;
                      },
                      style: TextStyle(color: Colors.white, fontSize: 20),
                      initialValue: coisas.nome ?? '',
                      textAlign: TextAlign.center,
                      cursorColor: Colors.white,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        labelText: coisas.nome.isEmpty ? "Digite um Titulo" : null,
                        labelStyle: TextStyle(
                          color: Colors.white,
                        ),
                      )),
                  CircleAvatar(
                      backgroundColor: Colors.white,
                      child: IconButton(
                          icon: Icon(
                            Icons.add,
                            color: getPrimary(),
                          ),
                          onPressed: () => setState(() => coisas.checklist.add(Checklist(feito: false)))))
                ])),
            ListView.builder(
              padding: EdgeInsets.all(10),
              shrinkWrap: true,
              itemCount: coisas.checklist.length,
              itemBuilder: (BuildContext context, int i) {
                return Row(
                  children: [
                    Checkbox(
                      fillColor: MaterialStateProperty.all(Colors.white),
                      checkColor: getPrimary(),
                      onChanged: (bool value) {
                        setState(() {
                          coisas.checklist[i].feito = value;
                        });
                      },
                      value: coisas.checklist[i].feito ?? false,
                    ),
                    Expanded(
                        child: TextFormField(
                      validator: (value) {
                        coisas.checklist[i].item = value;
                        if (value.isEmpty) return "Conteudo não pode ser vazio";
                        return null;
                      },
                      autofocus: true,
                      initialValue: coisas.checklist[i].item ?? '',
                      cursorColor: Colors.white,
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(25)),
                            borderSide: BorderSide(
                              color: Colors.white,
                              width: 2,
                            )),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(25)),
                            borderSide: BorderSide(
                              color: Colors.white,
                              width: 2,
                            )),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(25)),
                            borderSide: BorderSide(
                              color: Colors.white,
                              width: 2,
                            )),
                        hintStyle: TextStyle(color: Colors.white),
                        alignLabelWithHint: true,
                        labelStyle: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    )),
                    IconButton(
                        icon: Icon(
                          Icons.clear,
                          color: Colors.white,
                        ),
                        onPressed: () => setState(() => coisas.checklist.remove(coisas.checklist[i])))
                  ],
                );
              },
            )
          ],
        ));
  }

  Widget contentCheckCompra() {
    return Form(
        key: formKey,
        child: ListView(
          children: [
            Padding(
                padding: EdgeInsets.all(10),
                child: ListView(padding: EdgeInsets.all(10), shrinkWrap: true, children: [
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                      validator: (value) {
                        coisas.nome = value;
                        if (value.isEmpty) return "Titulo não pode ser vazio";
                        return null;
                      },
                      style: TextStyle(color: Colors.white, fontSize: 20),
                      initialValue: coisas.nome ?? '',
                      textAlign: TextAlign.center,
                      cursorColor: Colors.white,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        labelText: coisas.nome.isEmpty ? "Digite um Titulo" : null,
                        labelStyle: TextStyle(
                          color: Colors.white,
                        ),
                      )),
                  CircleAvatar(
                      backgroundColor: Colors.white,
                      child: IconButton(
                          icon: Icon(
                            Icons.add,
                            color: getPrimary(),
                          ),
                          onPressed: () => setState(() => coisas.checkCompras.add(CheckCompras(
                                feito: false,
                                item: '',
                                quant: 1,
                                valor: 0.0,
                              )))))
                ])),
            ListView.builder(
              padding: EdgeInsets.all(10),
              shrinkWrap: true,
              itemCount: coisas.checkCompras.length,
              itemBuilder: (BuildContext context, int i) {
                return Row(
                  children: [
                    Checkbox(
                      fillColor: MaterialStateProperty.all(Colors.white),
                      checkColor: getPrimary(),
                      onChanged: (bool value) {
                        setState(() {
                          coisas.checkCompras[i].feito = value;
                        });
                      },
                      value: coisas.checkCompras[i].feito ?? false,
                    ),
                    Expanded(
                        flex: 7,
                        child: TextFormField(
                          onEditingComplete: () => node.nextFocus(),
                          validator: (value) {
                            coisas.checkCompras[i].item = value;
                            if (value.isEmpty) return "Conteudo não pode ser vazio";
                            return null;
                          },
                          autofocus: coisas.checkCompras[i].item.isEmpty ? true : false,
                          initialValue: coisas.checkCompras[i].item,
                          cursorColor: Colors.white,
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.zero,
                            border: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                            hintStyle: TextStyle(color: Colors.white),
                            alignLabelWithHint: true,
                            hintText: "item",
                            labelStyle: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        )),
                    Expanded(
                        flex: 2,
                        child: TextFormField(
                          onEditingComplete: () => node.nextFocus(),
                          validator: (value) {
                            if (value.isEmpty) return "Conteudo não pode ser vazio";
                            return null;
                          },
                          onChanged: (v) => coisas.checkCompras[i].quant = int.tryParse(v),
                          autofocus: coisas.checkCompras[i].quant == null ? true : false,
                          initialValue: coisas.checkCompras[i].quant.toString() ?? '',
                          cursorColor: Colors.white,
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.zero,
                            hintText: "Qts",
                            border: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                            hintStyle: TextStyle(color: Colors.white),
                            alignLabelWithHint: true,
                            labelStyle: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        )),
                    Expanded(
                        flex: 2,
                        child: TextFormField(
                          onEditingComplete: () => setState(() => node.nextFocus()),
                          validator: (value) {
                            if (value.isEmpty) return "Conteudo não pode ser vazio";
                            return null;
                          },
                          onChanged: (value) => coisas.checkCompras[i].valor = double.tryParse(value),
                          autofocus: coisas.checkCompras[i].valor == null ? true : false,
                          initialValue: coisas.checkCompras[i].valor.toString() ?? '',
                          cursorColor: Colors.white,
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.zero,
                            hintText: "R\u0024",
                            border: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                            hintStyle: TextStyle(color: Colors.white),
                            alignLabelWithHint: true,
                            labelStyle: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        )),
                    IconButton(
                        padding: EdgeInsets.zero,
                        icon: Icon(
                          Icons.clear,
                          color: Colors.white,
                        ),
                        onPressed: () => setState(() => coisas.checkCompras.remove(coisas.checkCompras[i])))
                  ],
                );
              },
            ),
            Center(
              child: Text(
                "Valor total da compra R\u0024: ${retornaTotal(coisas.checkCompras)}",
                style: Theme.of(context).textTheme.subtitle1.copyWith(color: Colors.white),
              ),
            )
          ],
        ));
  }

  retornaTotal(List<dynamic> lista) {
    double total = 0;
    lista.forEach((element) {
      total += element.quant * element.valor;
    });
    return total.toString();
  }
}
