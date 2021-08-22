import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:listadecoisa/model/coisas.dart';
import 'package:listadecoisa/model/user.dart';
import 'package:listadecoisa/services/banco.dart';
import 'package:listadecoisa/services/global.dart';

class ListasController extends GetxController {
  final gb = Get.find<Global>();
  final banco = Get.find<BancoFire>();
  final bool isComp = Get.arguments[1];
  late AdmobBannerSize bannerSize;
  final formKey = GlobalKey<FormState>();
  final Coisas coisas = Get.arguments[0];
  late FocusScopeNode node;
  final FocusNode nodeText1 = FocusNode();
  late AdmobInterstitial interstitialAd;
  @override
  void onInit() {
    interstitialAd = AdmobInterstitial(
      adUnitId: 'ca-app-pub-1205611887737485/8086429884',
      listener: (AdmobAdEvent event, Map<String, dynamic>? args) {
        if (event == AdmobAdEvent.closed) interstitialAd.load();
      },
    );
    interstitialAd.load();
    super.onInit();
  }

  Future<void> criaCoisa({required Coisas coisa}) async {
    var auxi = gb.lisComp.indexWhere((element) => element.idLista == coisa.idFire);
    if (auxi >= 0) {
      await banco.criaAlteraCoisas(
          coisas: coisa,
          user: UserP(id: gb.lisComp.firstWhere((element) => element.idLista == coisa.idFire).idUser));
    } else {
      await banco.criaAlteraCoisas(coisas: coisa, user: gb.usuario!);
    }
    Fluttertoast.showToast(
        msg: coisa.idFire != null ? "Alterado com Sucesso!!" : "Criado com Sucesso!!",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 5,
        backgroundColor: gb.getPrimary(),
        textColor: Colors.white,
        fontSize: 18.0);
  }

  Future<bool> bottonVoltar() async {
    if (coisas.idFire == null) {
      if (coisas.checkCompras!.isNotEmpty || coisas.checklist!.isNotEmpty || coisas.descricao!.isNotEmpty) {
        await showDialog(
          context: Get.context!,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Atenção !!!"),
              content: Text("Deseja descartar essa lista ?"),
              actions: [
                TextButton(
                  child: Text("Sim"),
                  onPressed: () {
                    Get.back();
                    Get.back();
                  },
                ),
                TextButton(
                  child: Text("Não"),
                  onPressed: () => Get.back(),
                ),
              ],
            );
          },
        );
        return false;
      }
      return true;
    } else {
      return true;
    }
  }

  retornaTotal(List<dynamic> lista) {
    double total = 0;
    lista.forEach((element) {
      if (element.feito != null) total += element.quant * (element.valor ?? 0.0);
    });
    return total.toStringAsFixed(2);
  }
}
