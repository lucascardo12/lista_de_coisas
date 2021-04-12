import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:listadecoisa/controller/listas-controller.dart';
import 'package:listadecoisa/model/coisas.dart';
import 'package:listadecoisa/controller/temas.dart';
import 'package:listadecoisa/controller/global.dart' as global;
import 'package:listadecoisa/widgets/borda-padrao.dart';

class ListasPage extends StatefulWidget {
  ListasPage({
    Key key,
    this.coisa,
  }) : super(key: key);
  final Coisas coisa;
  @override
  _ListasPageState createState() => _ListasPageState();
}

class _ListasPageState extends State<ListasPage> {
  AdmobBannerSize bannerSize;
  final formKey = GlobalKey<FormState>();
  Coisas _coisas;
  FocusScopeNode node;
  final FocusNode _nodeText1 = FocusNode();
  AdmobInterstitial interstitialAd;
  @override
  void initState() {
    _coisas = widget.coisa;
    interstitialAd = AdmobInterstitial(
      adUnitId: 'ca-app-pub-1205611887737485/8086429884',
      listener: (AdmobAdEvent event, Map<String, dynamic> args) {
        if (event == AdmobAdEvent.closed) interstitialAd.load();
      },
    );
    interstitialAd.load();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    node = FocusScope.of(context);
    return Scaffold(
        bottomNavigationBar: Container(
          child: AdmobBanner(
            adUnitId: 'ca-app-pub-1205611887737485/8760342564',
            adSize: AdmobBannerSize.ADAPTIVE_BANNER(width: MediaQuery.of(context).size.width.round()),
            listener: (AdmobAdEvent event, Map<String, dynamic> args) {},
            onBannerCreated: (AdmobBannerController controller) {
              //controller.dispose();
            },
          ),
        ),
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
                    Navigator.pop(context);
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
                      await ListasController.criaCoisa(coisa: _coisas);
                      Navigator.pop(context, _coisas);
                    }
                  },
                ),
              ])
            ])),
        floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [getPrimary(), getSecondary()])),
            ),
            retornaBody(tipo: _coisas.tipo),
          ],
        ));
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
        padding: EdgeInsets.only(left: 10, right: 10, top: 30),
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
                    onChanged: (value) => _coisas.nome = value,
                    style: TextStyle(color: Colors.white, fontSize: 20),
                    initialValue: _coisas.nome ?? '',
                    textAlign: TextAlign.center,
                    cursorColor: Colors.white,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      labelText: _coisas.nome.isEmpty ? "Digite um Titulo" : null,
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
                  autofocus: _coisas.descricao.isEmpty ? true : false,
                  maxLines: 300,
                  initialValue: _coisas.descricao ?? '',
                  onChanged: (value) => _coisas.descricao = value,
                  minLines: 20,
                  cursorColor: Colors.white,
                  style: TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    border: BordaPadrao.build(),
                    enabledBorder: BordaPadrao.build(),
                    focusedBorder: BordaPadrao.build(),
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
                        _coisas.nome = value;
                        if (value.isEmpty) return "Titulo não pode ser vazio";
                        return null;
                      },
                      style: TextStyle(color: Colors.white, fontSize: 20),
                      initialValue: _coisas.nome ?? '',
                      textAlign: TextAlign.center,
                      cursorColor: Colors.white,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        labelText: _coisas.nome.isEmpty ? "Digite um Titulo" : null,
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
                          onPressed: () =>
                              setState(() => _coisas.checklist.add(Checklist(feito: false, item: '')))))
                ])),
            Container(
                height: MediaQuery.of(context).size.height * 0.8,
                child: ListView.builder(
                  padding: EdgeInsets.all(10),
                  shrinkWrap: true,
                  itemCount: _coisas.checklist.length,
                  itemBuilder: (BuildContext context, int i) {
                    return Row(
                      children: [
                        Checkbox(
                          fillColor: MaterialStateProperty.all(Colors.white),
                          checkColor: getPrimary(),
                          onChanged: (bool value) {
                            setState(() {
                              _coisas.checklist[i].feito = value;
                            });
                          },
                          value: _coisas.checklist[i].feito ?? false,
                        ),
                        Expanded(
                            child: TextFormField(
                          onEditingComplete: () => node.nextFocus(),
                          validator: (value) {
                            _coisas.checklist[i].item = value;
                            if (value.isEmpty) return "Conteudo não pode ser vazio";
                            return null;
                          },
                          autofocus: _coisas.checklist[i].item.isEmpty ? true : false,
                          initialValue: _coisas.checklist[i].item,
                          cursorColor: Colors.white,
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.zero,
                            border: BordaPadrao.check(),
                            enabledBorder: BordaPadrao.check(),
                            focusedBorder: BordaPadrao.check(),
                            hintStyle: TextStyle(color: Colors.white),
                            alignLabelWithHint: true,
                            hintText: "item",
                            labelStyle: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        )),
                        IconButton(
                            icon: Icon(
                              Icons.clear,
                              color: Colors.white,
                            ),
                            onPressed: () => setState(() => _coisas.checklist.remove(_coisas.checklist[i])))
                      ],
                    );
                  },
                ))
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
                child: Column(children: [
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                      validator: (value) {
                        _coisas.nome = value;
                        if (value.isEmpty) return "Titulo não pode ser vazio";
                        return null;
                      },
                      style: TextStyle(color: Colors.white, fontSize: 20),
                      initialValue: _coisas.nome ?? '',
                      textAlign: TextAlign.center,
                      cursorColor: Colors.white,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        labelText: _coisas.nome.isEmpty ? "Digite um Titulo" : null,
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
                          onPressed: () => setState(() => _coisas.checkCompras.add(CheckCompras(
                                feito: false,
                                item: '',
                                quant: 1,
                              )))))
                ])),
            Container(
                height: MediaQuery.of(context).size.height * 0.7,
                child: ListView.builder(
                  padding: EdgeInsets.all(10),
                  shrinkWrap: true,
                  itemCount: _coisas.checkCompras.length,
                  itemBuilder: (BuildContext context, int i) {
                    return Row(
                      children: [
                        Checkbox(
                          fillColor: MaterialStateProperty.all(Colors.white),
                          checkColor: getPrimary(),
                          onChanged: (bool value) {
                            setState(() {
                              _coisas.checkCompras[i].feito = value;
                            });
                          },
                          value: _coisas.checkCompras[i].feito ?? false,
                        ),
                        Expanded(
                            flex: 7,
                            child: TextFormField(
                              onEditingComplete: () => node.nextFocus(),
                              validator: (value) {
                                _coisas.checkCompras[i].item = value;
                                if (value.isEmpty) return "Conteudo não pode ser vazio";
                                return null;
                              },
                              autofocus: _coisas.checkCompras[i].item.isEmpty ? true : false,
                              initialValue: _coisas.checkCompras[i].item,
                              cursorColor: Colors.white,
                              style: TextStyle(color: Colors.white),
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.zero,
                                border: BordaPadrao.check(),
                                enabledBorder: BordaPadrao.check(),
                                focusedBorder: BordaPadrao.check(),
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
                              onChanged: (v) => _coisas.checkCompras[i].quant = int.tryParse(v) ?? 0,
                              autofocus: _coisas.checkCompras[i].quant == null ? true : false,
                              initialValue: _coisas.checkCompras[i].quant.toString() ?? '',
                              cursorColor: Colors.white,
                              style: TextStyle(color: Colors.white),
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.zero,
                                hintText: "Qts",
                                border: BordaPadrao.check(),
                                enabledBorder: BordaPadrao.check(),
                                focusedBorder: BordaPadrao.check(),
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
                              onChanged: (value) =>
                                  _coisas.checkCompras[i].valor = double.tryParse(value) ?? 0.0,
                              autofocus: _coisas.checkCompras[i].valor == null ? true : false,
                              initialValue: _coisas.checkCompras[i].valor == null
                                  ? ''
                                  : _coisas.checkCompras[i].valor.toString(),
                              cursorColor: Colors.white,
                              style: TextStyle(color: Colors.white),
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.zero,
                                hintText: "R\u0024",
                                border: BordaPadrao.check(),
                                enabledBorder: BordaPadrao.check(),
                                focusedBorder: BordaPadrao.check(),
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
                            onPressed: () =>
                                setState(() => _coisas.checkCompras.remove(_coisas.checkCompras[i])))
                      ],
                    );
                  },
                )),
            SizedBox(
              height: 10,
            ),
            Center(
              child: Text(
                "Valor total da compra R\u0024: ${retornaTotal(_coisas.checkCompras)}",
                style: Theme.of(context).textTheme.subtitle1.copyWith(color: Colors.white),
              ),
            )
          ],
        ));
  }

  retornaTotal(List<dynamic> lista) {
    double total = 0;
    lista.forEach((element) {
      total += element.quant * (element.valor ?? 0.0);
    });
    return total.toString();
  }
}
