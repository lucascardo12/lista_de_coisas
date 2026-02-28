import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:listadecoisa/core/interfaces/controller_interface.dart';
import 'package:listadecoisa/modules/listas/domain/enums/status_page.dart';
import 'package:listadecoisa/modules/listas/domain/models/coisas.dart';
import 'package:listadecoisa/core/services/global.dart';
import 'package:listadecoisa/core/services/theme/theme_service.dart';
import 'package:listadecoisa/modules/listas/infra/coisas_repository.dart';
import 'package:listadecoisa/modules/listas/presenter/arguments/lists_argument.dart';

const umaHora = 2880000;

class ListasController extends ChangeNotifier implements IController {
  final Global gb;
  final CoisasRepository coisasRepository;
  bool marcaTodos = false;
  final formKey = GlobalKey<FormState>();
  Coisas? coisas;
  late FocusScopeNode node;
  final FocusNode nodeText1 = FocusNode();
  var statusPage = ValueNotifier(StatusPage.loading);
  final TextEditingController quant = TextEditingController();
  var totalGeral = ValueNotifier(0.0);

  ListasController({required this.gb, required this.coisasRepository});

  @override
  void init(BuildContext context) async {
    final arguments =
        ModalRoute.of(context)!.settings.arguments as ListsArgument;
    if (arguments.idDoc != null) {
      coisas = await coisasRepository.get(idDoc: arguments.idDoc!);
    } else {
      coisas = Coisas.empty();
    }
    statusPage.value = StatusPage.done;
  }

  Future<void> criaCoisa({required Coisas coisa}) async {
    await coisasRepository.createUpdate(object: coisa);

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

    coisas = await coisasRepository.get(idDoc: coisas!.idFire!);

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

  bool bottonVoltar(BuildContext context) {
    if (coisas!.idFire == null) {
      if (coisas!.checkCompras.isNotEmpty ||
          coisas!.checklist.isNotEmpty ||
          coisas!.descricao.isNotEmpty) {
        showDialog(
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
