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
    return IconButton(
      icon: Icon(Icons.delete_outline, color: gb.getErrorColor(), size: 20),
      onPressed: () async {
        await ct.showAlertDialog2(
          coisas: ct.lisCoisa.value[index],
          context: context,
        );
      },
      tooltip: 'Excluir lista',
    );
  }
}
