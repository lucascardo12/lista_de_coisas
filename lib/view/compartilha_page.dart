import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:listadecoisa/controller/compartilha_controller.dart';
import 'package:listadecoisa/model/compartilha.dart';
import 'package:listadecoisa/widgets/button_text_padrao.dart';
import 'package:listadecoisa/widgets/loading_padrao.dart';

class CompartilhaPage extends GetView {
  final ct = Get.put(CompartilhaController());

  CompartilhaPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ct.gb.getSecondary(),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ButtonTextPadrao(
            label: '  Cancelar  ',
            onPressed: () => Get.back(),
          ),
          ButtonTextPadrao(
            label: '  Confirmar  ',
            onPressed: () async {
              var comp = Compartilha(
                idLista: ct.gb.codigoList,
                idUser: ct.gb.codigoUser,
                isRead: ct.gb.codigRead == 'true' ? true : false,
              );

              if (ct.gb.lisComp
                  .where((element) => element.idLista == comp.idLista && element.idUser == comp.idUser)
                  .isEmpty) {
                ct.gb.lisComp.add(comp);
                await ct.banco.criaAlteraComp(user: ct.gb.usuario!, coisas: comp);
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
              Get.back();
            },
          )
        ],
      ),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        backgroundColor: ct.gb.getPrimary(),
        title: const Text(
          'Lista Compartilhada',
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [ct.gb.getPrimary(), ct.gb.getSecondary()],
          ),
        ),
        child: ct.gb.isLoading
            ? LoadPadrao()
            : ListView(
                padding: const EdgeInsets.all(30),
                children: [
                  Text(
                    'Desejar anexar a seguinte lista?',
                    style: Get.textTheme.headline5!.copyWith(color: Colors.white),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ButtonTextPadrao(
                    label: "${ct.lista.nome}",
                    onPressed: () => Get.toNamed(
                      '/listas',
                      arguments: [ct.lista, true],
                    ),
                  )
                ],
              ),
      ),
    );
  }
}
