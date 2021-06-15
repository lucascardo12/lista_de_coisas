import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:listadecoisa/controller/listas-controller.dart';
import 'package:listadecoisa/model/coisas.dart';
import 'package:listadecoisa/services/global.dart';
import 'package:listadecoisa/widgets/borda-padrao.dart';

class ListasPage extends StatefulWidget {
  final Coisas coisa = Get.arguments[0];
  final bool isComp = Get.arguments[1];
  @override
  _ListasPageState createState() => _ListasPageState();
}

class _ListasPageState extends State<ListasPage> {
  final gb = Get.find<Global>();
  final ct = ListasController();
  late AdmobBannerSize bannerSize;
  final formKey = GlobalKey<FormState>();
  late Coisas coisas;
  late FocusScopeNode node;
  final FocusNode _nodeText1 = FocusNode();
  late AdmobInterstitial interstitialAd;
  @override
  void initState() {
    coisas = widget.coisa;
    interstitialAd = AdmobInterstitial(
      adUnitId: 'ca-app-pub-1205611887737485/8086429884',
      listener: (AdmobAdEvent event, Map<String, dynamic>? args) {
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
              !widget.isComp
                  ? Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                      IconButton(
                        icon: Icon(
                          Icons.clear,
                          color: Colors.white,
                        ),
                        onPressed: () => Get.back(),
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
                          if (formKey.currentState!.validate()) {
                            var day = gb.box.get('day', defaultValue: 1);
                            if ((await interstitialAd.isLoaded ?? false) &&
                                (day != DateTime.now().day || day == null)) {
                              gb.box.put('day', DateTime.now().day);
                              interstitialAd.show();
                            }
                            await ct.criaCoisa(coisa: coisas);
                            Get.back(result: coisas);
                          }
                        },
                      ),
                    ])
                  : SizedBox(
                      width: 15,
                    )
            ])),
        floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(begin: Alignment.topRight, end: Alignment.bottomLeft, colors: [
                gb.getPrimary(),
                gb.getSecondary(),
              ])),
            ),
            retornaBody(tipo: coisas.tipo),
          ],
        ));
  }

  Widget retornaBody({int? tipo}) {
    tipo = tipo != null ? tipo : 0;
    switch (tipo) {
      case 0:
        return contentText();

      case 1:
        return contentCheckList();

      case 2:
        return contentCheckCompra();

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
                    readOnly: widget.isComp,
                    validator: (value) {
                      if (value!.isEmpty) return "Titulo não pode ser vazio";
                      return null;
                    },
                    onChanged: (value) => coisas.nome = value,
                    style: TextStyle(color: Colors.white, fontSize: 20),
                    initialValue: coisas.nome ?? '',
                    textAlign: TextAlign.center,
                    cursorColor: Colors.white,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      labelText: coisas.nome!.isEmpty ? "Digite um Titulo" : null,
                      labelStyle: TextStyle(
                        color: Colors.white,
                      ),
                    )),
                SizedBox(
                  height: 5,
                ),
                TextFormField(
                  readOnly: widget.isComp,
                  validator: (value) {
                    if (value!.isEmpty) return "Conteudo não pode ser vazio";
                    return null;
                  },
                  focusNode: _nodeText1,
                  autofocus: coisas.descricao!.isEmpty ? true : false,
                  maxLines: 300,
                  initialValue: coisas.descricao ?? '',
                  onChanged: (value) => coisas.descricao = value,
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
                      readOnly: widget.isComp,
                      validator: (value) {
                        coisas.nome = value;
                        if (value!.isEmpty) return "Titulo não pode ser vazio";
                        return null;
                      },
                      style: TextStyle(color: Colors.white, fontSize: 20),
                      initialValue: coisas.nome ?? '',
                      textAlign: TextAlign.center,
                      cursorColor: Colors.white,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        labelText: coisas.nome!.isEmpty ? "Digite um Titulo" : null,
                        labelStyle: TextStyle(
                          color: Colors.white,
                        ),
                      )),
                  !widget.isComp
                      ? CircleAvatar(
                          backgroundColor: Colors.white,
                          child: IconButton(
                              icon: Icon(
                                Icons.add,
                                color: gb.getPrimary(),
                              ),
                              onPressed: () =>
                                  setState(() => coisas.checklist!.add(Checklist(feito: false, item: '')))))
                      : SizedBox()
                ])),
            Container(
                height: MediaQuery.of(context).size.height * 0.8,
                child: ListView.builder(
                  padding: EdgeInsets.all(10),
                  shrinkWrap: true,
                  itemCount: coisas.checklist!.length,
                  itemBuilder: (BuildContext context, int i) {
                    return Row(
                      children: [
                        !widget.isComp
                            ? Checkbox(
                                fillColor: MaterialStateProperty.all(Colors.white),
                                checkColor: gb.getPrimary(),
                                onChanged: (bool? value) {
                                  setState(() {
                                    coisas.checklist![i].feito = value;
                                  });
                                },
                                value: coisas.checklist![i].feito ?? false,
                              )
                            : SizedBox(
                                width: 20,
                              ),
                        Expanded(
                            child: TextFormField(
                          readOnly: widget.isComp,
                          onEditingComplete: () => node.nextFocus(),
                          validator: (value) {
                            coisas.checklist![i].item = value;
                            if (value!.isEmpty) return "Conteudo não pode ser vazio";
                            return null;
                          },
                          autofocus: coisas.checklist![i].item.isEmpty ? true : false,
                          initialValue: coisas.checklist![i].item,
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
                        !widget.isComp
                            ? IconButton(
                                icon: Icon(
                                  Icons.clear,
                                  color: Colors.white,
                                ),
                                onPressed: () =>
                                    setState(() => coisas.checklist!.remove(coisas.checklist![i])))
                            : SizedBox(
                                width: 20,
                              )
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
                      readOnly: widget.isComp,
                      validator: (value) {
                        coisas.nome = value;
                        if (value!.isEmpty) return "Titulo não pode ser vazio";
                        return null;
                      },
                      style: TextStyle(color: Colors.white, fontSize: 20),
                      initialValue: coisas.nome ?? '',
                      textAlign: TextAlign.center,
                      cursorColor: Colors.white,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        labelText: coisas.nome!.isEmpty ? "Digite um Titulo" : null,
                        labelStyle: TextStyle(
                          color: Colors.white,
                        ),
                      )),
                  CircleAvatar(
                      backgroundColor: Colors.white,
                      child: IconButton(
                          icon: Icon(
                            Icons.add,
                            color: gb.getPrimary(),
                          ),
                          onPressed: () => setState(() => coisas.checkCompras!.add(CheckCompras(
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
                  itemCount: coisas.checkCompras!.length,
                  itemBuilder: (BuildContext context, int i) {
                    return Row(
                      children: [
                        Checkbox(
                          fillColor: MaterialStateProperty.all(Colors.white),
                          checkColor: gb.getPrimary(),
                          onChanged: (bool? value) {
                            setState(() {
                              coisas.checkCompras![i].feito = value;
                            });
                          },
                          value: coisas.checkCompras![i].feito ?? false,
                        ),
                        Expanded(
                            flex: 7,
                            child: TextFormField(
                              readOnly: widget.isComp,
                              onEditingComplete: () => node.nextFocus(),
                              validator: (value) {
                                coisas.checkCompras![i].item = value;
                                if (value!.isEmpty) return "Conteudo não pode ser vazio";
                                return null;
                              },
                              autofocus: coisas.checkCompras![i].item.isEmpty ? true : false,
                              initialValue: coisas.checkCompras![i].item,
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
                              readOnly: widget.isComp,
                              onEditingComplete: () => node.nextFocus(),
                              validator: (value) {
                                if (value!.isEmpty) return "Conteudo não pode ser vazio";
                                return null;
                              },
                              onChanged: (v) => coisas.checkCompras![i].quant = int.tryParse(v) ?? 0,
                              autofocus: coisas.checkCompras![i].quant == null ? true : false,
                              initialValue: coisas.checkCompras![i].quant.toString(),
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
                              readOnly: widget.isComp,
                              onEditingComplete: () => setState(() => node.nextFocus()),
                              validator: (value) {
                                if (value!.isEmpty) return "Conteudo não pode ser vazio";
                                return null;
                              },
                              onChanged: (value) =>
                                  coisas.checkCompras![i].valor = double.tryParse(value) ?? 0.0,
                              autofocus: coisas.checkCompras![i].valor == null ? true : false,
                              initialValue: coisas.checkCompras![i].valor == null
                                  ? ''
                                  : coisas.checkCompras![i].valor.toString(),
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
                                setState(() => coisas.checkCompras!.remove(coisas.checkCompras![i])))
                      ],
                    );
                  },
                )),
            SizedBox(
              height: 10,
            ),
            Center(
              child: Text(
                "Valor total da compra R\u0024: ${retornaTotal(coisas.checkCompras!)}",
                style: Theme.of(context).textTheme.subtitle1!.copyWith(color: Colors.white),
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
