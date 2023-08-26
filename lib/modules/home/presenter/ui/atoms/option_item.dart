import 'package:flutter/material.dart';
import 'package:listadecoisa/core/services/global.dart';
import 'package:listadecoisa/modules/home/presenter/controllers/home_controller.dart';

class OptionItem extends StatelessWidget {
  final Global gb;
  final HomeController ct;
  final int index;

  const OptionItem({
    super.key,
    required this.ct,
    required this.gb,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      padding: EdgeInsets.zero,
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
            ct.showCompartilha(
              context: context,
              index: index,
            );
            break;
          case 1:
            await ct.showAlertDialog2(
              coisas: ct.lisCoisa.value[index],
              context: context,
            );
            break;
          default:
        }
      },
    );
  }
}
