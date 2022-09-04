import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:listadecoisa/core/interfaces/controller_interface.dart';
import 'package:listadecoisa/modules/home/domain/repositories/compartilha_repository_inter.dart';
import 'package:listadecoisa/modules/listas/domain/enums/status_page.dart';
import 'package:listadecoisa/modules/listas/domain/models/coisas.dart';
import 'package:listadecoisa/core/services/admob.dart';
import 'package:listadecoisa/core/services/global.dart';
import 'package:listadecoisa/modules/listas/domain/repositories/coisas_repository_inter.dart';

const umaHora = 2880000;

class ListasController extends ChangeNotifier implements IController {
  final Global gb;
  final AdMob admob;
  final ICompartilhaRepository compartilhaRepository;
  final ICoisasRepository coisasRepository;
  bool marcaTodos = false;
  bool? isComp;
  final formKey = GlobalKey<FormState>();
  Coisas? coisas;
  late FocusScopeNode node;
  final FocusNode nodeText1 = FocusNode();
  var statusPage = ValueNotifier(StatusPage.loading);
  final TextEditingController quant = TextEditingController();

  ListasController({
    required this.gb,
    required this.coisasRepository,
    required this.admob,
    required this.compartilhaRepository,
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
    var auxi = await compartilhaRepository.list(idUser: gb.usuario!.id!);
    var indexAuxi = auxi.indexWhere((element) => element.idLista == coisa.idFire);
    if (indexAuxi >= 0) {
      await coisasRepository.createUpdate(idUser: auxi[indexAuxi].idUser, object: coisa);
    } else {
      await coisasRepository.createUpdate(idUser: gb.usuario!.id!, object: coisa);
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
    if (coisas?.idFire != null && isComp == true) {
      statusPage.value = StatusPage.loading;
      var auxi = await compartilhaRepository.list(idUser: gb.usuario!.id!);
      var indexAuxi = auxi.indexWhere((element) => element.idLista == coisas!.idFire);
      if (indexAuxi >= 0) {
        coisas = await coisasRepository.get(
          idDoc: coisas!.idFire!,
          idUser: auxi[indexAuxi].idUser,
        );
      } else {
        coisas = await coisasRepository.get(idDoc: coisas!.idFire!, idUser: gb.usuario!.id!);
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
      if (coisas!.checkCompras.isNotEmpty || coisas!.checklist.isNotEmpty || coisas!.descricao.isNotEmpty) {
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
