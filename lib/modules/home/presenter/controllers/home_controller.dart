import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:listadecoisa/core/interfaces/controller_interface.dart';
import 'package:listadecoisa/core/interfaces/local_database_inter.dart';
import 'package:listadecoisa/core/services/global.dart';
import 'package:listadecoisa/core/services/theme/theme_service.dart';
import 'package:listadecoisa/modules/auth/domain/services/auth_service.dart';
import 'package:listadecoisa/modules/listas/domain/models/coisas.dart';
import 'package:listadecoisa/modules/listas/infra/coisas_repository.dart';
import 'package:listadecoisa/modules/listas/presenter/arguments/lists_argument.dart';
import 'package:listadecoisa/modules/listas/presenter/ui/pages/listas_page.dart';

class HomeController extends IController {
  final ILocalDatabase localDatabase;
  final CoisasRepository coisasRepository;
  final AuthService authService;
  final Global global;
  var lisCoisa = ValueNotifier(<Coisas>[]);

  var scaffoldKe = GlobalKey<ScaffoldState>();
  var isread = false;
  var tipo = 1;
  var listaTipo = ['Texto Simples', 'Check-List', 'Lista de Compras'];

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

  void showCria({required BuildContext context}) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        final theme = Theme.of(context);
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                title: Text(
                  'Escolha o tipo de Lista',
                  style: theme.textTheme.titleMedium!.copyWith(
                    color: ThemeService.instance.getWhiteOrBlack(),
                  ),
                ),
                tileColor: ThemeService.instance.getPrimary(),
              ),
              for (int i = 0; i < listaTipo.length; i++)
                GestureDetector(
                  onTap: () {
                    tipo = i;
                    Navigator.pop(context);
                    showCria(context: context);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: tipo == i
                          ? ThemeService.instance.getPrimary().withValues(
                              alpha: 0.1,
                            )
                          : Colors.transparent,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: ThemeService.instance.getPrimary(),
                              width: 2,
                            ),
                            color: tipo == i
                                ? ThemeService.instance.getPrimary()
                                : Colors.transparent,
                          ),
                          child: tipo == i
                              ? const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 14,
                                )
                              : null,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          listaTipo[i],
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                color: Colors.black,
                                fontWeight: tipo == i
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.white,
                        ),
                        child: Text(
                          'Cancelar',
                          style: theme.textTheme.titleMedium!.copyWith(
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pushNamed(
                            context,
                            ListasPage.route,
                            arguments: ListsArgument(),
                          ).then((value) => atualizaLista());
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                        child: Text(
                          'Continuar',
                          style: theme.textTheme.titleMedium!.copyWith(
                            color: ThemeService.instance.getWhiteOrBlack(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void showAlertRedefinir({required BuildContext context}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
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
        );
      },
    );
  }
}
