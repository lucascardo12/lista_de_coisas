import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:listadecoisa/controller/listas_controller.dart';
import 'package:listadecoisa/widgets/lista_check.dart';
import 'package:listadecoisa/widgets/lista_compras.dart';
import 'package:listadecoisa/widgets/lista_texto.dart';

class ListasPage extends GetView {
  final ct = Get.put(ListasController());

  ListasPage({super.key});

  @override
  Widget build(BuildContext context) {
    ct.node = FocusScope.of(context);
    return Scaffold(
      body: WillPopScope(
        onWillPop: () => ct.bottonVoltar(),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                ct.gb.getPrimary(),
                ct.gb.getSecondary(),
              ],
            ),
          ),
          child: Form(
            key: ct.formKey,
            child: Column(
              children: [
                const SizedBox(
                  height: 60,
                ),
                Expanded(
                  child: TextFormField(
                    readOnly: ct.isComp,
                    validator: (value) {
                      if (value!.isEmpty) return "Titulo não pode ser vazio";
                      return null;
                    },
                    onChanged: (value) => ct.coisas.nome = value,
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                    initialValue: ct.coisas.nome ?? '',
                    textAlign: TextAlign.center,
                    cursorColor: Colors.white,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      labelText: ct.coisas.nome!.isEmpty ? "    Digite um Titulo" : null,
                      alignLabelWithHint: true,
                      labelStyle: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 8,
                  child: GetBuilder(
                    init: ct,
                    builder: (ListasController controller) => [
                      ListaTexto(
                        isComp: ct.isComp,
                        ct: controller,
                      ),
                      ListaCheck(
                        isComp: ct.isComp,
                        ct: controller,
                      ),
                      ListaCompras(
                        isComp: ct.isComp,
                        ct: controller,
                      ),
                    ].elementAt(ct.coisas.tipo ?? 0),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 50,
        child: AdWidget(
          ad: ct.admob.banner2,
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 20, right: 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const BackButton(
              color: Colors.white,
            ),
            !ct.isComp
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: 15,
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.done,
                          color: Colors.white,
                        ),
                        onPressed: () async {
                          if (ct.formKey.currentState!.validate()) {
                            var day = ct.gb.box.get('day', defaultValue: DateTime.now().day);
                            if (day != DateTime.now().day) {
                              int diasCount = ct.gb.box.get('diasCount', defaultValue: 2);
                              ct.gb.box.put('day', DateTime.now().day);
                              if (diasCount == 0) {
                                await ct.admob.mostraTelaCheia();
                                ct.gb.box.put('diasCount', 1);
                              } else {
                                ct.gb.box.put('diasCount', --diasCount);
                              }
                            }
                            int index = ct.gb.lisCoisa.indexWhere(
                              (element) => element.idFire == ct.coisas.idFire,
                            );
                            index < 0 ? ct.gb.lisCoisa.add(ct.coisas) : ct.gb.lisCoisa[index] = ct.coisas;
                            await ct.criaCoisa(coisa: ct.coisas);
                            Get.back();
                          }
                        },
                      ),
                    ],
                  )
                : const SizedBox(
                    width: 15,
                  )
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
    );
  }
}
