import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:listadecoisa/core/interfaces/controller_interface.dart';
import 'package:listadecoisa/modules/listas/domain/enums/status_page.dart';
import 'package:listadecoisa/modules/listas/domain/models/coisas.dart';
import 'package:listadecoisa/modules/auth/domain/models/user.dart';
import 'package:listadecoisa/core/services/admob.dart';
import 'package:listadecoisa/core/services/banco.dart';
import 'package:listadecoisa/core/services/global.dart';

const umaHora = 2880000;

class ListasController extends ChangeNotifier implements IController {
  final Global gb;
  final BancoFire banco;
  final AdMob admob;
  bool? isComp;
  final formKey = GlobalKey<FormState>();
  Coisas? coisas;
  late FocusScopeNode node;
  final FocusNode nodeText1 = FocusNode();
  var statusPage = ValueNotifier(StatusPage.loading);

  ListasController({
    required this.gb,
    required this.banco,
    required this.admob,
  });

  @override
  void init(BuildContext context) {
    var arguments = ModalRoute.of(context)!.settings.arguments as List;
    if (verificaUltimaAds()) admob.loadInterstitialAd();
    isComp = arguments[1];
    coisas = arguments[0];
    statusPage.value = StatusPage.done;
  }

  Future<void> criaCoisa({required Coisas coisa}) async {
    var auxi = gb.lisComp.value.indexWhere((element) => element.idLista == coisa.idFire);
    if (auxi >= 0) {
      await banco.criaAlteraCoisas(
          coisas: coisa,
          user: UserP(id: gb.lisComp.value.firstWhere((element) => element.idLista == coisa.idFire).idUser));
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

  Future<void> atualizaCoisa() async {
    if (coisas?.idFire != null) {
      statusPage.value = StatusPage.loading;
      var auxi = gb.lisComp.value.indexWhere((element) => element.idLista == coisas!.idFire!);
      if (auxi >= 0) {
        var retCoisa = await banco.getCoisa(
          idLista: coisas!.idFire!,
          idUser: gb.lisComp.value.firstWhere((element) => element.idLista == coisas!.idFire).idUser,
        );
        coisas = Coisas.fromSnapshot(retCoisa);
      } else {
        var retCoisa = await banco.getCoisa(idLista: coisas!.idFire!, idUser: gb.usuario!.id!);
        coisas = Coisas.fromSnapshot(retCoisa);
      }

      statusPage.value = StatusPage.done;
      Fluttertoast.showToast(
        msg: "Atualizado com Sucesso!!",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 5,
        backgroundColor: gb.getPrimary(),
        textColor: Colors.white,
        fontSize: 18.0,
      );
    }
  }

  Future<bool> bottonVoltar(BuildContext context) async {
    if (coisas!.idFire == null) {
      if (coisas!.checkCompras!.isNotEmpty ||
          coisas!.checklist!.isNotEmpty ||
          coisas!.descricao!.isNotEmpty) {
        await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Atenção !!!"),
              content: const Text("Deseja descartar essa lista ?"),
              actions: [
                TextButton(
                  child: const Text("Sim"),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                ),
                TextButton(
                  child: const Text("Não"),
                  onPressed: () => Navigator.pop(context),
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

  String retornaTotal(List<dynamic> lista) {
    double total = 0;
    for (var element in lista) {
      if (element.feito != null) total += element.quant * (element.valor ?? 0.0);
    }
    return total.toStringAsFixed(2);
  }

  void update() => notifyListeners();
  bool verificaUltimaAds() {
    var agora = DateTime.now().millisecondsSinceEpoch;
    var depois = gb.box.get('day') ?? DateTime.now().millisecondsSinceEpoch;
    var dif = agora - depois;
    return dif > umaHora || dif <= 0;
  }
}
