import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:listadecoisa/services/global.dart';

class SelectTheme extends GetView {
  final List items;
  final gb = Get.find<Global>();
  SelectTheme({required this.items});
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
            margin: EdgeInsets.symmetric(horizontal: 40),
            child: Container(
              decoration: BoxDecoration(
                color: CupertinoColors.white,
                borderRadius: BorderRadius.circular(25),
              ),
              padding: EdgeInsets.all(20),
              child: Wrap(
                children: items.map((e) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Radio(
                        value: gb.box.get(
                          e['nome'],
                          defaultValue: false,
                        ),
                        groupValue: gb.box.get(
                          e['nome'],
                          defaultValue: false,
                        ),
                        onChanged: (dynamic valor) async {
                          await gb.box.put(e['nome'], valor);
                          Get.back();
                        },
                      ),
                      Text(e['nome'])
                    ],
                  );
                }).toList(),
              ),
            )),
      ],
    );
  }
}
