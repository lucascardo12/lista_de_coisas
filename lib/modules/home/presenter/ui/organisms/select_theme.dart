import 'package:flutter/material.dart';
import 'package:listadecoisa/core/services/global.dart';

class SelectTheme extends StatelessWidget {
  final List items;
  final Global gb;

  const SelectTheme({super.key, required this.items, required this.gb});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Wrap(
          children: items.map(
            (e) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Radio<dynamic>(
                    value: e,
                    activeColor: gb.getPrimary(),
                    groupValue: gb.box.get('tema', defaultValue: ''),
                    onChanged: (dynamic valor) async {
                      if (valor is int || valor == null) valor = '';
                      gb.tema.value = valor;
                      await gb.box.put('tema', valor);
                      Navigator.pop(context);
                    },
                  ),
                  Text(e)
                ],
              );
            },
          ).toList(),
        ),
      ],
    );
  }
}
