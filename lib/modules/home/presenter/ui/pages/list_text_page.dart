import 'package:flutter/material.dart';
import 'package:listadecoisa/modules/home/presenter/controllers/home_controller.dart';
import 'package:listadecoisa/modules/listas/presenter/ui/pages/listas_page.dart';
import 'package:listadecoisa/services/global.dart';

class ListTextoPage extends StatelessWidget {
  final Global gb;
  final HomeController ct;

  const ListTextoPage({super.key, required this.ct, required this.gb});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: gb.lisCoisa,
        builder: (context, value, child) {
          return ListView.builder(
            padding: const EdgeInsets.only(
              left: 10,
              right: 10,
              top: 10,
            ),
            shrinkWrap: true,
            itemCount: gb.lisCoisa.value.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () => Navigator.pushNamed(
                  context,
                  ListasPage.route,
                  arguments: [
                    gb.lisCoisa.value[index],
                    false,
                  ],
                ),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(gb.lisCoisa.value[index].nome ?? ''),
                        PopupMenuButton(
                          icon: const Icon(Icons.more_vert),
                          itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                            PopupMenuItem(
                              value: 0,
                              child: ListTile(
                                leading: Icon(
                                  Icons.qr_code_scanner_rounded,
                                  color: gb.getPrimary(),
                                ),
                                title: const Text('Compartilhar'),
                              ),
                            ),
                            PopupMenuItem(
                              value: 1,
                              child: ListTile(
                                leading: Icon(
                                  Icons.delete,
                                  color: gb.getPrimary(),
                                ),
                                title: const Text('Excluir'),
                              ),
                            ),
                          ],
                          onSelected: (value) async {
                            switch (value) {
                              case 0:
                                ct.showCompartilha(context: context, index: index);
                                break;
                              case 1:
                                await ct.showAlertDialog2(coisas: gb.lisCoisa.value[index], context: context);
                                break;
                              default:
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        });
  }
}
