import 'package:flutter/material.dart';
import 'package:listadecoisa/core/services/global.dart';
import 'package:listadecoisa/core/services/theme/theme_service.dart';
import 'package:listadecoisa/modules/home/presenter/controllers/home_controller.dart';
import 'package:listadecoisa/modules/listas/domain/models/coisas.dart';

class OptionItem extends StatelessWidget {
  final Global gb;
  final HomeController ct;
  final Coisas coisa;

  const OptionItem({
    super.key,
    required this.ct,
    required this.gb,
    required this.coisa,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.delete_outline,
        color: ThemeService.instance.getErrorColor(),
        size: 20,
      ),
      onPressed: () async {
        await ct.showAlertDialog2(coisas: coisa, context: context);
      },
      tooltip: 'Excluir lista',
    );
  }
}
