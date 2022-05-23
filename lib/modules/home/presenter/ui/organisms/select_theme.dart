import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:listadecoisa/core/services/global.dart';

class SelectTheme extends StatelessWidget {
  final List items;
  final Global gb;

  const SelectTheme({super.key, required this.items, required this.gb});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 40),
          child: Container(
            decoration: BoxDecoration(
              color: CupertinoColors.white,
              borderRadius: BorderRadius.circular(25),
            ),
            padding: const EdgeInsets.all(15),
            child: Wrap(
              children: items.map(
                (e) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Radio(
                        value: e,
                        activeColor: gb.getPrimary(),
                        groupValue: gb.box.get('tema', defaultValue: 1),
                        onChanged: (dynamic valor) async {
                          gb.tema = valor;
                          await gb.box.put('tema', valor);
                          //Get.forceAppUpdate();
                          Navigator.pop(context);
                        },
                      ),
                      Text(e)
                    ],
                  );
                },
              ).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
