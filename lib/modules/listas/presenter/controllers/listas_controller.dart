import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:listadecoisa/core/interfaces/controller_interface.dart';
import 'package:listadecoisa/modules/listas/domain/enums/status_page.dart';
import 'package:listadecoisa/modules/listas/domain/models/coisas.dart';
import 'package:listadecoisa/core/services/global.dart';
import 'package:listadecoisa/core/services/theme/theme_service.dart';
import 'package:listadecoisa/modules/listas/domain/repositories/coisas_repository_inter.dart';

const umaHora = 2880000;

class ListasController extends ChangeNotifier implements IController {
  final Global gb;
  final ICoisasRepository coisasRepository;
  bool marcaTodos = false;
  bool? isComp;
  final formKey = GlobalKey<FormState>();
  Coisas? coisas;
  late FocusScopeNode node;
  final FocusNode nodeText1 = FocusNode();
  var statusPage = ValueNotifier(StatusPage.loading);
  final TextEditingController quant = TextEditingController();
  var totalGeral = ValueNotifier(0.0);

  ListasController({required this.gb, required this.coisasRepository});

  @override
  void init(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments as List;
    isComp = arguments[1];
    coisas = arguments[0];
    statusPage.value = StatusPage.done;
  }

  Future<void> criaCoisa({required Coisas coisa}) async {
    await coisasRepository.createUpdate(idUser: gb.usuario!.uid, object: coisa);

    Fluttertoast.showToast(
      msg: coisa.idFire != null
          ? 'Alterado com Sucesso!!'
          : 'Criado com Sucesso!!',
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 5,
      backgroundColor: ThemeService.instance.getPrimary(),
      textColor: Colors.white,
      fontSize: 18.0,
    );
  }

  Future<void> atualizaCoisa() async {
    statusPage.value = StatusPage.loading;

    coisas = await coisasRepository.get(
      idDoc: coisas!.idFire!,
      idUser: gb.usuario!.uid,
    );

    statusPage.value = StatusPage.done;
    Fluttertoast.showToast(
      msg: 'Atualizado com Sucesso!!',
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 5,
      backgroundColor: ThemeService.instance.getPrimary(),
      textColor: Colors.white,
      fontSize: 18.0,
    );
  }

  Future<void> refreshCoisa(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Atualizar'),
          content: const Text('Deseja atualizar essa lista ?'),
          actions: [
            TextButton(
              child: const Text('Sim'),
              onPressed: () {
                atualizaCoisa();
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: const Text('Não'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }

  Future<bool> bottonVoltar(BuildContext context) async {
    if (coisas!.idFire == null) {
      if (coisas!.checkCompras.isNotEmpty ||
          coisas!.checklist.isNotEmpty ||
          coisas!.descricao.isNotEmpty) {
        await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Atenção !!!'),
              content: const Text('Deseja descartar essa lista ?'),
              actions: [
                TextButton(
                  child: const Text('Sim'),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                ),
                TextButton(
                  child: const Text('Não'),
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

  void calculaValorTotal() {
    double total = 0;
    for (var element in coisas!.checkCompras) {
      total += element.quant * element.valor;
    }
    totalGeral.value = total;
  }

  void update() => notifyListeners();
}
