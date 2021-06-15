import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SelectTheme extends GetView {
  final List items;
  bool valuet = false;
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
                        value: valuet,
                        groupValue: valuet,
                        onChanged: (bool? valor) {
                          valuet = valor!;
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
