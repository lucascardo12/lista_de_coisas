import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:listadecoisa/core/interfaces/controller_interface.dart';
import 'package:listadecoisa/core/interfaces/local_database_inter.dart';
import 'package:listadecoisa/core/services/global.dart';
import 'package:listadecoisa/modules/auth/domain/services/auth_service.dart';
import 'package:listadecoisa/modules/home/presenter/ui/organisms/new_list_bottom_sheet.dart';
import 'package:listadecoisa/modules/listas/domain/models/coisas.dart';
import 'package:listadecoisa/modules/listas/infra/coisas_repository.dart';

class HomeController extends IController {
  final ILocalDatabase localDatabase;
  final CoisasRepository coisasRepository;
  final AuthService authService;
  final Global global;
  var lisCoisa = ValueNotifier(<Coisas>[]);

  var scaffoldKe = GlobalKey<ScaffoldState>();

  HomeController({
    required this.coisasRepository,
    required this.localDatabase,
    required this.global,
    required this.authService,
  });

  @override
  void dispose() {}

  @override
  void init(BuildContext context) {
    atualizaLista();
  }

  Future<void> atualizaLista() async {
    lisCoisa.value = await coisasRepository.list();
  }

  void logoff() async {
    await localDatabase.update(id: 'user', objeto: '');
    await localDatabase.update(id: 'fezLogin', objeto: false);
    global.usuario = null;
  }

  Future<void> deleteList({required Coisas coisa}) async {
    await coisasRepository.remove(idDoc: coisa.idFire!);
    await atualizaLista();
  }

  Future showAlertDialog2({
    required BuildContext context,
    required Coisas coisas,
  }) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Atenção !!!'),
          content: const Text('Deseja deletar a lista ?'),
          actions: [
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: const Text('Continar'),
              onPressed: () async {
                await deleteList(coisa: coisas);
                if (context.mounted) {
                  Navigator.pop(context);
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<bool> showExit({required BuildContext context}) async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Atenção !!!'),
              content: const Text('Deseja sair do app ?'),
              actions: [
                TextButton(
                  child: const Text('Sim'),
                  onPressed: () {
                    SystemNavigator.pop();
                  },
                ),
                TextButton(
                  child: const Text('Não'),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  void showCria({required BuildContext context}) => showModalBottomSheet(
    context: context,
    builder: (context) => NewListBottomSheet(onUpdateList: atualizaLista),
  );

  void showAlertRedefinir({required BuildContext context}) => showDialog(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: const Text('Confirma redefinição de senha!!'),
      content: const Text(
        'Será encaminhado um e-mail para redefinição de senha, verifique sua caixa de spam.',
      ),
      actions: [
        TextButton(
          child: const Text('Cancelar'),
          onPressed: () => Navigator.pop(context),
        ),
        TextButton(
          child: const Text('Confirmar'),
          onPressed: () {
            authService.resetarSenha(user: global.usuario!);
            Navigator.pop(context);
          },
        ),
      ],
    ),
  );
}
